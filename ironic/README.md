# Openstack Ironic

<!-- markdownlint-disable MD004 MD007 MD012 MD029 MD033 -->

## Documentation

- [Openstack Ironic’s documentation](https://docs.openstack.org/ironic)

- [ironic-book](https://ironic-book.readthedocs.io/zh_CN/latest/index.html)

- [Ironic-API (Bare Metal API) References](https://developer.openstack.org/api-ref/baremetal/)
    - RESTful api: `http://[ironic-server]:8080/v1/`

## Use Ironic Service

Restart `ironic-api` and `ironic-conductor` services:

```Bash
sudo service ironic-api restart
sudo service ironic-conductor restart
```

Create a **Node** in Bare Metal service:

```Bash
openstack baremetal node create --driver ipmi \
    --driver-info ipmi_address=ipmi.zerone.io \
    --driver-info ipmi_username=user \
    --driver-info ipmi_password=pass \
    --driver-info deploy_kernel=file:///images/deploy.vmlinuz \
    --driver-info deploy_ramdisk=http://zerone.io/images/deploy.ramdisk
```

Create a port to inform Bare Metal service of the network interface cards (used for naming of PXE configs for a node):

```Bash
openstack baremetal port create $MAC_ADDRESS --node $NODE_UUID
```

Specify some fields in the node’s **instance_info**:

```Bash
openstack baremetal node set $NODE_UUID \
    --instance-info image_source=$IMG \
    --instance-info image_checksum=$MD5HASH \
    --instance-info kernel=$KERNEL \
    --instance-info ramdisk=$RAMDISK \
    --instance-info root_gb=10
```

Validate that all parameters are correct: 

```Bash
openstack baremetal node validate $NODE_UUID
```

Start the deployment:

```Bash
openstack baremetal node deploy $NODE_UUID
```

### Default baremetal drivers (ipmi)

```Bash
vagrant@ironic:~$ openstack baremetal driver list
+---------------------+----------------+
| Supported driver(s) | Active host(s) |
+---------------------+----------------+
| ipmi                | ironic         |
| pxe_ipmitool        | ironic         |
+---------------------+----------------+

vagrant@ironic:~$ openstack baremetal driver show ipmi
+-------------------------------+---------------------+
| Field                         | Value               |
+-------------------------------+---------------------+
| default_boot_interface        | pxe                 |
| default_console_interface     | no-console          |
| default_deploy_interface      | iscsi               |
| default_inspect_interface     | no-inspect          |
| default_management_interface  | ipmitool            |
| default_network_interface     | noop                |
| default_power_interface       | ipmitool            |
| default_raid_interface        | no-raid             |
| default_storage_interface     | noop                |
| default_vendor_interface      | ipmitool            |
| enabled_boot_interfaces       | pxe                 |
| enabled_console_interfaces    | no-console          |
| enabled_deploy_interfaces     | iscsi, direct       |
| enabled_inspect_interfaces    | no-inspect          |
| enabled_management_interfaces | ipmitool            |
| enabled_network_interfaces    | flat, noop          |
| enabled_power_interfaces      | ipmitool            |
| enabled_raid_interfaces       | no-raid, agent      |
| enabled_storage_interfaces    | cinder, noop        |
| enabled_vendor_interfaces     | ipmitool, no-vendor |
| hosts                         | ironic              |
| name                          | ipmi                |
| type                          | dynamic             |
+-------------------------------+---------------------+

```

## Cli Usage

### 1. IPMI Commands

```Bash
vagrant@ironic:~$ ipmitool  -h
ipmitool version 1.8.16

usage: ipmitool [options...] <command>

       -h             This help
       -V             Show version information
       -v             Verbose (can use multiple times)
       -c             Display output in comma separated format
       -d N           Specify a /dev/ipmiN device to use (default=0)
       -I intf        Interface to use
       -H hostname    Remote host name for LAN interface
       -p port        Remote RMCP port [default=623]
       -U username    Remote session username
       -f file        Read remote session password from file
       -z size        Change Size of Communication Channel (OEM)
       -S sdr         Use local file for remote SDR cache
       -D tty:b[:s]   Specify the serial device, baud rate to use
                      and, optionally, specify that interface is the system one
       -4             Use only IPv4
       -6             Use only IPv6
       -a             Prompt for remote password
       -Y             Prompt for the Kg key for IPMIv2 authentication
       -e char        Set SOL escape character
       -C ciphersuite Cipher suite to be used by lanplus interface
       -k key         Use Kg key for IPMIv2 authentication
       -y hex_key     Use hexadecimal-encoded Kg key for IPMIv2 authentication
       -L level       Remote session privilege level [default=ADMINISTRATOR]
                      Append a '+' to use name/privilege lookup in RAKP1
       -A authtype    Force use of auth type NONE, PASSWORD, MD2, MD5 or OEM
       -P password    Remote session password
       -E             Read password from IPMI_PASSWORD environment variable
       -K             Read kgkey from IPMI_KGKEY environment variable
       -m address     Set local IPMB address
       -b channel     Set destination channel for bridged request
       -t address     Bridge request to remote target address
       -B channel     Set transit channel for bridged request (dual bridge)
       -T address     Set transit address for bridge request (dual bridge)
       -l lun         Set destination lun for raw commands
       -o oemtype     Setup for OEM (use 'list' to see available OEM types)
       -O seloem      Use file for OEM SEL event descriptions
       -N seconds     Specify timeout for lan [default=2] / lanplus [default=1] interface
       -R retry       Set the number of retries for lan/lanplus interface [default=4]

Interfaces:
    open          Linux OpenIPMI Interface [default]
    imb           Intel IMB Interface
    lan           IPMI v1.5 LAN Interface
    lanplus       IPMI v2.0 RMCP+ LAN Interface
    free          FreeIPMI IPMI Interface
    serial-terminal  Serial Interface, Terminal Mode
    serial-basic  Serial Interface, Basic Mode
    usb           IPMI USB Interface(OEM Interface for AMI Devices)

Commands:
    raw           Send a RAW IPMI request and print response
    i2c           Send an I2C Master Write-Read command and print response
    spd           Print SPD info from remote I2C device
    lan           Configure LAN Channels
    chassis       Get chassis status and set power state
    power         Shortcut to chassis power commands
    event         Send pre-defined events to MC
    mc            Management Controller status and global enables
    sdr           Print Sensor Data Repository entries and readings
    sensor        Print detailed sensor information
    fru           Print built-in FRU and scan SDR for FRU locators
    gendev        Read/Write Device associated with Generic Device locators sdr
    sel           Print System Event Log (SEL)
    pef           Configure Platform Event Filtering (PEF)
    sol           Configure and connect IPMIv2.0 Serial-over-LAN
    tsol          Configure and connect with Tyan IPMIv1.5 Serial-over-LAN
    isol          Configure IPMIv1.5 Serial-over-LAN
    user          Configure Management Controller users
    channel       Configure Management Controller channels
    session       Print session information
    dcmi          Data Center Management Interface
    nm            Node Manager Interface
    sunoem        OEM Commands for Sun servers
    kontronoem    OEM Commands for Kontron devices
    picmg         Run a PICMG/ATCA extended cmd
    fwum          Update IPMC using Kontron OEM Firmware Update Manager
    firewall      Configure Firmware Firewall
    delloem       OEM Commands for Dell systems
    shell         Launch interactive IPMI shell
    exec          Run list of commands from file
    set           Set runtime variable for shell and exec
    hpm           Update HPM components using PICMG HPM.1 file
    ekanalyzer    run FRU-Ekeying analyzer using FRU files
    ime           Update Intel Manageability Engine Firmware
    vita          Run a VITA 46.11 extended cmd

```

### 2. Ironic Commands

