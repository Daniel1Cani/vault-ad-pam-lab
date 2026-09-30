# Starts Vault server with specified config file.
# Run as Administrator in PowerShell.
Start-Process -NoNewWindow -FilePath "C:\vault\vault.exe" -ArgumentList 'server -config="C:\vault\config.hcl"'
