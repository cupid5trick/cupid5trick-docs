---
title: Untitled
author: cupid5trick
created: -1
tags: 
categories: 
access: private
draft: true
lang:
- zh-cn
- en-us
abstract:
keywords:
---

# IANA

[Number Resources](https://www.iana.org/numbers): <https://www.iana.org/numbers>

（IANA）负责互联网协议寻址系统的全球协调，以及用于互联网流量路由的自治系统号码。

目前，有两种类型的互联网协议（IP）地址在积极使用：IP版本4（IPv4）和IP版本6（IPv6）。IPv4最初于1983年1月1日部署，现在仍然是最常用的版本。IPv4地址是32位数字，通常以 "点十进制 "符号表示为4个八位数（例如，192.0.2.53）。IPv6协议的部署开始于1999年。IPv6地址是128位数字，习惯上用十六进制字符串表示（例如，2001:0db8:582:ae33::29）。

IPv4和IPv6地址通常都是以分层方式分配的。用户由互联网服务提供商（ISP）分配IP地址。ISP从本地互联网注册处（LIR）或国家互联网注册处（NIR），或从其适当的区域互联网注册处（RIR）获得IP地址的分配。

| Registry                           | Area Covered                              |
| ---------------------------------- | ----------------------------------------- |
| [AFRINIC](http://www.afrinic.net/) | Africa Region                             |
| [APNIC](http://www.apnic.net/)     | Asia/Pacific Region                       |
| [ARIN](http://www.arin.net/)       | Canada, USA, and some Caribbean Islands   |
| [LACNIC](http://www.lacnic.net/)   | Latin America and some Caribbean Islands  |
| [RIPE NCC](http://www.ripe.net/)   | Europe, the Middle East, and Central Asia |

![](image-20230603164657023.png)

我们在IP地址方面的主要作用是根据全球政策所描述的需求，将未分配的地址池分配给RIRs，并记录IETF的协议分配。当一个区域注册机构在其区域内需要更多的IP地址进行分配或指派时，我们会向该区域注册机构进行额外的分配。我们不直接向ISP或终端用户进行分配，除非在特殊情况下，如分配组播地址或其他协议的具体需求。

# 区域性区域互联网注册处（RIR）

[routes - Where to get full list of registered ASN (autonomous system number)? - Stack Overflow](https://stackoverflow.com/questions/57620307/where-to-get-full-list-of-registered-asn-autonomous-system-number): <https://stackoverflow.com/questions/57620307/where-to-get-full-list-of-registered-asn-autonomous-system-number>

TLDR; Officially assigned ASNs are listed in

[https://ftp.ripe.net/pub/stats/ripencc/nro-stats/latest/nro-delegated-stats](https://ftp.ripe.net/pub/stats/ripencc/nro-stats/latest/nro-delegated-stats)

There is no such thing as universally official AS names; one of the attempts to provide AS names is published at

[https://ftp.ripe.net/ripe/asnames/asn.txt](https://ftp.ripe.net/ripe/asnames/asn.txt)

(but these aren't "names of their owners") /TLDR;

The lists of officially assigned AS numbers are published by each of the RIRs on their ftp/websites, the canonical URLs are like this:

```
ftp://ftp.<rir>.net/pub/stats/<rir>/
```

where `<rir>` is one of `afrinic`, `apnic`, `arin`, `lacnic`, `ripencc`.

Most of these locations are also available over `https:` (but the host names still contain `ftp.`). And some RIRs mirror other's data, so you will find all data under `/pub/stats/` on the same site (but it might be slightly outdated).

[NRO](https://www.nro.net) combines all this data into single file:

[https://ftp.ripe.net/pub/stats/ripencc/nro-stats/latest/nro-delegated-stats](https://ftp.ripe.net/pub/stats/ripencc/nro-stats/latest/nro-delegated-stats)

so that you do not have to get 5 different files any more.

"AS names" are more difficult, and often do not contain "names of their owners (organizations)". RIRs do provide this info in their public databases, but it is registered differently and you would need to make several queries for each AS to get both the "AS name" and "AS owner name". [RDAP](https://www.apnic.net/about-apnic/whois_search/about/rdap/) unifies some aspects of these differences, but you would still need to query different servers with different URLs and paths.

There are several attempts to aggregate that info, for example:

[https://ftp.ripe.net/ripe/asnames/asn.txt](https://ftp.ripe.net/ripe/asnames/asn.txt)

[https://bgp.potaroo.net/cidr/autnums.html](https://bgp.potaroo.net/cidr/autnums.html)

[https://stat.ripe.net/docs/data_api#as-overview](https://stat.ripe.net/docs/data_api#as-overview)
