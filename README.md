# GithubActionsBuildimmortaWrt
## 这是什么？
它是一个工作流。可快速构建 带docker且支持自定义固件大小的 immortalWrt
> 支持自定义固件大小 默认 <br>
> 支持预安装docker（可选）<br>
> 支持x86-64 和 rockchip ）<br>
> 支持MT3000/MT2500/MT6000/B2200（docker可选）<br>
> 全志平台R1S、香橙派Zero3等机型的工作流<br>
> 预设置pppoe拨号功能<br>
> 支持树莓派1,2,3,4,5<br>


## 如何查询都有哪些插件?
https://downloads.immortalwrt.org/releases/23.05.4/packages/aarch64_cortex-a53/luci/ <br>
https://downloads.immortalwrt.org/releases/23.05.4/packages/x86_64/luci/ 


## 旁路由
旁路的逻辑应该是单网口模式。根据下面的固件属性可知。单网口默认采取`dhcp模式`，用户应当自行在上一级路由器查看给imm路由器分配的ip地址。
然后通过该ip来访问imm后台页面，在imm后台页面中，根据自己主路由的网段 自行配置旁路的ip地址。

## 正常路由
所谓正常的路由模式 就是指多网口用户，多网口的意思就是2个或者2个以上网口的情况。<br>
一般wan用于拨号或者自动获取ip <br>
而其他lan一般是给其他设备分配dhcp<br>
这种情况下 你可以修改路由器的默认ip  `192.168.2.1` 比如你可以修改为`192.168.100.1 ` 诸如此类。<br>
没错，修改此ip 无非就是为了避免跟光猫或者跟家庭中的其他路由器网段冲突。大多数用户，无需更改。

## 该固件默认属性？(必读)
- 该固件刷入【单网口设备】默认采用DHCP模式,自动获得ip。类似NAS的做法
- 该固件刷入【多网口设备】默认WAN口采用DHCP模式，LAN 口ip为  `192.168.2.1` <br>其中eth0为WAN 其余网口均为LAN
- 若用户在工作流中勾选了拨号信息 则WAN口模式为pppoe拨号模式。
- 建议拨号用户使用之前重启一次光猫。
- 综合上述特点，【单网口设备】应该先接路由器，先在上级路由器查看一下它的ip 再访问。
- 上述特点 你都可以通过 `99-custom.sh` 配置和调整

# immortalwrt
### https://github.com/immortalwrt
# info
由@wukongdaily/AutoBuildImmortalWrt修改
