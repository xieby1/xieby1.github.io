2020.5.5写在前面：[原网页](https://people.csail.mit.edu/albert/bluez-intro/index.html)是章节是分离的，这个文档是为了方便搜索而简单地将多个网页粘贴在一起的。目前没有看chapter 3（python编程），所以暂时没有放在这个markdown文档里。脚注目前只修改了前2章。

# An Introduction to Bluetooth Programming

**Albert Huang**

[albert@csail.mit.edu](mailto:albert@csail.mit.edu)

Copyright © 2005-2008 Albert Huang. This document may be redistributed under the terms of the [GNU Free Documentation License.](http://www.gnu.org/licenses/fdl-1.2.txt)

**Book News:** Since its writing, this document has been expanded into a more complete text, published by Cambridge University Press. The book is titled *Bluetooth Essentials for Programmers* and provides a much more detailed introduction to Bluetooth. It also describes how to write Bluetooth programs targeted for the GNU/Linux, Windows XP, OS X, and Series 60 platforms. Examples are given in C, Python, and Java.

This tutorial on Bluetooth programming in GNU/Linux will continue to be freely distributed from this website, but if you find it useful, or would like to learn more about Bluetooth programming, please consider purchasing, borrowing, or otherwise obtaining a copy of the book. Cheers.

*-Albert*

More information is available at the website: http://www.btessentials.com

# Chapter 1. Introduction

## 1.1. About this booklet

There are two reasons I wrote this document. The first is that during my research, which involved the heavy use of Bluetooth, I could not find any good documentation on using Bluetooth in Linux or programming with the BlueZ development libraries. BlueZ, like many other excellent open-source software projects, provides a robust and mature development environment, but has virtually no documentation whatsoever. The second reason is that I really needed some material for my master's thesis ;) No silly, this isn't the whole thesis, but it helped give context to the rest of it.

The original thesis was written in Latex, and there may be some residual Latex formatting (e.g. all the citations).

## 1.2. Who this document is for

I wrote this document so that it would have been *extreeeeemely* helpful to have when I started my work with Bluetooth. It targets the experienced programmer who is comfortable with either C or Python, is reasonably comfortable with the Linux environment, and is familiar with socket programming. This document specifically does not introduce network and socket programming concepts, as there are some excellent guides for that already, such as [Beej's Guide to Network Programming](http://www.ecst.csuchico.edu/~beej/guide/net/). If you find yourself struggling with the socket concepts discussed in this document, I strongly recommend reading through Beej's guide and then coming back.

Beyond knowledge of C or Python and network programming, it is not necessary to know much about other development libraries or systems to understand the material presented here.

## 1.3. Obtaining BlueZ and PyBluez

Instructions for installing the BlueZ development libraries can be found at the BlueZ website: [htp://www.bluez.org](http://www.bluez.org). Most modern Linux distributions (date of this writing: 08/24/2005) should have this packaged somehow. For example, on Debian-based systems:

```
    apt-get install libbluetooth1-dev bluez-utils
```

On Fedora:

```
    yum install bluez-devel
```

To install PyBluez, visit the PyBluez website: http://org.csail.mit.edu/pybluez. PyBluez unfortunately is not included in most distributions, so you'll have to install from source.

# Chapter 2. Bluetooth Programming Introduced

This chapter presents an overview of Bluetooth, with a special emphasis on the parts that concern a software developer. Bluetooth programming is explained in the context of TCP/IP and Internet programming, as the vast majority of network programmers are already familiar and comfortable with this framework. It is our belief that the concepts and terminology introduced by Bluetooth are easier to understand when presented side by side with the Internet programming concepts most similar to Bluetooth.

## 2.1. Overview

Hovering at over 1,000 pages [^2.1.1], the Bluetooth specification is quite large and daunting to the novice developer. But upon closer inspection, it turns out that although the specification is immense, the typical application programmer is only concerned with a small fraction of it. A significant part of the specification is dedicated to lower level tasks such as specifying the different radio frequencies to transmit on, the timing and signalling protocols, and the intricacies needed to establish communication. Interspersed with all of this are the portions that are relevant to the application developer. Although Bluetooth has its own terminology and ways of describing its various concepts, we find that explaining Bluetooth programming in the context of Internet programming is easy to understand since almost all network programmers are already familiar with those techniques. We do not try to explain in great detail the actual Bluetooth specification, except where it aids in understanding how it fits in with Internet programming.

Although Bluetooth was designed from the ground up, independently of the Ethernet and TCP/IP protocols, it is quite reasonable to think of Bluetooth programming in the same way as Internet programming. Fundamentally, they have the same principles of one device communicating and exchanging data with another device.

The different parts of network programming can be separated into several components



- Choosing a device with which to communicate
- Figuring out how to communicate with it
- Making an outgoing connection
- Accepting an incoming connection
- Sending data
- Receiving data

Some of these components do not apply to all models of network programming. In a connectionless model, for example, there is no notion of establishing a connection. Some parts can be trivial in certain scenarios and quite complex in another. If the numerical IP address of a server is hard-coded into a client program, for example, then choosing a device is no choice at all. In other cases, the program may need to consult numerous lookup tables and perform several queries before it knows its final communication endpoint.

[^2.1.1]: http://www.bluetooth.org/spec

## 2.2. Choosing a communication partner

Every Bluetooth chip ever manufactured is imprinted with a globally unique 48-bit address, which we will refer to as the *Bluetooth address* or *device address*. This is identical in nature to the MAC addresses of Ethernet [^2.2.1], and both address spaces are actually managed by the same organization - the IEEE Registration Authority. These addresses are assigned at manufacture time and are intended to be unique and remain static for the lifetime of the chip. It conveniently serves as the basic addressing unit in all of Bluetooth programming.

For one Bluetooth device to communicate with another, it must have some way of determining the other device's Bluetooth address. This address is used at all layers of the Bluetooth communication process, from the low-level radio protocols to the higher-level application protocols. In contrast, TCP/IP network devices that use Ethernet as their data link layer discard the 48-bit MAC address at higher layers of the communication process and switch to using IP addresses. The principle remains the same, however, in that the unique identifying address of the target device must be known to communicate with it.

In both cases, the client program will often not have advance knowledge of these target addresses. In Internet programming, the user will typically supply a host name, such as `csail.mit.edu`, which the client must translate to a physical IP address using the Domain Name System (DNS). In Bluetooth, the user will typically supply some user-friendly name, such as ``My Phone", and the client translates this to a numerical address by searching nearby Bluetooth devices.

### 2.2.1. Device Name

Since humans do not deal well with 48-bit numbers like `0x000EED3D1829` (in much the same way we do not deal well with numerical IP addresses like 64.233.161.104), Bluetooth devices will almost always have a user-friendly name. This name is usually shown to the user in lieu of the Bluetooth address to identify a device, but ultimately it is the Bluetooth address that is used in actual communication. For many machines, such as cell phones and desktop computers, this name is configurable and the user can choose an arbitrary word or phrase. There is no requirement for the user to choose a unique name, which can sometimes cause confusion when many nearby devices have the same name. When sending a file to someone's phone, for example, the user may be faced with the task of choosing from 5 different phones, each of which is named "My Phone".

Although names in Bluetooth differ from Internet names in that there is no central naming authority and names can sometimes be the same, the client program still has to translate from the user-friendly names presented by the user to the underlying numerical addresses. In TCP/IP, this involves contacting a local nameserver, issuing a query, and waiting for a result. In Bluetooth, where there are no nameservers, a client will instead broadcast inquiries to see what other devices are nearby and query each detected device for its user-friendly name. The client then chooses whichever device has a name that matches the one supplied by the user.

[^2.2.1]: http://www.ietf.org/rfc/rfc0826.txt

## 2.3. Choosing a transport protocol

Once our client application has determined the address of the host machine it wants to connect to, it must determine which transport protocol to use. This section describes the Bluetooth transport protocols closest in nature to the most commonly used Internet protocols. Consideration is also given to how the programmer might choose which protocol to use based on the application requirements.

Both Bluetooth and Internet programming involve using numerous different transport protocols, some of which are stacked on top of others. In TCP/IP, many applications use either TCP or UDP, both of which rely on IP as an underlying transport. TCP provides a connection-oriented method of reliably sending data in streams, and UDP provides a thin wrapper around IP that unreliably sends individual datagrams of fixed maximum length. There are also protocols like RTP for applications such as voice and video communications that have strict timing and latency requirements.

While Bluetooth does not have exactly equivalent protocols, it does provide protocols which can often be used in the same contexts as some of the Internet protocols.

### 2.3.1. RFCOMM + TCP

The RFCOMM protocol provides roughly the same service and reliability guarantees as TCP. Although the specification explicitly states that it was designed to emulate RS-232 serial ports (to make it easier for manufacturers to add Bluetooth capabilities to their existing serial port devices), it is quite simple to use it in many of the same scenarios as TCP.

In general, applications that use TCP are concerned with having a point-to-point connection over which they can reliably exchange streams of data. If a portion of that data cannot be delivered within a fixed time limit, then the connection is terminated and an error is delivered. Along with its various serial port emulation properties that, for the most part, do not concern network programmers, RFCOMM provides the same major attributes of TCP.

The biggest difference between TCP and RFCOMM from a network programmer's perspective is the choice of port number. Whereas TCP supports up to 65535 open ports on a single machine, RFCOMM only allows for 30. This has a significant impact on how to choose port numbers for server applications, and is discussed shortly.

### 2.3.2. L2CAP + UDP

UDP is often used in situations where reliable delivery of every packet is not crucial, and sometimes to avoid the additional overhead incurred by TCP. Specifically, UDP is chosen for its best-effort, simple datagram semantics. These are the same criteria that L2CAP satisfies as a communications protocol.

L2CAP, by default, provides a connection-oriented [[1\]](#FTN.AEN109) protocol that reliably sends individual datagrams of fixed maximum length [[2\]](#FTN.AEN111). Being fairly customizable, L2CAP can be configured for varying levels of reliability. To provide this service, the transport protocol that L2CAP is built on [[3\]](#FTN.AEN113) employs an transmit/acknowledgement scheme, where unacknowledged packets are retransmitted. There are three policies an application can use:



- never retransmit
- retransmit until total connection failure (the default)
- drop a packet and move on to queued data if a packet hasn't been acknowledged after a specified time limit (0-1279 milliseconds). This is useful when data must be transmitted in a timely manner.

Although Bluetooth does allow the application to use best-effort communication instead of reliable communication, several caveats are in order. The reason for this is that adjusting the delivery semantics for a single L2CAP connection to another device affects *all* L2CAP connections to that device. If a program adjusts the delivery semantics for an L2CAP connection to another device, it should take care to ensure that there are no other L2CAP connections to that device. Additionally, since RFCOMM uses L2CAP as a transport, all RFCOMM connections to that device are also affected. While this is not a problem if only one Bluetooth connection to that device is expected, it is possible to adversely affect other Bluetooth applications that also have open connections.

The limitations on relaxing the delivery semantics for L2CAP aside, it serves as a suitable transport protocol when the application doesn't need the overhead and streams-based nature of RFCOMM, and can be used in many of the same situations that UDP is used in.

Given this suite of protocols and different ways of having one device communicate with another, an application developer is faced with the choice of choosing which one to use. In doing so, we will typically consider the delivery reliability required and the manner in which the data is to be sent. As shown above and illustrated in [Table 2-1](x95.html#protocol-table), we will usually choose RFCOMM in situations where we would choose TCP, and L2CAP when we would choose UDP.



**Table 2-1. A comparison of the requirements that would lead us to choose certain protocols. Best-effort streams communication is not shown because it reduces to best-effort datagram communication.**

| Requirement             | Internet | Bluetooth                                |
| ----------------------- | -------- | ---------------------------------------- |
| Reliable, streams-based | TCP      | RFCOMM                                   |
| Reliable, datagram      | TCP      | RFCOMM or L2CAP with infinite retransmit |
| Best-effort, datagram   | UDP      | L2CAP (0-1279 ms retransmit)             |

### Notes

| [[1\]](x95.html#AEN109) | The L2CAP specification actually allows for both connectionless and connection-based channels, but connectionless channels are rarely used in practice. Since sending ``connectionless" data to a device requires joining its piconet, a time consuming process that is merely establishing a connection at a lower level, connectionless L2CAP channels afford no advantages over connection-oriented channels. |
| ----------------------- | ------------------------------------------------------------ |
| [[2\]](x95.html#AEN111) | The default maximum length is 672 bytes, but this can be negotiated up to 65535 bytes |
| [[3\]](x95.html#AEN113) | Asynchronous Connection-Less logical transport               |

## 2.4. Port numbers and the Service Discovery Protocol

The second part of figuring out how to communicate with a remote machine, once a numerical address and transport protocol are known, is to choose the port number. Almost all Internet transport protocols in common usage are designed with the notion of port numbers, so that multiple applications on the same host may simultaneously utilize a transport protocol. Bluetooth is no exception, but uses slightly different terminology. In L2CAP, ports are called *Protocol Service Multiplexers*, and can take on odd-numbered values between 1 and 32767. In RFCOMM, *channels* 1-30 are available for use. These differences aside, both protocol service multiplexers and channels serve the exact same purpose that ports do in TCP/IP. L2CAP, unlike RFCOMM, has a range of reserved port numbers (1-1023) that are not to be used for custom applications and protocols. This information is summarized in [Table 2-2](x148.html#port-numbers). Through the rest of this document, the word *port* is use in place of protocol service multiplexer and channel for clarity.



**Table 2-2. Port numbers and their terminology for various protocols**

| protocol | terminology | reserved/well-known ports | dynamically assigned ports |
| -------- | ----------- | ------------------------- | -------------------------- |
| TCP      | port        | 1-1024                    | 1025-65535                 |
| UDP      | port        | 1-1024                    | 1025-65535                 |
| RFCOMM   | channel     | none                      | 1-30                       |
| L2CAP    | PSM         | odd numbered 1-4095       | odd numbered 4097 - 32765  |

In Internet programming, server applications traditionally make use of well known port numbers that are chosen and agreed upon at design time. Client applications will use the same well known port number to connect to a server. The main disadvantage to this approach is that it is not possible to run two server applications which both use the same port number. Due to the relative youth of TCP/IP and the large number of available port numbers to choose from, this has not yet become a serious issue.

The Bluetooth transport protocols, however, were designed with many fewer available port numbers, which means we cannot choose an arbitrary port number at design time. Although this problem is not as significant for L2CAP, which has around 15,000 unreserved port numbers, RFCOMM has only 30 different port numbers. A consequence of this is that there is a greater than 50% chance of port number collision with just 7 server applications. In this case, the application designer clearly should not arbitrarily choose port numbers. The Bluetooth answer to this problem is the Service Discovery Protocol (SDP).

Instead of agreeing upon a port to use at application design time, the Bluetooth approach is to assign ports at runtime and follow a publish-subscribe model. The host machine operates a server application, called the SDP server, that uses one of the few L2CAP reserved port numbers. Other server applications are dynamically assigned port numbers at runtime and register a description of themselves and the services they provide (along with the port numbers they are assigned) with the SDP server. Client applications will then query the SDP server (using the well defined port number) on a particular machine to obtain the information they need.

This raises the question of how do clients know which description is the one they are looking for. The standard way of doing this in Bluetooth is to assign a 128-bit number, called the Universally Unique Identifier (UUID), at design time. Following a standard method [[1\]](#FTN.AEN189) of choosing this number guarantees choosing a UUID unique from those chosen by anyone else following the same method. Thus, a client and server application both designed with the same UUID can provide this number to the SDP server as a search term.

As with RFCOMM and L2CAP, only a small portion of SDP has been described here - those parts most relevant to a network programmer. Among the other ways SDP can be used are to describe which transport protocols a server is using, to give information such as a human-readable description of the service provided and who is providing it, and to search on fields other than the UUID such as the service name. Another point worth mentioning is that SDP is not even required to create a Bluetooth application. It is perfectly possible to revert to the TCP/IP way of assigning port numbers at design time and hoping to avoid port conflicts, and this might often be done to save some time. In controlled settings such as the computer science laboratory, this is quite reasonable. Ultimately, however, to create a portable application that will run in the greatest number of scenarios, the application should use dynamically assigned ports and SDP.

### Notes

| [[1\]](x148.html#AEN189) | RFC 4122 |
| ------------------------ | -------- |
|                          |          |

## 2.5. Establishing connections and transferring data

It turns out that choosing which machine to connect to and how to connect are the most difficult parts of Bluetooth programming. In writing a server application, once the transport protocol and port number to listen on are chosen, building the rest of the application is essentially the same type of programming most network programmers are already accustomed to. A server application waiting for an incoming Bluetooth connection is conceptually the same as a server application waiting for an incoming Internet connection, and a client application attempting to establish an outbound connection appears the same whether it is using RFCOMM, L2CAP, TCP, or UDP.

Furthermore, once the connection has been established, the application is operating with the same guarantees, constraints, and error conditions as are encountered in Internet programming. Depending on the transport protocol chosen, packets may be dropped or delayed. Connections may be severed due to host or link failures. External factors such as congestion and interference may result in decreased quality of service. Due to these conceptual similarities, it is perfectly reasonable to treat Bluetooth programming of an established connection in exactly the same manner that as an established connections in Internet programming.

## 2.6. Bluetooth Profiles + RFCs

Along with the simple TCP, IP, and UDP transport protocols used in Internet programming, there are a host of other protocols to specify, in great detail, methods to route data packets, exchange electronic mail, transfer files, load web pages, and more. Once standardized by the Internet Engineering Task Force in the form of Request For Comments (RFCs) [[1\]](#FTN.AEN199), these protocols are generally adopted by the wider Internet community. Similarly, Bluetooth also has a method for proposing, ratifying, and standardizing protocols and specifications that are eventually adopted by the Bluetooth community. The Bluetooth equivalent of an RFC is a Bluetooth Profile.

Due to the short-range nature of Bluetooth, the Bluetooth Profiles tend to be complementary to the Internet RFCs, with emphasis on tasks that can assume physical proximity. For example, there is a profile for exchanging physical location information [[2\]](#FTN.AEN203), a profile for printing to nearby printers [[3\]](#FTN.AEN205), and a profile for using nearby modems [[4\]](#FTN.AEN207) to make phone calls. There is even a specification for encapsulating TCP/IP traffic in a Bluetooth connection, which really does reduce Bluetooth programming to Internet programming. An overview of all the profiles available is beyond the scope of this chapter, but they are freely available for download at the Bluetooth website [[5\]](#FTN.AEN209)

### Notes

| [[1\]](x196.html#AEN199) | http://www.ietf.org/rfc.html  |
| ------------------------ | ----------------------------- |
| [[2\]](x196.html#AEN203) | Local Positioning Profile     |
| [[3\]](x196.html#AEN205) | Basic Printing Profile        |
| [[4\]](x196.html#AEN207) | Dial Up Networking Profile    |
| [[5\]](x196.html#AEN209) | http://www.bluetooth.org/spec |

# Chapter 4. Bluetooth programming in C with BlueZ

There are reasons to prefer developing Bluetooth applications in C instead of in a high level language such as Python. The Python environment might not be available or might not fit on the target device; strict application requirements on program size, speed, and memory usage may preclude the use of an interpreted language like Python; the programmer may desire finer control over the local Bluetooth adapter than PyBluez provides; or the project may be to create a shared library for other applications to link against instead of a standalone application. As of this writing, BlueZ is a powerful Bluetooth communications stack with extensive APIs that allows a user to fully exploit all local Bluetooth resources, but it has no official documentation. Furthermore, there is very little unofficial documentation as well. Novice developers requesting documentation on the official mailing lists [[1\]](#FTN.AEN407) are typically rebuffed and told to figure out the API by reading through the BlueZ source code. This is a time consuming process that can only reveal small pieces of information at a time, and is quite often enough of an obstacle to deter many potential developers.

This chapter presents a short introduction to developing Bluetooth applications in C with BlueZ. The tasks covered in chapter 2 are now explained in greater detail here for C programmers.

## 4.1. Choosing a communication partner

A simple program that detects nearby Bluetooth devices is shown in [Example 4-1](c404.html#simplescan.c). The program reserves system Bluetooth resources, scans for nearby Bluetooth devices, and then looks up the user friendly name for each detected device. A more detailed explanation of the data structures and functions used follows.



**Example 4-1. simplescan.c**

```
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>

int main(int argc, char **argv)
{
    inquiry_info *ii = NULL;
    int max_rsp, num_rsp;
    int dev_id, sock, len, flags;
    int i;
    char addr[19] = { 0 };
    char name[248] = { 0 };

    dev_id = hci_get_route(NULL);
    sock = hci_open_dev( dev_id );
    if (dev_id < 0 || sock < 0) {
        perror("opening socket");
        exit(1);
    }

    len  = 8;
    max_rsp = 255;
    flags = IREQ_CACHE_FLUSH;
    ii = (inquiry_info*)malloc(max_rsp * sizeof(inquiry_info));
    
    num_rsp = hci_inquiry(dev_id, len, max_rsp, NULL, &ii, flags);
    if( num_rsp < 0 ) perror("hci_inquiry");

    for (i = 0; i < num_rsp; i++) {
        ba2str(&(ii+i)->bdaddr, addr);
        memset(name, 0, sizeof(name));
        if (hci_read_remote_name(sock, &(ii+i)->bdaddr, sizeof(name), 
            name, 0) < 0)
        strcpy(name, "[unknown]");
        printf("%s  %s\n", addr, name);
    }

    free( ii );
    close( sock );
    return 0;
}
```

### 4.1.1. Compilation

To compile our program, invoke `gcc` and link against `libbluetooth`

```
# gcc -o simplescan simplescan.c -lbluetooth
```

### 4.1.2. Explanation



```
typedef struct {
	uint8_t b[6];
} __attribute__((packed)) bdaddr_t;
```



The basic data structure used to specify a Bluetooth device address is the `bdaddr_t`. All Bluetooth addresses in BlueZ will be stored and manipulated as `bdaddr_t` structures. BlueZ provides two convenience functions to convert between strings and `bdaddr_t` structures.



```
int str2ba( const char *str, bdaddr_t *ba );
int ba2str( const bdaddr_t *ba, char *str );
```



`str2ba` takes an string of the form ``XX:XX:XX:XX:XX:XX", where each XX is a hexadecimal number specifying an octet of the 48-bit address, and packs it into a 6-byte `bdaddr_t`. `ba2str` does exactly the opposite.

Local Bluetooth adapters are assigned identifying numbers starting with 0, and a program must specify which adapter to use when allocating system resources. Usually, there is only one adapter or it doesn't matter which one is used, so passing `NULL` to `hci_get_route` will retrieve the resource number of the first available Bluetooth adapter.

```
int hci_get_route( bdaddr_t *bdaddr );
int hci_open_dev( int dev_id );
```



| ![Note](../../../../images/note.gif) | It is *not* a good idea to hard-code the device number 0, because that is not always the id of the first adapter. For example, if there were two adapters on the system and the first adapter (id 0) is disabled, then the first *available* adapter is the one with id 1. |
| ------------------------------------ | ------------------------------------------------------------ |
|                                      |                                                              |

If there are multiple Bluetooth adapters present, then to choose the adapter with address ``01:23:45:67:89:AB", pass the `char *` representation of the address to `hci_devid` and use that in place of `hci_get_route`.

```
int dev_id = hci_devid( "01:23:45:67:89:AB" );
```

Most Bluetooth operations require the use of an open socket. `hci_open_dev` is a convenience function that opens a Bluetooth socket with the specified resource number [[2\]](#FTN.AEN454). To be clear, the socket opened by `hci_open_dev` represents a connection to the microcontroller on the specified local Bluetooth adapter, and not a connection to a remote Bluetooth device. Performing low level Bluetooth operations involves sending commands directly to the microcontroller with this socket, and [Section 4.5](x682.html) discusses this in greater detail.

After choosing the local Bluetooth adapter to use and allocating system resources, the program is ready to scan for nearby Bluetooth devices. In the example, `hci_inquiry` performs a Bluetooth device discovery and returns a list of detected devices and some basic information about them in the variable `ii`. On error, it returns -1 and sets `errno` accordingly.

```
int hci_inquiry(int dev_id, int len, int max_rsp, const uint8_t *lap, 
                inquiry_info **ii, long flags);
```

`hci_inquiry` is one of the few functions that requires the use of a resource number instead of an open socket, so we use the `dev_id` returned by `hci_get_route`. The inquiry lasts for at most 1.28 * `len` seconds, and at most `max_rsp` devices will be returned in the output parameter `ii`, which must be large enough to accommodate `max_rsp` results. We suggest using a `max_rsp` of 255 for a standard 10.24 second inquiry.

If `flags` is set to `IREQ_CACHE_FLUSH`, then the cache of previously detected devices is flushed before performing the current inquiry. Otherwise, if `flags` is set to 0, then the results of previous inquiries may be returned, even if the devices aren't in range anymore.

The `inquiry_info` structure is defined as

```
typedef struct {
    bdaddr_t    bdaddr;
    uint8_t     pscan_rep_mode;
    uint8_t     pscan_period_mode;
    uint8_t     pscan_mode;
    uint8_t     dev_class[3];
    uint16_t    clock_offset;
} __attribute__ ((packed)) inquiry_info;
```



For the most part, only the first entry - the `bdaddr` field, which gives the address of the detected device - is of any use. Occasionally, there may be a use for the `dev_class` field, which gives information about the type of device detected (i.e. if it's a printer, phone, desktop computer, etc.) and is described in the Bluetooth Assigned Numbers [[3\]](#FTN.AEN484). The rest of the fields are used for low level communication, and are not useful for most purposes. The interested reader can see the Bluetooth Core Specification [[4\]](#FTN.AEN487) for more details.

Once a list of nearby Bluetooth devices and their addresses has been found, the program determines the user-friendly names associated with those addresses and presents them to the user. The `hci_read_remote_name` function is used for this purpose.

```
int hci_read_remote_name(int sock, const bdaddr_t *ba, int len, 
                         char *name, int timeout)
```

`hci_read_remote_name` tries for at most `timeout` milliseconds to use the socket `sock` to query the user-friendly name of the device with Bluetooth address `ba`. On success, `hci_read_remote_name` returns 0 and copies at most the first `len` bytes of the device's user-friendly name into `name`. On failure, it returns -1 and sets `errno` accordingly.

### Notes

| [[1\]](c404.html#AEN407) | http://www.bluez.org/lists.html                              |
| ------------------------ | ------------------------------------------------------------ |
| [[2\]](c404.html#AEN454) | for the curious, it makes a call to `socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI)`, followed by a call to `bind` with the specified resource number. |
| [[3\]](c404.html#AEN484) | https://www.bluetooth.org/foundry/assignnumb/document/baseband |
| [[4\]](c404.html#AEN487) | http://www.bluetooth.org/spec                                |

## 4.2. RFCOMM sockets

As with Python, establishing and using RFCOMM connections boils down to the same socket programming techniques we already know how to use for TCP/IP programming. The only difference is that the socket addressing structures are different, and we use different functions for byte ordering of multibyte integers. [Example 4-2](x502.html#rfcomm-server.c) and [Example 4-3](x502.html#rfcomm-client.c) show how to establish a connection using an RFCOMM socket, transfer some data, and disconnect. For simplicity, the client is hard-coded to connect to ``01:23:45:67:89:AB".



**Example 4-2. rfcomm-server.c**

```
#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/rfcomm.h>

int main(int argc, char **argv)
{
    struct sockaddr_rc loc_addr = { 0 }, rem_addr = { 0 };
    char buf[1024] = { 0 };
    int s, client, bytes_read;
    socklen_t opt = sizeof(rem_addr);

    // allocate socket
    s = socket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);

    // bind socket to port 1 of the first available 
    // local bluetooth adapter
    loc_addr.rc_family = AF_BLUETOOTH;
    loc_addr.rc_bdaddr = *BDADDR_ANY;
    loc_addr.rc_channel = (uint8_t) 1;
    bind(s, (struct sockaddr *)&loc_addr, sizeof(loc_addr));

    // put socket into listening mode
    listen(s, 1);

    // accept one connection
    client = accept(s, (struct sockaddr *)&rem_addr, &opt);

    ba2str( &rem_addr.rc_bdaddr, buf );
    fprintf(stderr, "accepted connection from %s\n", buf);
    memset(buf, 0, sizeof(buf));

    // read data from the client
    bytes_read = read(client, buf, sizeof(buf));
    if( bytes_read > 0 ) {
        printf("received [%s]\n", buf);
    }

    // close connection
    close(client);
    close(s);
    return 0;
}
```



**Example 4-3. rfcomm-client.c**

```
#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/rfcomm.h>

int main(int argc, char **argv)
{
    struct sockaddr_rc addr = { 0 };
    int s, status;
    char dest[18] = "01:23:45:67:89:AB";

    // allocate a socket
    s = socket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);

    // set the connection parameters (who to connect to)
    addr.rc_family = AF_BLUETOOTH;
    addr.rc_channel = (uint8_t) 1;
    str2ba( dest, &addr.rc_bdaddr );

    // connect to server
    status = connect(s, (struct sockaddr *)&addr, sizeof(addr));

    // send a message
    if( status == 0 ) {
        status = write(s, "hello!", 6);
    }

    if( status < 0 ) perror("uh oh");

    close(s);
    return 0;
}
```

Most of this should look familiar to the experienced network programmer. As with Internet programming, first allocate a socket with the `socket` system call. Instead of `AF_INET`, use `AF_BLUETOOTH`, and instead of `IPPROTO_TCP`, use `BTPROTO_RFCOMM`. Since RFCOMM provides the same delivery semantics as TCP, `SOCK_STREAM` can still be used for the socket type.

### 4.2.1. Addressing structures

To establish an RFCOMM connection with another Bluetooth device, incoming or outgoing, create and fill out a `struct sockaddr_rc` addressing structure. Like the `struct sockaddr_in` that is used in TCP/IP, the addressing structure specifies the details of an outgoing connection or listening socket.

```
struct sockaddr_rc {
	sa_family_t	rc_family;
	bdaddr_t	rc_bdaddr;
	uint8_t		rc_channel;
};
```

The `rc_family` field specifies the addressing family of the socket, and will always be `AF_BLUETOOTH`. For an outgoing connection, `rc_bdaddr` and `rc_channel` specify the Bluetooth address and port number to connect to, respectively. For a listening socket, `rc_bdaddr` specifies the local Bluetooth adapter to use, and is typically set to `BDADDR_ANY` to indicate that any local Bluetooth adapter is acceptable. For listening sockets, `rc_channel` specifies the port number to listen on.

### 4.2.2. A note on byte ordering

Since Bluetooth deals with the transfer of data from one machine to another, the use of a consistent byte ordering for multi-byte data types is crucial. Unlike network byte ordering, which uses a big-endian format, Bluetooth byte ordering is little-endian, where the least significant bytes are transmitted first. BlueZ provides four convenience functions to convert between host and Bluetooth byte orderings.

```
unsigned short int htobs( unsigned short int num );
unsigned short int btohs( unsigned short int num );
unsigned int htobl( unsigned int num );
unsigned int btohl( unsigned int num );
```

Like their network order counterparts, these functions convert 16 and 32 bit unsigned integers to Bluetooth byte order and back. They are used when filling in the socket addressing structures, communicating with the Bluetooth microcontroller, and when performing low level operations on transport protocol sockets.

### 4.2.3. Dynamically assigned port numbers

For Linux kernel versions 2.6.7 and greater, dynamically binding to an RFCOMM or L2CAP port is simple. The `rc_channel` field of the socket addressing structure used to bind the socket is simply set to 0, and the kernel binds the socket to the first available port. Unfortunately, for earlier versions of the Linux kernel, the only way to bind to the first available port number is to try binding to *every* possible port and stopping when `bind` doesn't fail. The following function illustrates how to do this for RFCOMM sockets.

```
int dynamic_bind_rc(int sock, struct sockaddr_rc *sockaddr, uint8_t *port)
{
    int err;
    for( *port = 1; *port <= 31; *port++ ) {
        sockaddr->rc_channel = *port;
        err = bind(sock, (struct sockaddr *)sockaddr, sizeof(sockaddr));
        if( ! err || errno == EINVAL ) break;
    }
    if( port == 31 ) {
        err = -1;
        errno = EINVAL;
    }
    return err;
}
```

The process for L2CAP sockets is similar, but tries odd-numbered ports 4097-32767 (0x1001 - 0x7FFF) instead of ports 1-30.

### 4.2.4. RFCOMM summary

Advanced TCP options that are often set with `setsockopt`, such as receive windows and the Nagle algorithm, don't make sense in Bluetooth, and can't be used with RFCOMM sockets. Aside from this, the byte ordering, and socket addressing structure differences, programming RFCOMM sockets is virtually identical to programming TCP sockets. To accept incoming connections with a socket, use `bind` to reserve operating system resource, `listen` to put it in listening mode, and `accept` to block and accept an incoming connection. Creating an outgoing connection is also simple and merely involves a call to `connect`. Once a connection has been established, the standard calls to `read`, `write`, `send`, and `recv` can be used for data transfer.

## 4.3. L2CAP sockets

As with RFCOMM, L2CAP communications are structured around socket programming. [Example 4-4](x559.html#l2cap-server.c) and [Example 4-5](x559.html#l2cap-client.c) demonstrate how to establish an L2CAP channel and transmit a short string of data. For simplicity, the client is hard-coded to connect to ``01:23:45:67:89:AB".



**Example 4-4. l2cap-server.c**

```
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/l2cap.h>

int main(int argc, char **argv)
{
    struct sockaddr_l2 loc_addr = { 0 }, rem_addr = { 0 };
    char buf[1024] = { 0 };
    int s, client, bytes_read;
    socklen_t opt = sizeof(rem_addr);

    // allocate socket
    s = socket(AF_BLUETOOTH, SOCK_SEQPACKET, BTPROTO_L2CAP);

    // bind socket to port 0x1001 of the first available 
    // bluetooth adapter
    loc_addr.l2_family = AF_BLUETOOTH;
    loc_addr.l2_bdaddr = *BDADDR_ANY;
    loc_addr.l2_psm = htobs(0x1001);

    bind(s, (struct sockaddr *)&loc_addr, sizeof(loc_addr));

    // put socket into listening mode
    listen(s, 1);

    // accept one connection
    client = accept(s, (struct sockaddr *)&rem_addr, &opt);

    ba2str( &rem_addr.l2_bdaddr, buf );
    fprintf(stderr, "accepted connection from %s\n", buf);

    memset(buf, 0, sizeof(buf));

    // read data from the client
    bytes_read = read(client, buf, sizeof(buf));
    if( bytes_read > 0 ) {
        printf("received [%s]\n", buf);
    }

    // close connection
    close(client);
    close(s);
}
```



**Example 4-5. l2cap-client.c**

```
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/l2cap.h>

int main(int argc, char **argv)
{
    struct sockaddr_l2 addr = { 0 };
    int s, status;
    char *message = "hello!";
    char dest[18] = "01:23:45:67:89:AB";

    if(argc < 2)
    {
        fprintf(stderr, "usage: %s <bt_addr>\n", argv[0]);
        exit(2);
    }

    strncpy(dest, argv[1], 18);

    // allocate a socket
    s = socket(AF_BLUETOOTH, SOCK_SEQPACKET, BTPROTO_L2CAP);

    // set the connection parameters (who to connect to)
    addr.l2_family = AF_BLUETOOTH;
    addr.l2_psm = htobs(0x1001);
    str2ba( dest, &addr.l2_bdaddr );

    // connect to server
    status = connect(s, (struct sockaddr *)&addr, sizeof(addr));

    // send a message
    if( status == 0 ) {
        status = write(s, "hello!", 6);
    }

    if( status < 0 ) perror("uh oh");

    close(s);
}
```

For simple usage scenarios, the only differences are the socket type specified, the protocol family, and the addressing structure. By default, L2CAP connections provide reliable datagram-oriented connections with packets delivered in order, so the socket type is `SOCK_SEQPACKET`, and the protocol is `BTPROTO_L2CAP`. The addressing structure `struct sockaddr_l2` differs slightly from the RFCOMM addressing structure.

```
struct sockaddr_l2 {
    sa_family_t     l2_family;
    unsigned short  l2_psm;
    bdaddr_t        l2_bdaddr;
};
```

The `l2_psm` field specifies the L2CAP port number to use. Since it is a multibyte unsigned integer, byte ordering is significant. The `htobs` function, described earlier, is used here to convert numbers to Bluetooth byte order.

### 4.3.1. Maximum Transmission Unit

Occasionally, an application may need to adjust the maximum transmission unit (MTU) for an L2CAP connection and set it to something other than the default of 672 bytes. In BlueZ, this is done with the `getsockopt` and `setsockopt` functions.

```
struct l2cap_options {
    uint16_t    omtu;
    uint16_t    imtu;
    uint16_t    flush_to;
    uint8_t     mode;
};

int set_l2cap_mtu( int sock, uint16_t mtu ) {
	struct l2cap_options opts;
    int optlen = sizeof(opts), err;
    err = getsockopt( s, SOL_L2CAP, L2CAP_OPTIONS, &opts, &optlen );
    if( ! err ) {
        opts.omtu = opts.imtu = mtu;
        err = setsockopt( s, SOL_L2CAP, L2CAP_OPTIONS, &opts, optlen );
    }
    return err;
};
```

The `omtu` and `imtu` fields of the `struct l2cap_options` are used to specify the *outgoing MTU* and *incoming MTU*, respectively. The other two fields are currently unused and reserved for future use. To adjust the connection-wide MTU, both clients must adjust their outgoing and incoming MTUs. Bluetooth allows the MTU to range from a minimum of 48 bytes to a maximum of 65,535 bytes.

### 4.3.2. Unreliable sockets

It is slightly misleading to say that L2CAP sockets are reliable by default. Multiple L2CAP and RFCOMM connections between two devices are actually logical connections multiplexed on a single, lower level connection [[1\]](#FTN.AEN593) established between them. The only way to adjust delivery semantics is to adjust them for the lower level connection, which in turn affects *all* L2CAP and RFCOMM connections between the two devices.

As we delve deeper into the more complex aspects of Bluetooth programming, the interface becomes a little harder to manage. Unfortunately, BlueZ does not provide an easy way to change the packet timeout for a connection. A handle to the underlying connection is first needed to make this change, but the only way to obtain a handle to the underlying connection is to query the microcontroller on the local Bluetooth adapter. Once the connection handle has been determined, a command can be issued to the microcontroller instructing it to make the appropriate adjustments. [Example 4-6](x559.html#set-flush-to.c) shows how to do this.



**Example 4-6. set-flush-to.c**

```
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>

int set_flush_timeout(bdaddr_t *ba, int timeout)
{
    int err = 0, dd;
    struct hci_conn_info_req *cr = 0;
    struct hci_request rq = { 0 };

    struct {
        uint16_t handle;
        uint16_t flush_timeout;
    } cmd_param;

    struct {
        uint8_t  status;
        uint16_t handle;
    } cmd_response;

    // find the connection handle to the specified bluetooth device
    cr = (struct hci_conn_info_req*) malloc(
            sizeof(struct hci_conn_info_req) + 
            sizeof(struct hci_conn_info));
    bacpy( &cr->bdaddr, ba );
    cr->type = ACL_LINK;
    dd = hci_open_dev( hci_get_route( &cr->bdaddr ) );
    if( dd < 0 ) {
        err = dd;
        goto cleanup;
    }
    err = ioctl(dd, HCIGETCONNINFO, (unsigned long) cr );
    if( err ) goto cleanup;

    // build a command packet to send to the bluetooth microcontroller
    cmd_param.handle = cr->conn_info->handle;
    cmd_param.flush_timeout = htobs(timeout);
    rq.ogf = OGF_HOST_CTL;
    rq.ocf = 0x28;
    rq.cparam = &cmd_param;
    rq.clen = sizeof(cmd_param);
    rq.rparam = &cmd_response;
    rq.rlen = sizeof(cmd_response);
    rq.event = EVT_CMD_COMPLETE;

    // send the command and wait for the response
    err = hci_send_req( dd, &rq, 0 );
    if( err ) goto cleanup;

    if( cmd_response.status ) {
        err = -1;
        errno = bt_error(cmd_response.status);
    }

cleanup:
    free(cr);
    if( dd >= 0) close(dd);
    return err;
}
```

On success, the packet timeout for the low level connection to the specified device is set to `timeout * 0.625` milliseconds. A timeout of 0 is used to indicate infinity, and is how to revert back to a reliable connection. The bulk of this function is comprised of code to construct the command packets and response packets used in communicating with the Bluetooth controller. The Bluetooth Specification defines the structure of these packets and the magic number `0x28`. In most cases, BlueZ provides convenience functions to construct the packets, send them, and wait for the response. Setting the packet timeout, however, seems to be so rarely used that no convenience function for it currently exists.

### Notes

| [[1\]](x559.html#AEN593) | Bluetooth terminology refers to this as the ACL connection |
| ------------------------ | ---------------------------------------------------------- |
|                          |                                                            |

## 4.4. Service Discovery Protocol

The process of searching for services involves two steps - detecting all nearby devices with a device inquiry, and connecting to each of those devices in turn to search for the desired service. Despite Bluetooth's piconet abilities, the early versions don't support multicasting queries, so this must be done the slow way. Since detecting nearby devices was covered in [Section 4.1](c404.html#bzi-choosing), only the second step is described here.

Searching a specific device for a service also involves two steps. The first part, shown in [Example 4-7](x604.html#sdpsearch1), requires connecting to the device and sending the search request. The second part, shown in in [Example 4-8](x604.html#sdpsearch2), involves parsing and interpreting the search results.



**Example 4-7. Step one of searching a device for a service with UUID 0xABCD**

```
#include <bluetooth/bluetooth.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>

int main(int argc, char **argv)
{
    uint8_t svc_uuid_int[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0xab, 0xcd };
    uuid_t svc_uuid;
    int err;
    bdaddr_t target;
    sdp_list_t *response_list = NULL, *search_list, *attrid_list;
    sdp_session_t *session = 0;

    str2ba( "01:23:45:67:89:AB", &target );

    // connect to the SDP server running on the remote machine
    session = sdp_connect( BDADDR_ANY, &target, SDP_RETRY_IF_BUSY );

    // specify the UUID of the application we're searching for
    sdp_uuid128_create( &svc_uuid, &svc_uuid_int );
    search_list = sdp_list_append( NULL, &svc_uuid );

    // specify that we want a list of all the matching applications' attributes
    uint32_t range = 0x0000ffff;
    attrid_list = sdp_list_append( NULL, &range );

    // get a list of service records that have UUID 0xabcd
    err = sdp_service_search_attr_req( session, search_list, \
            SDP_ATTR_REQ_RANGE, attrid_list, &response_list);
    .
    .
```

The `uuid_t` data type is used to represent the 128-bit UUID that identifies the desired service. To obtain a valid `uuid_t`, create an array of 16 8-bit integers and use the `sdp_uuid128_create` function, which is similar to the `str2ba` function for converting strings to `bdaddr_t` types. `sdp_connect` synchronously connects to the SDP server running on the target device. `sdp_service_search_attr_req` searches the connected device for the desired service and requests a list of attributes specified by `attrid_list`. It's easiest to use the magic number `0x0000ffff` to request a list of all the attributes describing the service, although it is possible, for example, to request only the name of a matching service and not its protocol information.

Continuing our example, we now get to the tricky part - parsing and interpreting the results of a search. Unfortunately, there isn't an easy way to do this. Taking the result of our search above, [Example 4-8](x604.html#sdpsearch2) shows how to extract the RFCOMM channel of a matching result.



**Example 4-8. parsing and interpreting an SDP search result**

```
    sdp_list_t *r = response_list;

    // go through each of the service records
    for (; r; r = r->next ) {
        sdp_record_t *rec = (sdp_record_t*) r->data;
        sdp_list_t *proto_list;
        
        // get a list of the protocol sequences
        if( sdp_get_access_protos( rec, &proto_list ) == 0 ) {
        sdp_list_t *p = proto_list;

        // go through each protocol sequence
        for( ; p ; p = p->next ) {
            sdp_list_t *pds = (sdp_list_t*)p->data;

            // go through each protocol list of the protocol sequence
            for( ; pds ; pds = pds->next ) {

                // check the protocol attributes
                sdp_data_t *d = (sdp_data_t*)pds->data;
                int proto = 0;
                for( ; d; d = d->next ) {
                    switch( d->dtd ) { 
                        case SDP_UUID16:
                        case SDP_UUID32:
                        case SDP_UUID128:
                            proto = sdp_uuid_to_proto( &d->val.uuid );
                            break;
                        case SDP_UINT8:
                            if( proto == RFCOMM_UUID ) {
                                printf("rfcomm channel: %d\n",d->val.int8);
                            }
                            break;
                    }
                }
            }
            sdp_list_free( (sdp_list_t*)p->data, 0 );
        }
        sdp_list_free( proto_list, 0 );

        }

        printf("found service record 0x%x\n", rec->handle);
        sdp_record_free( rec );
    }

    sdp_close(session);
}
```

Getting the protocol information requires digging deep into the search results. Since it's possible for multiple application services to match a single search request, a list of *service records* is used to describe each matching service. For each service that's running, it's (theoretically, but not usually done in practice) possible to have different ways of connecting to the service. So each service record has a list of *protocol sequences* that each describe a different way to connect. Furthermore, since protocols can be built on top of other protocols (e.g. RFCOMM uses L2CAP as a transport), each protocol sequence has a list of *protocols* that the application uses, only one of which actually matters. Finally, each protocol entry will have a list of *attributes*, like the protocol type and the port number it's running on. Thus, obtaining the port number for an application that uses RFCOMM requires finding the port number protocol attribute in the RFCOMM protocol entry.

In this example, several new data structures have been introduced that we haven't seen before.

```
typedef struct _sdp_list_t {
    struct _sdp_list_t *next;
    void *data;
} sdp_list_t;

typedef void(*sdp_free_func_t)(void *)

sdp_list_t *sdp_list_append(sdp_list_t *list, void *d);
sdp_list_t *sdp_list_free(sdp_list_t *list, sdp_list_func_t f);
```

Since C does not have a built in linked-list data structure, and SDP search criteria and search results are essentially nothing but lists of data, the BlueZ developers wrote their own linked list data structure and called it `sdp_list_t`. For now, it suffices to know that appending to a `NULL` list creates a new linked list, and that a list must be deallocated with `sdp_list_free` when it is no longer needed.

```
typedef struct {
	uint32_t handle;
	sdp_list_t *pattern;
	sdp_list_t *attrlist;
} sdp_record_t;
```

The `sdp_record_t` data structure represents a single service record being advertised by another device. Its inner details aren't important, as there are a number of helper functions available to get information in and out of it. In this example, `sdp_get_access_protos` is used to extract a list of the protocols for the service record.

```
typedef struct sdp_data_struct sdp_data_t;
struct sdp_data_struct {
	uint8_t dtd;
	uint16_t attrId;
	union {
		int8_t    int8;
		int16_t   int16;
		int32_t   int32;
		int64_t   int64;
		uint128_t int128;
		uint8_t   uint8;
		uint16_t  uint16;
		uint32_t  uint32;
		uint64_t  uint64;
		uint128_t uint128;
		uuid_t    uuid;
		char     *str;
		sdp_data_t *dataseq;
	} val;
	sdp_data_t *next;
	int unitSize;
};
```

Finally, there is the `sdp_data_t` structure, which is ultimately used to store each element of information in a service record. At a high level, it is a node of a linked list that carries a piece of data (the `val` field). As a variable type data structure, it can be used in different ways, depending on the context. For now, it's sufficient to know that each protocol stack in the list of protocol sequences is represented as a singly linked list of `sdp_data_t` structures, and extracting the protocol and port information requires iterating through this list until the proper elements are found. The type of a `sdp_data_t` is specified by the `dtd` field, which is what we use to search the list.

### 4.4.1. `sdpd` - The SDP daemon

Every Bluetooth device typically runs an SDP server that answers queries from other Bluetooth devices. In BlueZ, the implementation of the SDP server is called `sdpd`, and is usually started by the system boot scripts. `sdpd` handles all incoming SDP search requests. Applications that need to advertise a Bluetooth service must use inter-process communication (IPC) methods to tell `sdpd` what to advertise. Currently, this is done with the named pipe `/var/run/sdp`. BlueZ provides convenience functions written to make this process a little easier.

Registering a service with `sdpd` involves describing the service to advertise, connected to `sdpd`, instructing `sdpd` on what to advertise, and then disconnecting.

### 4.4.2. Describing a service

Describing a service is essentially building the service record that was parsed in the previous examples. This involves creating several lists and populating them with data attributes. [Example 4-9](x604.html#sdpdesc) shows how to describe a service application with UUID `0xABCD` that runs on RFCOMM channel 11, is named ``Roto-Rooter Data Router", provided by ``Roto-Rooter", and has the description ``An experimental plumbing router"



**Example 4-9. Describing a service**

```
#include <bluetooth/bluetooth.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>

sdp_session_t *register_service()
{
    uint32_t service_uuid_int[] = { 0, 0, 0, 0xABCD };
    uint8_t rfcomm_channel = 11;
    const char *service_name = "Roto-Rooter Data Router";
    const char *service_dsc = "An experimental plumbing router";
    const char *service_prov = "Roto-Rooter";

    uuid_t root_uuid, l2cap_uuid, rfcomm_uuid, svc_uuid;
    sdp_list_t *l2cap_list = 0, 
               *rfcomm_list = 0,
               *root_list = 0,
               *proto_list = 0, 
               *access_proto_list = 0;
    sdp_data_t *channel = 0, *psm = 0;

    sdp_record_t *record = sdp_record_alloc();

    // set the general service ID
    sdp_uuid128_create( &svc_uuid, &service_uuid_int );
    sdp_set_service_id( record, svc_uuid );

    // make the service record publicly browsable
    sdp_uuid16_create(&root_uuid, PUBLIC_BROWSE_GROUP);
    root_list = sdp_list_append(0, &root_uuid);
    sdp_set_browse_groups( record, root_list );

    // set l2cap information
    sdp_uuid16_create(&l2cap_uuid, L2CAP_UUID);
    l2cap_list = sdp_list_append( 0, &l2cap_uuid );
    proto_list = sdp_list_append( 0, l2cap_list );

    // set rfcomm information
    sdp_uuid16_create(&rfcomm_uuid, RFCOMM_UUID);
    channel = sdp_data_alloc(SDP_UINT8, &rfcomm_channel);
    rfcomm_list = sdp_list_append( 0, &rfcomm_uuid );
    sdp_list_append( rfcomm_list, channel );
    sdp_list_append( proto_list, rfcomm_list );

    // attach protocol information to service record
    access_proto_list = sdp_list_append( 0, proto_list );
    sdp_set_access_protos( record, access_proto_list );

    // set the name, provider, and description
    sdp_set_info_attr(record, service_name, service_prov, service_dsc);
    .
    .
```

### 4.4.3. Registering a service

Building the description is quite straightforward, and consists of taking those five fields and packing them into data structures. Most of the work is just putting lists together. Once the service record is complete, the application connects to the local SDP server and registers a new service, taking care afterwards to free the data structures allocated earlier.

```
    .
    .
    int err = 0;
    sdp_session_t *session = 0;

    // connect to the local SDP server, register the service record, and 
    // disconnect
    session = sdp_connect( BDADDR_ANY, BDADDR_LOCAL, SDP_RETRY_IF_BUSY );
    err = sdp_record_register(session, record, 0);

    // cleanup
    sdp_data_free( channel );
    sdp_list_free( l2cap_list, 0 );
    sdp_list_free( rfcomm_list, 0 );
    sdp_list_free( root_list, 0 );
    sdp_list_free( access_proto_list, 0 );

    return session;
}
```

The special argument `BDADDR_LOCAL` causes `sdp_connect` to connect to the local SDP server (via the named pipe `/var/run/sdp`) instead of a remote device. Once an active session is established with the local SDP server, `sdp_record_register` advertises a service record. The service will be advertised for as long as the session with the SDP server is kept open. As soon as the SDP server detects that the socket connection is closed, it will stop advertising the service. `sdp_close` terminates a session with the SDP server.

```
sdp_session_t *sdp_connect( const bdaddr_t *src, const bdaddr_t *dst, uint32_t
        flags );
int sdp_close( sdp_session_t *session );

int sdp_record_register(sdp_session_t *sess, sdp_record_t *rec, uint8_t flags);
```

## 4.5. Advanced BlueZ programming

In addition to the L2CAP and RFCOMM sockets described in this chapter, BlueZ provides a number of other socket types. The most useful of these is the Host Controller Interface (HCI) socket, which provides a direct connection to the microcontroller on the local Bluetooth adapter. This socket type, introduced in section [Section 4.1](c404.html#bzi-choosing), can be used to issue arbitrary commands to the Bluetooth adapter. Programmers requiring precise control over the Bluetooth controller to perform tasks such as asynchronous device discovery or reading signal strength information should use HCI sockets.

The Bluetooth Core Specification describes communication with a Bluetooth microcontroller in great detail, which we summarize here. The host computer can send commands to the microcontroller, and the microcontroller generates events to indicate command responses and other status changes. A command consists of a Opcode Group Field that specifies the general category the command falls into, an Opcode Command Field that specifies the actual command, and a series of command parameters. In BlueZ, `hci_send_cmd` is used to transmit a command to the microcontroller.

```
int hci_send_cmd(int sock, uint16_t ogf, uint16_t ocf, uint8_t plen, 
                 void *param);
```

Here, `sock` is an open HCI socket, `ogf` is the Opcode Group Field, `ocf` is the Opcode Command Field, and `plen` specifies the length of the command parameters `param`.

Calling `read` on an open HCI socket waits for and receives the next event from the microcontroller. An event consists of a header field specifying the event type, and the event parameters. A program that requires asynchronous device detection would, for example, send a command with `ocf` of `OCF_INQUIRY` and wait for events of type `EVT_INQUIRY_RESULT` and `EVT_INQUIRY_COMPLETE`. The specific codes to use for each command and event are defined in the specifications and in the BlueZ source code.

## 4.6. Chapter Summary

This chapter has provided an introduction to Bluetooth programming with BlueZ. The concepts covered in chapter 2 were presented here in greater detail with examples on how to implement them in BlueZ. Many other useful aspects of BlueZ were left out for brevity. Specifically, the command line tools and utilities that are distributed with BlueZ, such as `hciconfig`, `hcitool`, `sdptool`, and `hcidump`, are not described here. These utilities, which are invaluable to a serious Bluetooth developer, are already well documented. Only the simplest aspects of using the Service Discovery Protocol were covered - just enough to search for and advertise services. Additionally, other socket types such as `BTPROTO_SCO` and `BTPROTO_BNEP` were left out, as they are not crucial to forming a working knowledge of programming with BlueZ. Unfortunately, as of now there is no official API reference to refer to, so more curious readers are advised to download and examine the BlueZ source code [[1\]](#FTN.AEN710).

### Notes

| [[1\]](x701.html#AEN710) | available at http://www.bluez.org |
| ------------------------ | --------------------------------- |
|                          |                                   |