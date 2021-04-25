# Quy trình backup RHVM lên OSB
#### Bước 1. Đồng bộ kết nối SSH giữa các node RHVM với OSB

##### 1.	Trên mỗi node RHVM
###### 1.1	Add OSB server vào file /etc/hosts
###### 1.2	Add ssh-key của RHVM lên OSB server
###### 1.3	Cấu hình /root/.ssh/config để tự động kết nối.
```
Host osb-server
     Hostname osb-server
     User root
     IdentityFile ~/.ssh/id_rsa
```

##### 2.	Trên OSB-Server
###### 2.1	Add các RHVM node vào file /etc/hosts
###### 2.2	Add ssh-key của OSB Server lên các node RHVM
###### 2.3	Cấu hình /root/.ssh/config để tự động kết nối.
```
Host rhvm01
     Hostname rhvm01
     User root
     IdentityFile ~/.ssh/id_rsa
```
#### Bước 2. Code script để tự động phần chuyển các file backup sinh ra từ RHVMs tới OSB server
Xem code + đọc file README:[Link code](https://github.com/LamNguy/svtech_intership/tree/master/osb_backup)

##### 1. Copy file osb_server.sh lên trên OSB server
Chỉnh sửa file backup_rhvm.sh, cấu hình tham số __backup__ (đường dẫn thư mục file backup rhvm) và __rhvms__ (chứa tên RHVM host).
Script xóa những file backup nào có tạo quá 10 ngày.
##### 2. Copy file backup_rhvm lên trên các con RHVM (có thể làm bằng tự động như scp)
Copy file backup_rhvm lên trên 3 con RHVM (default path=/root ). 
Chỉnh sửa tham số __osb__ là hostname của osb-server.
Script tạo ra file backup và file log đẩy vào thư mục /tmp. Đồng thời đẩy file backup tới OSB server (default path: OSB:/root/rhvm). 
ĐInh dạng tên file backup có dạng [hostRHVM][time]
#### Bước 3. Trên OSB, chạy Crontab (1:00 am daily)
```
bash backup_rhvm.sh > /tmp/backup_rhvm.log
```
Mục đích để in ra log. 

#Chú ý
Hiện tại đang là từ OSB server đẩy lệnh về và các RHVM sẽ tự sinh ra file upload và scp lại OSB. Tuy nhiên có thể thay đổi script để dùng OSB đẩy lệnh về các RHVM và tự đẩy file backup mà các RHVM sinh ra
```
when execute command ssh, it will wait ssh command finish and continue processing
```
