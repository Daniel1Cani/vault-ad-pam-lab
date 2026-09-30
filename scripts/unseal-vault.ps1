# Unseal Vault if sealed
$vaultPath = "C:\vault\vault.exe"
$unsealKey = "<YOUR_UNSEAL_KEY>"

$status = & $vaultPath status | Out-String
if ($status -match "Sealed *true") {
    Write-Host "Vault is sealed. Unsealing now..."
    & $vaultPath operator unseal $unsealKey
} else {
    Write-Host "Vault is already unsealed."
}
