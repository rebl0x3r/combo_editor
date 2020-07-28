#!/bin/bash

# colors

# Reset
rs='\033[m'

# Regular Colors
r='\033[0;31m'
g='\033[0;32m'
y='\033[0;33m'
b='\033[0;34m'
p='\033[0;35m'
c='\033[0;36m'
w='\033[0;37m'

# Background
or='\033[41m'
og='\033[42m'
oy='\033[43m'
ob='\033[44m'
op='\033[45m'
oc='\033[46m'
ow='\033[47m'

# Bold

bd='\033[1m'

# Blink

l='\033[5m'

file=''

while getopts :f:h OPT; do
	case $OPT in
		f)
			file="$OPTARG"
			;;
		h)
			echo -e "Read again!"
			;;
		\?)
			echo -e "invalid"
	esac
done

function main {
	echo -e "
${ob}${bd}  _____           __          ____   ___ __          ${rs}
${ob}${bd} / ___/__  __ _  / /  ___    / __/__/ (_) /____  ____${rs}
${ob}${bd}/ /__/ _ \/  ' \/ _ \/ _ \  / _// _  / / __/ _ \/ __/${rs}
${ob}${bd}\___/\___/_/_/_/_.__/\___/ /___/\_,_/_/\__/\___/_/   ${rs}
${ob}${bd}                                                     ${rs}
                                    ${or}By @LeakerHounds ${rs}
	"
	echo -e "
${bd}${g}File Selected: ${or}$file${rs}
${bd}
${r}1) ${g}Delete Passwords
${r}2) ${g}Delete Emails
${r}3) ${g}Remove Duplicates
${r}4) ${g}Generate Keywords
${r}5) ${g}Remove Bad Lines
${r}6) ${g}Combine Combos
${r}7) ${g}Split Combos
${r}8) ${g}Quit

"
	num=0
	while [ $num = 0 ]
	do
		echo -ne "${r}[${b}~>${r}]${p} "
		read start
		case "$start" in
			1)
				password_remover
				r=1
				;;
			2)
				email_remover
				r=1
				;;
			3)
				remove_duplicate
				r=1
				;;
			4)
				keyword_gen
				r=1
				;;
			5)
				removelines
				r=1
				;;
			6)
				combine_combos
				r=1
				;;
			7)
				splitter
				r=1
				;;
			8)
				exit
				r=1
				;;
			*) echo -e "${y}[${r}!${y}] ${or}Wrong input! >:(.${rs}"
		esac
	done

}

function password_remover {
	echo -e "${bd}"
	echo -e "${y}[${g}*${y}] ${b}${l}Removing passwords...${rs}"
	echo ""
	sleep 1
	tr ':' '\n' < $file > mail.tmp
	grep -i -o '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}' mail.tmp > mail2.tmp
	sort mail2.tmp | uniq -u > emails.txt
	co=$(wc -l emails.txt | awk '{print $1}')
	rm -rf *.tmp
	echo ""
	echo -e "${y}[${g}*${y}] ${r}$co ${b}Email/s extracted."
	echo ""
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

function email_remover {
	echo -e "${bd}"
	echo -e "${y}[${g}*${y}] ${b}${l}Removing mails...${rs}"
	echo ""
	sleep 1
	tr ':' '\n' < $file > pass.tmp
	sed '/@/d' pass.tmp > pass2.tmp
	sort pass2.tmp | uniq -u > passlist.txt
	co=$(wc -l passlist.txt | awk '{print $1}')
	rm -rf *.tmp
	echo ""
	echo -e "${y}[${g}*${y}] ${r}$co ${b}Password/s extracted."
	echo ""
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

function remove_duplicate {
	echo -e "${bd}"
	echo -e "${y}[${g}*${y}] ${b}${l}Removing duplicates...${rs}"
	echo ""
	sleep 1
	awk '!(count[$0]++)' $file > cleared.txt
	echo ""
	echo -e "${y}[${g}*${y}] ${b}Duplicates removed, saved: ${r}$PWD/cleared.txt${rs}"
	echo ""
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

function keyword_gen {
	echo -e "${bd}"
	echo -ne "${y}[${g}*${y}] ${b}How many keywords you want(max. 100.000)?:${c} "
	read count
	echo ""
	echo -e "${y}[${g}*${y}] ${b}This is a text generator, use this for really common keywords leeching."
	echo ""
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	read bck
	cat /usr/share/dict/* > /tmp/full.tmp
	awk '!(count[$0]++)' /tmp/full.tmp > /tmp/keys.txt
	shuf -n $count /tmp/keys.txt > $PWD/keywords.txt
	rm /tmp/keys.txt /tmp/full.tmp
	co=$(wc -l keywords.txt | awk '{print $1}')
	sed -i "s/'//g" keywords.txt
	echo -e "${y}[${g}*${y}] ${r}$co ${b}Keywords saved: ${r}$PWD/keywords.txt${rs}"
	echo ""
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	read bck
	clear
	main
}

function removelines {
	echo -e "${bd}"
	echo -e "${y}[${g}*${y}] ${b}${l}Removing Badlines..."
	echo ""
	sleep 1
	sed -i 's/<//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}< ${b}removed."
	sed -i 's/>//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}> ${b}removed."
	sed -i 's/|//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}| ${b}removed."
	sed -i 's/§//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}§ ${b}removed."
	sed -i 's/$//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}$ ${b}removed."
	sed -i 's/%//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}% ${b}removed."
	sed -i 's/&//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}& ${b}removed."
	sed -i 's/(//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}( ${b}removed."
	sed -i 's/)//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}) ${b}removed."
	sed -i 's/=//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}= ${b}removed."
	sed -i 's/?//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}? ${b}removed."
	sed -i 's/{//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}{ ${b}removed."
	sed -i 's/}//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}} ${b}removed."
	sed -i 's/"["//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}[ ${b}removed."
	sed -i 's/]//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}] ${b}removed."
	sed -i 's/\//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}\ ${b}removed."
	sed -i 's/*//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}* ${b}removed."
	sed -i 's/<//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}! ${b}removed."
	sed -i 's/,//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}, ${b}removed."
	sed -i 's/^$//g' $file 2>err.log
	echo -e "${y}[${g}i${y}] ${b}String :${r}BLANK LINES ${b}removed."
	echo ""
	#sed -i 's/�//g' $file 2>err.log
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

function combine_combos {
	echo -e "${bd}"
	echo -ne "${y}[${g}*${y}] ${b}Enter the file extension(${r}default: ${y}.txt):${c} "
	read ext
	sleep 0.5
	echo -e "${y}[${g}*${y}] ${r}Make also sure you removed your first combo(if yo used)"
	sleep 0.5
	mv $file tmp
	if [ -f cleared.txt ]; then
		mv cleared.txt cleared
	fi
	if [ -f emails.txt ]; then
		mv emails.txt emails
	fi
	if [ -f passlist.txt ]; then
		mv passlist.txt passlist
	fi
	if [ -f keywords.txt ]; then
		mv keywords.txt keywords
	fi

	echo -e "${y}[${g}*${y}] ${b}${l}Combining combos with ${y}${l}$ext${b}${l}..."
	echo ""
	sleep 1
	cat *$ext > combined.txt
	mv tmp $file
	if [ -f cleared ]; then
		mv cleared cleared.txt
	fi
	if [ -f emails ]; then
		mv emails emails.txt
	fi
	if [ -f passlist ]; then
		mv passlist passlist.txt
	fi
	if [ -f keywords ]; then
		mv keywords keywords.txt
	fi

	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

function splitter {
	echo -e "${bd}"
	echo -ne "${y}[${g}*${y}] ${b}Line To Split Combo(${r}default: ${y}10000):${c} "
	read line
	sleep 0.5
	echo -e "${y}[${g}*${y}] ${b}${l}Splitting combo on every ${r}${l}$line${b}${l} line..."
	awk -vc=1 -vb=$line 'NR%b==0{++c}{print $0 > c".txt"}' $file
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}
if [ $# -eq 0 ]; then
	echo -e "${bd}${y}[${r}!${y}] ${or}Please Specify A Combo.${rs}"
	echo ""
	echo -e "${r}
${ob}Example:${r}
${og}./combo_editor.sh -f combo.txt${rs}
	"
else
	clear
	main
fi

#
# developed by
# @themasterch
# join us on
# telegram :
# t.me/viperzcrew
#
