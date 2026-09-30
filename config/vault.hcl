# Example Vault configuration for the lab (values redacted).
# Lab only: TLS is disabled on the listener. See "Hardening" in the README.
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

storage "file" {
  path = "C:\\vault\\data"
}

# Auto-unseal with AWS KMS (key id and region are placeholders)
seal "awskms" {
  region     = "<AWS_REGION>"
  kms_key_id = "<KMS_KEY_ID>"
}

api_addr     = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
ui           = true
