# ARO-POC-Jfrog

Repository for the Jfrog ARO POC Project

---

## Diagram

![alt text](https://github.com/zakarel/ARO-POC-jfrog/blob/main/Diagram-jfrog-tf-aro-v3.png?raw=true)

## Technical details

- 3 X Master nodes: E4as_v4
- 3 X Worker nodes: E2s_v5
- Ingress & Api visibility: Public
- Authentication for POC: Entra ID

## Planned changes before production

Production ready:
- 3 X Master nodes: D8as_v5
- 3 X Worker nodes: D4as_v5
- Ingress & Api visibility: Private
- Authentication: Okta's Jfrog

## Pricing breakdown

![alt text](https://github.com/zakarel/ARO-POC-jfrog/blob/main/aro-poc-costs.png?raw=true)

## Constrains & Limitations

- Deploy cluster average time is between ~30m-~55m
- Unable to stop the cluster
- Unable to resize cluster
- An Azure Red Hat OpenShift cluster consists of 3 master nodes and 3 or more worker nodes.
- Master and worker nodes run on Azure Virtual Machines, billed at Linux VM pricing. Worker nodes have an additional cost for the OpenShift license component
Compute, networking and storage resources consumed by your cluster are billed according to usage. Use on-demand pricing, or reserved instances, whichever best meets the need of your workload and business.
- [ARO FAQ](https://learn.microsoft.com/en-us/azure/openshift/openshift-faq).
  
