
How to config and set up kubeadm, please look at this [link](https://computingforgeeks.com/install-kubernetes-cluster-ubuntu-jammy/)

Conmand for kubeadm deployment

```
// 10.244.0.0/16  is requred for network seting using  Flannel network plugin
sudo kubeadm init   --pod-network-cidr=10.244.0.0/16   --cri-socket /run/containerd/containerd.sock --skip-phases=addon/kube-proxy


kubeadm join 192.168.122.11:6443 --token b4fome.c0wh3ulgd191131a         --discovery-token-ca-cert-hash sha256:720fb08fe48823d955a4e694968810a40008439892994aed752f058486e57c2f 
```



Bug fix:
1. unable to create RBAC clusterrolebinding header missing HTTP content-type [link](https://github.com/kubernetes/kubeadm/issues/2699)
   
   This is a HAporxy issue, one solution would be setting up the HAporxy properly, another easy workearound is disable kube-proxy when we initialize the cluster using `skip the proxy initilization part by using kubeadm init --skip-phases=addon/kube-proxy`

2. Got error `plugin type="flannel" failed (add): open /run/flannel/subnet.env: no such file or directory`   when i deploy a pod.
   fixed it by manually adding the file /run/flannel/subnet.env to worker node and master node:
   ```
FLANNEL_NETWORK=10.244.0.0/16
FLANNEL_SUBNET=10.244.0.1/24
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true
   ```

3. The connection to the server x.x.x.:6443 was refused - did you specify the right host or port? Kubernetes

   [link](https://stackoverflow.com/questions/56737867/the-connection-to-the-server-x-x-x-6443-was-refused-did-you-specify-the-right)

