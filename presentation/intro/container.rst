:title: Introduction to Containerization
:css: presentation.css
:css: container.css


----


Introduction to Containers
==========================

----


Outline
-------

* What are containers?

.. VM vs Container
.. Linux features

* Why use containers?

.. monolithic -> microservices
.. container features

* Container Concepts

.. Image
.. Registry
.. Runtime

* Docker != Container

..

* Alternatives to Docker


.. note::
    * Only talking about regular Docker. Not Docker Swarm!

----


:data-rotate-x: r-90
:data-x: r0
:data-y: r1000
:data-z: r-1000

What are containers?
====================


----


:data-rotate-x: r0
:data-x: r1600
:data-y: r0
:data-z: r0

:id: vmVsContainer

What are containers?
====================

VM vs Container
---------------

Container = OS-level virtualization

+----------------------------------+-----------------------------------------+
| VM                               | Container                               |
+==================================+=========================================+
| .. raw:: html                    | .. raw:: html                           |
|     :file: graphics/stack_vm.svg |     :file: graphics/stack_container.svg |
+----------------------------------+-----------------------------------------+


.. note::
    * container = more lightweight
        * does not require one Guest OS / virtualized instance
        * uses linux kernel of existing OS
    * isolation?


----


:data-rotate-x: r0
:data-x: r1600
:data-y: r0
:data-z: r0


What are containers?
====================

Linux features
--------------

* `cgroups <wikipedia cgroups_>`_ (control groups)
    * CPU
    * Memory
    * Disk I/O
    * Network
* `namespaces <wikipedia linux namespaces_>`_
    * NET
    * PID
    * MNT
    * UTS (UNIX Timesharing System)
    * IPC (InterProcess Communication)
    * USER

.. _wikipedia cgroups: https://en.wikipedia.org/wiki/Cgroups
.. _wikipedia linux namespaces: https://en.wikipedia.org/wiki/Linux_namespaces

.. note::
    * cgroups
        * assign, limit and monitor resources
    * namespaces
        * group things into a namespace

    * Surrounding ecosystem and perspectives are enormous

----


:data-rotate-x: r-90
:data-x: r0
:data-y: r-1000
:data-z: r-1000

Why use containers?
===================


----


:data-rotate-x: r0
:data-x: r1600
:data-y: r0
:data-z: r0

Why use containers?
===================

Shift from monolithic towards microservices
-------------------------------------------

.. figure:: graphics/external/monolithic-v-microservices.jpg
    :width: 100%

    Source: https://blog.g2crowd.com/blog/trends/digital-platforms/2018-dp/microservices/

.. note::
    * Applictaion = several microservice components
    * Advantages
        * different scalability requirements for different components of a system
        * each component can focus on its job
            * which programming language is most suitable?
            * dependencies required?
            -> Best fit for the job

    * VMs => several VMs
        * due to dependency collisions?


----


Why use containers?
===================

Container Features
------------------

* Scalability (microservices)
    * (+) lightweight
    * (+) rapid deployment
* Portability
    * (+) deploy anywhere (Cloud, on-premise, local)
* Isolation
    * (-) VMs offer better isolation
    * (?) Cause for security concerns??
* Monolithic legacy -> container


.. note::
    * Scalable
        * more lightweight (compute resources, space) than virtual machines
            * images can be big if not constructed with care
        * **easy** and rapid deployment
            * when containers are done right!
    * portable
        * many cloud providers
        * quickly deployed
    * security concerns?
        * Indeed, it's been and still is a hot topic
            * container security
                * secure image pulling
                * isolation
                    * escalation of priviledges
                * which user runs containers
                * vulnerabilities in container image's dependencies

----


:data-rotate-x: r-90
:data-x: r0
:data-y: r-1000
:data-z: r+1000

Container Concepts
==================

* Images
* Registry
* Runtime


.. note::
    * images <-> containers

----


:data-rotate-x: r0
:data-x: r1600
:data-y: r0
:data-z: r0

:id: container_concept_image

Container Concepts
==================

Image
-----

.. image:: graphics/image_architecture.png

* Filesystem layers
    * lower layers can be shared
* Configuration
    * environment variables
    * network interfaces
    * mounted volumes
    * meta: author, version

.. note::
    * Lower image FS layers can be shared
    * Layers are mounted as a union filesystem (Beware: Copy-On-Write, thin writable layer not ideal to write big data)
    * Running image -> container
        * mount union fs
        * create nics, volumes, env vars in container, ...


----


Container Concepts
==================

Registry
--------
* Registry serves Images and
* supports
    * tagging (versioning),
    * image signing,
    * security/vulnerability analysis,
    * image replication among registry instances,
    * ...

* Think **Git** (push, pull, commit)

*Every image has a UID/hash*


----


Container Concepts
==================

Runtime
-------

* Running an image creates a container, i.e.:
    * Registry interaction (e.g. pull image)
    * set up containerized environment using `cgroups <wikipedia cgroups_>`_, `namespaces <wikipedia linux namespaces_>`_
    * Mount image filesystem,
    * create thin writeable container layer

.. note::
    * low-level vs high-level: separation of concerns (OCI-runc vs containerd)
    * setup: network interfaces, users, env_vars
    * Thin writeable container layer (union fs) -> image layers can be shared by other container instances of layer
        * ephemeral storage!


.. TODO: Add info
    * thin writeable layer graphic
    * container properties (ephemeral storage, ...)


----


:data-rotate-x: r0
:data-x: r1600
:data-y: r0
:data-z: r0

Docker != Container
===================

* Docker made using containers popular
* Integrates many functionalities useful for container handling
    * Creating images: Dockerfile
    * Image registry: Dockerhub
    * Container management:
        * Run containers
        * List running containers
    * Popular among developers

:data-y: 3000
:data-x: 0


----


Alternatives to Docker
======================

**Images**

* buildah
* kaniko
* jib
* ...

**Registry**

* skopeo (interact with registries)
* Harbor (self-hosted)
* Red Hat Container Catalog
* Google Container Registry
* ...

**Runtime**

* CRI-O (lightweight, kubernetes)
* Podman
* frakti (Run containers in VMs)

.. note::
    * Why alternatives? Docker requires a Daemon
    * OCI standardization effort
    * frakti: uses virtual machines as containers (enhanced security/isolation?)
