# Create the service accounts for the Vault-AD integration.
# Passwords are prompted for, never stored in the script.
Import-Module ActiveDirectory

$bindPw    = Read-Host "Password for svc-vault-bind"        -AsSecureString
$managedPw = Read-Host "Initial password for vault-managed-admin" -AsSecureString

# Bind account: Vault uses it to connect to AD over LDAPS
New-ADUser -Name "svc-vault-bind" -SamAccountName "svc-vault-bind" `
  -Path "OU=ServiceAccounts,DC=corp,DC=local" `
  -AccountPassword $bindPw -Enabled $true -PasswordNeverExpires $true

# Managed account: Vault rotates this password
New-ADUser -Name "vault-managed-admin" -SamAccountName "vault-managed-admin" `
  -Path "OU=ServiceAccounts,DC=corp,DC=local" `
  -AccountPassword $managedPw -Enabled $true -PasswordNeverExpires $true
