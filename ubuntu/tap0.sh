#/bin/bash

modprobe tun

echo -e "\tOld interfaces..."
ERROR=0
for line in $(ip link show) 
do
	devWTF=$(echo $line | grep -oE "tap[0-9]+")
	if [ $devWTF ]; then
		echo -e "\told dev: $devWTF"
		sudo tunctl -d $devWTF 2>&1
		if [ "1" == "$?" ]; then
			ERROR=1
		fi
	fi
done

if [ $ERROR == "1" ]; then
	exit
fi

echo -e "\tThe new interface..."

result=$(sudo tunctl)
# do something
echo $result
dev=$(echo $result | grep -oE "tap[0-9]+")
echo -e "\tnew dev: $dev"

sudo ip link set $dev up
sudo ip address add 10.0.0.1/8 dev $dev
sudo ip route add 10.0.0.1 dev $dev
ip link show $dev
