#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 0.0.3
#	Blog: blog.lvcshu.club
#	Author: johnpoint
#    USE AT YOUR OWN RISK!!!
#    Publish under GNU General Public License v2
#=================================================

sh_ver="0.0.3"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
Separator_1="——————————————————————————————"
check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
}

#check OS
if [ -f /etc/redhat-release ]; then
    release="centos"
    PM='yum'
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    PM='apt-get'
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    PM='apt-get'
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    PM='yum'
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    PM='apt-get'
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    PM='apt-get'
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    PM='yum'
fi

${PM} update
${PM} install jq -y

config=$( curl -s ipinfo.io )
touch ip.json
echo "
'ip_config':
$config" > ip.json

ip(){
cat ip.json | jq '.ip'
}

city(){
cat ip.json | jq '.city'
}

country(){
cat ip.json | jq '.country'
}

loc(){
cat ip.json | jq '.loc'
}

org(){
cat ip.json | jq '.org'
}

ip=$(ip)
city=$(city)
country=$(country)
loc=$(loc)
org=$(org)

echo -e "[v${Green_font_prefix}${sh_ver}${Font_color_suffix}]
============= IP INFO =============
IP地址：$ip
位置：$country $city $loc
组织：$org
=================================
" && echo
	stty erase '^H' && read -p "是否删除ip.json?(Y/N)" YON
	[[ -z "${YON}" ]] && echo "已取消..." && exit 1
	if [[ ${YON} == "Y" ]]; then
       rm ip.json
	elif [[ ${YON} == "N" ]]; then
		exit 0
   else
       echo -e "${Tip}那我删掉了喔~"
       rm ip.json
       exit 0
   fi
   