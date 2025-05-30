#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"
# yml 传入的固件大小 ROOTFS_PARTSIZE
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"

echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings

# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."


# 定义所需安装的包列表
PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"



# 服务——FileBrowser 用户名admin 密码admin
PACKAGES="$PACKAGES luci-i18n-filebrowser-go-zh-cn"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
# 增加几个必备组件 方便用户安装iStore
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"
# 网络和 VPN 包
PACKAGES="$PACKAGES wireguard-tools"
PACKAGES="$PACKAGES kmod-wireguard"
PACKAGES="$PACKAGES luci-proto-wireguard"
# PACKAGES="$PACKAGES openvpn"
# PACKAGES="$PACKAGES luci-app-openvpn"
PACKAGES="$PACKAGES luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
# Docker 和相关的管理工具
PACKAGES="$PACKAGES docker"
PACKAGES="$PACKAGES dockerd"
PACKAGES="$PACKAGES luci-app-dockerman"
PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
# iptables 和 DNS 配置
PACKAGES="$PACKAGES ipset"
PACKAGES="$PACKAGES ip-full"
PACKAGES="$PACKAGES iptables-mod-tproxy"
PACKAGES="$PACKAGES iptables-mod-extra"
PACKAGES="$PACKAGES dnsmasq-full"
# 网络和内核模块支持
PACKAGES="$PACKAGES kmod-tun"
PACKAGES="$PACKAGES kmod-inet-diag"
# Ruby 和相关的库
PACKAGES="$PACKAGES ruby"
PACKAGES="$PACKAGES ruby-yaml"
# 工具
PACKAGES="$PACKAGES unzip"
PACKAGES="$PACKAGES luci-compat"
PACKAGES="$PACKAGES luci-base"
PACKAGES="$PACKAGES nano"
# 必备的系统工具
PACKAGES="$PACKAGES ntpd"
PACKAGES="$PACKAGES syslog-ng"
PACKAGES="$PACKAGES strace"
PACKAGES="$PACKAGES htop"
PACKAGES="$PACKAGES screen"
# 流媒体和多媒体支持
PACKAGES="$PACKAGES ffmpeg"
PACKAGES="$PACKAGES minidlna"
#USB
PACKAGES="$PACKAGES kmod-usb-core"
PACKAGES="$PACKAGES kmod-usb-ehci"
PACKAGES="$PACKAGES kmod-ath9k"   # 如果使用 Atheros 无线芯片
PACKAGES="$PACKAGES kmod-rt2800-usb"  # 如果使用 Ralink USB 无线芯片
PACKAGES="$PACKAGES kmod-mac80211"
PACKAGES="$PACKAGES hostapd"
PACKAGES="$PACKAGES wpa-supplicant"
#流量監控
PACKAGES="$PACKAGES luci-app-nlbwmon"
# vnStat 流量统计工具
PACKAGES="$PACKAGES vnstat2"
PACKAGES="$PACKAGES luci-app-vnstat2"
# 网络流量管理和 QoS
PACKAGES="$PACKAGES luci-app-sqm"
#luci-app-statistics
# 進系統後裝一下opkg install collectd-mod-ethstat collectd-mod-ipstatistics collectd-mod-irq collectd-mod-load collectd-mod-ping collectd-mod-powerdns collectd-mod-sqm collectd-mod-thermal collectd-mod-wireless
PACKAGES="$PACKAGES luci-app-statistics"
#多語言
PACKAGES="$PACKAGES luci-i18n-base-zh-cn"
PACKAGES="$PACKAGES luci-i18n-base-zh-tw"
PACKAGES="$PACKAGES luci-i18n-base-ja"






# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

# immortalwrt
make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE
# openwrt
# make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/openwrt/files" ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE


if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
