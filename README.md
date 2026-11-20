# ai-agent-operations

**Website:** https://slauger.github.io/ai-agent-operations/

Referenzkonzept für den Betrieb von KI-Agenten, die wiederkehrende Arbeit erledigen: täglich etwas prüfen und melden, auf Chat-Nachrichten antworten, Repositories pflegen. Es beschreibt alle Bausteine mit Architekturbildern, Begründungen und Stand: offenes Workflow-Format (AWP), Laufzeit auf Kubernetes, GitOps mit einem Verzeichnis pro Agent, Ereignisse über MQTT und Argo Events, Chat als Oberfläche, Namespace und Egress-Proxy pro Agent, Secrets, Budgets, Zustand, Topologie und Betrieb.

Jeder Baustein, der als "umgesetzt" markiert ist, lief in einem Proof of Concept auf Kubernetes.

## Die Idee in einem Satz

Ein Agent ist ein geprüftes, offenes Workflow-Manifest in Git; die Plattform rollt ihn per GitOps in einen eigenen, abgeschotteten Namespace aus, startet ihn deterministisch über Zeitpläne und Ereignisse, und jeder Schritt erreicht Modelle, Werkzeuge und das Internet nur über Türen, die prüfen, zählen und protokollieren.

## Komponenten

| Komponente | Aufgabe | Produkt im Proof of Concept | Stand |
| --- | --- | --- | --- |
| Workflow-Manifest | beschreibt, was ein Agent tut und darf: Modelle, Schritte, Rechte, Budgets, Auslöser | [Agentic Workflow Protocol](https://agenticworkflowprotocol.org) (AWP) `v1alpha2` | umgesetzt |
| Laufzeit (Operator) | prüft Manifeste, Zeitpläne und Läufe, startet jeden Schritt als eigenen Pod, Modell- und Tool-Proxy mit Budgets, Audit | agentable-operator (Go, Kubernetes) | umgesetzt |
| Runner | führt einen Schritt aus: Tool-Schleife für Agenten, Wrapper für Kommandos; nur ein Ticket, kein Token, kein Schlüssel | agentable-runner | umgesetzt |
| Agenten-Repository | ein Verzeichnis pro Agent mit Manifest, Werten, Skripten, Tests; Bibliotheks- und Anwendungs-Charts; Richtlinien-Prüfung in der CI | Git, Helm | umgesetzt |
| Bereitstellung | ein Verzeichnis wird eine Application im eigenen Namespace; entfernt heißt gelöscht | Argo CD mit ApplicationSet und AppProject | umgesetzt |
| Ereignis-Bus | interner Bus für Ereignisse, Zugriff pro Client über ACLs | Mosquitto (MQTT), Format CloudEvents | umgesetzt |
| Ereignis-Router | deterministische Filter ohne Modell, legt Läufe an | Argo Events (EventSource, EventBus, Sensor pro Workflow) | umgesetzt |
| Chat und Benachrichtigung | Meldungen mit Push, Rückfragen und Antworten im Thread, später Freigaben | Mattermost | umgesetzt |
| Chat-Brücke | hört im Chat mit und veröffentlicht Nachrichten samt Thread-Verlauf als CloudEvents | agentable-mattermost-bridge | umgesetzt |
| Egress-Proxy | einzige Tür ins Internet für Kommando-Schritte, Allowlist von Domains, keine privaten Ziele, ein Proxy pro Agent | Squid (`ubuntu/squid`), Chart `squid` aus slauger/helm-charts | umgesetzt |
| Isolation | Namespace pro Agent, Pod Security `restricted`, NetworkPolicy standardmäßig zu | Kubernetes | umgesetzt (Policies wirken erst mit einer CNI, die sie durchsetzt) |
| Runtime-Image | generisches Image für Kommando-Schritte: Antwort ins Chat-Thread mit Bereinigung | UBI 9 mit Python | umgesetzt |
| Modelle | über den Modell-Proxy mit Budget, Schlüssel nur dort | Anthropic Claude | umgesetzt |
| Secrets | Zuordnung in der Binding, Wert nur im Kommando-Schritt | Kubernetes Secrets; External Secrets oder Sealed Secrets geplant | teilweise |
| Cluster | kleine, gleichförmige Cluster, Agenten in einem eigenen | lokal Docker Desktop; k3s auf Flatcar Linux geplant | teilweise |

Die Produkte sind austauschbar, die Grenzen zwischen den Bausteinen nicht. Details und Architekturbilder stehen auf der [Website](https://slauger.github.io/ai-agent-operations/), das Gesamtbild in [01 Architektur](docs/01-architektur.md).

## Inhalt

| Bereich | Inhalt |
| --- | --- |
| [docs/index.md](docs/index.md) | Übersicht, Bausteine und Produkte |
| [Grundlagen](docs/00-ziel-und-leitlinien.md) | Ziel, Leitlinien, Architektur, drei Ebenen der Konfiguration |
| [Bausteine](docs/03-workflow-manifest.md) | Manifest, Laufzeit, GitOps, Ereignisse, Chat, Netzwerk, Secrets, Kosten, Zustand, Beobachtung |
| [Betrieb](docs/13-cluster-topologie.md) | Cluster-Topologie, Sicherheit, Pflege, ohne Kubernetes |
| [Beispiele](docs/beispiel-konzert-scout.md) | Konzert-Scout, Chat-Assistent, neuen Agenten anlegen |
| [Abgleich](docs/entscheidungen.md) | Entscheidungen, Abgleich mit AWP, offene Fragen, Stand |

## Website

`make docs-serve` startet die Website lokal (MkDocs Material in Docker), `make check` prüft Satzzeichen und baut streng.

## Lizenz

Copyright Simon Lauger. [CC BY-NC-SA 4.0](LICENSE).
