osb="osb-server"
status=$(sudo systemctl is-active ovirt-engine)

ssh_status=$(ssh ${osb} echo ok 2>&1)
if [ -L /usr/bin/engine-backup -a "$status" == "active" -a "$ssh_status" == "ok" ]; then
        hostname=$(/usr/bin/hostname)
        date=$(/usr/bin/date +"%d-%m-%y")
        filename="${hostname}-backup-${date}.tgz"
        sudo engine-backup --scope=all --mode=backup --log=/tmp/backup.log --file=$filename
        sudo scp $filename ${osb}:/root/rhvm/
        sudo mv $filename /tmp/
fi
