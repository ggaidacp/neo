
									DD
									D D
									DD OKUMENTATION


SCHRITT-FÜR-SCHRITT ANLEITUNG:

- ZIP Datei entpacken.
- DVAG_Presenter.exe 1x ausführen mit dem Kommandozeilen-Parameter --cfginit um Office zu suchen, den Hintergrund auszupacken und
  die Konfiguration und die für das System spezifischen Pfade in die Registry zu schreiben.
- Anwendung wieder beenden. (Später nicht mehr mit dem --cfginit Parameter starten, da sonst die Konfiguration zurückgesetzt wird.)
- In der Registry im Pfad HKEY_CURRENT_USER\Software\Unit 08\DVAG Presenter\E-Mail\SMTP die Mailserver Zugansdaten hinterlegen.
  Der "Encryption" Parameter bedeutet:
	0: Keine verschlüsselung
	1: SSL
	2: STARTTLS
  Der "AuthMethod" Parameter bedeutet:
	0: Keine verschlüsselung (PLAIN)
	1: LOGIN
- Überprüfen, ob Office gefunden wurde. Die Pfade zu den Executables müssen unter HKEY_CURRENT_USER\Software\Unit 08\DVAG Presenter\Applications
  hinterlegt sein.
- URL zur Mediensteuerung und NextCloud eintragen/überprüfen. Diese beiden Einträge sind in der Registry unterhalb des Pfades
  HKEY_CURRENT_USER\Software\Unit 08\DVAG Presenter\URIs
  zu finden.

Die komplette Anwendungskonfiguration ist in der Registry unterhalb des Pfades "HKEY_CURRENT_USER\Software\Unit 08\DVAG Presenter\" zu finden.

Es ist eine Beispiel-.REG-Datei beigelegt. In dieser sind jedoch dummydaten, sie müsste also manuell angepasst werden vor dem import, damit die
Konfiguration zu Ihrer Umgebung passt.
Es ist auch möglich, alles manuell anzulegen, aber es ist einfacher die .REG Datei manuell anzupassen und mit einem Doppelklick in die Registry zu
importieren. In dem Fall kann man den ersten Start der Anwendung mit dem --cfginit Parameter weglassen. Man kommt aber dadurch nicht in den Genuss
der Automatischen Erkennung soweit es der Anwendug möglich ist.

.REG-Dateien sehen .INI-Dateien sehr ähnlich, können mit dem Texteditor bearbeitet werden (Rechtsklick -> Bearbeiten) und mit einem Doppelklick
in die Registry importiert werden.

ANWENDUNG BEENDEN:

Mindestens 5x schnell nacheinander oben links auf das Logo tippen, dann 1x oben rechts auf die Uhrzeit. Daraufhin öffnet sich ein Dialog, über den
die Anwendug beendet werden kann. In diesen muss man die PIN eingeben, welche in der Registry definiert wird. Bei richtiger eingabe wird die
Anwendung beendet.
Wenn die Anwendung mit --cfginit gestartet wird, wird die PIN auf 1234 gesetzt.

WEITERE KONFIGURATION:

Alle Daten der Anwendung werden im Unterverzeichnis /data unterhalb des aktuellen Arbeitsverzeichnisses abgelegt. In diesem Verzeichnis befinden sich
zwei .JSON dateien. In der Datei filemetadata.json können zu realen Dateinamen:
	1. Benutzerfreundliche Bezeichnungen vergeben werden, die anstelle des Dateinamen angezeigt werden.
	2. Tags zugewiesen werden, um die globale Suche erleichtern zu können.
Es sind Beispieldaten in der Datei, die die nötige Struktur beschreiben.
Daneben liegt die Datei onlineplatforms.json, in der die Links zu den Onlineplattformen hinterlegt sind. Die Struktur dieser Datei ist noch einfacher
und selbsterklärend. Beispieldaten sind in der Datei vorhanden.

SYSTEMEINSTELLUNGS-FENSTER DEAKTIVIEREN:

Um zu verhindern, dass über die Windows-Onscreen-Tastatur die Systemeinstellungen geöffnet werden können, kann in der Registry unterhalb des Pfades

\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer

ein REG_DWORD Eintrag mit dem Namen "NoControlPanel" und dem Wert "1" angelegt werden. Diese Einstellung ist auch in settings.reg vorhanden.

FEHLERANALYSE:

Zur Fehlersuche kann die Anwendug eine Logdatei schreiben. Im normalen Betrieb ist diese funktion nicht aktiv. Um das Logging zu aktivieren, muss die
Anwendung mit dem Parameter --logfile gestartet werden. Der Ort und Name des Logfiles kann optional als nachfolgender Parameter angegeben werden.
Wird dieser jedoch weg gelassen, muss --logfile der letzte parameter sein, sollten noch andere mit angegeben werden. Anderenfalls würde der nachfolgende
Parameter als Dateiname fehlinterpretiert.
Wenn kein Dateiname angegeben wird, wird das Logfile im aktuellen Verzeichnis unter dem Namen DVAG_Presenter.log gespeichert.

Beispiele:

DVAG_Presenter.exe --logfile
DVAG_Presenter.exe --logfile C:\logs\presenter.log
DVAG_Presenter.exe --logfile log.txt
DVAG_Presenter.exe --cfginit --logfile

DAS GEHT NICHT:
DVAG_Presenter.exe --logfile --cfginit

Das geht:
DVAG_Presenter.exe --logfile DVAG_Presenterr.log --cfginit



