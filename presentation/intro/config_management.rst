:title: Introduction to Kubernetes Configuration Management
:css: presentation.css




----

Introduction to Kubernetes Configuration Management
===================================================

----

Config Management
=================

Topics
------

* Declarative vs Imperative
* Kubernetes Objects



----

Config Management
=================

Delcarative vs Imperative
-------------------------

* Imperative:
    * Specify instructions to reach desired state
    * 'How?'
* Declarative:
    * Specify desired state
    * 'What?'

.. note::
   + Declarative: Somebody else will think about required instructions to reach that goal (Kubernetes controllers/operators)


----

Config Management
=================

Kubernetes Objects and Resources
--------------------------------

* Kubernetes Objects are represented by Resource Files
    * Example :code:`yaml` resource for a pod object:
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
              command: ["stress"]
              args: ["--vm", "1", "--vm-bytes", "150M", "--vm-hang", "1"]

* `Kubernetes API <https://kubernetes.io/docs/reference/#api-reference>`_ documents available objects
* Additionally, Custom Resource Definitions (CRDs) allow defining custom objects

* -> A collection of resource files describes the desired state of a cluster!


----

Config Management
=================

Managing Resources
------------------

**Goal**: Version-controlled configuration management (Basis for GitOps)

* Raw resource files
* Templating
    * Helm
    * ksonnet (discontinued)
    * kapitan
* Layering
    * kustomize

----

Config Management
=================

Managing Resources - Toy Scenario
---------------------------------

:code:`app.yaml`:

   .. code:: yaml

     apiVersion: v1
     kind: Pod
     metadata:
       name: great-application
     spec:
       containers:
       - image: great_app:v1337

Setup:

.. raw:: html
    :file: ../../graphics/config_scenario.svg

----

Config Management
=================

Managing Resources - Raw
------------------------

::

    cluster_1/
        namespace1/
            app.yaml
                -----
                apiVersion: v1
                kind: Pod
                metadata:
                  name: great-application
                  namespace: namespace1         <-------------------
                spec:
                  containers:
                  - image: great_app:v1337
                -----
        namespace2/
            app.yaml
                -----
                apiVersion: v1
                kind: Pod
                metadata:
                  name: great-application
                  namespace: namespace2         <-------------------
                spec:
                  containers:
                  - image: great_app:v1337
                -----

    cluster_2/
        namespace3/
            app.yaml
        namespace4/
            app.yaml


+-----+---------------------------------------------------+
| Pro | No additional tooling required                    |
+-----+---------------------------------------------------+
| Con | A simple change requires 4 changes (not scalable) |
|     | -> Produces lots of work                          |
+-----+---------------------------------------------------+


----

Config Management
=================

Managing Resources - Helm 1/2 (Templating)
------------------------------------------

app.yaml:

.. code:: yaml

        apiVersion: v1
        kind: Pod
        metadata:
          name: great-application
          namespace: {{ .Values.namespace }}     <-------------------
        spec:
          containers:
          - image: {{ .Values.image.repository }}:{{ .Values.image.tag }}

::

    cluster_1/
        namespace1/
            values.yaml
                -----
                namespace: namespace1
                image:
                  repository: great_app
                  tag: v1
                -----
        namespace2/
            values.yaml
                -----
                namespace: namespace2
                image:
                  repository: great_app
                  tag: v0.9
                -----

    cluster_2/
        namespace3/
            values.yaml
        namespace4/
            values.yaml


+-----+-----------------------------------------------------------------------------------------------------------+
| Pro | Customizable variables                                                                                    |
+-----+-----------------------------------------------------------------------------------------------------------+
| Con | Dependency on upstream - Can not easily add further values without forking or requests to upstream source |
+-----+-----------------------------------------------------------------------------------------------------------+

----

Config Management
=================

Managing Resources - Helm 2/2 (Templating)
------------------------------------------

**Template everything???**

.. code:: yaml

    {{- if .Values.ingress.enabled }}
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
    {{- if .Values.ingress.annotations }}
      annotations:
    {{ toYaml .Values.ingress.annotations | indent 4 }}
    {{- end }}
      name: {{ template "spinnaker.fullname" . }}-deck
      labels:
    {{ include "spinnaker.standard-labels" . | indent 4 }}
    spec:
      rules:
      - host: {{ .Values.ingress.host | quote }}
         http:
           paths:
           {{- if index $.Values.ingress "annotations" }}
           {{- if eq (index $.Values.ingress.annotations "kubernetes.io/ingress.class" | default "") "gce" "alb" }}
           - path: /*
           {{- else }}{{/* Has annotations but ingress class is not "gce" nor "alb" */}}
           - path: /
           {{- end }}
           {{- else}}{{/* Has no annotations */}}
           - path: /
           {{- end }}
              backend:
                serviceName: spin-deck
                servicePort: 9000
    {{- if .Values.ingress.tls }}
      tls:
    {{ toYaml .Values.ingress.tls | indent 4 }}
    {{- end -}}
    {{- end }}



----

Config Management
=================

Managing Resources - kustomize 1/2
----------------------------------

.. figure:: https://kustomize.io/images/header_templates.png
   :width: 100%

   Source: https://kustomize.io/images/header_templates.png

----

Config Management
=================

Managing Resources - kustomize 2/3
----------------------------------

.. code:: yaml

    cluster_1/
        namespace1/
            overlays/
                app-image.yaml
                    -----
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      name: great-application
                    spec:
                      containers:
                      - image: great_app:v0.x
                    -----
            kustomization.yaml
                -----
                base:
                - https://upstream.int/app.yaml
                namespace: namespace1

                patchesStrategicMerge:
                - overlays/
                -----
        namespace2/
            kustomization.yaml
                -----
                base:
                - https://upstream.int/app.yaml
                namespace: namespace2
                -----

    cluster_2/
        namespace3/
            kustomization.yaml
        namespace4/
            kustomization.yaml


----

Config Management
=================

Managing Resources - kustomize 3/3
----------------------------------

+-----+--------------------------------------------------------------------------------------------------+
| Pro | * High degree of flexibility                                                                     |
|     | * Easy conversion of other sources into kustomize while keeping up-to-date with upstream sources |
|     | * From Helm to kustomize with `Ship <https://github.com/replicatedhq/ship>`_                     |
+-----+--------------------------------------------------------------------------------------------------+
| Con | * Can become a bit overwhelming due to high flexibility                                          |
|     |     * mitigated by well-designed directory structuring                                           |
+-----+--------------------------------------------------------------------------------------------------+


----

Config Management
=================

Deploying resources
-------------------

Deployment is independent of config management!

(It is easy to replace one Deployment strategy with another)

* kubectl
* Githooks
* Ansible
* CD tools
    * Weave Flux
    * Argo CD


----

Config Management
=================

Deploying resources - Argo CD
-----------------------------

* Understands kustomize, helm, ksonnet, jsonnet, plain yaml,
* can use resource files from different repositories & paths,
* can deploy to multiple clusters
* OIDC & RBAC

