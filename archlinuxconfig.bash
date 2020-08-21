#!/usr/bin/env bash
# Copyright 2017-2020 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosted sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/README has info about this project.
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.
################################################################################

_ADDAUSER_() {
	_CFLHDR_ root/bin/addauser "# add Arch Linux in Termux PRoot user"
	cat >> root/bin/addauser <<- EOM
_FUNADDU_() {
if [[ -z "\${1:-}" ]]
then
	printf "\\e[1;31m%s\\\\n" "Use: addauser username: exiting..."
	exit 201
else
	sed -i "s/required/sufficient/g" /etc/pam.d/su
	sed -i "s/^#auth/auth/g" /etc/pam.d/su
	useradd -s /bin/bash "\$1" -U
	usermod "\$1" -aG wheel
	passwd -d "\$1"
	chage -I -1 -m 0 -M -1 -E -1 "\$1"
	[[ -d /etc/sudoers.d ]] && printf "%s\\n" "\$1 ALL=(ALL) ALL" >> /etc/sudoers.d/"\$1"
	sed -i "s/\$1:x/\$1:/g" /etc/passwd
	cp -r /root /home/"\$1"
	printf "%s\\n" "Added user \$1 and directory /home/\$1 created.  To use this account run '$STARTBIN login \$1' in Termux.  Remember please not to nest proot in proot by running '$STARTBIN' in '$STARTBIN' as this may cause issues."
fi
}
_PMFSESTRING_() { 
printf "\\e[1;31m%s\\e[1;37m%s\\e[1;32m%s\\e[1;37m%s\\n\\n" "Signal generated in '\$1' : Cannot complete task : " "Continuing..."
printf "\\e[1;34m%s\\e[0;34m%s\\e[1;34m%s\\e[0;34m%s\\e[1;34m%s\\e[0m\\n\\n" "  If you find improvements for " "setupTermuxArch.bash" " and " "\$0" " please open an issue and accompanying pull request."
}
_FUNADDU_ "\$@"
EOM
	chmod 700 root/bin/addauser
}

_ADDREADME_() {
	_CFLHDR_ root/bin/README.md
	cat > root/bin/README.md <<- EOM
	This directory contains shortcut commands that automate and ease using the command line.

	* Comments welcome at https://github.com/TermuxArch/TermuxArch/issues ✍
	* Pull requests welcome at https://github.com/TermuxArch/TermuxArch/pulls ✍
	EOM
}

_ADDae_() {
	_CFLHDR_ root/bin/ae "# Contributed by https://github.com/cb125"
	cat >> root/bin/ae <<- EOM
	watch cat /proc/sys/kernel/random/entropy_avail
	EOM
	chmod 700 root/bin/ae
}

_ADDaddresolvconf_() {
	[ ! -e run/systemd/resolve ] && mkdir -p run/systemd/resolve
	cat > run/systemd/resolve/resolv.conf <<- EOM
	nameserver 8.8.8.8
	nameserver 8.8.4.4
	EOM
}

_ADDbash_logout_() {
	cat > root/.bash_logout <<- EOM
	if [ ! -e "\$HOME"/.hushlogout ] && [ ! -e "\$HOME"/.chushlogout ] ; then
		. /etc/moto
	fi
	EOM
}

_ADDbash_profile_() {
	[ -e root/.bash_profile ] && _DOTHF_ "root/.bash_profile"
	printf "%s\\n" "PATH=\"\$HOME/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:\$PATH\"" > root/.bash_profile
	cat >> root/.bash_profile <<- EOM
	. "\$HOME"/.bashrc
	if [ ! -e "\$HOME"/.hushlogin ] && [ ! -e "\$HOME"/.chushlogin ] ; then
		. /etc/motd
	fi
	if [ -e "\$HOME"/.chushlogin ] ; then
		rm "\$HOME"/.chushlogin
	fi
	PS1="[\[\e[38;5;148m\]\u\[\e[1;0m\]\A\[\e[1;38;5;112m\]\W\[\e[0m\]]$ "
	export GPG_TTY="\$(tty)"
	export TZ="$(getprop persist.sys.timezone)"
	EOM
	for i in "${!LC_TYPE[@]}"
	do
	 	printf "%s=\"%s\"\\n" "export ${LC_TYPE[i]}" "$ULANGUAGE.UTF-8" >> root/.bash_profile
	done
	[[ -f "$HOME"/.bash_profile ]] && grep proxy "$HOME"/.bash_profile | grep "export" >> root/.bash_profile ||:
}

_ADDbashrc_() {
	[ -e root/.bashrc ] && _DOTHF_ "root/.bashrc"
	cat > root/.bashrc <<- EOM
	[ -f /etc/profile.d/perlbin.sh ] && . /etc/profile.d/perlbin.sh
	alias C='cd .. && pwd'
	alias c='cd .. && pwd'
	alias ..='cd ../.. && pwd'
	alias ...='cd ../../.. && pwd'
	alias ....='cd ../../../.. && pwd'
	alias .....='cd ../../../../.. && pwd'
	alias D='nice -n 20 du -hs'
	alias d='nice -n 20 du -hs'
	alias E='exit'
	alias e='exit'
	alias F='grep -n --color=always'
	alias f='grep -n --color=always'
	alias G='ga ; gcm ; gp'
	alias g='ga ; gcm ; gp'
	alias gca='git commit -a -S'
	alias gcam='git commit -a -S -m'
	alias H='history >> \$HOME/.historyfile'
	alias h='history >> \$HOME/.historyfile'
	alias J='jobs'
	alias j='jobs'
	alias I='whoami'
	alias i='whoami'
	alias L='ls -al --color=always'
	alias l='ls -al --color=always'
	alias ls='ls --color=always'
	alias LR='ls -alR --color=always'
	alias lr='ls -alR --color=always'
	alias N2='nice -n -20'
	alias n2='nice -n -20'
	alias P='pwd'
	alias p='pwd'
	alias pacman='pacman --color=always'
	alias pcs='pacman -S --color=always'
	alias pcss='pacman -Ss --color=always'
	alias Q='exit'
	alias q='exit'
	EOM
	if [ -e "$HOME"/.bashrc ] ; then
		grep proxy "$HOME"/.bashrc | grep "export" >>  root/.bashrc 2>/dev/null ||:
	fi
}

_ADDcdtd_() {
	_CFLHD_ root/bin/cdtd "# Usage: \`. cdtd\` the dot sources \`cdtd\` which makes this shortcut script work."
	cat > root/bin/cdtd <<- EOM
	#!/usr/bin/env bash
	cd "$HOME/storage/downloads" && pwd
	EOM
	chmod 700 root/bin/cdtd
}

_ADDcdth_() {
	_CFLHD_ root/bin/cdth "# Usage: \`. cdth\` the dot sources \`cdth\` which makes this shortcut script work."
	cat > root/bin/cdth <<- EOM
	#!/usr/bin/env bash
	cd "$HOME" && pwd
	EOM
	chmod 700 root/bin/cdth
}

_ADDcdtmp_() {
	_CFLHD_ root/bin/cdtmp "# Usage: \`. cdtmp\` the dot sources \`cdtmp\` which makes this shortcut script work."
	cat > root/bin/cdtmp <<- EOM
	#!/usr/bin/env bash
	cd "$PREFIX/tmp" && pwd
	EOM
	chmod 700 root/bin/cdtmp
}

_ADDch_() {
	_CFLHDR_ root/bin/ch "# This script creates .hushlogin and .hushlogout files."
	cat >> root/bin/ch <<- EOM
	declare -a ARGS

	_TRPET_() { # on exit
		printf "\\e[?25h\\e[0m"
		set +Eeuo pipefail
	 	_PRINTTAIL_ "\$ARGS[@]"
	}

	_PRINTTAIL_() {
		printf "\\\\n\\\\e[0m%s \\\\e[0;32m%s %s %s\\\\e[1;34m: \\\\e[1;32m%s\\\\e[0m 🏁  \\\\n\\\\n\\\\e[0m" "TermuxArch" "\$(basename "\$0")" "\$ARGS"  "\$VERSIONID" "DONE"
		printf '\033]2;  🔑 TermuxArch '"\$(basename "\$0")"':DONE 📱 \007'
	}

	## ch begin ####################################################################

	if [[ -z "\${1:-}" ]] ; then
		ARGS=""
	else
		ARGS="\$@"
	fi

	printf "\\\\n\\\\e[1;32m==> \\\\e[1;37m%s \\\\e[1;32m%s %s %s\\\e[0m%s...\\\\n\\\\n" "Running" "TermuxArch \$(basename "\$0")" "\$ARGS" "\$VERSIONID"

	if [[ -f "\$HOME"/.hushlogin ]] && [[ -f "\$HOME"/.hushlogout ]] ; then
		rm "\$HOME"/.hushlogin "\$HOME"/.hushlogout
		echo "Hushed login and logout: OFF"
	elif [[ -f "\$HOME"/.hushlogin ]] || [[ -f "\$HOME"/.hushlogout ]] ; then
		touch "\$HOME"/.hushlogin "\$HOME"/.hushlogout
		echo "Hushed login and logout: ON"
	else
		touch "\$HOME"/.hushlogin "\$HOME"/.hushlogout
		echo "Hushed login and logout: ON"
	fi
	EOM
	chmod 700 root/bin/ch
}

_ADDcsystemctl_() {
	_CFLHDR_ root/bin/csystemctl.bash
	cat >> root/bin/csystemctl.bash  <<- EOM
	INSTALLDIR="$INSTALLDIR"
	printf "%s\\n" "Installing /usr/bin/systemctl replacement: "
	[ -f /var/lock/csystemctl.lock ] && printf "%s\\n" "Already installed /usr/bin/systemctl replacement: DONE" && exit
	declare COMMANDP
	COMMANDP="\$(command -v python3)" || printf "%s\\n" "Command python3 not found; Continuing..."
	[[ "\${COMMANDP:-}" == *python3* ]] || pacman --noconfirm --color=always -S python3 || sudo pacman --noconfirm --color=always -S python3
	# path is $HOME/bin because updates overwrite /usr/bin/systemctl and may make systemctl-replacement obsolete
	# backup original binary
	if [ -f /usr/bin/systemctl ]
	then
		mv /usr/bin/systemctl /usr/bin/systemctl.old
	fi
	printf "%s\\n" "Moved /usr/bin/systemctl /usr/bin/systemctl.old"
	printf "%s\\n" "Getting replacement systemctl from https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py"
	# copy to $HOME/bin
	# updates won't halt functioning since $HOME/bin precedes /usr/bin in PATH and even if /usr/bin/systemctl respawns due to updates, it will have no effect
	# downloading to $HOME/bin will suffice because it preceeds /usr/bin in PATH
	curl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /root/bin/systemctl
	chmod 700 /root/bin/systemctl
	# make it available for all users
	HVAR="$(ls "/home")"
	for USER in ${HVAR[@]}
	do
		if [[ "$USER" != alarm ]]
		then
			cp /root/bin/systemctl /home/$USER/bin/systemctl
			chmod 700 /home/$USER/bin/systemctl
		fi
	done
	[ ! -e /run/lock ] && mkdir -p /run/lock
	touch /var/lock/csystemctl.lock	
	printf "%s\\n" "Installing systemctl replacement in ~/bin: DONE"
	EOM
	chmod 700 root/bin/csystemctl.bash
}

_ADDdfa_() {
	_CFLHDR_ root/bin/dfa
	cat >> root/bin/dfa <<- EOM
	units="\$(df 2>/dev/null | awk 'FNR == 1 {print \$2}')"
	USRSPACE="\$(df 2>/dev/null | grep "/data" | awk {'print \$4'})"
	printf "\e[0;33m%s\n\e[0m" "\$USRSPACE \$units of free user space is available on this device."
	EOM
	chmod 700 root/bin/dfa
}

_ADDexd_() {
	_CFLHDR_ root/bin/exd "# Usage: \`. exd\` the dot sources \`exd\` which makes this shortcut script work."
	cat >> root/bin/exd <<- EOM
	export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1:4712
	EOM
	chmod 700 root/bin/exd
}

_ADDfbindprocshmem_() {
	_CFLHDRS_ var/binds/fbindprocshmem.prs
	cat > var/binds/fbindprocshmem.prs  <<- EOM
	PROOTSTMNT+="-b $INSTALLDIR/var/binds/fbindprocshmem:/proc/shmem "
	EOM
	cat > var/binds/fbindprocshmem <<- EOM
	------ Message Queues --------
	key        msqid      owner      perms      used-bytes   messages

	------ Shared Memory Segments --------
	key        shmid      owner      perms      bytes      nattch     status

	------ Semaphore Arrays --------
	key        semid      owner      perms      nsems
	EOM
}

_ADDfbindprocstat_() { # Chooses the appropriate four or eight processor stat file.
	NESSOR="$(grep cessor /proc/cpuinfo)"
	NCESSOR="${NESSOR: -1}"
	if [[ "$NCESSOR" -le "3" ]] 2>/dev/null ; then
		_ADDfbindprocstat4_
	else
		_ADDfbindprocstat8_
	fi
}

_ADDfbindprocstat4_() {
	cat > var/binds/fbindprocstat <<- EOM
	cpu  4232003 351921 6702657 254559583 519846 1828 215588 0 0 0
	cpu0 1595013 127789 2759942 61446568 310224 1132 92124 0 0 0
	cpu1 1348297 91900 1908179 63099166 110243 334 78861 0 0 0
	cpu2 780526 73446 1142504 64682755 61240 222 32586 0 0 0
	cpu3 508167 58786 892032 65331094 38139 140 12017 0 0 0
	intr 182663754 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 23506963 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13479102 0 0 0 0 0 0 0 108 0 0 0 0 0 0 0 0 0 178219 72133 5 0 1486834 0 0 0 8586048 0 0 0 0 0 0 0 0 0 0 2254 0 0 0 0 29 3 7501 38210 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4610975 0 0 0 0 0 1 0 78471 0 0 0 0 0 0 0 0 0 0 0 0 0 0 305883 0 15420 0 3956500 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8937474 0 943938 0 0 0 0 0 0 0 0 0 0 0 0 12923 0 0 0 34931 5 0 2922124 848989 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 12502497 0 0 3270275 0 0 0 0 0 0 0 0 0 0 0 1002881 0 0 0 0 0 0 17842 0 44011 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1975390 0 0 0 0 0 0 0 0 0 0 0 0 4968 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1340 2 762 0 0 0 50 42 0 27 82 0 0 0 0 14 28 0 0 0 0 14277 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1974794 0 142 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 367 81
	ctxt 473465697
	btime 1533498667
	processes 800170
	procs_running 2
	procs_blocked 0
	softirq 71223290 12005 18257219 222294 2975533 4317 4317 7683319 19799901 40540 22223845
	EOM
}

_ADDfbindprocstat6_() {
	cat > var/binds/fbindprocstat <<- EOM
	# cat /proc/stat
	cpu  148928556 146012 6648853 2086709554 4518337 0 1314039 293017 0 0
	cpu0 24948069 38092 1137251 347724817 1169568 0 30231 21138 0 0
	cpu1 16545576 29411 890111 356315677 971747 0 41593 115368 0 0
	cpu2 82009143 11955 2705377 286616379 473751 0 1239704 114343 0 0
	cpu3 9487436 29342 673090 364602319 631633 0 843 11690 0 0
	cpu4 6696319 23709 584149 367425424 501898 0 890 12546 0 0
	cpu5 9242011 13500 658872 364024935 769737 0 775 17929 0 0
	intr 3438098651 134 26 0 0 0 0 3 0 0 0 0 581717 74 0 0 3669554 0 0 0 0 0 0 0 0 0 150777509 19 0 843288252 7923 0 0 0 256 0 4 0 13323712 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	ctxt 1109789017
	btime 1499444193
	processes 6613836
	procs_running 3
	procs_blocked 0
	softirq 3644958646 1 2007831497 2340 995352344 1834998 0 97563 249921452 0 389918451
	EOM
}

_ADDfbindprocstat8_() {
	cat > var/binds/fbindprocstat <<- EOM
	cpu  10278859 1073916 12849197 97940412 70467 2636 323477 0 0 0
	cpu0 573749 46423 332546 120133 32 79 5615 0 0 0
	cpu1 489409 40445 325756 64094 0 59 5227 0 0 0
	cpu2 385758 36997 257949 50488114 40123 39 4021 0 0 0
	cpu3 343254 34729 227718 47025740 30205 20 2566 0 0 0
	cpu4 3063160 288232 4291656 58418 27 940 146236 0 0 0
	cpu5 2418517 277690 3105779 60431 48 751 67052 0 0 0
	cpu6 1671400 189460 2302016 61521 23 402 49717 0 0 0
	cpu7 1333612 159940 2005777 61961 9 346 43043 0 0 0
	intr 607306752 0 0 113 0 109 0 0 26 0 0 4 0 0 0 0 0 0 0 0 0 67750564 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 51073258 0 0 0 0 0 0 0 160 0 0 0 0 0 0 0 0 0 51831 2 5 0 24598 0 0 0 15239501 0 0 0 0 0 0 0 0 0 0 1125885 0 0 0 0 5966 3216 120 2 0 0 5990 0 24741 0 37 0 0 0 0 0 0 0 0 0 0 0 0 15262980 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 42742 16829690 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 19844763 0 8873762 0 0 0 0 0 0 0 0 6 0 0 0 49937 0 0 0 2768306 5 0 3364052 3700518 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 41435584 0 0 3939101 0 0 0 0 0 0 0 0 0 0 0 1894201 0 0 0 0 0 0 864195 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8961077 3996222 0 0 0 0 0 0 0 0 0 0 0 0 66386 0 0 0 0 0 0 87497 0 285431 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11217187 0 6 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3578 0 0 0 0 0 301 300 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 117 14 0 0 0 0 0 95 0 0 0 0 0 0 0 27 0 2394 0 0 0 0 62 0 0 0 0 0 857124 0 1 0 0 0 0 20 3990685 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5021 481 4
	ctxt 1589697753
	btime 1528042653
	processes 1400085
	procs_running 5
	procs_blocked 0
	softirq 204699421 2536598 39636497 522981 4632002 29263706 104522 6736991 41332715 232221 79701188
	EOM
}

_ADDfbindprocuptime_() {
	printf "%s\\n" "350735.47 234388.90" > var/binds/fbindprocuptime
}

_ADDfbindprocversion_() {
	_CFLHDRS_ var/binds/fbindprocversion.prs
	cat > var/binds/fbindprocversion.prs  <<- EOM
	# bind a fake kernel when /proc/version is accessed
	PROOTSTMNT+=" -b $INSTALLDIR/var/binds/fbindprocversion:/proc/version "
	EOM
	cat > var/binds/fbindprocversion <<- EOM
	Linux version $(uname -r)-generic (root@localhost) (gcc version 4.9.x 20150123 (prerelease) (GCC) ) #1 SMP PREEMPT $(date +%a" "%b" "%d" "%X" UTC "%Y)
	EOM
}

_ADDfbindexample_() {
	_CFLHDRS_ var/binds/fbindexample.prs "# Before regenerating the start script with \`setupTermuxArch.bash re[fresh]\`, first copy this file to another name such as \`fbinds.prs\`.  Then add as many proot statements as you want; The init script will parse file \`fbinds.prs\` at refresh adding these proot options to \`$STARTBIN\`.  The space before the last double quote is necessary.  Examples are included for convenience:"
	cat >> var/binds/fbindexample.prs <<- EOM
	# PRoot bind usage: PROOTSTMNT+="-b host_path:guest_path " # the space before the last double quote is necessary
	# PROOTSTMNT+="-q $PREFIX/bin/qemu-x86_64 "
	# PROOTSTMNT+="-b /proc/:/proc/ "
	# [[ ! -r /dev/shm ]] && PROOTSTMNT+="-b $INSTALLDIR/tmp:/dev/shm "
	# fbindexample.prs EOF
	EOM
}

_ADDfbinds_() { # Checks if /proc/stat is usable.
	if [[ ! -r /proc/stat ]] ; then
		_ADDfbindprocstat_
		_ADDfbindprocversion_
	fi
}

_ADDfibs_() {
	_CFLHDR_ root/bin/fibs
	cat >> root/bin/fibs  <<- EOM
	find /proc/ -name maps 2>/dev/null | xargs awk '{print \$6}' 2>/dev/null | grep '\.so' | sort | uniq
	EOM
	chmod 700 root/bin/fibs
}

_ADDga_() {
	_CFLHDR_ root/bin/ga
	cat >> root/bin/ga  <<- EOM
	if [[ ! -x "\$(command -v git)" ]]
	then
		pacman --noconfirm --color=always -S git
		git add .
	else
		git add .
	fi
	EOM
	chmod 700 root/bin/ga
}

_ADDgcl_() {
	_CFLHDR_ root/bin/gcl
	cat >> root/bin/gcl  <<- EOM
	if [[ ! -x "\$(command -v git)" ]]
	then
		pacman --noconfirm --color=always -S git
		git clone --depth 1 "\$@" --branch master --single-branch
	else
		git clone --depth 1 "\$@" --branch master --single-branch
	fi
	EOM
	chmod 700 root/bin/gcl
}

_ADDgcm_() {
	_CFLHDR_ root/bin/gcm
	cat >> root/bin/gcm  <<- EOM
	if [[ ! -x "\$(command -v git)" ]]
	then
		pacman --noconfirm --color=always -S git
		git commit
	else
		git commit
	fi
	EOM
	chmod 700 root/bin/gcm
}

_ADDgpl_() {
	_CFLHDR_ root/bin/gpl
	cat >> root/bin/gpl  <<- EOM
	if [[ ! -x "\$(command -v git)" ]]
	then
		pacman --noconfirm --color=always -S git
		git pull
	else
		git pull
	fi
	EOM
	chmod 700 root/bin/gpl
}

_ADDgp_() {
	_CFLHDR_ root/bin/gp "# git push https://username:password@github.com/username/repository.git master"
	cat >> root/bin/gp  <<- EOM
	if [[ ! -x "\$(command -v git)" ]]
	then
		pacman --noconfirm --color=always -S git
		git push
	else
		git push
	fi
	EOM
	chmod 700 root/bin/gp
}

_ADDinputrc() {
	cat > root/.inputrc <<- EOM
	set bell-style none
	EOM
}

_ADDkeys_() {
	_CFLHDR_ root/bin/keys
	cat >> root/bin/keys <<- EOM
	declare -a KEYRINGS

	_TRPET_() { # on exit
		printf "\\e[?25h\\e[0m"
		set +Eeuo pipefail
	 	_PRINTTAIL_ "\$KEYRINGS[@]"
	}

	_GENEN_() { # This for loop generates entropy on device for \$t seconds.
		N=2 # Number of loop generations for generating entropy.
		T0=256 # Maximum number of seconds loop will run unless keys completes earlier.
		T1=0.4
		for I in "\$(seq 1 "\$N")"; do
			"\$(nice -n 20 ls -alR / >/dev/null 2>/dev/null & sleep "\$T0" ; kill \$! >/dev/null)" >/dev/null &
			sleep "\$T1"
			"\$(nice -n 20 find / >/dev/null 2>/dev/null & sleep "\$T0" ; kill \$! >/dev/null)" >/dev/null &
			sleep "\$T1"
			"\$(nice -n 20 cat /dev/urandom >/dev/null 2>/dev/null & sleep "\$T0" ; kill \$! >/dev/null)" >/dev/null &
			sleep "\$T1"
		done
		disown
	}

	_PRINTTAIL_() {
		printf "\\\\n\\\\e[0;32m%s %s %s\\\\e[1;34m: \\\\e[1;32m%s\\\\e[0m 🏁  \\\\n\\\\n\\\\e[0m" "TermuxArch \$(basename "\$0")" "\$ARGS" "\$VERSIONID" "DONE"
		printf '\033]2;  🔑 TermuxArch '"\$(basename "\$0") \$ARGS"': DONE 📱 \007'
	}

	trap _TRPET_ EXIT
	## keys begin ##################################################################

	if [[ -z "\${1:-}" ]] ; then
		KEYRINGS[0]="archlinux-keyring"
		KEYRINGS[1]="archlinuxarm-keyring"
		KEYRINGS[2]="ca-certificates-utils"
	elif [[ "\$1" = x86 ]]; then
		KEYRINGS[0]="archlinux32-keyring-transition"
		KEYRINGS[1]="ca-certificates-utils"
	elif [[ "\$1" = x86_64 ]]; then
		KEYRINGS[0]="archlinux-keyring"
		KEYRINGS[1]="ca-certificates-utils"
	else
		KEYRINGS="\$@"
	fi
	ARGS="\${KEYRINGS[@]}"
	printf '\033]2;  🔑 TermuxArch '"\$(basename "\$0") \$ARGS"' 📲 \007'
	printf "\\\\n\\\\e[1;32m==> \\\\e[1;37m%s \\\\e[0;32m%s \\\\e[1;32m%s %s \\\\e[0m%s...\\\\n" "Running" "TermuxArch" "\$(basename "\$0")" "\$ARGS" "\$VERSIONID"
	mv usr/lib/gnupg/scdaemon{,_} 2>/dev/null ||:
	printf "\n\e[0;34m[1/2] When \e[0;37mgpg: Generating pacman keyring master key\e[0;34m appears on the screen, the installation process can be accelerated.  The system desires a lot of entropy at this part of the install procedure.  To generate as much entropy as possible quickly, watch and listen to a file on your device.  \n\nThe program \e[1;32mpacman-key\e[0;34m will want as much entropy as possible when generating keys.  Entropy is also created through tapping, sliding, one, two and more fingers tapping with short and long taps.  When \e[0;37mgpg: Generating pacman keyring master key\e[0;34m appears on the screen, use any of these simple methods to accelerate the installation process if it is stalled.  Put even simpler, just do something on device.  Browsing files will create entropy on device.  Slowly swiveling the device in space and time will accelerate the installation process.  This method alone might not generate enough entropy (a measure of randomness in a closed system) for the process to complete quickly.  Use \e[1;32mbash ~${DARCH}/bin/we \e[0;34min a new Termux session to and watch entropy on device.\n\n\e[1;32m==>\e[0m Running \e[1mpacman-key --init\e[0;32m...\n"
	pacman-key --init ||:
	chmod 700 /etc/pacman.d/gnupg
	pacman-key --populate ||:
	printf "\n\e[1;32m==>\e[0m Running \e[1mpacman -S \$ARGS --noconfirm --color=always\e[0;32m...\n"
	pacman -S "\${KEYRINGS[@]}" --noconfirm --color=always ||:
	printf "\n\e[0;34m[2/2] When \e[1;37mAppending keys from archlinux.gpg\e[0;34m appears on the screen, the installation process can be accelerated.  The system desires a lot of entropy at this part of the install procedure.  To generate as much entropy as possible quickly, watch and listen to a file on your device.  \n\nThe program \e[1;32mpacman-key\e[0;34m will want as much entropy as possible when generating keys.  Entropy is also created through tapping, sliding, one, two and more fingers tapping with short and long taps.  When \e[1;37mAppending keys from archlinux.gpg\e[0;34m appears on the screen, use any of these simple methods to accelerate the installation process if it is stalled.  Put even simpler, just do something on device.  Browsing files will create entropy on device.  Slowly swiveling the device in space and time will accelerate the installation process.  This method alone might not generate enough entropy (a measure of randomness in a closed system) for the process to complete quickly.  Use \e[1;32mbash ~${DARCH}/bin/we \e[0;34min a new Termux session to watch entropy on device.\n\n\e[1;32m==>\e[0m Running \e[1mpacman-key --populate\e[0;32m...\n"
	pacman-key --populate ||:
	printf "\e[1;32m==>\e[0m Running \e[1mpacman -Ss keyring --color=always\e[0m...\n"
	pacman -Ss keyring --color=always ||:
	EOM
	chmod 700 root/bin/keys
}

_ADDMOTD_() {
	if [[ "$CPUABI" = "$CPUABIX86" ]] || [[ "$CPUABI" = "$CPUABIX86_64" ]]
	then
		cat > etc/motd  <<- EOM
		printf "\\n\\e[1;34m%s\\n%s\\e[0;34m%s\\n\\e[1;34m%s\\e[0;34m%s\\n\\e[1;34m%s\\e[0;34m%s\\n\\e[1;34m%s\\e[0;34m%s\\n\\n\\e[1;34m%s\\e[0m%s\\n\\e[1;34m%s\\e[0;34m%s\\e[1;34m%s\\e[0;34m%s\\n\\e[1;34m%s\\e[0m%s\\n\\n" "Welcome to Arch Linux in Termux!" "Install a package: " "pacman -S package" "More  information: " "pacman -[D|F|Q|R|S|T|U]h" "Search   packages: " "pacman -Ss query" "Upgrade  packages: " "pacman -Syu" "Chat:  " "https://wiki.termux.com/wiki/Community" "Help: " "info query " "and " "man query" "IRC: " "wiki.archlinux.org/index.php/IRC_channel"
		EOM
	else
		cat > etc/motd  <<- EOM
		printf "\\n\\e[1;34m%s\\n%s\\e[0;34m%s\\n\\e[1;34m%s\\e[0;34m%s\\n\\e[1;34m%s\\e[0;34m%s\\n\\e[1;34m%s\\e[0;34m%s\\n\\n\\e[1;34m%s\\e[0m%s\\n\\e[1;34m%s\\e[0m%s\\n\\e[1;34m%s\\e[0;34m%s\\e[1;34m%s\\e[0;34m%s\\n\\e[1;34m%s\\e[0m%s\\n\\n" "Welcome to Arch Linux in Termux!" "Install a package: " "pacman -S package" "More  information: " "pacman -[D|F|Q|R|S|T|U]h" "Search   packages: " "pacman -Ss query" "Upgrade  packages: " "pacman -Syu" "Chat:  " "https://wiki.termux.com/wiki/Community" "Forum: " "https://archlinuxarm.org/forum" "Help: " "info query " "and " "man query" "IRC: " "wiki.archlinux.org/index.php/IRC_channel"
		EOM
	fi
}

_ADDMOTO_() {
	cat > etc/moto  <<- EOM
	printf "\n\e[1;34mShare Your Arch Linux in Termux Experience!\n\n\e[1;34mChat: \e[0mwiki.termux.com/wiki/Community\n\e[1;34mHelp: \e[0;34minfo query \e[1;34mand \e[0;34mman query\n\e[1;34mIRC:  \e[0mwiki.archlinux.org/index.php/IRC_channel\n\n\e[0m"
	EOM
}

_ADDmakefakeroot-tcp_() {
	_CFLHDR_ root/bin/makefakeroot-tcp.bash "# attempt to build and install fakeroot-tcp"
	cat >> root/bin/makefakeroot-tcp.bash  <<- EOM
	if [ "\$UID" = "0" ]
	then
		printf "\\n%s\\n\\n" "Error: Should not be used as root."
	else
		[ ! -f /var/lock/patchmakepkg.lock ] && patchmakepkg.bash
		printf "%s\\n" "Attempting to build and install fakeroot-tcp: "
		([[ ! "\$(command -v automake)" ]] || [[ ! "\$(command -v fakeroot)" ]] || [[ ! "\$(command -v git)" ]] || [[ ! "\$(command -v po4a)" ]]) && sudo pacman --noconfirm --color=always -S automake base-devel fakeroot git po4a libtool
		cd 
		(git clone https://aur.archlinux.org/fakeroot-tcp.git && cd fakeroot-tcp && sed -i 's/  patch/  sudo patch/g' PKGBUILD && makepkg -is) || printf "%s\n" "Continuing to build and install fakeroot-tcp: " && cd fakeroot-tcp && sed -i 's/  patch/  sudo patch/g' PKGBUILD && makepkg -is
		printf "%s\\n" "Attempting to build and install fakeroot-tcp: DONE"
	fi
	EOM
	chmod 700 root/bin/makefakeroot-tcp.bash
}

_ADDmakeyay_() {
	_CFLHDR_ root/bin/makeyay.bash "# attempt to build and install yay"
	cat >> root/bin/makeyay.bash  <<- EOM
	if [ "\$UID" = "0" ]
	then
		printf "\\n%s\\n\\n" "Error: Should not be used as root: Exiting..."
	else
		[ ! -f /var/lock/patchmakepkg.lock ] && patchmakepkg.bash
		! fakeroot ls >/dev/null && makefakeroot-tcp.bash
		printf "%s\\n" "Attempting to build and install yay: "
		cd 
		(git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -irs --noconfirm) || printf "%s\n" "Continuing to build and install yay..." && cd yay && makepkg -irs --noconfirm
		printf "%s\\n" "Attempting to build and install yay: DONE"
	fi
	EOM
	chmod 700 root/bin/makeyay.bash
}

_ADDpatchmakepkg_() {
	_CFLHDR_ root/bin/patchmakepkg.bash "# attempt to build and install yay"
	cat >> root/bin/patchmakepkg.bash  <<- EOM
	printf "%s\\n" "Attempting to patch makepkg: "
	[ -f /var/lock/patchmakepkg.lock ] && printf "%s\\n" "Already patched makepkg: DONE" && exit
	cd && curl -O https://raw.githubusercontent.com/TermuxArch/TermuxArch/master/diff.makepkg.zip && unzip diff.makepkg.zip 
	patch -n -i makepkg.diff -o makepkg /bin/makepkg
	cp /bin/makepkg makepkg.\$(date +%s).bkp 
	chmod 700 makepkg /bin/makepkg
	# copy to /usr/local/bin to make it update-proof (fail safe measure)
	cp makepkg /usr/local/bin/makepkg
	mv makepkg /bin/makepkg
	touch /var/lock/patchmakepkg.lock
	printf "%s\\n" "Attempting to patch makepkg: DONE"
	EOM
	chmod 700 root/bin/patchmakepkg.bash
}

_ADDpc_() {
	_CFLHDR_ root/bin/pc "# pacman install packages wrapper without system update"
	cat >> root/bin/pc  <<- EOM
	declare -g ARGS="\$@"

	_TRPET_() { # on exit
		printf "\\e[?25h\\e[0m"
		set +Eeuo pipefail
	 	_PRINTTAIL_ "\$ARGS"
	}

	_PRINTTAIL_() {
		printf "\\\\n\\\\e[0;32m%s %s %s\\\\e[1;34m: \\\\e[1;32m%s\\\\e[0m 🏁  \\\\n\\\\n\\\\e[0m" "TermuxArch \$(basename "\$0")" "\$ARGS" "\$VERSIONID" "DONE"
		printf '\033]2;  🔑 TermuxArch '"\$(basename "\$0") \$ARGS"' 📱 \007'
	}

	trap _TRPET_ EXIT
	## pc begin ####################################################################

	printf '\033]2;  🔑 TermuxArch '"\$(basename "\$0") \$ARGS"' 📲 \007'
	printf "\\\\n\\\\e[1;32m==> \\\\e[1;37m%s \\\\e[0;32m%s \\\\e[1;32m%s %s \\\e[0m%s...\\\\n\\\\n" "Running" "TermuxArch" "\$(basename "\$0")" "\$ARGS" "\$VERSIONID"
	if [[ -z "\${1:-}" ]] ; then
	pacman --noconfirm --color=always -S
	elif [[ "\$1" = "a" ]] ; then
	pacman --noconfirm --color=always -S base base-devel "\${@:2}"
	elif [[ "\$1" = "ae" ]] ; then
	pacman --noconfirm --color=always -S base base-devel emacs "\${@:2}"
	elif [[ "\$1" = "a8" ]] ; then
	pacman --noconfirm --color=always -S base base-devel emacs jdk8-openjdk "\${@:2}"
	else
	pacman --noconfirm --color=always -S "\$@"
	fi
	EOM
	chmod 700 root/bin/pc
}

_ADDpci_() {
	_CFLHDR_ root/bin/pci "# Pacman install packages wrapper with system update."
	cat >> root/bin/pci  <<- EOM
	declare ARGS="\$@"

	_TRPET_() { # on exit
		printf "\\e[?25h\\e[0m"
		set +Eeuo pipefail
	 	_PRINTTAIL_ "\$ARGS"
	}

	_PRINTTAIL_() {
		printf "\\\\n\\\\e[0;32m%s %s %s\\\\e[1;34m: \\\\e[1;32m%s\\\\e[0m 🏁  \\\\n\\\\n\\\\e[0m" "TermuxArch \$(basename "\$0")" "\$ARGS" "\$VERSIONID" "DONE"
		printf '\033]2;  🔑 TermuxArch '"\$(basename "\$0") \$ARGS"' 📱 \007'
	}

	trap _TRPET_ EXIT
	## pci begin ###################################################################

	printf "\\\\n\\\\e[1;32m==> \\\\e[1;37m%s \\\\e[1;32m%s %s %s \\\e[0m%s...\\\\n\\\\n" "Running" "TermuxArch \$(basename "\$0")" "\$ARGS" "\$VERSIONID"
	if [[ -z "\${1:-}" ]] ; then
	pacman --noconfirm --color=always -Syu
	elif [[ "\$1" = "e" ]] ; then
	pacman --noconfirm --color=always -Syu base base-devel emacs "\${@:2}"
	elif [[ "\$1" = "e8" ]] ; then
	pacman --noconfirm --color=always -Syu base base-devel emacs jdk8-openjdk "\${@:2}"
	elif [[ "\$1" = "e10" ]] ; then
	pacman --noconfirm --color=always -Syu base base-devel emacs jdk10-openjdk "\${@:2}"
	else
	pacman --noconfirm --color=always -Syu "\$@"
	fi
	# pci EOF
	EOM
	chmod 700 root/bin/pci
}

_ADDprofile_() {
	[ -e root/.profile ] && _DOTHF_ "root/.profile"
	[ -e "$HOME"/.profile ] && (grep "proxy" "$HOME"/.profile | grep "export" >>  root/.profile 2>/dev/null) ||:
	touch root/.profile
}

_ADDt_() {
	_CFLHDR_ root/bin/t
	cat >> root/bin/t  <<- EOM
	if [[ ! -x "\$(command -v tree)" ]]
	then
		pacman --noconfirm --color=always -S tree
		tree "\$@"
	else
		tree "\$@"
	fi
	EOM
	chmod 700 root/bin/t
}

_ADDthstartarch_() {
	_CFLHDR_ root/bin/th"$STARTBIN"
	cat >> root/bin/th"$STARTBIN" <<- EOM
	echo $STARTBIN help
	$STARTBIN help
	sleep 1
	echo $STARTBIN command "pwd && whoami"
	$STARTBIN command "pwd && whoami"
	sleep 1
	echo $STARTBIN login user
	$STARTBIN login user ||:
	echo $STARTBIN raw su user -c "pwd && whoami"
	$STARTBIN raw su user -c "pwd && whoami"
	sleep 1
	echo $STARTBIN su user "pwd && whoami"
	$STARTBIN su user "pwd && whoami"
	echo th$STARTBIN done
	EOM
	chmod 700 root/bin/th"$STARTBIN"
}

_ADDtour_() {
	_CFLHDR_ root/bin/tour "# A short tour that shows a few of the new files in ths system."
	cat >> root/bin/tour <<- EOM
	printf "\n\e[1;32m==> \e[1;37mRunning \e[1;32mls -alr --color=always \$HOME \e[1;37m\n\n"
	sleep 1
	ls -alr --color=always "\$HOME"
	sleep 4
	printf "\n\e[1;32m==> \e[1;37mRunning \e[1;32mcat \$HOME/.bash_profile\e[1;37m\n\n"
	sleep 1
	cat "\$HOME"/.bash_profile
	sleep 4
	printf "\n\e[1;32m==> \e[1;37mRunning \e[1;32mcat \$HOME/.bashrc\e[1;37m\n\n"
	sleep 1
	cat "\$HOME"/.bashrc
	sleep 4
	printf "\n\e[1;32m==> \e[1;37mRunning \e[1;32mcat \$HOME/bin/pci\e[1;37m\n\n"
	sleep 1
	cat "\$HOME"/bin/pci
	printf "\\e[1;32m\\n%s \\e[38;5;121m%s \\n\\n\\e[4;38;5;129m%s\\e[0m\\n\\n\\e[1;34m%s \\e[38;5;135m%s\\e[0m\\n\\n" "==>" "Short tour is complete; Scroll up if you wish to study the output.  Run this script again at a later time, and it might be surprising at how this environment changes over time. " "If you are new to *nix, http://tldp.org has documentation." "IRC: " "https://wiki.archlinux.org/index.php/IRC_channel"
	EOM
	chmod 700 root/bin/tour
}

_ADDtrim_() {
	_CFLHDR_ root/bin/trim
	cat >> root/bin/trim <<- EOM
	_PMFSESTRING_() { 
	printf "\\e[1;31m%s\\e[1;37m%s\\e[1;32m%s\\e[1;37m%s\\n\\n" "Signal generated in '\$1' : Cannot complete task : " "Continuing..."
	printf "\\e[1;34m%s\\e[0;34m%s\\e[1;34m%s\\e[0;34m%s\\e[1;34m%s\\e[0m\\n\\n" "  If you find improvements for " "setupTermuxArch.bash" " and " "\$0" " please open an issue and accompanying pull request."
	}
	printf "\\\\n\\\\e[1;32m==> \\\\e[1;0m%s\\\\e[0m\\\\n\\\\n" "Running \${0##*/} trim \$@:"
	if [[ "\$UID" -eq "0" ]]
	then
		SUTRIM="pacman -Sc --noconfirm --color=always"
		_SUTRIM_() {
			pacman -Sc --noconfirm --color=always || _PMFSESTRING_ "pacman -Sc"
		}
	else
		SUTRIM="sudo pacman -Sc --noconfirm --color=always"
		_SUTRIM_() {
			sudo pacman -Sc --noconfirm --color=always || _PMFSESTRING_ "pacman -Sc"
		}
	fi
	printf "%s\\\\n" "[1/5] rm -rf /boot/"
	rm -rf /boot/
	printf "%s\\\\n" "[2/5] rm -rf /usr/lib/firmware"
	rm -rf /usr/lib/firmware
	printf "%s\\\\n" "[3/5] rm -rf /usr/lib/modules"
	rm -rf /usr/lib/modules
	printf "%s\\\\n" "[4/5] \$SUTRIM"
	_SUTRIM_
	printf "%s\\\\n" "[5/5] rm -f /var/cache/pacman/pkg/*xz"
	rm -f /var/cache/pacman/pkg/*xz || _PMFSESTRING_ "rm -f"
	printf "\\\\n\\\\e[1;32m%s\\\\e[0m\\\\n\\\\n" "\${0##*/} trim \$@: Done"
	EOM
	chmod 700 root/bin/trim
}

_ADDv_() {
	_CFLHDR_ root/bin/v
	cat >> root/bin/v  <<- EOM
	if [[ -z "\${1:-}" ]]
	then
		ARGS=(".")
	else
		ARGS=("\$@")
	fi
	EOM
	printf "%s\\n# v EOF#" "[ ! -x \"\$(command -v vim)\" ] && ( [ \"\$UID\" = \"0\" ] && pacman --noconfirm --color=always -S vim || sudo pacman --noconfirm --color=always -S vim ) && vim  \"\${ARGS[@]}\" || vim  \"\${ARGS[@]}\"" >> root/bin/v
	chmod 700 root/bin/v
}

_ADDwe_() {
	_CFLHDR_ usr/bin/we "# Watch available entropy on device." "# cat /proc/sys/kernel/random/entropy_avail contributed by https://github.com/cb125"
	cat >> usr/bin/we <<- EOM

	i=1
	multi=16
	entropy0=\$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null)

	printintro()
	{
		printf "\n\e[1;32mTermuxArch Watch Entropy:\n"'\033]2; TermuxArch Watch Entropy 📲  \007'
	}

	_PRINTTAIL_()
	{
		printf "\n\n\e[1;32mTermuxArch Watch Entropy 🏁 \n\n"'\033]2; TermuxArch Watch Entropy 🏁 \007'
	}

	_PRINTUSAGE_()
	{
		printf "\n\e[0;32mUsage:  \e[1;32mwe \e[0;32m Watch Entropy simple.\n\n	\e[1;32mwe sequential\e[0;32m Watch Entropy sequential.\n\n	\e[1;32mwe simple\e[0;32m Watch Entropy simple.\n\n	\e[1;32mwe verbose\e[0;32m Watch Entropy verbose.\n\n"'\033]2; TermuxArch Watch Entropy 📲  \007'
	}

	infif()
	{
		if [[ \$entropy0 = "inf" ]] || [[ \$entropy0 = "" ]] || [[ \$entropy0 = "0" ]] ; then
			entropy0=1000
			printf "\e[1;32m∞^∞infifinfif2minfifinfifinfifinfif∞=1\e[0;32minfifinfifinfifinfif\e[0;32m∞==0infifinfifinfifinfif\e[0;32minfifinfifinfif∞"
		fi
	}

	en0=\$((\${entropy0}*\$multi))

	esleep()
	{
		int=\$(echo "\$i/\$entropy0" | bc -l)
		for i in {1..5}; do
			if (( \$(echo "\$int > 0.1"|bc -l) ));then
				tmp=\$(echo "\${int}/100" | bc -l)
				int=\$tmp
			fi
			if (( \$(echo "\$int > 0.1"|bc -l) ));then
				break
			fi
		done
	}

	1sleep()
	{
		sleep 0.1
	}

	bcif()
	{
		commandif=\$(command -v getprop) ||:
		if [[ \$commandif = "" ]] ; then
			abcif=\$(command -v bc) ||:
			if [[ \$abcif = "" ]] ; then
				printf "\e[1;34mInstalling \e[0;32mbc\e[1;34m...\n\n\e[1;32m"
				pacman -S bc --noconfirm --color=always
				printf "\n\e[1;34mInstalling \e[0;32mbc\e[1;34m: \e[1;32mDONE\n\e[0m"
			fi
		else
			tbcif=\$(command -v bc) ||:
			if [[ \$tbcif = "" ]] ; then
				printf "\e[1;34mInstalling \e[0;32mbc\e[1;34m...\n\n\e[1;32m"
				apt install bc --yes
				printf "\n\e[1;34mInstalling \e[0;32mbc\e[1;34m: \e[1;32mDONE\n\e[0m"
			fi
		fi
	}

	entropysequential()
	{
	printf "\n\e[1;32mWatch Entropy Sequential:\n\n"'\033]2; Watch Entropy Sequential 📲  \007'
	for i in \$(seq 1 \$en0); do
		entropy0=\$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null)
		infif
		printf "\e[1;30m \$en0 \e[0;32m\$i \e[1;32m\${entropy0}\n"
		1sleep
	done
	}

	entropysimple()
	{
	printf "\n\e[1;32mWatch Entropy Simple:\n\n"'\e]2; Watch Entropy Simple 📲  \007'
	for i in \$(seq 1 \$en0); do
		entropy0=\$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null)
		infif
		printf "\e[1;32m\${entropy0} "
		1sleep
	done
	}

	entropyverbose()
	{
	printf "\n\e[1;32mWatch Entropy Verbose:\n\n"'\033]2; Watch Entropy Verbose 📲  \007'
	for i in \$(seq 1 \$en0); do
		entropy0=\$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null)
		infif
		printf "\e[1;30m \$en0 \e[0;32m\$i \e[1;32m\${entropy0} \e[0;32m#E&&√♪"
		esleep
		sleep \$int
		entropy1=\$(cat /proc/sys/kernel/random/uuid 2>/dev/null)
		infif
		printf "\$entropy1"
		esleep
		sleep \$int
		printf "&&π™♪&##|♪FLT"
		esleep
		sleep \$int
		printf "\$int♪||e"
		esleep
		sleep \$int
	done
	}

	# [we sequential] Run sequential watch entropy.
	if [[ -z "\${1:-}" ]] ; then
		printintro
		entropysequential
	elif [[ \$1 = [Ss][Ee]* ]] || [[ \$1 = -[Ss][Ee]* ]] || [[ \$1 = --[Ss][Ee]* ]] ; then
		printintro
		entropysequential
	# [we simple] Run simple watch entropy.
	elif [[ \$1 = [Ss]* ]] || [[ \$1 = -[Ss]* ]] || [[ \$1 = --[Ss]* ]] ; then
		printintro
		entropysimple
	# [we verbose] Run verbose watch entropy.
	elif [[ \$1 = [Vv]* ]] || [[ \$1 = -[Vv]* ]] || [[ \$1 = --[Vv]* ]] ; then
		printintro
		bcif
		entropyverbose
	# [] Run default watch entropy.
	elif [[ \$1 = "" ]] ; then
		printintro
		entropysequential
	else
		_PRINTUSAGE_
	fi
	_PRINTTAIL_
	EOM
	chmod 700 usr/bin/we
}

_ADDyt_() {
	_CFLHDR_ root/bin/yt
	printf "%s\\n%s\\n" "[ \"\$UID\" = \"0\" ] && printf \"\\e[1;31m%s\\e[1;37m%s\\e[1;31m%s\\n\" \"Cannot run '\${0##*/}' as root user :\" \" the command 'addauser username' can create user accounts in $INSTALLDIR : the command '$STARTBIN command addauser username' can create user accounts in $INSTALLDIR from Termux : the command '$STARTBIN help' has more information : \" \"exiting...\" && exit" "[ ! -x \"\$(command -v youtube-dl)\" ] && sudo pci youtube-dl && youtube-dl \"\$@\" || youtube-dl \"\$@\" " >> root/bin/yt
	chmod 700 root/bin/yt
}

_PREPPACMANCONF_() {
	if [ -f "$INSTALLDIR"/etc/pacman.conf ] # file is found
	then # rewrite it for the PRoot environment
		sed -i 's/^CheckSpace/\#CheckSpace/g' "$INSTALLDIR/etc/pacman.conf" && sed -i 's/^#Color/Color/g' "$INSTALLDIR/etc/pacman.conf" && sed -i 's/#IgnorePkg   =/IgnorePkg   = systemctl systemd systemd-libs systemd-sysvcompat/g' "$INSTALLDIR/etc/pacman.conf" && sed -i 's/#IgnoreGroup =/IgnoreGroup = systemctl systemd systemd-libs systemd-sysvcompat/g' "$INSTALLDIR/etc/pacman.conf" && sed -i 's/#NoUpgrade   =/NoUpgrade  = systemctl systemd systemd-libs systemd-sysvcompat/g' "$INSTALLDIR/etc/pacman.conf"
	else
		printf "%s%s" "Cannot find file $INSTALLDIR/etc/pacman.conf : " "Signal generated in _PREPPACMANCONF_ archlinuxconfig.bash ${0##*/} : Continuing... "
	fi
}
# archlinuxconfig.bash EOF
