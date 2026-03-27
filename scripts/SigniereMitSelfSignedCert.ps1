# ===============================================
# Self-Signed Code Signing Certificate + Signatur
# ===============================================

# === Einstellungen (bitte anpassen) ===
$certName = "CN=MeineFirma GmbH" #"CN=gerhard.gaida@itopea.de"
$pfxPassword = "deimos" #"Deimos04082025"
$pfxPath = "C:\Users\Thanos\projekte\neo\dvag_praesenter\signieren\itopea_codesign.pfx"
$exePath = "C:\Users\Thanos\projekte\neo\build\build-NEO-6_7_1\DVAG_Presenter\DVAG_Presenter.exe"  # <--- Hier Pfad zur EXE anpassen
$signtoolPath = "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe"  # ggf. anpassen

# === 1. Zertifikat erstellen ===
#rite-Host "Erstelle self-signed Code-Signing-Zertifikat..."
#$cert = New-SelfSignedCertificate -Type CodeSigning -Subject $certName -CertStoreLocation "cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature -NotAfter (Get-Date).AddYears(5)

# === 2. Zertifikat exportieren (.PFX) ===
#Write-Host "Exportiere Zertifikat nach: $pfxPath"
#$password = ConvertTo-SecureString -String $pfxPassword -Force -AsPlainText
#Export-PfxCertificate -Cert $cert -FilePath $pfxPath -Password $password

# === 3. Anwendung signieren ===
if (-Not (Test-Path $signtoolPath)) {
    Write-Host "signtool.exe wurde nicht gefunden. Bitte Pfad prüfen!"
    exit 1
}

if (-Not (Test-Path $exePath)) {
    Write-Host "Die angegebene EXE-Datei wurde nicht gefunden: $exePath"
    exit 1
}

Write-Host "Signiere EXE mit dem Zertifikat..."
& "$signtoolPath" sign /f "$pfxPath" /p "$pfxPassword" /fd sha256 /td SHA256 /tr http://timestamp.digicert.com "$exePath"

# === 4. Signatur überprüfen ===
Write-Host "check Signatur..."
& "$signtoolPath" verify /pa /v "$exePath"

Write-Host "Vorgang abgeschlossen!"
