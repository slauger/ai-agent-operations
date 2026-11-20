# Offene Fragen

| Nr. | Frage | Optionen | Abhängig von |
| --- | --- | --- | --- |
| O01 | Wie wird das Trigger-Objekt gebaut, wenn die Laufzeit es aus dem Manifest erzeugt (E22)? | Laufzeit erzeugt einen Argo-Sensor, der nur ein internes Ereignis an die Laufzeit gibt; oder die Laufzeit abonniert den EventBus selbst | Filter-Semantik (G42), Trigger-Objekte in AEP-0021 |
| O02 | Wie wird die Allowlist des Egress-Proxys aus `permissions.network` abgeleitet, und wo steht die Obergrenze des Betreibers? | Obergrenze pro Namespace außerhalb des Agenten-Verzeichnisses; Ablehnung, wenn das Manifest mehr verlangt | Rolle von `permissions.network` (G47), Syntax von `allowHosts` |
| O05 | Braucht die Laufzeit für Coding-Aufgaben einen vollwertigen Coding-Agenten im Pod statt der eigenen Tool-Schleife? | eigene Schleife, Coding-Agent als Kommando-Schritt | Anwendungsfall Repository-Pflege |
| O06 | Wie werden Freigaben gebaut? | Knöpfe im Chat über einen eigenen Dienst (nicht die lesende Brücke), signierter Kontext, Lauf wartet | AWP-Profil `governance` |
| O07 | Ein Chat-Kanal pro Agent oder ein gemeinsamer? | pro Agent für Meldungen, gemeinsamer Betriebskanal für Fehler | Zahl der Agenten |
| O08 | Wohin gehen Pod-Logs, Audit-Ereignisse und Proxy-Protokolle, und wie lange bleiben sie? | zentrale Protokollierung mit Frist | Datenschutz |
| O09 | Wie kommen Secrets in den Agenten-Cluster? | External Secrets aus einem Tresor, Sealed Secrets | Topologie |
| O10 | Wo läuft die Brücke? | nahe am Chat oder bei den Agenten | Topologie |
| O11 | Wie erreicht ein Chat-Agent den Chat für seine Antwort, wenn die Policies wirken? | Egress-Proxy im Anwendungs-Chart mit dem Chat-Host als einziger Domain (bevorzugt), CIDR-Allowlist | Agenten-Cluster |
| O13 | Wie wird der Zustand vor versehentlichem Löschen geschützt? | PVC aus dem Prune ausnehmen, `Retain`, Löschen nur mit Freigabe | Datensicherung |
| O14 | Wie wird der Operator hochverfügbar, obwohl er auch Datenweg (Runner-API, Proxys) ist? | mehrere Replikas mit Wahl eines Leiters für die Steuerung und Proxy in allen Replikas; oder Proxy als eigener Dienst | Last |
| O15 | Soll eine einzelne Ereignisquelle über Broker und EventBus laufen oder direkt an eine Webhook-EventSource? | Bus ab der zweiten Quelle, direkt für den Anfang | Zahl der Quellen |
| O16 | Wie werden ereignisgesteuerte Workflows getestet, wenn manuelle Läufe kein Ereignis tragen dürfen (AEP-0004)? | Testlauf mit mitgegebenem Ereignis, als Wiederholung markiert | AWP |

Geschlossen:

- **O03** (wie Ereignisdaten in den Lauf kommen): in AWP entschieden (D7, AEP-0004): eigene Wurzel `${{ event.* }}`, keine Abbildung auf Inputs. Die Laufzeit folgt (E22).
- **O04** (Webhook-Eingang): Argo Events (E07).
- **O12** (Images festlegen): im AWP-Entwurf geregelt (G40): Tags werden beim Start auf den Digest aufgelöst und festgehalten, unter dem Sicherheitsprofil ist ein Digest Pflicht.
