# Prüfprotokoll

Der erste Entwurf wurde am 20.11.2026 dreimal unabhängig geprüft, jeweils ohne Kenntnis der anderen Prüfungen:

| Prüfung | Blick | Grundlage |
| --- | --- | --- |
| 1 | Architektur und Sicherheit | Konzept gegen den Code des PoC (Operator, Runner, Charts, Brücke, Squid-Chart) |
| 2 | Betrieb und Verständlichkeit | Konzept aus Sicht eines Betreibers, der das System nicht gebaut hat; alle Diagramme gerendert |
| 3 | Abgleich mit AWP | Konzept und Lückenliste gegen den aktuellen Entwurf von AWP `v1alpha2` |

## Wichtigste Befunde und was daraus wurde

| Befund | Prüfung | Ergebnis |
| --- | --- | --- |
| Der Tool-Proxy des Operators ist eine zweite Tür ins Internet ohne Schutz vor privaten Zielen (SSRF) | 1, 2 | neuer Abschnitt in [08](08-isolation-und-netzwerk.md#der-operator-als-zweite-tür), Härtung des Operators in [14](14-sicherheit.md#härtung-des-operators); Code-Fehler in [Stand](stand.md#bekannte-schwachstellen-im-poc) |
| Filter und Auslöser-Typ eines Laufs werden nicht durchgesetzt; Zeitplan-Läufe kann jeder anlegen, der Läufe anlegen darf | 1 | korrigiert in [04](04-laufzeit.md#lebenslauf-eines-laufs) und [06](06-ereignisse.md#filtern-auf-zwei-ebenen); Admission-Regel geplant |
| Der Chat-Workflow schreibt in den Zustand: Gedächtnis kann vergiftet werden | 1 | korrigiert in [11](11-zustand-und-kontext.md), neue Bedrohung in [14](14-sicherheit.md), E24 |
| Ebene 3 (Plattform) wird in der Werte-Datei des Agenten geschrieben | 1, 2 | Abschnitt "Durchsetzung heute" in [02](02-drei-ebenen.md#durchsetzung-heute); AppProject, Richtlinien-Prüfung, CODEOWNERS geplant |
| Mehrere Angaben "umgesetzt" waren nicht durch den PoC gedeckt | 2 | Kennzeichnung "teilweise" eingeführt, Status in 08, 14, 15 korrigiert |
| Kostenrisiko: Ratenbegrenzung erlaubt über 1000 USD am Tag | 1, 2 | [10](10-modelle-und-kosten.md#budgets), E21 |
| Notfall-Abschaltung von Hand wird von Argo CD zurückgesetzt | 1, 2 | [15](15-betrieb.md#einen-agenten-abschalten), Pause im Operator geplant |
| Es fehlten Ausfälle, Upgrade, Mandanten, Datenschutz, Fixkosten, Ratenlimits | 2 | neue Abschnitte in [10](10-modelle-und-kosten.md) und [15](15-betrieb.md) |
| Chat-Antwort als Ausgang für Daten; Ziel-URL aus Eingaben; Injection über Thread-Beiträge Dritter; DNS-Tunnel | 1 | [07](07-kanaele.md#rückweg), [14](14-sicherheit.md) |
| Chat-Agent im Modus `none` kann mit wirksamen Policies nicht antworten | 1, 2 | [Beispiel](beispiel-assistent.md), O11 |
| Lauf-Objekt und Ereignisdaten weichen vom AWP-Entwurf ab (AEP-0019, D7, AEP-0004) | 3 | [04](04-laufzeit.md#ressourcen), [03](03-workflow-manifest.md#beispiel), E22, O03 geschlossen |
| `scope: [agent]` ist kein Schlüsselwort; ohne `network`-Block gilt `egress: allow` | 3 | [03](03-workflow-manifest.md), [09](09-secrets-und-identitaeten.md), E23 |
| G01, G07, G08, G40 im Entwurf gelöst; G10, G26, G35 kleiner | 3 | [Abgleich](awp-abgleich.md#stand-der-lücken) |
| Elf neue Punkte für die Spezifikation | 3 | [Abgleich](awp-abgleich.md#neue-punkte-für-die-spezifikation) |
| Wiederholungen (Duplikate achtfach, Ausführungsort, CI/CD-Abgrenzung), überflüssige Diagramme | 2 | gekürzt; CI/CD-Abgrenzung nach [00](00-ziel-und-leitlinien.md) |
| Topologie liest sich wie ein privates Setup; Knoten vor Ort öffnet das Heimnetz | 2 | [13](13-cluster-topologie.md) als Ausblick, allgemein formuliert, Risiko genannt |

## Nicht übernommen

| Vorschlag | Warum nicht |
| --- | --- |
| Kapitel 16 auflösen und auf 02 und die Entscheidungen verteilen | Die Frage "geht es ohne Kubernetes?" ist für Leser eigenständig wichtig; das Kapitel ist kurz |
| Kapitel 02 hinter 04 stellen | Die drei Ebenen sind der rote Faden; stattdessen erklärt 01 jetzt kurz die beiden Schrittarten |
| Broker und EventBus für eine einzige Quelle streichen | als offene Frage O15 aufgenommen; der Bus trägt weitere Quellen |
