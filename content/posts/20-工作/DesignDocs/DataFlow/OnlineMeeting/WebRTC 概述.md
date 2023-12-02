---
scope: work
draft: true
---




# 架构
![](_attachments/WebRTC%20概述/Pasted%20image%2020220123150201.png)


# 信令


![](_attachments/WebRTC%20概述/Pasted%20image%2020220123150347.png)

P2P 握手流程：
![](_attachments/WebRTC%20概述/Pasted%20image%2020220227221124.png)





# STUN, TRUN & ICE


## STUN

-   Tell me what my public IP address is
-   Simple server, cheap to run
-   Data flows peer-to-peer

![](_attachments/WebRTC%20概述/Pasted%20image%2020220123150735.png)



## TURN

-   Provide a cloud fallback if peer-to-peer communication fails
-   Data is sent through server, uses server bandwidth
-   Ensures the call works in almost all environments

![](_attachments/WebRTC%20概述/Pasted%20image%2020220123150713.png)


## ICE

-   [ICE](http://en.wikipedia.org/wiki/Interactive_Connectivity_Establishment "Wikipedia ICE article"): a framework for connecting peers
-   Tries to find the best path for each call
-   Vast majority of calls can use STUN (webrtcstats.com):


![Data pathways between peers using TURN](http://io13webrtc.appspot.com/images/icestats.png)



# 开放资源

[stun-turn服务器搭建 | 常丁方的博客](http://www.changdingfang.com/2020/09/19/notes/linux/stun-turn/): <http://www.changdingfang.com/2020/09/19/notes/linux/stun-turn/>
