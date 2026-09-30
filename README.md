# Vault + Active Directory Privileged Access Management Lab

An open-source PAM lab: **HashiCorp Vault** rotates the password of an **Active Directory** service account on demand, with **AWS KMS** auto-unseal. It does what CyberArk or BeyondTrust do for service accounts, using free tools.

## How it works

```
 dc_admin ──LDAP login──▶ Vault (Windows Server) ──LDAPS, bind account──▶ Domain Controller (corp.local)
                            │  read ad/creds/admins                          │
                            │  ◀── new password set on vault-managed-admin ──┘
                            └── AWS KMS unseals Vault after a reboot
```

1. Vault connects to AD with a low-privilege **bind account** (`svc-vault-bind`) that is only allowed to reset one account's password.
2. An admin (`dc_admin`) logs into Vault with LDAP and reads `ad/creds/admins`.
3. Vault resets the password of `vault-managed-admin` in AD. The old password stops working immediately.
4. The rotation is recorded in Vault's audit trail.

| Component | Role |
|---|---|
| Vault server (Windows Server) | AD secrets engine, file storage, AWS KMS auto-unseal |
| Domain controller `DC01` | Domain `corp.local`, `ServiceAccounts` OU |
| `svc-vault-bind` | Bind account with delegated "Reset Password" on the managed account |
| `vault-managed-admin` | Account whose password Vault rotates (TTL or on demand) |
| `dc_admin` | Human admin who authenticates to Vault and requests credentials |

## Repo layout

| Path | Contents |
|---|---|
| [`config/`](config) | `vault.hcl` (server, KMS seal), `admins.hcl` (policy), `ad-password.hcl` (password policy) |
| [`scripts/`](scripts) | `ad-setup.ps1` (create accounts), `delegate-reset.ps1` (grant reset rights), `vault-start.ps1`, `unseal-vault.ps1` |
| [`screenshots/`](screenshots) | AD config, OU layout, service running, and a credential rotation (password values blacked out) |

## Setup order

1. Build a domain controller with the `corp.local` domain and a `ServiceAccounts` OU.
2. Run `scripts/ad-setup.ps1` (prompts for passwords), then `scripts/delegate-reset.ps1`.
3. Fill in the placeholders in `config/vault.hcl`, start Vault with `scripts/vault-start.ps1`, and initialize it.
4. Enable the AD secrets engine, point it at `ldaps://dc01.corp.local` with the bind account, and create the `admins` role.
5. Log in as `dc_admin` and run `vault read ad/creds/admins`. Run it twice to see the password rotate.

## Hardening (what a production setup would change)

This is a lab and some settings are deliberately relaxed:

- The Vault listener has TLS disabled, and the AD engine was configured with `insecure_tls=true` because the lab CA is self-signed. Production: a trusted CA certificate on both.
- The `admins` policy grants `*` with `sudo`. Production: scope it to `ad/creds/*` and the auth methods in use.
- The bind account has `PasswordNeverExpires`. Production: rotate it too.
- Vault runs as a single node with file storage. Production: Integrated Storage (Raft) for HA.
- No secrets are in this repo: scripts prompt for passwords, and KMS values are placeholders.
