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

## Planned changes before production (after successful POC)

Production ready:
- 3 X Master nodes: D8as_v5
- 3 X Worker nodes: D4as_v5
- Ingress & Api visibility: Private
- Fully automate patches
- Semi automate minors
- Authentication: Okta's Jfrog

## Using Managed upgrade operator

For Jfrog to apply the non interference
[MUO Link](https://learn.microsoft.com/en-us/azure/openshift/howto-upgrade#scheduling-individual-upgrades-using-the-managed-upgrade-operator)

```yaml
apiVersion: upgrade.managed.openshift.io/v1alpha1
kind: UpgradeConfig
metadata:
  name: managed-upgrade-config
  namespace: openshift-managed-upgrade-operator
spec:
  type: "ARO"
  upgradeAt: "2024-04-02T14:00:00Z"
  PDBForceDrainTimeout: 60
  desired:
    channel: "stable-4.14"
    version: "4.13.38"
```

```bash
oc create -f <file_name>.yaml
```

## Pricing breakdown

![alt text](https://github.com/zakarel/ARO-POC-jfrog/blob/main/aro-poc-costs.png?raw=true)

## Constrains & Limitations

- Deploy cluster time is between ~30m-~55m
- Unable to stop the cluster
- Unable to resize cluster
- An Azure Red Hat OpenShift cluster consists of 3 master nodes and 3 or more worker nodes.
- Master and worker nodes run on Azure Virtual Machines, billed at Linux VM pricing. Worker nodes have an additional cost for the OpenShift license component
Compute, networking and storage resources consumed by your cluster are billed according to usage. Use on-demand pricing, or reserved instances, whichever best meets the need of your workload and business.
- [ARO FAQ](https://learn.microsoft.com/en-us/azure/openshift/openshift-faq).
  
## Appendix

- Terraform Azurerm ARO - [Link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redhat_openshift_cluster)
- Configure Okta as Identity provider - [Link](https://www.redhat.com/en/blog/how-to-configure-okta-as-an-identity-provider-for-openshift)
- Schedule ind
