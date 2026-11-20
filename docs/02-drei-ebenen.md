# 02 Drei Ebenen der Konfiguration

Die wichtigste Entscheidung des Konzepts ist, wo eine Einstellung steht. Drei Ebenen, drei Verantwortliche, drei Prüfwege.

```mermaid
flowchart TB
    subgraph E1["Ebene 1: Manifest (AWP)"]
        direction LR
        M1[Agenten, Modelle, Anweisungen]
        M2[Schritte, Ausgaben]
        M3[Rechte, Budgets, Auslöser]
    end
    subgraph E2["Ebene 2: Laufzeit-Bindung"]
        direction LR
        B1[Runner-Image, Proxy]
        B2[Modell-Zugang, Secret-Zuordnung]
        B3[Zustands-Volume, Aufbewahrung]
        B4[Sensor: Transport, feinere Filter]
    end
    subgraph E3["Ebene 3: Plattform"]
        direction LR
        P1[Namespace, Pod Security]
        P2[NetworkPolicy, Egress-Proxy]
        P3[Cluster, Knoten, Runtime-Klasse]
    end
    E1 -->|"was der Agent tun und dürfen soll"| E2
    E2 -->|"wie diese Laufzeit es umsetzt"| E3
    E3 -->|"Obergrenze, die nichts überschreitet"| E1
```

| | Ebene 1: Manifest | Ebene 2: Laufzeit-Bindung | Ebene 3: Plattform |
| --- | --- | --- | --- |
| Frage | Was tut der Agent, was darf er? | Wie läuft er in dieser Laufzeit? | Wo läuft er, mit welchen Grenzen? |
| Objekte | AWP `Workflow` | `WorkflowBinding`, Sensor | Namespace, NetworkPolicy, Egress-Proxy, Cluster |
| Portabel | ja, zwischen Laufzeiten | nein, gehört zu agentable | nein, gehört zum Betreiber |
| Geschrieben von | Fachseite, oft mit einem Assistenten | Werte-Datei im Agenten-Verzeichnis | Charts der Plattform |
| Geprüft durch | Review, JSON-Schema, `awp-check`, Operator | Chart-Tests, Operator | Chart-Tests, Admission (Pod Security) |
| Im Digest des Manifests | ja | nein | nein |
| Beispiel | `budget.maxCostUsd: 0.5` | `state.claimName: scout-state` | `egress.mode: proxy` |

## Regeln

1. **Das Manifest enthält keine Laufzeit-Begriffe.** Kein Namespace, kein Image-Pull-Secret, kein Volume-Name, keine Kubernetes-Secret-Namen. Ein Secret heißt im Manifest `MATTERMOST_BOT_TOKEN` und hat einen `scope`; welches Kubernetes-Secret dahintersteht, sagt die Binding.
2. **Untere Ebenen dürfen nur enger machen.** Erlaubt das Manifest `api.example.org`, darf der Egress-Proxy das zulassen oder verbieten, aber nichts hinzufügen. Filtert das Manifest Ereignisse auf einen Absender, darf der Sensor enger filtern, nie weiter.
3. **Die Plattform ist die Obergrenze.** Ein Manifest kann nicht mehr Netzwerk, mehr Rechte oder mehr Ressourcen bekommen, als Namespace und Policy hergeben. Ein fehlerhaftes oder manipuliertes Manifest kann die Plattform nicht öffnen.
4. **Wer ändert, prüft auf seiner Ebene.** Eine neue Domain im Manifest ist eine fachliche Änderung im Review; eine neue Domain in der Allowlist des Proxys ist eine Betriebsänderung. Beide sind Pull Requests, aber mit anderem Blick.

## Warum nicht alles ins Manifest

Es wäre bequem, Netzwerkregeln, Volumes und Images im Manifest zu haben: eine Datei, alles drin. Drei Gründe dagegen:

- **Portabilität.** Dasselbe Manifest soll auf dem Laptop, in einem anderen Cluster oder in einer anderen Laufzeit laufen ([Kapitel 16](16-ohne-kubernetes.md)). Kubernetes-Begriffe im Manifest machen das unmöglich.
- **Trennung der Verantwortung.** Wer einen Agenten fachlich beschreibt, soll nicht über Volumes und Secret-Namen entscheiden müssen, und wer die Plattform betreibt, soll Grenzen setzen können, ohne Manifeste anzufassen.
- **Sicherheit.** Ein Manifest wird oft von einem Assistenten geschrieben. Wenn es seine eigenen Grenzen festlegen könnte, wäre jede Grenze nur so gut wie der Review.

## Doppelte Angaben sind gewollt

Manche Dinge stehen auf zwei Ebenen: Das Manifest sagt "dieser Workflow braucht `www.example.org`" (`permissions.network`), der Egress-Proxy lässt `www.example.org` durch. Das ist keine Verdopplung, sondern Anspruch und Zusage. Langfristig soll der Proxy seine Allowlist aus dem Manifest ableiten, geschnitten mit einer Obergrenze des Betreibers; dann steht die Domain nur noch einmal in der Datei, die der Mensch pflegt. Die Frage, wie das Manifest seine Netzwerkwünsche ausdrückt und was eine Laufzeit damit tun muss, ist an die Spezifikation gemeldet ([Abgleich](awp-abgleich.md), G47).
