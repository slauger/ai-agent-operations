# 15 Betrieb und Pflege

## Images

| Image | Inhalt | Wer pflegt |
| --- | --- | --- |
| Runner | Runner-Binary für Agenten-Schritte und als Wrapper | Laufzeit |
| Runtime | generisches Image für Kommando-Schritte: Python, jq, Zeitzonen, Antwort-Skript | Agenten-Repository |
| Werkzeug-Image pro Agent | nur wenn ein Agent eigene Skripte braucht | Agenten-Repository, gebaut in der CI |
| Egress-Proxy | Squid | Hersteller (Canonical), Chart extern |
| Operator, Brücke | | Laufzeit |

Regeln:

- **Basis mit Sicherheitsupdates:** UBI oder Ubuntu-Rocks, regelmäßig neu gebaut.
- **Digest statt Tag im Betrieb.** Ein Tag wie `:dev` oder `:edge` kann sich ändern. Im Betrieb steht im Manifest ein Digest, oder die Laufzeit löst den Tag beim Start auf und hält den Digest im Lauf fest (G40). Renovate schlägt neue Digests als Pull Request vor.
- **Möglichst wenige Images.** Neue Agenten nutzen das Runtime-Image, solange sie keine eigenen Abhängigkeiten brauchen.

## Updates

| Teil | Wie | Wer prüft |
| --- | --- | --- |
| Betriebssystem der Knoten | Flatcar aktualisiert sich selbst, Neustart koordiniert | automatisch |
| Kubernetes (k3s) | Upgrade-Plan im Cluster | Betrieb |
| Operator, Argo Events, Argo CD | Chart-Version im GitOps-Repository, Renovate | Review |
| Images der Agenten | Renovate, CI baut, Digest im Manifest | Review |
| Modelle | Modellname im Manifest; neues Modell ist eine fachliche Änderung | Review mit Testlauf |
| Preise | Preistabelle der Laufzeit | Betrieb |

Ein Modellwechsel ist keine Kleinigkeit: Anweisungen, Kosten und Verhalten ändern sich. Vor dem Wechsel ein Testlauf gegen gespeicherte Eingaben (zum Beispiel Mocks der Webseiten im Agenten-Verzeichnis).

## Datensicherung

| Was | Wo | Sicherung |
| --- | --- | --- |
| Manifeste, Werte, Skripte | Git | Git |
| Zustand der Agenten | Zustands-Volumes | Volume-Sicherung des Clusters; Skripte legen vor dem Schreiben eine Kopie an |
| Läufe | Kubernetes | nicht gesichert, sind Geschichte; Audit-Ereignisse in der Protokollierung |
| Secrets | Secret-Speicher | Sicherung des Tresors |

## Typische Fehlerbilder

| Symptom | Ursache | Wo nachsehen |
| --- | --- | --- |
| Agent erscheint nicht nach dem Push | ApplicationSet folgt `main`, Push ging auf einen anderen Branch | Argo CD, Branch |
| Workflow `Valid=False` | Feld oder Funktion nicht unterstützt, Schema-Fehler | Condition am Workflow |
| Binding `Ready=False`, `StateVolume` | genanntes Volume fehlt | Binding-Status |
| Lauf `TriggerNotAllowed` | Sensor und Manifest passen nicht zusammen (Quelle, Typ, Index) | Lauf-Status, Sensor |
| Lauf `DuplicateEvent` | gewollt: zweite Zustellung desselben Ereignisses | nichts zu tun |
| Keine Antwort im Chat | Brücke nicht im Kanal, Filter passt nicht, Sensor verwirft | Brücke, Sensor-Protokoll |
| Kommando-Schritt erreicht Seite nicht | Domain fehlt in der Allowlist | Zugriffsprotokoll des Egress-Proxys (`TCP_DENIED`) |
| Lauf bricht ab mit Budget | Grenze erreicht | Kosten im Lauf, Audit |
| Keine Push-Nachricht | keine Erwähnung in der Nachricht | Push-Einstellungen, `@all` |

## Einen Agenten abschalten

| Wie | Wirkung |
| --- | --- |
| `suspend: true` in den Werten | Zeitpläne pausieren; manuelle und Ereignis-Läufe gehen weiter |
| Sensor abschalten (`events.enabled: false`) | keine Ereignis-Läufe mehr |
| Verzeichnis entfernen | Agent samt Namespace, Zustand und Secrets weg |
| Notfall | Namespace-Policy auf `none`, oder Binding löschen |
