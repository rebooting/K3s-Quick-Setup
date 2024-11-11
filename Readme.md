
# Summary

Condensing Rancher tutorial to a single script (https://www.rancher.academy/courses/take/k3s-basics/) to install Kubernetes, build a simple image and deploy it.

I ran this on a Rpi 5 , modify the architecture to suit your needs 

nerdctl and k3s do not share the same containerd.sock, so we need to force nerdctl to use the same containerd.sock as k3s



# install K3s
```curl -sfL https://get.k3s.io | sh -```

# install nerdctl
```wget https://github.com/containerd/nerdctl/releases/download/v2.0.0/nerdctl-full-2.0.0-linux-arm64.tar.gz```
```mkdir nerdctl && cd nerdctl```
```tar xvf ../nerdctl-full-2.0.0-linux-arm64.tar.gz```
```sudo cp nerdctl /usr/local```

# add profile 
``` echo "export PATH=$PATH:/usr/local/nerdctl/bin" > /etc/profile.d/nerdctl.sh```
```source ~/.profile```

# setup nerdctl
``` /usr/local/nerdctl/bin/containerd-rootless-setuptool.sh install```

# change permission of containerd.sock ( this depend on your user)
```make change_sock_perm```

```make new_namespace```

```make build```

```make new_deployment```

```make deploy_nginx```

```make new_expose```

```make new_ingress```

to finally serve

```make new_map```


references:

- https://salimwp.medium.com/hello-nerdctl-16347cc194ff

-