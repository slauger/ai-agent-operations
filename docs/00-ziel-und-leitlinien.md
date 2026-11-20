# 00 Ziel und Leitlinien

## Worum es geht

Ein Chat-Assistent antwortet, wenn ein Mensch fragt, und der Mensch liest die Antwort, bevor etwas passiert. Ein Agent im Betrieb arbeitet ohne diesen Menschen: Er startet um sieben Uhr, liest fremde Webseiten, ruft Werkzeuge auf, schreibt in einen Kanal, merkt sich etwas für morgen. Er tut das jeden Tag, mit echtem Geld für Modellaufrufe, mit echten Zugangsdaten und mit Eingaben, die jemand anderes geschrieben hat.

Damit wird ein Agent zu einer Arbeitslast wie jede andere, nur mit einer Eigenschaft, die klassische Software nicht hat: **Sein Verhalten ist nicht vorhersagbar.** Ein Skript tut, was im Code steht. Ein Agent tut, was das Modell aus Anweisung, Eingabe und Werkzeugergebnissen macht, und eine präparierte Webseite kann ihm neue Anweisungen unterschieben.

Das Konzept beantwortet deshalb nicht die Frage "Wie baue ich einen klugen Agenten?", sondern: **Wie betreibe ich viele kleine Agenten so, dass ein Fehler oder eine Manipulation klein bleibt, nachvollziehbar ist und nichts kostet, was niemand erlaubt hat?**

## Anwendungsfälle

Die Anwendungsfälle sind bewusst gewöhnlich:

| Art | Beispiel | Auslöser |
| --- | --- | --- |
| Beobachten und melden | neue Konzerte in bekannten Clubs, neue CVEs für eingesetzte Software | Zeitplan |
| Antworten | Rückfrage zu einer Meldung im Thread, freier Chat in einem Kanal | Chat-Nachricht |
| Pflegen | Repository prüfen: läuft die CI, arbeitet Renovate, sind Abhängigkeiten aktuell | Zeitplan, Webhook |
| Prüfen | eigene Webseiten auf Sicherheitsstandard prüfen, Portscan aus einer kurzlebigen VM | Zeitplan, mit Freigabe |

Gemeinsam ist allen: wenige Schritte, ein klares Ergebnis, ein Kanal, in dem es landet.

## Leitlinien

1. **Git ist die einzige Quelle.** Ein Agent ist eine Datei in einem Repository. Was im Repository steht, läuft; was entfernt wird, verschwindet aus dem Cluster. Niemand legt etwas von Hand an.
2. **Offenes Format statt eigener Erfindung.** Agenten werden in einem offenen, dokumentierten Format beschrieben (AWP), mit JSON-Schema und Prüfwerkzeug. Was im Format fehlt, geht als Vorschlag an die Spezifikation, statt still in der Laufzeit nachgebaut zu werden.
3. **Das Manifest sagt was, nicht wo.** Das geprüfte Manifest beschreibt, was ein Agent tun und dürfen soll. Wo und mit welchen Zugangsdaten er läuft, steht außerhalb ([Kapitel 02](02-drei-ebenen.md)).
4. **Deterministisch bis zum Modell.** Auslöser, Filter, Routing und Zustellung kommen ohne Sprachmodell aus. Eine Nachricht kann den Router nicht per Prompt umlenken, und tausend Ereignisse kosten nichts.
5. **Eine Tür pro Richtung.** Ein Schritt erreicht Modelle und Werkzeuge nur über den Proxy der Laufzeit und das Internet nur über den Egress-Proxy seines Agenten. Jede Tür prüft, zählt und protokolliert.
6. **Kleinster Spielraum.** Ein Namespace pro Agent, kein Kubernetes-Token im Pod, Secrets nur für die Schritte, die sie brauchen, Netzwerk standardmäßig zu.
7. **Fail closed.** Was die Laufzeit nicht sicher umsetzen kann (eine Freigabe, ein unbekanntes Werkzeug), wird abgelehnt, nicht halb ausgeführt.
8. **Budgets sind Pflicht.** Jeder Lauf hat eine Kostenobergrenze und ein Zeitlimit. Ein Agent, der sich verrennt, wird teuer gestoppt, nicht teuer bezahlt.
9. **Keine eigene Oberfläche.** Status steht in Kubernetes, Meldungen und Rückfragen laufen über einen vorhandenen Chat. Gebaut wird nur, was es für Agenten nirgends gibt.
10. **Vorhandenes nutzen.** Für Ereignisse, Bereitstellung, Proxy und Chat gibt es reife Werkzeuge. Die Plattform baut nur den Teil, der für Agenten spezifisch ist: Modell-Proxy mit Budget, Tool-Proxy mit Rechten, Ticket pro Schritt.

## Was das Konzept nicht ist

- **Keine Agenten-Bibliothek.** Wie ein Agent intern denkt (Tool-Schleife, Planung), ist Sache der Laufzeit; das Konzept legt nur fest, was er darf.
- **Keine CI/CD-Engine.** Feste Abläufe aus vertrauenswürdigem Code gehören weiter in Tekton, GitLab CI oder Forgejo Actions:

| | CI/CD | AWP | Laufzeit |
| --- | --- | --- | --- |
| Was | Engine für feste Abläufe | Spezifikation, keine Engine | Laufzeit für AWP auf Kubernetes |
| Wer handelt | vertrauenswürdiger, fest geschriebener Code | Agenten mit nicht vorhersagbarem Verhalten, dazu Kommandos | |
| Kernfrage | läuft Build, Test, Deploy durch | was darf ein Agent: Modell, Werkzeuge, Aktionen, Budget, Freigaben, Daten, Audit | setzt das durch |

Für die Mechanik drumherum wird nichts nachgebaut (Auslöser aus Argo Events). Ein Agenten-Schritt mit Ticket, Proxy und Freigaben passt aber schlecht in eine CI-Task; deshalb führt die Laufzeit Schritte selbst aus (E03).
- **Kein Produkt mit Oberfläche.** Wer Dashboards für Manager braucht, baut sie auf die Kubernetes-API oder die Audit-Ereignisse.
