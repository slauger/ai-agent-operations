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
