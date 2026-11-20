# Glossar

| Begriff | Bedeutung |
| --- | --- |
| AEP | AWP Enhancement Proposal: Änderungsvorschlag an die Spezifikation, mit Nummer und Status (Draft, Review, angenommen). |
| Agent | Ein Sprachmodell mit Anweisungen, Werkzeugen, Rechten und Budget. Im Manifest ein Eintrag unter `agents`; umgangssprachlich auch der ganze Workflow. |
| Agenten-Schritt | Schritt, in dem ein Agent eine Aufgabe bearbeitet. Unvorhersagbar, ohne Zugangsdaten. |
| Allowlist | Liste des Erlaubten; alles andere ist verboten. |
| ApplicationSet | Argo-CD-Objekt, das aus einer Vorlage viele Applications erzeugt, hier eine pro Agenten-Verzeichnis. |
| AWP | Agentic Workflow Protocol: offene Spezifikation für Agenten-Workflows mit JSON-Schema und Prüfwerkzeug. Keine Engine. |
| Binding (WorkflowBinding) | Laufzeit-Objekt, das sagt, dass und wie ein Workflow ausgeführt wird: Image, Proxy, Modell-Zugang, Secrets, Zustand. |
| Brücke | Kleiner Dienst, der Chat-Nachrichten als CloudEvents auf den Broker legt. |
| CloudEvents | Standard für das Format von Ereignissen (`id`, `source`, `type`, `subject`, `data`). |
| Condition | Zustandsangabe im Status eines Kubernetes-Objekts (`Valid`, `Bound`, `Ready`) mit Grund und Text. |
| Digest | Prüfsumme über einen Inhalt (Manifest, Image). Zwei gleiche Digests heißen: gleicher Inhalt. |
| Egress-Proxy | Squid im Namespace eines Agenten, einzige Tür ins Internet für Kommando-Schritte, mit Allowlist von Domains. |
| EventSource, Sensor, EventBus | Bausteine von Argo Events: Quelle abonnieren, intern verteilen, filtern und Ressourcen anlegen. |
| G-Nummer | Nummer einer Lücke in der Liste der Laufzeit-Rückmeldungen an AWP. |
| JetStream | Persistenter Nachrichtenspeicher von NATS; Argo Events nutzt ihn als EventBus. |
| Kommando-Schritt | Schritt, der ein Kommando in einem Container ausführt. Fester Code, darf Secrets bekommen. |
| Lauf (WorkflowRun) | Eine Ausführung eines Workflows mit Auslöser, Eingaben, Kopie des Manifests, Status und Kosten. |
| Manifest | Die AWP-Datei eines Workflows. Geprüft, portabel, ohne Laufzeit-Angaben. |
| Modell-Proxy | Teil des Operators: prüft Modell und Budget, setzt den Schlüssel ein, zählt Kosten. |
| MQTT | Leichtgewichtiges Publish-Subscribe-Protokoll, hier interner Ereignis-Bus. QoS 0 heißt höchstens einmal, QoS 1 mindestens einmal. |
| NetworkPolicy | Kubernetes-Regel, welche Pods wohin Verbindungen aufbauen dürfen. Kennt nur IP-Adressen und Ports. |
| Operator | Programm im Cluster, das eigene Ressourcen beobachtet und den gewünschten Zustand herstellt. Hier: agentable. |
| Pod Security `restricted` | Strengste Stufe der Kubernetes Pod Security Standards: kein root, keine Privilegien. |
| Prompt-Injection | Anweisungen in Daten (Webseite, Nachricht), die ein Modell als Befehl befolgt. |
| Runner | Binary im Schritt-Pod: Tool-Schleife für Agenten, Wrapper für Kommandos. |
| Runner-API | Schnittstelle des Operators, über die ein Schritt mit seinem Ticket Auftrag holt, Modell und Werkzeuge ruft und Ausgaben abgibt. |
| SSRF | Server-Side Request Forgery: Ein Dienst wird dazu gebracht, Anfragen an interne Ziele zu stellen, die von außen nicht erreichbar sind. |
| Ticket | Kurzlebiger Nachweis für genau einen Schritt-Versuch gegenüber der Runner-API. |
| Tool-Proxy | Teil des Operators: prüft Werkzeugaufrufe gegen die Rechte im Manifest. |
| Zustand | Daten, die ein Agent zwischen Läufen behält, zum Beispiel "schon gemeldet". |
