# Xuất thông tin danh sách máy ảo trong RHVM

* _**Chức năng**_
	* Script chỉ lấy thông tin các máy ảo, không điều chỉnh chỉnh sửa hệ thống.
	* Xuất thông tin các máy ảo trong một RHVM phân theo các host, thông tin máy ảo được export như [hình](https://github.com/LamNguy/rhvm/blob/master/0-02-06-5704fc31239704bfe9ebd97bcbeed9701896a8139d69b9b492f400153dfd91f6_bf2436d6.jpg) 
    * output: một file csv/excel
    
* _**Yêu cầu**_
	* Khởi tạo một máy ảo Centos 7  VM_test
    * Trên máy ảo này sẽ chạy script tương tác với RHVM (_Do cài thêm các thư viện khác nên tách biệt phần chạy script với RHVM để tránh sự cố không mong muốn_)
    * Mở firewall kết nối HTTPS (443/tcp) từ VM_test đến RHVM
    * account admin
    * winscp/ scp file thông tin đã export sang được một máy desktop để hiện thị. 

* _**Cài đặt thư viện**_
```
sudo yum install git epel-release -y
sudo yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm -y
sudo yum install python-ovirt-engine-sdk4 -y
sudo yum install python-pip -y
sudo yum install wget -y
sudo yum install net-tools -y
sudo pip install numpy==1.12.0
sudo pip install pandas==0.24.2
sudo pip install xlrd==1.0.0
```	
* _**Tải certificate**_

__Thay đổi username, password và domain tương ứng__
```
export USER_NAME='admin'
export PASSWORD='Admin'
export CERT='http://rhvmanager09.svt.hn/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA'
wget -O ca.pem --user $USER_NAME --password $PASSWORD --no-check-certificate $CERT
```

__Chú ý__: Bước này có thể tải trực tiếp certificate từ trên portal RHVM rồi chuyển vào VM_test.
