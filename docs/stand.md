# Stand des Proof of Concept

Stand: 20.11.2026.

## Was gelaufen ist

| Fähigkeit | Nachweis |
| --- | --- |
| Täglicher Agent mit zwei Modellen, fünf Kommando-Schritten und Zustand | Konzert-Scout gegen echte Club-Seiten und das echte Modell, Meldung im Chat, per E-Mail und Telegram |
| Budgets stoppen einen Lauf | `maxCostUsd: 0.01` stoppt im Kurator, nachfolgende Schritte entfallen |
| Ereignis-Kette Chat bis Antwort | Nachricht im Chat, Brücke, Broker, EventSource, Sensor, Lauf, Antwort im Thread |
| Thread-Kontext und Antwort auf Thread | Rückfrage "und im April?" wird mit dem Verlauf verstanden |
| Duplikaterkennung | zwei passende Routen, zweiter Lauf `DuplicateEvent` |
| GitOps: Agent hinzufügen und entfernen | Verzeichnis anlegen oder löschen, rund 20 Sekunden bis zum Ergebnis |
| Zwei Workflows teilen Zustand | Chat-Workflow liest das Gedächtnis des täglichen Laufs |
| Chat-Assistent ohne Werkzeuge | eigener Kanal, jede Nachricht, Antwort im Thread |
| Egress-Proxy | Squid ohne root mit Pod Security `restricted`: erlaubte Domain geht, andere Domain, Cluster-Dienst, Service-IP, Metadaten-Adresse und falscher Port werden verweigert |
| Egress-Proxy im laufenden Agenten | je ein Squid in beiden Agenten-Namespaces; aus dem Namespace erreichbar: nur die erlaubten Domains |
| Mehrere Anbieter | Anthropic, dazu Ollama und vLLM auf CPU im Cluster über das Protokoll `openai`, Kosten 0 |
| Proxy-Variablen für Kommando-Schritte | `executor.proxy` in der Binding setzt `HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY`; Runner-API immer ausgenommen |

## Was nicht gezeigt ist

| Fähigkeit | Warum nicht |
| --- | --- |
| NetworkPolicies wirksam | lokaler Cluster (Docker Desktop) setzt sie nicht durch; braucht k3s |
| Freigaben, Rückfragen mitten im Lauf | nicht gebaut; Laufzeit lehnt solche Manifeste ab |
| MCP-Werkzeuge | nicht gebaut |
| Monatsbudget, Meldung bei Fehlschlag, Metriken | nicht gebaut |
| Lokaler Modus ohne Kubernetes | nicht gebaut |
| Eigener Agenten-Cluster | bewusst noch lokal |

## Schwachstellen aus der Prüfung

Aus der Sicherheitsprüfung ([Prüfprotokoll](pruefung.md)); sie betrafen den Code, nicht nur das Konzept. Stand nach den Korrekturen vom 20.11.2026:

| Schwachstelle | Wo | Schwere | Stand |
| --- | --- | --- | --- |
| `web.fetch` ohne Schutz vor privaten Zielen, ohne `allowHosts` jeder Host erlaubt (SSRF aus dem Operator) | Operator | hoch | behoben: nur Hosts aus `allowHosts`, private Ziele nach der Namensauflösung verweigert, auch bei Weiterleitungen |
| Läufe mit beliebigem Auslöser-Typ, `suspend` und Filter umgehbar | Operator | hoch | behoben: Admission-Regel (Zeitplan-Läufe nur der Operator, Sensoren nur Ereignis-Läufe), Zeitplan-Läufe müssen einen Zeitplan-Auslöser nennen |
| Chat schreibt Freitext-Wünsche in den Zustand, den der tägliche Lauf befolgt | Konzert-Scout | hoch | teilweise: nur noch typisierte, geprüfte Einträge; eine Bestätigung im Chat fehlt |
| Plattform-Werte in der Werte-Datei des Agenten, ApplicationSet im Projekt `default` | Agenten-Repository | hoch | behoben: Richtlinien-Prüfung in der CI, CODEOWNERS, AppProject `agents` |
| Modell-Proxy reicht Anfragen fast unverändert durch | Operator | mittel | behoben: Positivliste der Felder, keine serverseitigen Werkzeuge, keine Beta-Header, kein Streaming |
| Antwort ungefiltert gepostet, Ziel-URL aus einem Input | Antwort-Skripte | mittel | behoben: Bereinigung vor dem Posten, feste `https`-Adresse im Manifest |
| Chat-Agent im Modus `none` kann mit wirksamen Policies nicht antworten | Chart `mattermost-chat` | mittel | behoben: eigener Squid mit dem Chat-Host als einziger Domain |
| ServiceAccounts der Sensoren können zwischen Agenten kollidieren | Charts | mittel | behoben: Agent als Präfix, Eindeutigkeit in der CI geprüft |
| Modell-Schlüssel liegt im Namespace jedes Agenten | Charts, Operator | mittel | behoben: Anbieter-Profile im Operator, Schlüssel nur in dessen Namespace |
| Ticket im Pod für Kommandos lesbar | Runner | niedrig | offen |
| keine Tages- oder Monatsgrenze für Kosten | Operator | mittel | offen |

## Komponenten und Repositories

| Komponente | Wo |
| --- | --- |
| Operator | agentable-operator |
| Runner | agentable-runner |
| Chat-Brücke | agentable-mattermost-bridge |
| Agenten, Charts, Runtime-Image | agents |
| Squid-Chart | helm-charts (Chart `squid`) |
| Broker, Chat | GitOps-Repository des Betreibers |
| Spezifikation | Agentic Workflow Protocol |
