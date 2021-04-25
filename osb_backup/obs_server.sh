# backup directory
backup=/root/rhvm
# rhvms
rhvms="rhvm01 rhvm02 rhvm03"
# check directory backup
if [ -d ${backup} ]; then
        echo 'test_backup'
        # find file create 10 days 
        file=$(find ${backup}/* -mtime +10)
        for f in $file; do
                echo sudo rm $f
        done
else
        echo mkdir "$backup"
fi

for rhvm in $rhvms; do
        echo Trying to connect $rhvm
        ssh_status=$(ssh ${rhvm} echo ok 2>&1)
        echo $ssh_status
        if [ "$ssh_status" == "ok" ] ; then
                echo ssh ${rhvm} bash backuprhvm
        fi
done
