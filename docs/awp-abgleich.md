# Abgleich mit AWP

Was das Konzept für die Spezifikation bedeutet. Nummern (G..) stammen aus der Liste der Laufzeit-Rückmeldungen an AWP; hier werden keine neuen vergeben.

Stand des Abgleichs: Entwurf, gegen AWP `v1alpha2` (Branch der Überarbeitung) noch zu prüfen.

## Was sich bestätigt hat

| Teil von AWP | Erfahrung im PoC |
| --- | --- |
| Manifest als Kubernetes-Ressource | dieselbe Datei geht durch `kubectl apply --validate=strict` und `awp-check` |
| `default: deny`, Rechte pro Agent | im Tool-Proxy durchsetzbar |
| verschachtelte Budgets | im Modell-Proxy durchsetzbar, inklusive "ein erlaubter Aufruf darf überziehen" |
| Zeitplan-Semantik | `concurrencyPolicy`, `startingDeadline`, Tick-Zeit, Sommerzeit als reine Funktion testbar |
| Secrets mit `scope` | Trennung Agent und Kommando trägt das Sicherheitsmodell |
| Ereignis-Auslöser mit `source`, `eventType`, `filter` | passt direkt zu CloudEvents; Router und Laufzeit können ihn prüfen |
| Ausführungsort nicht im Manifest | alles Laufzeitspezifische passte in die Binding |

## Was das Konzept von der Spezifikation braucht

| Thema | G | Kapitel |
| --- | --- | --- |
| Ausgaben eines Schritts, Typen | G01, G02 | [03](03-workflow-manifest.md) |
| Zustand über Läufe | G03 | [11](11-zustand-und-kontext.md) |
| bedingte Schritte | G04 | [10](10-modelle-und-kosten.md) |
| Secrets pro Schritt, Quelle ohne Laufzeit | G05, G26 | [09](09-secrets-und-identitaeten.md) |
| Seiteneffekte von Kommandos | G06 | [03](03-workflow-manifest.md) |
| Lauf-Objekt, Festhalten des Manifests | G07, G08 | [04](04-laufzeit.md) |
| Admission-Prüfung | G09 | [05](05-bereitstellung.md) |
| Netzwerk nach Hostnamen, Rolle von `permissions.network` | G10, G47 | [08](08-isolation-und-netzwerk.md) |
| Herkunft von Daten | G11 | [14](14-sicherheit.md) |
| Schritt nach Fehlschlag | G13 | [12](12-beobachtung.md) |
| Preise, Kosten | G35 | [10](10-modelle-und-kosten.md) |
| Laufzeit-Neutralität | G39 | [16](16-ohne-kubernetes.md) |
| Images festlegen | G40 | [15](15-betrieb.md) |
| Ereignisdaten, Filter, Duplikate, Auslöser, Rückweg, Gesprächs-Kontext | G41 bis G46 | [06](06-ereignisse.md), [07](07-kanaele.md), [11](11-zustand-und-kontext.md) |
