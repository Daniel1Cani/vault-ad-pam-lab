# Delegate Reset Password permission to Bind Account
dsacls "CN=vault-managed-admin,OU=ServiceAccounts,DC=corp,DC=local" /I:T /G "corp\svc-vault-bind:CA;Reset Password"
