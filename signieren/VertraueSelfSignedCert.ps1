# ===============================================
# Self-Signed-Zertifikat vertrauenswürdig machen
# ===============================================

# === Einstellungen (bitte ggf. anpassen) ===
$pfxPath = "$env:USERPROFILE\Desktop\gerhard.gaida.pfx"  # Pfad zur .pfx-Datei
$pfxPassword = "Deimos04082025"                # Passwort der PFX-Datei

# === 1. PFX laden ===
Write-Host "📥 Lade Zertifikat aus: $pfxPath"
$password = ConvertTo-SecureString -String $pfxPassword -Force -AsPlainText

try {
    $cert = Import-PfxCertificate -FilePath $pfxPath -Password $password -CertStoreLocation "Cert:\CurrentUser\My"
} catch {
    Write-Host "❌ Fehler beim Laden der PFX-Datei. Ist der Pfad korrekt?"
    exit 1
}

# === 2. In vertrauenswürdige Stammzertifizierungsstellen importieren ===
Write-Host "🔐 Importiere Zertifikat in 'Trusted Root Certification Authorities'..."
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root", "CurrentUser")
$store.Open("ReadWrite")
$store.Add($cert)
$store.Close()

Write-Host "`n✅ Zertifikat wurde erfolgreich als vertrauenswürdig eingestuft!"
