# Hướng dẫn đồng bộ cấu hình
* _**Yêu cầu**_
	* Trên 2 host cài serivce: [lsyncd](https://axkibe.github.io/lsyncd/), ssh
    * Người dùng tồn tại trên cả hai hệ thống
    * Firewall 22/tcp

* _**Case đồng bộ**_ 

Đồng bộ ví dụ từ __porta0l:/config/data__   đến __portal01:/home/webportal/__
***
    portal01	10.3.60.15	dr-portal01	10.1.0.29	rsync	config/data	/home/webportal/
***


* _**Hướng đồng bộ**_ 
	* Chạy đồng bộ live từ node portal01 --> dr-portal01 còn ngược lại thì không 
    * Trong case DR, tắt đồng bộ live từ portal01 --> dr-portal01 và bật đồng bộ live từ dr-portal01 --> portal01

# Hướng dẫn
### 1.	Cài đặt lsyncd
```
yum install lsyncd -y
```
### 2.	Mở firewall trên cả 2 node (bước này có thể bỏ qua nếu cả 2 đã thông)
```
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --reload
```
### 3.	Thêm key để cho phép các node đăng nhập ssh qua ssh-key 
#### _3.1	Copy portal01_rsa to dr-portal01_
```
ssh-keygen portal01_rsa
ssh-copy-id -i portal01_rsa  root@dr-portal01
```
#### _3.2	Copy dr-portal01_rsa to portal01_
```
ssh-keygen dr-portal01_rsa
ssh-copy-id -i dr-portal01_rsa  root@portal01
```

### 4.	Cấu hình lysnc
* _**Giải thích các tham số**_
	* update = true (bỏ qua update các file trên destination mà timestamp mới hơn trên source)
    * whole_file = false (default) (copy files whole (w/o delta-xfer algorithm) --> chỉ copy các phần thay đổi)
    * dry_run (chỉ in ra tên những file đồng bộ mà không tranfer thật sự)
    * [delete](https://programmer.group/lsyncd-real-time-synchronization-mirror-daemon.html) = true (xóa những file trên destination mà trên source không có), another mode=running, before, after.
    * exclude = {“/web/dir/logs”,”/web/dir/tmp”} (không đồng bộ những thư mục này)

#### _4.1	Trên portal01, cấu hình /etc/lsyncd.conf_

***
    settings  {
        insist = true,
        statusInterval = 1,
        logfile = "/var/log/lsyncd/lsyncd.log",
        statusFile = "/var/log/lsyncd/lsyncd.status"
    }
    
    sync {
        default.rsyncssh,
        source = "/config/data/",
        targetdir = "/home/webportal/",
        host = "dr-portal01",
        delete = true,
        exclude = {'*.swp', '*.swn', '*.swo' },
        
        rsync = {
        	compress = true, -- nén file khi transfer
        	acls = true, -- giữ nguyên acls
        	verbose = true, -- hiển thị kết quả
        	owner = true, -- giữ nguyên người sở hữu
        	group = true, -- giữ nguyên group
        	perms = true, -- giữ permission
        	update = true,
          	dry_run = true,
        },
        ssh = {
            port = 22,
            identityFile = "/root/.ssh/portal01_rsa",
            options = {
                User = "root"
            }
        },
        delay = 5,
	}
***      
#### _4.2	Trên dr-portal01, cấu hình /etc/lsyncd.conf_
***
     settings  {
        insist = true,
        statusInterval = 1,
        logfile = "/var/log/lsyncd/lsyncd.log",
        statusFile = "/var/log/lsyncd/lsyncd.status"
    }
    
    sync {
        default.rsyncssh,
        source = "/home/webportal/",
        targetdir = "config/data/",
        host = "portal01",
        delete = true,
        exclude = {'*.swp', '*.swn', '*.swo' },
    
        rsync = {
        compress = true, -- nén file khi transfer
        acls = true, -- giữ nguyên acls
        verbose = true, -- hiển thị kết quả
        owner = true, -- giữ nguyên người sở hữu
        group = true, -- giữ nguyên group
        perms = true, -- giữ permission
        update = true,
        dry_run = true,
        },
        ssh = {
            port = 22,
            identityFile = "/root/.ssh/drportal01_rsa",
            options = {
                User = "root"
            }
        },
        delay = 5,
     }
***

* _**Cấu hình đồng bộ bên trên sẽ hoạt động như thế nào?**_
	* đồng bộ qua [ssh](https://github.com/axkibe/lsyncd/issues/217)
    * ghi log
    * bỏ qua các file swap
    * nén file,  giữ nguyên acl, user permision
    * delete = true , update = true, dry_run = true
    * đồng bộ mỗi 5s


### 5.	Test 
#### _5.1	Trên portal01_
```
systemctl start lsyncd
systemctl enable lsyncd
tail -f /var/log/lsyncd/lsyncd.log
```
Hiện tại đang chạy chế độ dry_run (chạy test chứ không tranfer thực sự), kiểm tra file log để xem các file có đồng bộ đúng hay không.

### 6.	Chạy đồng bộ live từ dc tới dr
#### _6.1	Trên portal01_
```
systemctl stop lsyncd
```
Uncomment " -- dry_run" trong /etc/lsyncd.conf
''
```
systemctl start lsyncd
```

### 7.	Chạy đồng bộ live từ dr --> dc
Tắt lsyncd trên dc

#### _6.1	Trên dr-portal01_
```
systemctl start lsyncd
systemctl enable lsyncd
```

