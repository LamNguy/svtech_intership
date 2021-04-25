# Installation DNS server
* responsibilty: lam.nd.svt
* Prerequisite: Centos 7
* info:  api.mobifone.vn  (103.99.78.16), beta.mobifone.vn (103.99.78.19) dns server: ?


### Step 1: Install DNS server
```
yum install bind bind-utils -y
```
### Step 2:  Open Firewall
```
firewall-cmd --permanent --add-port=53/udp
firewall-cmd --permanent --add-port=53/tcp
firewall-cmd --reload
```
### Step 3: Creat new zone
```
vi /etc/named/mobifone.conf
```
***
    zone "mobifone.vn" {
            type master;
            file "/var/named/forward.mobifone.vn";
            allow-update { none; };
    };
    
    zone "in-addr.arpa" IN {
            type master;
            file "/var/named/reverse.mobifone.vn";
            allow-update { none; };
    };
***
### Step 3: Forward & reverse pointer
```
vi /var/named/forward.mobifone.vn
```
***
    $TTL 86400
    @   IN  SOA     dns.mobifone.vn. root.mobifone.vn. (
            2011071001  ;Serial
            3600        ;Refresh
            1800        ;Retry
            604800      ;Expire
            86400       ;Minimum TTL
    
    );
    @       IN  NS          dns.mobifone.vn.
    @       IN  A           10.3.10.88
    dns      IN  A  10.3.10.88
    api       IN  A  103.99.78.16
    beta    IN  A   103.99.78.19
***

```
/var/named/reverse.mobifone.vn
```
***
    $TTL 86400
    @   IN  SOA     dns.mobifone.vn. root.mobifone.vn. (
            2011071001  ;Serial
            3600        ;Refresh
            1800        ;Retry
            604800      ;Expire
            86400       ;Minimum TTL
    );
    @       IN  NS          dns.mobifone.vn.
    10.3.10.88     IN  PTR        dns.mobifone.vn.
    16.78.99.103     IN  PTR         api.mobifone.vn.
    19.78.99.103     IN  PTR         beta.mobifone.vn.
***

### Step 4: Make changes in /etc/named.conf
```
listen-on port 53 { 127.0.0.1; 10.3.10.88;};
listen-on-v6 port 53 { ::1; };
allow-query     { localhost; 10.3.10.0/24; };
include "/etc/named/mymobifone.conf";
allow-transfer{ localhost; 192.168.1.102; };   ### Slave DNS IP ###  
```
### Step 5: Listen on ipv4
```
/etc/sysconfig/named
OPTIONS="-4"
```
### Step 6: Start service
```
sudo systemctl enable named
sudo systemctl start named
```
### Step 7 Test
```
nslookup api.mobifone.vn
nslookup beta.mobifone.vn
```
[Reference install dns server](https://www.itzgeek.com/how-tos/linux/centos-how-tos/configure-dns-bind-server-on-centos-7-rhel-7.html)

