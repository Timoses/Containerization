:title: Introduction to Kubernetes Services and Ingress
:css: presentation.css


----

Introduction to Kubernetes Service and Ingress
===============================================

----

:id: service

Service
=======


A service abstracts access via a
virtual IP to multiple **endpoints** which may be

* pods
* IP
* Domain (ExternalName)

.. raw:: html

    <style>
        #service svg {
            position: relative;
            top: -50px;
            margin-bottom: -20px;
            z-index: -100;
        }
        #service svg g g[id^='ingress'],
        #service svg g g[id^='edge_ingress'] {
            display: none;
        }
    </style>

.. raw:: html
    :file: ../../graphics/k8s_ingress.svg

----

Service
=======

Example
-------
.. code:: yaml

        apiVersion: v1
        kind: Service
        metadata:
          name: redis-master
        spec:
          selector:
            app: redis
          ports:
          - name: http
            protocol: TCP
            port: 80
            targetPort: 9376
          - name: https
            protocol: TCP
            port: 443
            targetPort: 9377
        ---
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            app: redis
          name: redis-master
          namespace: default
        spec:
          containers:
          - image: k8s.gcr.io/redis:e2e


----


Service
=======

Types
-----

* ClusterIP: vIP
* NodePort: vIP + NAT routing on all nodes
* LoadBalancer: Creates instance of a loadbalancer
     * drawback: one LB per service
     * only works if set up in cluster


.. note::
   * all services receive clusterIP
       * except if HEADLESS service (clusterIP: none)


----


Service
=======

Discovery
---------

The Service IP can be discovered via

* Environment variables
     * Pod contains environment variables with information on services
     * Example for svc "redis-master":

     .. code::

          REDIS_MASTER_SERVICE_HOST=10.0.0.11
          REDIS_MASTER_SERVICE_PORT=6379
          REDIS_MASTER_PORT=tcp://10.0.0.11:6379
          REDIS_MASTER_PORT_6379_TCP=tcp://10.0.0.11:6379
          REDIS_MASTER_PORT_6379_TCP_PROTO=tcp
          REDIS_MASTER_PORT_6379_TCP_PORT=6379
          REDIS_MASTER_PORT_6379_TCP_ADDR=10.0.0.11

* DNS
     * <service-name>.<namespace>.svc.cluster.local


----

Service
=======

kube-proxy
----------

* Sets rules to proxy services to endpoints on each node
* iptables: uses random endpoint on a node
* ipvs: can loadbalance: 'rr' (round robin) for several endpoints


.. note::
   * ipvs is much faster (uses hash tables)


----

Service
=======

Accessing a Service
-------------------

* NodePort or LoadBalancer Service type
* :code:`kubectl cluster-info` for services in namespace :code:`kube-system`
       * :code:`coredns is running at https://172.17.8.101:6443/api/v1/namespaces/kube-system/services/coredns:dns/proxy`
       * :code:`kubernetes-dashboard is running at https://172.17.8.101:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy`
* :code:`kubectl exec` -> Access services from inside another pod
* Access via kube-api `link <https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-services/#manually-constructing-apiserver-proxy-urls>`_
    * :code:`http://kubernetes_master_address/api/v1/namespaces/namespace_name/services/[https:]service_name[:port_name]/proxy`
* :code:`kubectl port-forward service/<service_name> <local_port:target_port>`


----

Service vs Ingress
==================

.. raw:: html
    :file: ../../graphics/k8s_ingress.svg

* A service is a cluster-internal construct
* Ingress allows defining traffic from outside into the cluster

* Currently: Service = Layer 4 capability, Ingress = Layer 7 capability
    * (Kubernetes docs states plans to introduce L7 capabilities to Services)
