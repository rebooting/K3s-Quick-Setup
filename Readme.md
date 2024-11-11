
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

# change permission of containerd.sock
```make change_sock_perm```

```make new_namespace```

```make build```

```make new_deployment```

```make deploy_nginx```

```make new_expose```

```make new_ingress```

to finally serve

```make new_map```