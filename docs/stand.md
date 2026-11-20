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
| Proxy-Variablen für Kommando-Schritte | `executor.proxy` in der Binding setzt `HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY`; Runner-API immer ausgenommen |

## Was nicht gezeigt ist

| Fähigkeit | Warum nicht |
| --- | --- |
| NetworkPolicies wirksam | lokaler Cluster (Docker Desktop) setzt sie nicht durch; braucht k3s |
| Egress-Proxy im laufenden Agenten | Chart fertig und getestet, Ausrollen wartet auf die Veröffentlichung des Charts |
| Freigaben, Rückfragen mitten im Lauf | nicht gebaut; Laufzeit lehnt solche Manifeste ab |
| MCP-Werkzeuge | nicht gebaut |
| Monatsbudget, Meldung bei Fehlschlag, Metriken | nicht gebaut |
| Lokaler Modus ohne Kubernetes | nicht gebaut |
| Eigener Agenten-Cluster | bewusst noch lokal |

## Bekannte Schwachstellen im PoC

Aus der Sicherheitsprüfung ([Prüfprotokoll](pruefung.md)); sie betreffen den Code, nicht nur das Konzept:

| Schwachstelle | Wo | Schwere |
| --- | --- | --- |
| `web.fetch` prüft keine privaten Ziele, und ohne `network`-Block ist jeder Host erlaubt (SSRF aus dem Operator) | Operator, Tool-Proxy | hoch |
| Wer Läufe anlegen darf, kann `manual` oder `schedule` wählen und so `suspend` und Filter umgehen | Operator, Lauf-Prüfung | hoch |
| Der Chat-Workflow schreibt Wünsche aus dem Gespräch in den Zustand, den der tägliche Lauf befolgt | Konzert-Scout | hoch |
| Plattform-Werte (Egress-Modus, Squid-Optionen) stehen in der Werte-Datei des Agenten; ApplicationSet im Projekt `default` | Agenten-Repository | hoch |
| Modell-Schlüssel liegt im Namespace jedes Agenten | Charts, Operator | mittel |
| Antwort wird ungefiltert gepostet; Ziel-URL des Chats kommt aus einem Input | Runtime-Image, Antwort-Skript | mittel |
| Modell-Proxy reicht Anfragen fast unverändert durch | Operator | mittel |
| ServiceAccounts der Sensoren können zwischen Agenten kollidieren | Charts | mittel |
| Chat-Agent im Modus `none` kann mit wirksamen Policies nicht antworten | Chart `mattermost-chat` | mittel |

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
