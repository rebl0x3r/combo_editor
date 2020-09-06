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

v="0.6"
file=''
output=''

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
	echo -e "${ob}${bd}  _____           __          ____   ___ __          ${rs}"; sleep 0.2
	echo -e "${ob}${bd} / ___/__  __ _  / /  ___    / __/__/ (_) /____  ____${rs}"; sleep 0.2
	echo -e "${ob}${bd}/ /__/ _ \/  ' \/ _ \/ _ \  / _// _  / / __/ _ \/ __/${rs}"; sleep 0.2
	echo -e "${ob}${bd}\___/\___/_/_/_/_.__/\___/ /___/\_,_/_/\__/\___/_/   ${rs}"; sleep 0.2
	echo -e "${ob}${bd}                                                     ${rs}"; sleep 0.2
	echo -e "                                    ${or}By @LeakerHounds ${rs}"
	echo -e "                                          ${oy}Version ${v}${rs}"
	
echo -e "${bd}${g}File Selected: ${or}$file${rs}"; sleep 0.1
echo -e "${bd}"
echo -e "${r}1) ${g}Delete Passwords"; sleep 0.1
echo -e "${r}2) ${g}Delete Emails"; sleep 0.1
echo -e "${r}3) ${g}Remove Duplicates"; sleep 0.1
echo -e "${r}4) ${g}Generate Keywords"; sleep 0.1
echo -e "${r}5) ${g}Remove Bad Lines"; sleep 0.1
echo -e "${r}6) ${g}Combine Combos"; sleep 0.1
echo -e "${r}7) ${g}Split Combos"; sleep 0.1
echo -e "${r}8) ${g}Extract USER:PASS"; sleep 0.1
echo -e "${r}9) ${g}USER:PASS to PASS:USER"; sleep 0.1
echo -e "${r}10) ${g}Soft Randomize Combos"; sleep 0.1
echo -e "${r}11) ${g}Hard Randomize Combos"; sleep 0.1
echo -e "${r}12) ${g}Sort Domains(+1mio)"; sleep 0.1
echo -e "${r}13) ${g}Extract Creditcard Data From A File|Combo"; sleep 0.1

echo -e "${r}exit|e) ${g}Quit\n\n"; sleep 0.1

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
				extracter
				r=1
				;;
			9)
				passuser
				r=1
				;;
			10)
				soft_mix
				r=1
				;;
			11)
				hard_mix
				r=1
				;;
			12)
				domain_sorter
				r=1
				;;
			13)
				cc_extractor
				r=1
				;;
			exit|e)
				exit
				r=1
				;;
			*) echo -e "${y}[${r}!${y}] ${or}Wrong input! >:(.${rs}"
		esac
	done

}

password_remover(){
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

email_remover(){
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

remove_duplicate(){
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

keyword_gen(){
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

removelines(){
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
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

combine_combos(){
	echo -e "${bd}"
	echo -ne "${y}[${g}*${y}] ${b}Enter the file extension(${r}default: ${y}.txt${b}):${c} "
	read ext
	sleep 0.5
	echo -e "${y}[${g}*${y}] ${r}Make also sure you removed your first combo(if you used)"
	sleep 0.5
	mv ${file} tmp
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

	echo -e "${r}[${b}>${r}] Saved as ${y}combined.txt"; sleep 0.1
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

splitter(){
	echo -e "${bd}"
	echo -ne "${y}[${g}*${y}] ${b}Line To Split Combo(${r}default: ${y}10000${b}):${c} "
	read line
	sleep 0.5
	echo -e "${y}[${g}*${y}] ${b}${l}Splitting combo on every ${r}${l}$line${b}${l} line..."
	awk -vc=1 -vb=$line 'NR%b==0{++c}{print $0 > c".txt"}' ${file}
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

extracter(){
	echo -e "${bd}"
	echo -ne "${y}[${g}*${y}] ${b}Enter user:pass filename as result(${r}default: ${y}userpass.txt${b}):${c} "
	read pass
	grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]+\b" $file | sed 's/:/ :/g' | sed 's/@/ /g' | awk '{print $1 $3}' >> $pass
	echo -e "${r}[${b}>${r}] ${w}Saved as ${y}${pass}"; sleep 0.1
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

passuser(){
	echo -e "${bd}"
	echo -ne "${y}[${g}*${y}] ${b}Enter the input filename which has been saved on the directory(${r}default: ${y}userpass.txt${b}):${c} "
	read input
	echo -ne "${y}[${g}*${y}] ${b}Enter the output filename(${r}default: ${y}passuser.txt${b}):${c} "
	read output
	cat $input | sed 's/:/ /' | awk '{print $2 ":" $1}' >> $output
	echo -e "${r}[${b}>${r}] ${w}Saved as ${y}${output}"; sleep 0.1
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

hard_mix(){
	echo -e "${bd}"
	echo -e "${y}[${g}*${y}] ${b}Counting lines..."; sleep 0.4
	c=$(wc -l ${file} | awk '{print $1}')
	sort -R ${file} | head -${c} >> hard_randomized.txt
	echo -e "${r}[${b}>${r}] ${w}Saved as ${y}hard_randomized.txt"; sleep 0.1
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

soft_mix(){
	echo -e "${bd}"
	echo -e "${y}[${g}*${y}] ${b}Counting lines..."; sleep 0.4
	c=$(wc -l ${file} | awk '{print $1}')
	shuf -n ${c} ${file} > soft_randomized.txt
	echo -e "${r}[${b}>${r}] ${w}Saved as ${y}soft_randomized.txt"; sleep 0.1
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

domain_sorter(){
	echo -e "${bd}"
	echo -e "${y}[${g}*${y}] ${b}Loading the configuration file, hold on.."; sleep 0.3
	echo -e "${y}[${g}*${y}] ${b}Loaded over 1 million domains, the process could take some minutes, be patatient!"; sleep 0.2
	echo -ne "${r}[${b}>${r}] \033[3;33mPress [Enter] - This Take Some Time"
	read start
	if [ -d sorted_domains ]; then
		cd sorted_domains
	else
		mkdir sorted_domains; cd sorted_domains
	fi
	if [ -f sorted_domains/temp.txt ]; then
		echo -e "${y}[${g}*${y}] ${b}Removing old results.."; sleep 0.3
		rm -rf sorted_domains/*.txt
	fi
	while read line
	do
		
		g=$(cat ../${file} | grep ${line})
		if [[ "${g}" == "" ]]; then
			echo -e "${line}" > /dev/null
		else
			echo -e "${g}" >> ${line}.txt
		fi
		echo -e "${y}[${g}*${y}] ${b}Sorted Domain ${y}${line}" 
	done < ../email.conf

	if [ -f sorted.txt ]; then
		rm -rf sorted.txt
	fi

	for line in $(ls);
	do
		wc -l ${line} >> sorted.txt
	done
	
	while read line
	do
		count=$(echo ${line} | cut -d\  -f1)
		file=$(echo ${line} | cut -d\  -f2)
		if [[ "$count" == 0 ]]; then
			rm ${file} 2>/dev/null
		fi
	done < sorted.txt

	cd ..
	echo -e "${r}[${b}>${r}] ${w}The domain sorter saved the emails by ${y}domain"; sleep 0.1
	echo -e "${r}[${g}>${r}] ${w}You can find them in the ${y} "; sleep 0.1
	echo -e "${r}[${b}>${r}] \033[3;33mPress Enter"
	echo ""
	read bck
	clear
	main
}

cc_extractor(){
	echo -e "${y}[${g}*${y}] ${b}Extracting Creditcard Data from the File"; sleep 0.3
	if [ -d credit_data ]; then
		cd credit_data
	else
		mkdir credit_data; cd credit_data
	fi
	echo -e "${y}[${g}*${y}] ${b}Sometimes it's a little bit buggy, but you can find the results on ${w}credit_data ${b}folder"
	echo -e "${y}[${g}*${y}] ${b}Visa..."; sleep 0.1
	grep -E "4[0-9]{3}[ -]?[0-9]{4}[ -]?[0-9]{4}[ -]?[0-9]{4}" ../${file} > visa.txt 2>/dev/null
	echo -e "${y}[${g}*${y}] ${b}MasterCard..."; sleep 0.1
	grep -E "5[0-9]{3}[ -]?[0-9]{4}[ -]?[0-9]{4}[ -]?[0-9]{4}" ../${file} > mastercard.txt 2>/dev/null
	echo -e "${y}[${g}*${y}] ${b}American Express..."; sleep 0.1
	grep -E "\b3[47][0-9]{13}\b" ../${file} > american-express.txt 2>/dev/null
	echo -e "${y}[${g}*${y}] ${b}Dinners Club..."; sleep 0.1
	grep -E "\b3(?:0[0-5]|[68][0-9])[0-9]{11}\b" ../${file} > diners.txt 2>/dev/null
	echo -e "${y}[${g}*${y}] ${b}Discover..."; sleep 0.1
	grep -E "6011[ -]?[0-9]{4}[ -]?[0-9]{4}[ -]?[0-9]{4}" ../${file} > discover.txt 2>/dev/null
	echo -e "${y}[${g}*${y}] ${b}AMEX 2.0..."; sleep 0.1
	grep -E "3[47][0-9]{2}[ -]?[0-9]{6}[ -]?[0-9]{5}" ../${file} > amex.txt 2>/dev/null
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
