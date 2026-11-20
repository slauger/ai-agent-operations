# Entscheidungen

Kurz begründet, in der Reihenfolge, in der sie gefallen sind. Jede Entscheidung kann neu bewertet werden, wenn sich die Begründung ändert.

| Nr. | Entscheidung | Begründung | Verworfen |
| --- | --- | --- | --- |
| E01 | Agenten werden in AWP beschrieben, die Laufzeit erfindet kein eigenes Format | offenes Schema, Prüfwerkzeug, portabel; Lücken gehen an die Spezifikation | eigenes CRD-Format |
| E02 | Laufzeit-Angaben stehen in einer Binding, nicht im Manifest | Manifest bleibt portabel und prüfbar; Trennung der Verantwortung | Annotationen oder Erweiterungsfelder im Manifest |
| E03 | Ein Kubernetes-Job pro Schritt-Versuch, keine Workflow-Engine darunter | Ticket, Proxy und spätere Freigaben passen schlecht in Tekton- oder Argo-Workflows-Tasks; ein Lauf mit wenigen Schritten ist im Operator überschaubar | Argo Workflows, Tekton Pipelines (wird neu bewertet, wenn Schritte komplex werden) |
| E04 | Schritt-Pods ohne Kubernetes-Token und ohne Modell-Schlüssel; Ticket pro Versuch | kleinster Spielraum; ein kompromittierter Schritt kann nichts außer seinem eigenen Auftrag | Schlüssel im Pod |
| E05 | Kubernetes-nativ ausführen; VMs über KubeVirt, Hardware über Knoten | einheitliche Authentifizierung, RBAC, NetworkPolicy; keine von außen erreichbare API | Pull-Modus mit Runner-Registrierung (zurückgestellt) |
| E06 | Das Datenmodell bleibt ohne Kubernetes nutzbar | Kubernetes ist Entscheidung des Betreibers; lokaler Modus als Gegenprobe | |
| E07 | Ereignisse über MQTT und Argo Events, Format CloudEvents | vorhandene Werkzeuge, deterministische Filter, Fan-out; MQTT als einfacher interner Bus mit ACLs | eigenes Ereignissystem im Operator; Webhooks direkt an den Operator |
| E08 | Kein Modell in Filter, Routing und Zustellung | prüfbar, nicht per Prompt umlenkbar, kostenlos | KI-Router, der entscheidet, welcher Agent zuständig ist |
| E09 | Duplikaterkennung im Operator über Quelle und Ereignis-ID | Zustellung ist nicht genau einmal; zwei Routen können dieselbe Nachricht treffen | sich auf den Router verlassen |
| E10 | Chat als Oberfläche, keine eigene Web-Oberfläche | Push aufs Telefon, Threads, Knöpfe vorhanden; nichts zu bauen | eigene Oberfläche |
| E11 | Antworten über die REST-API in einem Kommando-Schritt, kein Rückkanal über MQTT | Zustellung ist fester Code und im Manifest sichtbar | Antwort-Topic, das die Brücke zustellt |
| E12 | Eigenes Bot-Konto für die Brücke (nur lesen) und pro Agent (schreiben) | Brücke liest viel, schreibt nichts; im Chat sichtbar, wer antwortet | ein Bot für alles |
| E13 | Thread-Verlauf kommt von der Brücke im Ereignis | Agent bekommt kein Leserecht im Chat | Agent liest den Thread selbst über ein Werkzeug |
| E14 | Ein Repository für alle Agenten, ein Verzeichnis pro Agent, ApplicationSet | Hinzufügen und Entfernen ist eine Datei-Änderung; ein Ort für Review und CI | ein Repository pro Agent; Agenten im GitOps-Repository |
| E15 | Bibliotheks-Chart plus Anwendungs-Charts, über Pfade statt OCI | Gemeinsames einmal, Anwendungsfälle verständlich; keine Registry nötig | ein großes Chart mit Schaltern; OCI-Charts |
| E16 | Manifeste werden unverändert aus dem Verzeichnis angewendet, nicht durch Helm | dieselbe Datei, die geprüft wurde, kommt in den Cluster | Manifest als Helm-Template |
| E17 | Ein Namespace pro Agent, Pod Security `restricted`, Netzwerk standardmäßig zu | Isolation, Aufräumen, eigene Secrets | gemeinsamer Namespace |
| E18 | Egress über einen Squid pro Agent im eigenen Namespace, ohne Authentifizierung, ohne TLS-Aufbruch | Hostnamen-Regeln, Protokoll pro Agent, verschwindet mit dem Agenten; wenig Aufwand | zentraler Proxy für alle; FQDN-Policies der CNI; TLS-Aufbruch |
| E19 | Squid aus dem gepflegten Image `ubuntu/squid` | Sicherheitsupdates vom Hersteller, läuft ohne root | eigenes Image |
| E20 | Mehrere kleine Cluster mit Flatcar und k3s, Agenten in einem eigenen | Fehlerdomänen, Egress-Regeln, Rechte; vorerst lokal | ein großer Cluster |
