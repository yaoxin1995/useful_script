
How to config and set up kubeadm, please look at this [link](https://computingforgeeks.com/install-kubernetes-cluster-ubuntu-jammy/)





Bug fix:
1. unable to create RBAC clusterrolebinding header missing HTTP content-type [link](https://github.com/kubernetes/kubeadm/issues/2699)
   
   This is a HAporxy issue, one solution would be setting up the HAporxy properly, another easy workearound is disable kube-proxy when we initialize the cluster using `skip the proxy initilization part by using kubeadm init --skip-phases=addon/kube-proxy`

2. Got error `plugin type="flannel" failed (add): open /run/flannel/subnet.env: no such file or directory`   when i deploy a pod.
   fixed it by manually adding the file:
```
/run/flannel/subnet.env

FLANNEL_NETWORK=10.244.0.0/16
FLANNEL_SUBNET=10.244.0.1/24
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true
```

