# Abgleich mit AWP

Was das Konzept für die Spezifikation bedeutet und wo es vom aktuellen Entwurf abweicht. Nummern (G..) verweisen auf die Liste der Laufzeit-Rückmeldungen an AWP (`docs/runtime-feedback.md` im AWP-Repository); hier werden keine neuen vergeben. AEP sind Änderungsvorschläge an die Spezifikation.

Stand des Abgleichs: 20.11.2026, gegen AWP `v1alpha2` auf dem Branch der Überarbeitung (Commit `b8a0ee8`).

## Was sich bestätigt hat

| Teil von AWP | Erfahrung im PoC |
| --- | --- |
| Manifest als Kubernetes-Ressource | dieselbe Datei geht durch `kubectl apply --validate=strict` und `awp-check` |
| `default: deny`, Rechte pro Agent | im Tool-Proxy durchsetzbar |
| verschachtelte Budgets | im Modell-Proxy durchsetzbar, inklusive "ein erlaubter Aufruf darf überziehen" |
| Zeitplan-Semantik | `concurrencyPolicy`, `startingDeadline`, Tick-Zeit, Sommerzeit als reine Funktion testbar |
| Secrets mit `scope` | Trennung zwischen Kommando-Schritten und Agenten trägt das Sicherheitsmodell |
| Ausgaben über `$AWP_OUTPUTS` und `complete_step` | im Entwurf übernommen (AEP-0018) |
| Ausführungsort nicht im Manifest | alles Laufzeitspezifische passte in die Binding |
| `model.provider` als undurchsichtige Kennung (5.4.3) | Anbieter-Profile der Laufzeit bilden den Namen auf Protokoll, Adresse und Key ab; Ollama und vLLM liefen ohne Änderung am Manifest |
| Trennung von Katalog und Verbindung (AEP-0008) | Preise und Grenzen gehören in den Katalog, Adresse, Protokoll und Key in die Laufzeit; die Profile mischen beides noch ([Kapitel 10](10-modelle-und-kosten.md)) |

## Stand der Lücken

| G | Thema | Stand im Entwurf | Folge für das Konzept |
| --- | --- | --- | --- |
| G01 | Ausgaben eines Schritts | gelöst (5.6.4, AEP-0018) | nichts mehr zu tun |
| G02 | Typen von Ausgaben | offen (AEP-0003, AEP-0014) | JSON als Text |
| G03 | Zustand | offen, nächste wichtige AEP | Volume aus der Binding; geteilter Zustand als neuer Punkt |
| G04 | bedingte Schritte | offen (AEP-0001) | Kurator läuft immer |
| G05 | Secrets pro Schritt | offen (7.9 kennt `command`, Agenten-IDs, MCP-Server) | Token für alle Kommando-Schritte |
| G06 | Seiteneffekte von Kommandos | offen (AEP-0012) | Zustellung ist für Governance `shell.execute` |
| G07 | Lauf-Objekt | gelöst im Entwurf (3.11, 10.8, AEP-0019) | agentable weicht ab ([Kapitel 04](04-laufzeit.md#ressourcen)) |
| G08 | Lauf auf Manifest festhalten | gelöst (10.1, AEP-0020) | umgesetzt |
| G09 | Prüfung im Cluster | offen, Richtung: CRD verwirft unbekannte Felder, CEL (AEP-0021 B8) | Webhook wohl unnötig |
| G10 | Netzwerk nach Hostnamen | offen; durch den PoC nur noch ein Hinweis | Egress-Proxy pro Agent als Durchsetzung |
| G11 | Herkunft von Daten | offen; Ereignisdaten in AEP-0004 als nicht vertrauenswürdig markiert | Rahmen in der Aufgabe |
| G13 | Schritt nach Fehlschlag | offen | Meldung bei Fehlschlag durch Laufzeit oder Alarm |
| G26 | Namespace, `secrets[].source` | weitgehend gelöst: `source` ist eine undurchsichtige Kennung, Namespace darf ignoriert werden | Rest in G39 |
| G35 | unbekannte Preise | teilweise: Entwurf meldet `costKnown: false`, AEP-0013 lehnt ab | Konzept folgt AEP-0013 |
| G39 | Laufzeit-Neutralität | offen (Conditions in Kubernetes-Form) | lokaler Modus als Gegenprobe |
| G40 | Images festlegen | gelöst (5.6.2, 9.4, 10.1, 10.7) | Laufzeit muss Tags auflösen |
| G41 | Ereignisdaten im Lauf | teilweise: D7 entschieden, AEP-0004 nicht angewendet | PoC bildet auf Inputs ab, Zielform `${{ event.* }}` (E22) |
| G42 | Filter-Semantik | offen | Filter im Manifest nur beschreibend |
| G43 | Duplikate, Parallelität | offen; agentable-Verhalten als Vorlage | Duplikaterkennung umgesetzt, Parallelität fehlt |
| G44 | Akteur eines Ereignis-Laufs | offen: 5.2 setzt für jeden Ereignis-Start den Akteur `system`, ein bezeugter Mensch kommt nicht vor | bezeugter Mensch nur in Daten |
| G45 | Rückweg | offen | Zustellung als Kommando-Schritt |
| G46 | Gesprächs-Kontext | offen; Teilnehmer sind personenbezogene Daten | Brücke liefert den Thread |
| G47 | `permissions.network` und Grenzen der Plattform | offen (7.5.1: ohne Block `egress: allow`) | `network` in jedem Manifest (E23) |

## Wo das Konzept vom Entwurf abweicht

| Abweichung | Entwurf | Richtung |
| --- | --- | --- |
| eigenes `WorkflowRun` der Laufzeit | Laufzeiten mit Lauf-Objekten verwenden die AWP-Art (10.8) | umstellen, sobald AEP-0019 eine Rolle für Router hat |
| Sensor legt Läufe mit `spec.trigger.type: event` an | von außen angelegte Läufe sind manuell, Auslöser nur im Status | Laufzeit legt Ereignis-Läufe selbst an (E22) |
| Ereignisfelder als Inputs | D7: keine Abbildung auf Inputs | `${{ event.* }}` mit `dataSchema` (AEP-0004) |
| Filterschlüssel `data.user` | Bedeutung offen, AEP-0004 spricht von `event.data.*` | angleichen, wenn G42 entschieden ist |
| Mensch als Auslöser | Akteur `system` (5.2) | bis G44 nur in Daten |
| Sensor als Trigger-Objekt | AEP-0021 B6 kennt nur Bindings eigener Arten | Trigger-Objekte als neuer Punkt |
| Squid-Schreibweise `.example.org`, CIDR-Modus | `allowHosts` ohne Syntax | als agentable-spezifisch kennzeichnen |
| Variable `AWP_STATE_DIR` | Präfix `AWP_` ist reserviert (5.6.4) | umbenennen |

## Neue Punkte für die Spezifikation

Aus dem PoC und den Prüfungen, am 20.11.2026 als G48 bis G61 in die Lückenliste aufgenommen:

1. **Läufe von einem vertrauenswürdigen Router (G48).** Ein vorhandener Router (Argo Events, Tekton Triggers) ist weder Client (manuell) noch Laufzeit. Vorschlag: eine Rolle "trusted ingress", die Läufe mit Auslöser `event` und mitgegebenem Ereignis anlegen darf; die Laufzeit prüft den Auslöser gegen das Manifest und hält die Identität fest.
2. **Syntax von `allowHosts` (G49).** Subdomains, Ports, IP-Adressen und CIDRs sind nicht festgelegt; Allowlists sind nicht zwischen Laufzeiten übertragbar.
3. **Private Ziele (G50).** Ein erlaubter Host kann auf private, Loopback-, Link-Local- oder CGNAT-Adressen auflösen. Unter dem Sicherheitsprofil sollen Laufzeiten solche Ziele verweigern, außer sie sind ausdrücklich als Adresse erlaubt (SSRF, DNS-Rebinding).
4. **Egress-Proxy als Durchsetzung (G51).** Informativ: ein Proxy pro Arbeitslast mit Allowlist aus `allowHosts` plus eine Policy, die nur diesen Proxy erlaubt, setzt `permissions.network` für Kommando-Schritte konform um. Eine Laufzeit, die eine Netzregel nicht durchsetzen kann, lehnt den Workflow ab. Ergänzt G10 und G47.
5. **Trigger-Objekte als Erweiterungspunkt (G52).** Wie Bindings, aber für Auslöser: `targetRefs` mit Index des Auslösers, darf nur enger filtern, Status `Accepted`; erzeugt oder geprüft von der Laufzeit.
6. **Geteilter Zustand (G53).** Zwei Workflows eines Besitzers teilen Zustand (einer schreibt, einer liest). `spec.state` als benannte Ressource mit Zugriffsart, Regeln für gleichzeitiges Schreiben, strengste Datenklasse gilt für alle. Ergänzt G03.
7. **Bedeutung von `source` (G54).** CloudEvents meint den Erzeuger (URI), AEP-0021 B4 einen Adapter-Namen. Festlegen.
8. **Identität nach außen (G55).** Ein Workflow, der als eigenes Bot-Konto schreibt, handelt unter einer fremden Identität; das Manifest zeigt nur ein Secret. Mit Tool-Schritten (AEP-0012) die Identität deklarierbar machen.
9. **Zustellgarantie (G56).** Laufzeiten nennen pro Ereignisquelle die Garantie (höchstens einmal, mindestens einmal) im Konformitäts-Statement; Router können sie still herabsetzen (MQTT QoS 0).
10. **Ereignisgesteuerte Workflows testen (G57).** Nach AEP-0004 scheitert `event.*` außerhalb von Ereignis-Läufen, und von außen angelegte Läufe sind manuell. Vorschlag: Testlauf mit mitgegebenem Ereignis, als Wiederholung markiert, geprüft gegen `dataSchema`.
11. **Zustand als nicht vertrauenswürdige Eingabe (G58).** Was ein Lauf in den Zustand schreibt, liest der nächste als Daten; über Chat oder Webseiten kann so eine Anweisung dauerhaft werden. Herkunftsmarke (G11) auch für Zustand.
12. **Grenzen im Katalog sind verbindlich (G59).** AEP-0008 nennt `maxOutputTokens` nur informativ. Im PoC lehnte vLLM jede Anfrage ab, bis die Laufzeit die Ausgabe auf die Grenze des Modells kappte. Preis 0 für lokale Modelle gilt als bekannter Preis.
13. **Fähigkeiten eines Modells (G60).** Ein Agenten-Schritt braucht Tool-Aufrufe; sehr kleine Modelle rufen `complete_step` ohne Inhalt auf. Optionale Angaben wie `toolUse` im Katalog, damit die Laufzeit solche Kombinationen vor dem Start ablehnt.
14. **Ort der Modell-Zugangsdaten (G61).** Die Spezifikation sagt nicht, wo der Key liegt. Unter dem Sicherheitsprofil darf er im Schritt nicht sichtbar sein; der Schritt meldet sich mit einem kurzlebigen, an den Lauf gebundenen Nachweis an.
