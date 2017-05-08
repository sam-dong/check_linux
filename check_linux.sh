#!/bin/bash
#o_0.v_v@qq.com

#1
check_nopass ()
{
echo -e "\n`date +%m%d-%T` ↓检测空密码账户↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓默认不应出现空密码账户↓\e[00m"
sleep 1
nopass=`awk -F: '($2 == "") { print $0 }' /etc/shadow`
nopass_n=`awk -F: '($2 == "") { print $0 }' /etc/shadow | wc -l`
if [ "$nopass_n" == "0" ]; then
	echo "`date +%m%d-%T` 未发现空密码账户"
else
	echo -e "\e[00;31m`date +%m%d-%T` ↓发现空密码账户↓\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` /etc/shadow\e[00m"
	echo -e "\e[00;31m$nopass\e[00m"
fi
}

#2
check_uid_u ()
{
echo -e "\n`date +%m%d-%T` ↓检测除root外UID为0的用户↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓默认应该只用(root)用户↓\e[00m"
sleep 1
uid_0=`awk -F ":" '($3==0) {print $0}' /etc/passwd`
uid_u=`awk -F ":" '($3==0) {print $0}' /etc/passwd | wc -l`
if [ -z "$uid_0" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` 未发现UID为0的用户\e[00m"
else
	if [ "$uid_u" == "1" ]; then
		uid_r=`echo $uid_0 | awk -F ":" '{print $1}'`
		if [ "$uid_r" == "root" ]; then
			echo "`date +%m%d-%T` UID为0的用户只有root"
			echo "`date +%m%d-%T` /etc/passwd"
			echo "$uid_0"
		else
			echo -e "\e[00;31m`date +%m%d-%T` UID为0的用户不是root\e[00m"
			echo -e "\e[00;31m`date +%m%d-%T` /etc/passwd\e[00m"
			echo -e "\e[00;31m$uid_0\e[00m"
		fi
	else
		echo -e "\e[00;31m`date +%m%d-%T` UID为0的用户不只有root\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` /etc/passwd\e[00m"
		echo -e "\e[00;31m$uid_0\e[00m"
	fi
fi
}

#3
check_pass_max ()
{
echo -e "\n`date +%m%d-%T` ↓检测密码有效期↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓推荐密码有效期为90天↓\e[00m"
sleep 1
pass_max=`grep PASS_MAX_DAYS /etc/login.defs  | grep -v "#" | awk '{print $2}'`
if [ -z "$pass_max" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` 未发现 /etc/login.defs 内 PASS_MAX_DAYS 配置\e[00m"
else
	echo "`date +%m%d-%T` 密码有效期为: $pass_max 天"
	if [ $pass_max -gt 90 ]; then
	#(-gt:>)
		echo -e "\e[00;31m`date +%m%d-%T` 密码有效期应小于90天\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` /etc/login.defs\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 现:PASS_MAX_DAYS	$pass_max\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 例:PASS_MAX_DAYS	90\e[00m"
	fi
fi
}

#4
check_pass_war ()
{
echo -e "\n`date +%m%d-%T` ↓密码到期提醒↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓推荐密码还剩14天开始提醒↓\e[00m"
sleep 1
pass_war=`grep PASS_WARN_AGE /etc/login.defs  | grep -v "#" | awk '{print $2}'`
if [ -z "$pass_war" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` 未发现 /etc/login.defs 内 PASS_WARN_AGE 配置\e[00m"
else
	if [ $pass_war -eq 14 ]; then
	#(-eq:=)
		echo "`date +%m%d-%T` 距密码到期还有: $pass_war 天后开始提醒"
	else
		echo -e "\e[00;31m`date +%m%d-%T` 距密码到期还有: $pass_war 天后开始提醒\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` /etc/login.defs\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 现:PASS_WARN_AGE	$pass_war\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 例:PASS_WARN_AGE	14\e[00m"
	fi
fi
}

#5
check_pass_len ()
{
echo -e "\n`date +%m%d-%T` ↓检测密码位数↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓推荐密码为16位以上并无序随机↓\e[00m"
sleep 1
pass_len=`grep PASS_MIN_LEN /etc/login.defs  | grep -v "#" | awk '{print $2}'`
if [ -z "$pass_len" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` 未发现 /etc/login.defs 内 PASS_MIN_LEN 配置\e[00m"
else
	echo "`date +%m%d-%T` 密码最小位数: $pass_len 位"
	if [ $pass_len -lt 16 ]; then
	#(-lt:<)
		echo -e "\e[00;31m`date +%m%d-%T` 密码最小位数应大于16位\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` /etc/login.defs\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 现:PASS_MIN_LEN	$pass_len\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 例:PASS_MIN_LEN	16\e[00m"
	fi
fi
}

#6
check_pass_fz ()
{
echo -e "\n`date +%m%d-%T` ↓检测密码复杂度↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓推荐dcredit数字、ucredit大写、lcredit小写、ocredit特殊字符最少各包含一个↓\e[00m"
sleep 1
pass_fz=`grep dcredit /etc/pam.d/system-auth | grep ucredit | grep lcredit | grep ocredit`
#dcredit数字 ucredit大写 lcredit小写 ocredit特殊字符
if [ -z "$pass_fz" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` ↓密码不满足负责度要求↓\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` /etc/pam.d/system-auth\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` 例:password    requisite     pam_pwquality.so retry=3 minlen=16 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1\e[00m"
else
	echo "`date +%m%d-%T` ↓密码满足复杂度要求↓"
	echo "`date +%m%d-%T` /etc/pam.d/system-auth"
	echo "`date +%m%d-%T` $pass_fz"
fi
}

#7
check_pass_ls ()
{
echo -e "\n`date +%m%d-%T` ↓检测密码历史记录↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓推荐记录5个历史密码↓\e[00m"
sleep 1
pass_ls=`grep  remember /etc/pam.d/system-auth`
pass_ls_n=`echo $pass_ls | awk -F "remember=" '{print $2}' | awk '{print $1}'`
if [ -z "$pass_ls_n" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` ↓配置密码历史记录，禁止重复使用历史密码↓\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` /etc/pam.d/system-auth\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` 例:password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5\e[00m"
else
	if [ $pass_ls_n -eq 5 ]; then
	#(-eq:=)
		echo "`date +%m%d-%T` 密码历史记录为：$pass_ls_n 个"
		echo "`date +%m%d-%T` /etc/pam.d/system-auth"
		echo "`date +%m%d-%T` $pass_ls"
	else
		echo -e "\e[00;31m`date +%m%d-%T` 密码历史记录为：$pass_ls_n 个\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` /etc/pam.d/system-auth\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 现:$pass_ls\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 例:password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5\e[00m"
	fi
fi
}

#8
check_ssh_err ()
{
echo -e "\n`date +%m%d-%T` ↓检测SSH密码错误锁定↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓推荐登陆失败5次锁定60秒↓\e[00m"
sleep 1
ssh_err=`grep even_deny_root /etc/pam.d/sshd | grep deny | grep unlock_time`
ssh_err_d=`echo $ssh_err | awk -F "deny=" '{print $2}' | awk '{print $1}'`
ssh_err_u=`echo $ssh_err | awk -F "unlock_time=" '{print $2}' | awk '{print $1}'`
if [ -z "$ssh_err_d" ] || [ -z "$ssh_err_u" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` ↓未配置SSH密码错误锁定↓\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` /etc/pam.d/sshd\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` 例:auth       required     /lib64/security/pam_tally2.so even_deny_root deny=5 unlock_time=60\e[00m"
else
	if [ $ssh_err_d -eq 5 ] && [ $ssh_err_u -eq 60 ]; then
	#(-eq:=)
		echo "`date +%m%d-%T` 密码锁定策略为失败 $ssh_err_d 次，锁定 $ssh_err_u 秒"
		echo "`date +%m%d-%T` /etc/pam.d/sshd"
		echo "`date +%m%d-%T` $ssh_err"
	else
		echo -e "\e[00;31m`date +%m%d-%T` 密码锁定策略为失败 $ssh_err_d 次，锁定 $ssh_err_u 秒\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` /etc/pam.d/sshd\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 现:$ssh_err\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 例:auth       required     /lib64/security/pam_tally2.so even_deny_root deny=5 unlock_time=60\e[00m"
	fi
fi
}

#9
check_root_ssh ()
{
echo -e "\n`date +%m%d-%T` ↓检测是否允许root通过ssh登陆↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓推荐不允许root通过ssh登陆↓\e[00m"
sleep 1
root_ssh=`grep PermitRootLogin /etc/ssh/sshd_config | grep -v "#" | awk '{print $2}'`
if [ -z "$root_ssh" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` 未配置禁止root通过ssh登陆，默认允许\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` /etc/ssh/sshd_config\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` 例:PermitRootLogin no\e[00m"
else
	if [ $root_ssh == no ]; then
		echo "`date +%m%d-%T` 已经配置禁止root通过ssh登陆"
		echo "`date +%m%d-%T` /etc/ssh/sshd_config"
		echo "`date +%m%d-%T` PermitRootLogin $root_ssh"
	else
		echo -e "\e[00;31m`date +%m%d-%T` 未配置禁止root通过ssh登陆\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` /etc/ssh/sshd_config\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 现:PermitRootLogin $root_ssh\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 例:PermitRootLogin no\e[00m"
	fi
fi
}

#10
check_time_out ()
{
echo -e "\n`date +%m%d-%T` ↓检测是否配置全部用户登陆空闲超时↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓推荐300秒无操作自动登出账户↓\e[00m"
sleep 1
time_out=`grep TMOUT= /etc/profile | awk -F "=" '{print $2}'`
time_out_e=`grep export /etc/profile | grep TMOUT`
if [ -z "$time_out" ] || [ -z "$time_out_e" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` 未配置空闲超时\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` /etc/profile\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` 例:TMOUT=30000\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` 例:export TMOUT\e[00m"
else
	if [ $time_out -eq 300 ]; then
	#(-eq:=)
		echo "`date +%m%d-%T` 空闲超时时间为: $time_out 秒"
		echo "`date +%m%d-%T` /etc/profile"
		echo "`date +%m%d-%T` TMOUT=$time_out"
		echo "`date +%m%d-%T` $time_out_e"
	else
		echo -e "\e[00;31m`date +%m%d-%T` 空闲超时时间为: $time_out 秒\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` /etc/profile\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 现:TMOUT=$time_out\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 例:TMOUT=300\e[00m"
	fi
fi
}

#11
check_sshpam ()
{
echo -e "\n`date +%m%d-%T` ↓检测ssh是否开启UsePAM认证↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓ssh应该开启UsePAM认证，否则/etc/pam.d/sshd配置将失效↓\e[00m"
sleep 1
ssh_pam=`grep UsePAM /etc/ssh/sshd_config | grep -v "#"`
ssh_pamn=`grep UsePAM /etc/ssh/sshd_config | grep -v "#" | wc -l`
if [ -z "$ssh_pam" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` 未配置UsePAM认证\e[00m"
else
	if [ "$ssh_pamn" != "1" ]; then
		echo -e "\e[00;31m`date +%m%d-%T` 未正确配置UsePAM认证\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` /etc/ssh/sshd_config\e[00m"
		echo -e "\e[00;31m$ssh_pam\e[00m"
		echo -e "\e[00;31m`date +%m%d-%T` 例:UsePAM yes\e[00m"
	else
		ssh_pamy=`echo $ssh_pam | awk '{print $2}'`
		if [ "$ssh_pamy" == "yes" ]; then
			echo "`date +%m%d-%T` ssh服务已经开启UsePAM"
			echo "`date +%m%d-%T` /etc/ssh/sshd_config"
			echo "`date +%m%d-%T` $ssh_pam"
		else
			echo -e "\e[00;31m`date +%m%d-%T` 未配置UsePAM认证\e[00m"
			echo -e "\e[00;31m`date +%m%d-%T` /etc/ssh/sshd_config\e[00m"
			echo -e "\e[00;31m`date +%m%d-%T` 现:$ssh_pam\e[00m"
			echo -e "\e[00;31m`date +%m%d-%T` 例:UsePAM yes\e[00m"
		fi
	fi
fi
}

#12
check_sshjt ()
{
echo -e "\n`date +%m%d-%T` ↓检测ssh监听↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓本机如存在公网地址ssh需只监听到私网地址↓\e[00m"
sleep 1
#私网地址段:'10.0.0.0/8 172.16-31.0.0/16 192.168.0.0/16'
#保留地址段:'127.0.0.0/8 169.254.0.0/16'
ssh_jt=`grep ListenAddress /etc/ssh/sshd_config  | grep -v "#"`
for ip in `ip a | grep "inet " | awk '{print $2}' | awk -F "/" '{print $1}'`
do
	ip1=`echo $ip | cut -d . -f 1`
	ip2=`echo $ip | cut -d . -f 2`
	if [ $ip1 -eq 172 -a $ip2 -lt 31 -a $ip2 -gt 16 ] || [ $ip1 -eq 10 ] || [ "$ip1.$ip2" == "192.168" ] || [ "$ip1.$ip2" == "169.254" ] || [ "$ip1"  == "127" ]; then
	#if [ $ip1 -eq 172 -a $ip2 -lt 31 -a $ip2 -gt 16 ] || [ $ip1 -eq 10 ] || [ "$ip1.$ip2" == "192.168" ]; then
	#(-eq:=)(-gt:>)(-lt:<)
		echo "`date +%m%d-%T` IP地址为私网: $ip"
	else
		echo -e "\e[00;31m`date +%m%d-%T` IP地址为公网: $ip\e[00m"
		if [ -z "$ssh_jt" ]; then
			echo -e "\e[00;31m`date +%m%d-%T` 未配置ssh监听IP，默认监听:0.0.0.0\e[00m"
			echo -e "\e[00;31m`date +%m%d-%T` /etc/ssh/sshd_config\e[00m"
			echo -e "\e[00;31m`date +%m%d-%T` ListenAddress {私网地址}\e[00m"
		else
			for ssh_ip in `grep ListenAddress /etc/ssh/sshd_config | grep -v "#" | awk '{print $2}'`
			do
				if [ "$ssh_ip" == "0.0.0.0" ] || [ "$ssh_ip" == "$ip" ]; then
					echo -e "\e[00;31m`date +%m%d-%T` 已配置ssh监听:$ssh_ip\e[00m"
					echo -e "\e[00;31m`date +%m%d-%T` /etc/ssh/sshd_config\e[00m"
					echo -e "\e[00;31m`date +%m%d-%T` 现:ListenAddress $ssh_ip\e[00m"
					echo -e "\e[00;31m`date +%m%d-%T` 例:ListenAddress {私网地址}\e[00m"
				else
					ssh_ip1=`echo $ssh_ip | cut -d . -f 1`
					ssh_ip2=`echo $ssh_ip | cut -d . -f 2`
					if [ $ip1 -eq 172 -a $ip2 -lt 31 -a $ip2 -gt 16 ] || [ $ip1 -eq 10 ] || [ "$ip1.$ip2" == "192.168" ] || ["$ip1.$ip2" == "169.254" ] || [ "$ip1"  == "127" ]; then
						echo "`date +%m%d-%T` 已配置ssh监听:$ssh_ip"
						echo "`date +%m%d-%T` /etc/ssh/sshd_config"
						echo "`date +%m%d-%T` ListenAddress $ssh_ip"
					fi
				fi
			done
		fi
	fi
done
}

#13
check_user ()
{
echo -e "\n`date +%m%d-%T` ↓检测系统存在账户↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓建议禁用非必要账户↓\e[00m"
sleep 1
if [ -f ./userlist_new ]; then
	if [ -f ./userlist_old ]; then
		chattr -i ./userlist_old
		chattr -i ./userlist_new
		mv ./userlist_old ./userlist_`date +%Y%m%d-%T` && mv ./userlist_new ./userlist_old && grep -v '/sbin/nologin' /etc/passwd > ./userlist_new
		chattr +i ./userlist_old
		chattr +i ./userlist_new
	else
		chattr -i ./userlist_new
		mv ./userlist_new ./userlist_old && grep -v '/sbin/nologin' /etc/passwd > ./userlist_new
		chattr +i ./userlist_old
		chattr +i ./userlist_new
	fi
	user_l=`diff ./userlist_new ./userlist_old`
	if [ -z "$user_l" ]; then
		echo "`date +%m%d-%T` 系统账户无改变"
		echo "`date +%m%d-%T` /etc/passwd"
		cat ./userlist_new
	else
		user_a=`diff ./userlist_new ./userlist_old | grep "< " | awk '{print $2}'`
		if [ ! -z "$user_a" ]; then
			echo -e "\e[00;31m`date +%m%d-%T` 有新建系统账户，请查看\e[00m"
			echo -e "\e[00;31m`date +%m%d-%T` /etc/passwd\e[00m"
			echo -e "\e[00;31m$user_a\e[00m"
		fi
		user_d=`diff ./userlist_new ./userlist_old | grep "> " | awk '{print $2}'`
		if [ ! -z "$user_d" ]; then
			echo -e "\e[00;31m`date +%m%d-%T` 有删除系统账户，请查看\e[00m"
			echo -e "\e[00;31m`date +%m%d-%T` /etc/passwd\e[00m"
			echo -e "\e[00;31m$user_d\e[00m"
		fi
	fi
else
	echo -e "\e[00;31m`date +%m%d-%T` 第一次检测非nologin系统账户\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` ↓请关注以下账户是否必须↓\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` /etc/passwd\e[00m"
	grep -v '/sbin/nologin' /etc/passwd > ./userlist_new
	cat ./userlist_new
	chattr +i ./userlist_new
fi
}

#14
check_group ()
{
echo -e "\n`date +%m%d-%T` ↓检测系统存在账户组↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓建议禁用非必要账户组↓\e[00m"
sleep 1
if [ -f ./grouplist_new ]; then
	if [ -f ./grouplist_old ]; then
		chattr -i ./grouplist_old
		chattr -i ./grouplist_new
		mv ./grouplist_old ./grouplist_`date +%Y%m%d-%T` && mv ./grouplist_new ./grouplist_old && cat /etc/group > ./grouplist_new
		chattr +i ./grouplist_old
		chattr +i ./grouplist_new
	else
		chattr -i ./grouplist_new
		mv ./grouplist_new ./grouplist_old && cat /etc/group > ./grouplist_new
		chattr +i ./grouplist_old
		chattr +i ./grouplist_new
	fi
	user_l=`diff ./grouplist_new ./grouplist_old`
	if [ -z "$user_l" ]; then
		echo "`date +%m%d-%T` 系统账户组无改变"
		echo "`date +%m%d-%T` /etc/group"
		cat ./grouplist_new
	else
		user_a=`diff ./grouplist_new ./grouplist_old | grep "< " | awk '{print $2}'`
		if [ ! -z "$user_a" ]; then
			echo -e "\e[00;31m`date +%m%d-%T` 有新建系统账户组，请查看\e[00m"
			echo -e "\e[00;31m`date +%m%d-%T` /etc/group\e[00m"
			echo -e "\e[00;31m$user_a\e[00m"
		fi
		user_d=`diff ./grouplist_new ./grouplist_old | grep "> " | awk '{print $2}'`
		if [ ! -z "$user_d" ]; then
			echo -e "\e[00;31m`date +%m%d-%T` 有删除系统账户组，请查看\e[00m"
			echo -e "\e[00;31m`date +%m%d-%T` /etc/group\e[00m"
			echo -e "\e[00;31m$user_d\e[00m"
		fi
	fi
else
	echo -e "\e[00;31m`date +%m%d-%T` 第一次检测系统账户组\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` ↓请关注以下账户组是否必须↓\e[00m"
	echo -e "\e[00;31m`date +%m%d-%T` /etc/group\e[00m"
	cat /etc/group > ./grouplist_new
	cat ./grouplist_new
	chattr +i ./grouplist_new
fi
}

#15
check_rsyslog ()
{
echo -e "\n`date +%m%d-%T` ↓检测系统日志(rsyslog)↓"
echo -e "\e[00;33m`date +%m%d-%T` ↓关键日志为:登陆审计(secure)，系统日志(messages)，系统启动信息(boot)↓\e[00m"
sleep 1
rsys_pid=`ps aux | grep rsyslogd | grep -v grep`
if [ -z "$rsys_pid" ];then
	echo -e "\e[00;31m`date +%m%d-%T` 日志服务(rsyslog)未启动\e[00m"
else
	echo "`date +%m%d-%T` 日志服务(rsyslog)启动: $rsys_pid"
fi
log_sec=`grep "authpriv.\*" /etc/rsyslog.conf`
log_mes=`grep "^\*." /etc/rsyslog.conf | grep mess`
log_boo=`grep "local7.\*" /etc/rsyslog.conf`
echo "`date +%m%d-%T` /etc/rsyslog.conf"
if [ -z "$log_sec" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` 未发现登陆审计日志(secure)配置\e[00m"
else
	echo "`date +%m%d-%T` 登陆审计日志为: $log_sec"
fi
if [ -z "$log_mes" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` 未发现系统日志(messages)配置\e[00m"
else
	echo "`date +%m%d-%T` 系统日志为: $log_mes"
fi
if [ -z "$log_boo" ]; then
	echo -e "\e[00;31m`date +%m%d-%T` 未发现系统启动信息(boot)配置\e[00m"
else
	echo "`date +%m%d-%T` 系统启动信息: $log_boo"
fi
}

check_usage ()
{
echo "
用法: $0 {OPTIONS}
例子: $0 check_all
OPTIONS:
check_nopass {1.检测空密码账户}
check_uid_u {2.检测除root外UID为0的用户}
check_pass_max {3.检测密码有效期}
check_pass_war {4.密码到期提醒}
check_pass_len {5.检测密码位数}
check_pass_fz {6.检测密码复杂度}
check_pass_ls {7.检测密码历史记录}
check_ssh_err {8.检测SSH密码错误锁定}
check_root_ssh {9.检测是否允许root通过ssh登陆}
check_time_out {10.检测登陆空闲超时}
check_sshpam {11.检测ssh是否开启UsePAM认证}
check_sshjt {12.检测ssh监听}
check_user {13.检测系统存在账户
		首次运行会在当前目录下生成一个文件:userlist_new
		再次运行会在当前目录下生成两个文件:userlist_new userlist_old(不允许删除和修改，如需请执行chattr -i file)
		多次运行会备份userlist_old文件至当前目录，文件名(userlist_time)}
check_group {14.检测系统存在账户组
		首次运行会在当前目录下生成一个文件:grouplist_new
		再次运行会在当前目录下生成两个文件:grouplist_new grouplist_old(不允许删除和修改，如需请执行chattr -i file)
		多次运行会备份grouplist_old文件至当前目录，文件名(grouplist_time)}
check_rsyslog {15.检测系统日志(rsyslog)}
check_all {检测所有15项}
"
}

check_all ()
{
#1
check_nopass

#2
check_uid_u

#3
check_pass_max

#4
check_pass_war

#5
check_pass_len

#6
check_pass_fz

#7
check_pass_ls

#8
check_ssh_err

#9
check_root_ssh

#10
check_time_out

#11
check_sshpam

#12
check_sshjt

#13
check_user

#14
check_group

#15
check_rsyslog
}

case "$1" in
	check_nopass) check_nopass ;;
	check_uid_u) check_uid_u ;;
	check_pass_max) check_pass_max ;;
	check_pass_war) check_pass_war ;;
	check_pass_len) check_pass_len ;;
	check_pass_fz) check_pass_fz ;;
	check_pass_ls) check_pass_ls ;;
	check_ssh_err) check_ssh_err ;;
	check_root_ssh) check_root_ssh ;;
	check_time_out) check_time_out ;;
	check_sshpam) check_sshpam ;;
	check_sshjt) check_sshjt ;;
	check_user) check_user ;;
	check_group) check_group ;;
	check_rsyslog) check_rsyslog ;;
	check_all) check_all ;;
	*) check_usage ;;
esac
