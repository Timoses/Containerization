:title: Introduction to Container Orchestration
:css: presentation.css
:css: orchestration.css


----


Introduction to Container Orchestration
=======================================

----


Outline
-------

* Why do we need an orchestrator?
* Kubernetes


----


:data-rotate-x: r-90
:data-x: r0
:data-y: r1000
:data-z: r-1000

Why do we need an orchestrator?
===============================


----


:data-rotate-x: r0
:data-x: r1600
:data-y: r0
:data-z: r0

Why do we need an orchestrator?
===============================

Facing the issue
----------------

* How to manage a multitude of containers?
* How to deal with failure scenarios (e.g. container goes down)?
* How to provide communication between containers (across different hosts)?
* How to select servers to run containers?

-> Some control & management (orchestration) layer is required to fill the gap!

.. note::
    * ! Support for container structure is required !
    * imagine: 100s of containers running
        * even if less: k8s still offers advantages
            * automatic rescaling
            * portability to cloud and other k8s clusters
                * Infrastructure as Code (declarative state)
    * Failure scenarios: started containers are not auto-restarted on crash
    * How to select servers for containers?
        * Which server still has capacity?
        * which containers should run side-by-side on the same host?


----


Why do we need an orchestrator?
===============================

Desired features
----------------

* Container-to-container communication
* Access control and management of shared resources (e.g. storage)
* Container to Host allocation
    * Resource monitoring (available and used resources)
* Automatic scaling of container instances (on demand)
* failure recovery
    * automatic restart of containers
    * moving containers to a new host on host failure
* Container health monitoring
* Enforcement of security policies


.. note::
    * Security policies:
        * Who may communicate with who?
        * Priviledged Pods (access to node/host functionality)
        * Which volumes/storages may be shared/mounted?
        * Restrict user IDs of a container
        * SELinux requirements?


----


:data-rotate-x: r-90
:data-x: r0
:data-y: r-1000
:data-z: r-1000

Kubernetes
==========

* Architecture
* API Resource
* Networking


----


:data-rotate-x: r0
:data-x: r1600
:data-y: r0
:data-z: r0

:id: arch-nodes-and-pods

Kubernetes
==========

Architecture
------------

.. raw:: html

    <style>
        #arch-nodes-and-pods svg {
            position: relative;
            left: -500px;
            margin-bottom: -200px;
            z-index: -100;
        }
        #arch-nodes-and-pods svg g g {
            display: none;
        }

        #arch-nodes-and-pods svg g g[id='node1'],
        #arch-nodes-and-pods svg g g[id='node2'],
        #arch-nodes-and-pods svg g g[id*='Pod'] {
            display: inline;
        }
    </style>

.. raw:: html
    :file: ./graphics/k8s_architecture.svg

* **Node**
    * VM
    * bare metal

* **Pod**
    * group of one or more containers
    * containers share network and storage


.. note::
    * Pod
        * Why allow several containers in one Pod? -> sidecar containers, modular



----


:data-rotate-x: r0
:data-x: r0
:data-y: r0
:data-z: r0

:id: arch-kubelet

Kubernetes
==========

Architecture
------------

.. raw:: html

    <style>
        #arch-kubelet svg {
            position: relative;
            left: -500px;
            margin-bottom: -200px;
            z-index: -100;
        }
        #arch-kubelet svg g g {
            display: none;
        }

        #arch-kubelet svg g g[id='node1'],
        #arch-kubelet svg g g[id='node2'],
        #arch-kubelet svg g g[id*='Pod'],
        #arch-kubelet svg g g[id='node1_kubelet'],
        #arch-kubelet svg g g[id='node2_kubelet'] {
            display: inline;
        }
    </style>

.. raw:: html
    :file: ./graphics/k8s_architecture.svg

* **Kubelet**
    * Create pods (assigned to node)
        * Create network interfaces
        * Find necessary storage/mounts
        * Spin up containers
    * Monitor pod health
    * Restart on failure

----


:data-rotate-x: r0
:data-x: r1600
:data-y: r0
:data-z: r0

:id: arch-master

Kubernetes
==========

Architecture
------------

.. raw:: html

    <style>
        #arch-master svg {
            position: relative;
            left: -100px;
            margin-bottom: -20px;
            z-index: -100;
        }
        #arch-master svg g g {
            display: none;
        }

        #arch-master {
            height: 700px;
        }

        #arch-master svg g g[id='node1'],
        #arch-master svg g g[id^='node1_Pod'],
        #arch-master svg g g[id='node1_kubelet'],
        #arch-master svg g g[id^='master'],
        #arch-master svg g g[id='etcd'],
        #arch-master svg g g[id='edge_kubelet1_kubeapi'],
        #arch-master svg g g[id='edge_kubescheduler_kubeapi'],
        #arch-master svg g g[id='edge_kubecontrollermanager_etcd'],
        #arch-master svg g g[id='edge_kubeapi_etcd'] {
            display: inline;
        }
    </style>

.. raw:: html
    :file: ./graphics/k8s_architecture.svg


* **kube-apiserver**
    * Primary access point to query and manipulate cluster state

* **kube-scheduler**
    * Schedules Pod creation and destruction

* **kube-controller-manager**
    * Periodically reads desired cluster state from API-Server and makes necessary adjustments


.. note::
    kube-scheduler:
        * Resource Requirements
        * Affinity (to specific nodes, or (never) run side-by-side to specific Pod)

    kube-controller-manager:
        * E.g. updates a deployment if the DeploymentSpec was updated (new image version for example)

    etcd:
        * distributed key/value store
        * distributed "/etc" linux directory

----


:data-rotate-x: r0
:data-x: r0
:data-y: r0
:data-z: r0

:id: arch-kubectl

Kubernetes
==========

Architecture
------------

.. raw:: html

    <style>
        #arch-kubectl svg {
            position: relative;
            left: -100px;
            margin-bottom: -20px;
            z-index: -100;
        }
        #arch-kubectl svg g g {
            display: none;
        }

        #arch-kubectl {
            height: 700px;
        }

        #arch-kubectl svg g g[id='node1'],
        #arch-kubectl svg g g[id^='node1_Pod'],
        #arch-kubectl svg g g[id='node1_kubelet'],
        #arch-kubectl svg g g[id^='master'],
        #arch-kubectl svg g g[id='etcd'],
        #arch-kubectl svg g g[id='kubectl'],
        #arch-kubectl svg g g[id='edge_kubelet1_kubeapi'],
        #arch-kubectl svg g g[id='edge_kubescheduler_kubeapi'],
        #arch-kubectl svg g g[id='edge_kubecontrollermanager_etcd'],
        #arch-kubectl svg g g[id='edge_kubeapi_etcd'],
        #arch-kubectl svg g g[id='edge_kubectl_kubeapi']
     {
            display: inline;
        }
    </style>

.. raw:: html
    :file: ./graphics/k8s_architecture.svg

* **kubectl**
    * User CLI to control cluster


.. note::
    * Ueberleitung:
        * Example: Tell kube-api to create a new Pod


----


:data-rotate-x: r-90
:data-x: r0
:data-y: r-1000
:data-z: r+1000

Kubernetes
==========

API Resources
-------------

* YAML format
* Example: Pod Resource
    .. code:: yaml

        apiVersion: v1
        kind: Pod
        metadata:
          name: memory-demo
          namespace: mem-example
        spec:
          containers:
          - name: memory-demo-ctr
            image: polinux/stress
            resources:
              limits:
                memory: "200Mi"
              requests:
                memory: "100Mi"
            command: ["stress"]
            args: ["--vm", "1", "--vm-bytes", "150M", "--vm-hang", "1"]

    * program allocates 150MiB

* Declarative approach -> describe desired state
    * vs imperative (step by step instruction)

.. note::
    * API vs compute resources (in yaml: "memory")
    * Resources:
        * requests: So scheduler can assign pods correctly
    * Declarative vs imperative
        * Ich sage nicht:
            1. generiere Pod, 2. generiere NIC, ...
        * Sondern:
            "So soll's am Ende aussehen, mach das mal"
    * The complete cluster state is described in declarative yaml


----


:data-rotate-x: r-90
:data-x: r0
:data-y: r+1000
:data-z: r+1000


Kubernetes
==========

Networking
----------

* all containers can communicate with all other containers
* all nodes can communicate with all containers (and vice-versa)
* the IP that a container sees itself as is the same IP that others see it as

.. List Separator...

* No NAT (vs Docker Swarm)


.. note::
    * all containers:
        * Container -> container in same Pod: localhost
        * Container -> container on same node: bridge
        * Container -> container on other node:
            * manual routing table
            * overlay network


----


:data-rotate-x: r0
:data-x: r1600
:data-y: r0
:data-z: r0

:id: network-manual

Kubernetes
==========

Networking - Pod to pod on same Node
------------------------------------

.. raw:: html

    <style>
        #network-manual svg {
            position: relative;
            margin-bottom: -20px;
            z-index: -100;
        }
        #network-manual svg g g {
            display: none;
        }

        #network-manual {
            height: 700px;
        }

        #network-manual svg g g[id='node1'],
        #network-manual svg g g[id^='node1_pod'],
        #network-manual svg g g[id^='edge_node1Bridge_node1Pod'],
        #network-manual svg g g[id^='node1_bridge']
        {
            display: inline;
        }
    </style>

.. raw:: html
    :file: ./graphics/k8s_network_manual.svg

.. image:: ./router.png
    :height: 0px

* Every Pod has an IP address
* Every Node is assigned a Pod CIDR Block
* Virtual linux bridge *cbr0*

.. note::
    * cbr = cluster bridge


----


:data-rotate-x: r0
:data-x: r0
:data-y: r0
:data-z: r0

:id: network-manual2

Kubernetes
==========

Networking - Pod to pod over different nodes
--------------------------------------------

.. raw:: html

    <style>
        #network-manual2 svg {
            position: relative;
            margin-bottom: -20px;
            z-index: -100;
        }

        #network-manual2 {
            height: 700px;
        }
    </style>

.. raw:: html
    :file: ./graphics/k8s_network_manual.svg

.. image:: ./router.png
    :height: 0px

* Routing of packets from pods accross nodes:
    * Manual configuration of routing tables
    * Overlay network

.. note::
    * CIDR: Could say 172.20/16 for pods and 172.18/16 for nodes

    * manual config: program routes into router
    * otherwise: overlay/virtual network


----


:id: network-overlay

Kubernetes
==========

Networking - Overlay
--------------------

.. raw:: html

    <style>
        #network-overlay svg {
            position: relative;
            left: -150px;
            margin-bottom: -120px;
            z-index: -100;
        }

        #network-overlay svg g g[id="virt_network"],
        #network-overlay svg g g[id$="virtNetwork"] {
            display: none;
        }

        #network-overlay {
            height: 700px;
        }
    </style>

.. raw:: html
    :file: ./graphics/k8s_network.svg

.. image:: ./router.png
    :height: 0px


* Overlay plugin implements overlay network
    * e.g. via iptables, vxlan, ...


----


:id: network-overlay2

Kubernetes
==========

Networking - Overlay
--------------------

.. raw:: html

    <style>
        #network-overlay2 svg {
            position: relative;
            left: -150px;
            margin-bottom: -20px;
            z-index: -100;
        }

        #network-overlay2 {
            height: 700px;
        }
    </style>

.. raw:: html
    :file: ./graphics/k8s_network.svg

.. image:: ./router.png
    :height: 0px

.. note::
    In effect we have a virtual network of pods


----


:data-rotate-x: r0
:data-x: r1600
:data-y: r0
:data-z: r0

:id: calico

Kubernetes
==========

Networking - Calico
--------------------

.. image:: ./graphics/calico.svg
    :width: 50%

Source: https://docs.projectcalico.org/images/calico-arch-gen-v3.2.svg


* Layer 3, BGP
* calico/node manipulates iptables on node
* stores virtual network information in *key/value store*
* can implement network policies
    * e.g. which Pods may communicate with each other


.. note::
    * BGP - Border Gateway Protocol
    * Dikastes/Envoy = optional: secure communication with TLS
    * In general: Envoy = L7 proxy & communication bus -> communicaton mesh, abstracts away network from Pods


----


Openshift
=========

* Extends Kubernetes
    * web console/GUI (K8s has one as well)
    * Source-2-image
    * built-in container registry
    * pre-setup logging/monitoring solution
    * ...
* Is not the only one:
    * Rancher
    * Platform9

.. note::

    Source-2-image
        * inject new source-code into container and test it
        * other solutions exist? (in the back of my head there was one)

    * Abstrahiert viel in neue Konzepte
        -> noch mehr zu lernen
    * wahrscheinlich werden viele Lösungen bereits von anderen K8s Projekten abgedeckt
    * Gefahr eines "Lock-in"?


----


Extra
=====

* Services
* Ingress
* Namespaces

.. note::
    * Frage LB:
        * Service aus Deployment (e.g. 3 replicas of image)
            * Cluster internal DNS -> service can be resolved to service endpoints
        * Ingress controller sets up load balancer to point to virtual service cluster ip
        * Namespaces:
            * <service-name>.<namespace> (DNS entry)
            * asking for <service-name> only will provide the service within the current namespace
                -> good for separating e.g. dev/prod environments
