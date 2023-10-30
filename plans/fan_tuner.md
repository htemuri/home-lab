# Background:

Dell servers don't support 3rd part SSDs natively. This leads to the server contantly running fans on max RPM.

Able to bypass this, by enabling manual fan control through IPMI with iDRAC. Source: https://www.reddit.com/r/homelab/comments/t9pa13/dell_poweredge_fan_control_with_ipmitool/


```{bash}
# turn on manual fan control 
ipmitool -I lanplus -H $IP -U $USER -P $PASS raw 0x30 0x30 0x01 0x00

# turn off manual fan control
ipmitool -I lanplus -H $IP -U $USER -P $PASS raw 0x30 0x30 0x01 0x01

# controlling all fans single command '##' 0-64 hex to dec
ipmitool -I lanplus -H $IP -U $USER -P $PASS raw 0x30 0x30 0x02 0xff 0x## 

# control single fan ?? index of fan
ipmitool -I lanplus -H $IP -U $USER -P $PASS raw 0x30 0x30 0x02 0x?? 0x##
```

Features:

1. Control fan speed dynamically based on thermals
2. Set fan speed to follow set fan curve
3. UI to set fan curve

# Technologies to learn for this project

1. Rust/Go for service
2. Web Application for UI

![diagram of fan tuner architecture](/images/fan_tuner.png)