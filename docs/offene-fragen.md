# Offene Fragen

| Nr. | Frage | Optionen | Abhängig von |
| --- | --- | --- | --- |
| O01 | Soll die Laufzeit den Sensor aus dem `triggers`-Block des Manifests erzeugen? | erzeugen (Manifest einzige Quelle) oder von Hand pflegen (flexibler) | Filter-Semantik in AWP (G42) |
| O02 | Soll die Allowlist des Egress-Proxys aus `permissions.network` abgeleitet werden? | ableiten und mit Obergrenze schneiden, oder getrennt pflegen | Rolle von `permissions.network` (G47) |
| O03 | Wie kommen Ereignisdaten in den Lauf? | Zuordnung zu Inputs (heute) oder eigene Wurzel `${{ event.* }}` (AEP-0004) | G41 |
| O04 | Webhook-Eingang über Argo Events oder Tekton Triggers? | Argo Events (schon da) | Bedarf |
| O05 | Braucht die Laufzeit für Coding-Aufgaben einen vollwertigen Coding-Agenten im Pod statt der eigenen Tool-Schleife? | eigene Schleife, Coding-Agent als Kommando-Schritt | Anwendungsfall Repository-Pflege |
| O06 | Wie werden Freigaben gebaut? | Knöpfe im Chat über die Brücke, signierter Kontext, Lauf wartet | AWP-Profil `governance` |
| O07 | Ein Chat-Kanal pro Agent oder ein gemeinsamer? | pro Agent für Meldungen, gemeinsamer Betriebskanal für Fehler | Zahl der Agenten |
| O08 | Wie lange werden Läufe und Audit-Ereignisse aufbewahrt? | Läufe kurz (`history.keep`), Audit nach Vorgabe der Protokollierung | Datenschutz |
| O09 | Wie kommen Secrets in den Agenten-Cluster? | External Secrets aus einem Tresor, Sealed Secrets | Topologie |
| O10 | Wo läuft die Brücke: im Agenten-Cluster oder bei Chat und Broker im Infrastruktur-Cluster? | nahe am Chat (weniger Wege) oder bei den Agenten (gehört zur Laufzeit) | Topologie |
| O11 | Wie erreicht ein Agent ohne Egress-Proxy den Chat für seine Antwort? | Proxy auch für Chat-Agenten, Allowlist-CIDR, oder Zustellung über einen Dienst im Cluster | Durchsetzung der Policies im Agenten-Cluster |
| O12 | Werden Werkzeug-Images im Manifest auf Digest festgelegt, oder löst die Laufzeit Tags auf? | Digest im Manifest (Renovate), Auflösung beim Start (G40) | AEP-0020 |
