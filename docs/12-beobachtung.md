# 12 Beobachtung und Audit

Keine eigene Oberfläche: Der Status steht in Kubernetes, Meldungen kommen in den Chat, Audit-Ereignisse gehen in die Protokollierung.

## Status in Kubernetes

```text
$ kubectl get wfb -A
NAMESPACE             NAME                 WORKFLOW             VERSION   READY   LAST RUN                   RESULT      NEXT
agent-assistent       assistent            assistent            0.1.0     True    assistent-jcjr8            Succeeded
agent-konzert-scout   konzert-scout        konzert-scout        0.1.0     False
agent-konzert-scout   konzert-scout-chat   konzert-scout-chat   0.1.0     True    konzert-scout-chat-jcv5b   Succeeded

$ kubectl get wfr -n agent-konzert-scout
NAME                       WORKFLOW             TRIGGER   PHASE       COST USD   AGE
konzert-scout-chat-jcv5b   konzert-scout-chat   event     Succeeded   0.082366   3m
konzert-scout-chat-nmbb2   konzert-scout-chat   event     Failed                 3m
```

Der zweite Lauf ist das Duplikat derselben Nachricht (Grund `DuplicateEvent`), der tägliche Lauf ist pausiert (`Ready=False`, Grund `Suspended`).

| Objekt | Zeigt |
| --- | --- |
| `Workflow` | Conditions `Valid` (Schema, unterstützte Funktionen) und `Bound` |
| `WorkflowBinding` | Bereitschaft mit Grund (`Suspended`, `StateVolume`, ...), letzter Lauf, nächster Termin |
| `WorkflowRun` | Phase, Auslöser, Status je Schritt, Tokens, Kosten, Grund eines Fehlers |
| Kubernetes-Events | Läufe, Schritte, Bindings |

## Audit-Ereignisse

Der Operator schreibt die Audit-Ereignisse aus AWP als JSON-Zeilen (umgesetzt): Lauf gestartet (mit Digest des Manifests), Schritt gestartet und beendet, Modellaufruf, Werkzeugaufruf, Budget erreicht. Zusammen mit dem Zugriffsprotokoll des Egress-Proxys ergibt sich pro Lauf: welches Manifest lief, welches Modell wurde wie oft gefragt, was hat es gekostet, welche Domains haben Kommando-Schritte angefragt und welche wurden verweigert. Zwei Lücken: Abrufe über den Tool-Proxy (`web.fetch`) stehen nur im Audit des Operators, nicht im Proxy-Protokoll; und Ereignis-Läufe haben den Akteur `system`, der auslösende Mensch steht nur in den Eingaben (G44).

## Meldungen

| Was | Wohin | Stand |
| --- | --- | --- |
| Ergebnis eines Laufs | Kanal des Agenten | umgesetzt |
| fehlgeschlagener Lauf | Betriebskanal, sofort | geplant |
| Tageszusammenfassung aller Agenten, ohne Modell | Betriebskanal | geplant |
| Metriken (Läufe, Fehler, Kosten) | Prometheus, Alarme über Alertmanager | geplant |

Eine Meldung bei Fehlschlag kann heute nicht im Manifest stehen, weil es keine Schritte gibt, die nach einem Fehler laufen (G13). Bis dahin übernimmt das die Laufzeit oder ein Alarm auf die Metrik.

## Verwaltung im Chat

Zwei Stufen, damit es nichts kostet, solange niemand fragt:

1. **Status ohne Modell:** `/agent status` antwortet direkt aus dem Kubernetes-Status ("12 Agenten, 11 in Ordnung, 1 fehlgeschlagen, Kosten heute 0,84 USD").
2. **Verwaltungs-Agent nur auf Nachfrage:** "Warum schlägt die Prüfung seit drei Tagen fehl?" startet einen Agenten mit lesenden Werkzeugen des Operators (Läufe auflisten, Protokolle lesen) und, mit Freigabe, schreibenden (pausieren, starten). Der Operator bietet diese Werkzeuge als MCP-Server an.

Beides ist geplant.
