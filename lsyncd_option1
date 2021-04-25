### Lsyncd using rsync daemon (running on port 873)

#### Step 1. Open firewall
```
firewall-cmd --permanent --add-port=873/tcp
firewall-cmd --reload
```
#### Step 2. Each slave edit /etc/rsyncd.conf
```
[backup]
        path = /root/ahihi/
        uid  = root
        gid  = root
        read only = false
        write only = no
        hosts allow = 10.1.21.112/255.255.0.0
        incoming chmod  = 0644
        outgoing chmod  = 0644
        list = yes
        hots deny = *
```
--> open daemon [backup] pointer to /root/ahihi/ , allow only host 10.1.21.112

#### Step 3. Config lysncd (see ssh_lsyncd.conf on github)








