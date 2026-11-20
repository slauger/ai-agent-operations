# 16 Ohne Kubernetes

Das Konzept setzt für den Betrieb auf Kubernetes. Das Datenmodell darf das nicht.

## Warum das wichtig ist

Kubernetes ist eine Entscheidung des Betreibers, keine Eigenschaft eines Agenten. Derselbe Konzert-Scout soll auf dem Laptop eines Entwicklers laufen, in einer VM, in einem Container mit Podman oder in einer anderen Laufzeit. Gelingt das nicht, ist das Manifest in Wahrheit ein Kubernetes-Objekt mit AWP-Etikett.

## Wo die Grenze liegt

| Teil | Darf Kubernetes kennen | Begründung |
| --- | --- | --- |
| Manifest (AWP) | nein | portabel |
| Schritt-Vertrag: Ausgaben (`$AWP_OUTPUTS`, `complete_step`), Ticket, Runner-API | nein | dasselbe Kommando-Image läuft überall |
| Lauf-Objekt (Auslöser, Eingaben, Status, Kosten) | nein, nur seine Darstellung als CRD | Status-Form soll auch ohne `metav1.Condition` beschreibbar sein |
| Binding | ja | gehört zur Laufzeit |
| Plattform (Namespace, Policy, Proxy) | ja | gehört zum Betreiber |

Kubernetes-Begriffe stehen nur in Binding und Plattform. Das Manifest hat heute zwei Stellen, die das verletzen: `metadata.namespace` und `secrets[].source: kubernetes` (G26).

## Gegenprobe

Geplant ist ein lokaler Modus: derselbe Workflow auf dem Laptop, Schritte als Prozess oder mit Podman, Zustand in einem Verzeichnis, Modell- und Tool-Proxy im selben Prozess. Was dabei nicht ohne Kubernetes geht, ist eine Lücke im Datenmodell und geht an die Spezifikation (G39).

## VMs und andere Ausführungsorte

Andere Ausführungsorte kommen über Kubernetes, nicht neben ihm: KubeVirt für echte VMs, eigene Knoten für Hardware, Runtime-Klassen für stärkere Isolation. Damit bleiben Authentifizierung, NetworkPolicy und RBAC einheitlich.

Der Operator spricht intern nur mit einer Schnittstelle `Executor` (starten, Status, abbrechen); Kubernetes-Jobs sind die erste Umsetzung. Ein Pull-Modus, bei dem sich Runner wie bei GitLab selbst Arbeit holen, ist bewusst zurückgestellt: Er bräuchte eine von außen erreichbare API mit Registrierung, Leases und Token-Rotation und passt schlecht zum Reconcile-Modell. Die Tür bleibt offen, weil der Runner schon heute nur über HTTP mit Ticket spricht; ein späterer Pull-Dienst müsste nur die Zuweisung anders ausliefern.
