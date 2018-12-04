#/bin/bash

modprobe tun

ERROR=0
for line in $(ip link show) 
do
	devWTF=$(echo $line | grep -oE "tap[0-9]+")
	if [ $devWTF ]; then
		echo -e "\told dev: $devWTF"
		result=$(sudo tunctl -d $devWTF 2>&1)
		echo $result
		if [ "$(echo $result | grep -o "busy")" == "busy" ]; then
			echo -e "\tThere is a tap dev in this system."
			ERROR=1
		fi
	fi
done

if [ $ERROR == "1" ]; then
	exit
fi

result=$(sudo tunctl)
# do something
echo $result
dev=$(echo $result | grep -oE "tap[0-9]+")
echo -e "\tnew dev: $dev"

sudo ip link set $dev up
sudo ip address add 10.0.0.1/8 dev $dev
sudo ip route add 10.0.0.1 dev $dev
ip link show $dev
