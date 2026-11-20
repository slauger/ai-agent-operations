# KI-Agenten betreiben

Ein Referenzkonzept dafür, wie man KI-Agenten betreibt, die wiederkehrende Arbeit erledigen: täglich etwas prüfen und melden, auf eine Chat-Nachricht antworten, ein Repository pflegen. Es beschreibt alle Bausteine von der Definition eines Agenten über Auslöser, Ausführung, Netzwerk und Secrets bis zum Betrieb, jeweils mit Architekturbild, Begründung und Stand.

Das Konzept ist nicht am Reißbrett entstanden. Jeder Baustein, der als "umgesetzt" markiert ist, lief in einem Proof of Concept (PoC) auf Kubernetes: ein Agent, der Konzertprogramme abklappert und neue Konzerte meldet, und ein Chat-Assistent in einem Mattermost-Kanal. Was der PoC gezeigt hat, und was nicht, steht in [Stand des Proof of Concept](stand.md).

## Die Idee in einem Satz

Ein Agent ist ein geprüftes, offenes Workflow-Manifest in Git; die Plattform rollt ihn per GitOps in einen eigenen, abgeschotteten Namespace aus, startet ihn deterministisch über Zeitpläne und Ereignisse, und jeder Schritt erreicht Modelle, Werkzeuge und das Internet nur über Türen, die prüfen, zählen und protokollieren.

## Für wen

Für Menschen, die Plattformen betreiben oder Agenten produktiv einsetzen wollen: Betrieb, Plattform-Teams, Sicherheitsverantwortliche, Architekten. Grundwissen zu Kubernetes, Git und Containern wird vorausgesetzt; Begriffe rund um Agenten erklärt das [Glossar](glossar.md).

## Aufbau

| Teil | Kapitel | Worum es geht |
| --- | --- | --- |
| Grundlagen | [00 Ziel und Leitlinien](00-ziel-und-leitlinien.md) | Was Agenten im Betrieb von Chat-Assistenten unterscheidet und welche Grundsätze daraus folgen |
| | [01 Architektur im Überblick](01-architektur.md) | Das Gesamtbild: Komponenten, Datenflüsse, Verantwortlichkeiten |
| | [02 Drei Ebenen der Konfiguration](02-drei-ebenen.md) | Was ins Manifest gehört, was in die Laufzeit, was in die Plattform |
| Bausteine | [03 Workflow-Manifest](03-workflow-manifest.md) | Das offene Format AWP: Agenten, Schritte, Rechte, Budgets, Auslöser |
| | [04 Laufzeit](04-laufzeit.md) | Operator, Binding, Lauf, Schritt-Pods, Modell- und Tool-Proxy |
| | [05 Bereitstellung mit GitOps](05-bereitstellung.md) | Ein Verzeichnis pro Agent, Helm-Charts, ApplicationSet, Namespace pro Agent |
| | [06 Ereignisse und Auslöser](06-ereignisse.md) | Zeitplan, manuell, Ereignisse über MQTT, Argo Events und CloudEvents |
| | [07 Kanäle und Chat](07-kanaele.md) | Benachrichtigungen, Antworten im Thread, Chat-Assistent, Rückweg |
| | [08 Isolation und Netzwerk](08-isolation-und-netzwerk.md) | Namespace, Pod Security, NetworkPolicy, Egress-Proxy pro Agent |
| | [09 Secrets und Identitäten](09-secrets-und-identitaeten.md) | Wer welches Geheimnis sieht, Bot-Konten, Tickets statt Tokens |
| | [10 Modelle, Budgets und Kosten](10-modelle-und-kosten.md) | Modellwahl, verschachtelte Budgets, was ein Lauf kostet |
| | [11 Zustand und Kontext](11-zustand-und-kontext.md) | Gedächtnis zwischen Läufen, geteilte Volumes, Gesprächsverlauf |
| | [12 Beobachtung und Audit](12-beobachtung.md) | Status in Kubernetes, Audit-Ereignisse, Kosten, Alarme |
| Betrieb | [13 Cluster-Topologie](13-cluster-topologie.md) | Welche Cluster es gibt und was wo läuft |
| | [14 Sicherheit und Bedrohungen](14-sicherheit.md) | Bedrohungsmodell, Prompt-Injection, Vertrauensgrenzen |
| | [15 Betrieb und Pflege](15-betrieb.md) | Updates, Images, Backup, Fehlerbilder |
| | [16 Ohne Kubernetes](16-ohne-kubernetes.md) | Warum das Datenmodell nicht an Kubernetes hängen darf |
| Beispiele | [Konzert-Scout](beispiel-konzert-scout.md), [Chat-Assistent](beispiel-assistent.md), [Neuer Agent](neuer-agent.md) | Zwei echte Agenten Schritt für Schritt, und wie man einen neuen anlegt |
| Abgleich | [Entscheidungen](entscheidungen.md), [Abgleich mit AWP](awp-abgleich.md), [Offene Fragen](offene-fragen.md), [Stand](stand.md) | Was entschieden ist, was die Spezifikation betrifft, was offen ist |

## Bausteine und Produkte

| Aufgabe | Baustein im Konzept | Im PoC |
| --- | --- | --- |
| Format eines Agenten | offenes Workflow-Manifest | [Agentic Workflow Protocol](https://agenticworkflowprotocol.org) (AWP) `v1alpha2` |
| Ausführung | Kubernetes-Operator mit Schritt-Pods | agentable (Operator und Runner) |
| Bereitstellung | GitOps aus einem Repository | Argo CD mit ApplicationSet, Helm-Charts |
| Ereignisse | Bus plus deterministischer Router | Mosquitto (MQTT), Argo Events, CloudEvents |
| Chat und Benachrichtigung | vorhandener Team-Chat | Mattermost, eine kleine Brücke zum Bus |
| Netzwerkgrenze | NetworkPolicy plus Egress-Proxy pro Agent | Kubernetes NetworkPolicy, Squid |
| Modelle | über einen Proxy mit Budget | Anthropic Claude |
| Cluster | kleine, gleichförmige Cluster | k3s auf Flatcar Linux, lokal Docker Desktop |

Die Produkte sind austauschbar; die Grenzen zwischen den Bausteinen sind es nicht. Wer Argo Events durch Knative Eventing ersetzt oder Mattermost durch Matrix, ändert einen Baustein, nicht das Konzept.

## Stand der Angaben

Stand: 20.11.2026. Das Konzept ist ein Entwurf. Kennzeichnungen: **umgesetzt** (lief im PoC), **geplant** (entschieden, nicht gebaut), **offen** (nicht entschieden).
