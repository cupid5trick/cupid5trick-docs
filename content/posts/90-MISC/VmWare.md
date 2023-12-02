---
draft: true
categories: ["misc"]
tags: ['vmware']
---

# 命令行操作 VMWare
这是一篇更新于 460 天前的文章，其中的信息可能已经有所发展或是发生改变。
## 常用命令
Windows 环境下，需要使用命令后台开启虚拟机。  
操作环境：Windows 10 工作站版、VMware WorkStation 16 Pro

通过使用 vmrun 命令可以对虚拟机进行后台开机操作。

```powershell
cd C:\Program Files (x86)\VMware\VMware Workstation>  
  
.\vmrun.exe start D:\VMware\Win10\Win10.vmx nogui
```

常见命令及详解：

```powershell
# 启动虚拟机操作  
# -T 可指定宿主主机类型，合法的类型包括：ws（vmware workstation）|server|server1|fusion|esx|vc|player，其中ws、esx、player较为常用  
# nogui 表示无图形界面启动，也可以指定为gui表示图形界面启动  
.\vmrun.exe -T ws start guest.vmx nogui | gui  
  
# 关闭虚拟机操作  
# hard 表示硬关机，也可以指定为soft表示软关机  
.\vmrun.exe stop guest.vmx hard | soft  
  
# 重启虚拟机操作  
# hard 表示硬重启，也可以指定为soft表示软重启  
.\vmrun.exe reset guest.vmx hard | soft  
  
# 暂停虚拟机  
.\vmrun.exe pause guest.vmx  
  
# 停止暂停虚拟机   
.\vmrun.exe unpause guest.vmx  
     
# 列出正在运行的虚拟机  
.\vmrun.exe list  
  
# 获取关于vmrun命令行的帮助  
.\vmrun.exe -h
```

## 参考文档
[参考文档](https://www.txisfine.cn/archives/ca8ec92c#%E5%8F%82%E8%80%83%E6%96%87%E6%A1%A3 "参考文档")
- [VMware - 使用 vmrun 实用工具](https://docs.vmware.com/cn/VMware-Fusion/12/com.vmware.fusion.using.doc/GUID-7700DDB9-AE60-41C0-B638-9A0527795C8C.html?hWord=N4IghgNiBcIG4FsBOBXAdiAvkA)
- [vmware 命令选项](https://docs.vmware.com/cn/VMware-Workstation-Pro/16.0/com.vmware.ws.using.doc/GUID-7369457F-FE1D-40FE-97B6-B29CA4916CCD.html#GUID-7369457F-FE1D-40FE-97B6-B29CA4916CCD)
- [运行 vmrun 命令](https://docs.vmware.com/cn/VMware-Fusion/12/com.vmware.fusion.using.doc/GUID-3E063D73-E083-40CD-A02C-C2047E872814.html?hWord=N4IghgNiBcIG4FsBOBXAdiAvkA)
- [使用 VMware Workstation Pro REST API](https://docs.vmware.com/cn/VMware-Workstation-Pro/16.0/com.vmware.ws.using.doc/GUID-9FAAA4DD-1320-450D-B684-2845B311640F.html)
- [windows命令行启动vmware - 简书](https://www.jianshu.com/p/a999d3bcc320)

版权声明: 本博客所有文章除特别声明外，均采用 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) 许可协议。转载请注明来自 [弹霄博科](https://www.txisfine.cn/)！