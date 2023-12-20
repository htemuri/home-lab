# Background

Create a rust tool for IPMI over LAN. This will enable me to access server hardware through code.

This work is tracked under https://github.com/htemuri/rust-ipmi

## IPMI


IPMI is a specification which allows software to interact and communicate with systems through the BMC (Baseboard Management Controller). IPMI spec allows for multiple methods of connecting, this rust implementation will focus on the LAN connector.

![Alt text](/images/ipmi.png)


