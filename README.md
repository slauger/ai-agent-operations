# ai-agent-operations

**Website:** https://slauger.github.io/ai-agent-operations/

Referenzkonzept für den Betrieb von KI-Agenten, die wiederkehrende Arbeit erledigen: täglich etwas prüfen und melden, auf Chat-Nachrichten antworten, Repositories pflegen. Es beschreibt alle Bausteine mit Architekturbildern, Begründungen und Stand: offenes Workflow-Format (AWP), Laufzeit auf Kubernetes, GitOps mit einem Verzeichnis pro Agent, Ereignisse über MQTT und Argo Events, Chat als Oberfläche, Namespace und Egress-Proxy pro Agent, Secrets, Budgets, Zustand, Topologie und Betrieb.

Jeder Baustein, der als "umgesetzt" markiert ist, lief in einem Proof of Concept auf Kubernetes.

## Die Idee in einem Satz

Ein Agent ist ein geprüftes, offenes Workflow-Manifest in Git; die Plattform rollt ihn per GitOps in einen eigenen, abgeschotteten Namespace aus, startet ihn deterministisch über Zeitpläne und Ereignisse, und jeder Schritt erreicht Modelle, Werkzeuge und das Internet nur über Türen, die prüfen, zählen und protokollieren.

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
