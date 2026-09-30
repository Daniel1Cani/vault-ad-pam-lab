length = 24
rule "charset"  { charset = "abcdefghijklmnopqrstuvwxyz" min-chars = 1 }
rule "uppercase" { charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" min-chars = 1 }
rule "digits"    { charset = "0123456789" min-chars = 1 }
rule "symbols"   { charset = "!@#$%^&*()-_=+[]{}" min-chars = 1 }
