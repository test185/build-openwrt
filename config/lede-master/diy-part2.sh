#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic  #晶晨宝盒
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-passwall  #passwall代理软件
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-smartdns   #smartdns DNS防污染
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-store   #应用商店
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-openclash  #clash的图形代理软件
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-alist   #支持多存储的文件列表程序
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/mosdns
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-adguardhome  #AdG去广告
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/helloworld
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-eqos  #依IP地址限速
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-firewall  #添加防火墙
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-zerotier  #ZeroTier内网穿透
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-autoreboot  #支持计划重启
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-wireguard #VPN服务器 WireGuard状态
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-webadmin  #Web管理页面设置
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-watchcat  #断网检测功能与定时重启
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-advancedsetting  #系统高级设置（Le库以外的插件）
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-mosdns  #DNS 国内外分流解析与广告过滤
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-ttyd  #网页终端命令行
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-vlmcsd  #KMS服务器设置
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-accesscontrol   #访问时间控制

# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-accesscontrol
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-accesscontrol
# svn co https://github.com/ysx88/openwrt-packages/tree/master openwrt-packages/luci-app-autorepeater

# Fix runc version error
# rm -rf ./feeds/packages/utils/runc/Makefile
# svn export https://github.com/openwrt/packages/trunk/utils/runc/Makefile ./feeds/packages/utils/runc/Makefile

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

