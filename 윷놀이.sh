#!/bin/bash

cls()
{
	tput cup 0 0
	tput ed
}

print_xy()
{
	tput cup $1 $2
	echo -en $3
}

message()
{
	tput cup 35 15
	tput el
	echo -n $1
}

display()
{
	for i in {1..19} {25..29} {35..39}	# 보드 초기화
	do
		tput cup ${god[$i]} ${duf[$i]}
		echo "    "
		tput cup `expr ${god[$i]} + 1` ${duf[$i]}
		echo "    "
	done

	print_xy 2 70 "\e[${tor1}m<$dlfma1>\e[0m"
	tput el
	for i in {1..4}
	do
		if [ "${akf1[$i]}" = "0" ]
		then
			echo -en "\e[${tor1}m ● $i\e[0m"
		else
			echo -n "    "
		fi
	done

	if [ "${akf1[1]}" = "20" ] || [ "${akf1[2]}" = "20" ] || [ "${akf1[3]}" = "20" ] || [ "${akf1[4]}" = "20" ]	# 나간 말이 있을 때만
	then
		print_xy 3 70 "\e[${tor1}m도착 =\e[0m"
		tput el
		for i in {1..4}
		do
			if [ "${akf1[$i]}" = "20" ]
			then
				echo -en "\e[${tor1}m ● $i\e[0m"
			else
				echo -n "    "
			fi
		done
	fi

	print_xy 31 70 "\e[${tor2}m<$dlfma2>\e[0m"
	tput el
	for i in {1..4}
	do
		if [ "${akf2[$i]}" = "0" ]
		then
			echo -en "\e[${tor2}m ● $i\e[0m"
		else
			echo -n "    "
		fi
	done

	if [ "${akf2[1]}" = "20" ] || [ "${akf2[2]}" = "20" ] || [ "${akf2[3]}" = "20" ] || [ "${akf2[4]}" = "20" ]	# 나간 말이 있을 때만
	then
		print_xy 30 70 "\e[${tor2}m도착 =\e[0m"
		tput el
		for i in {1..4}
		do
			if [ "${akf3[$i]}" = "20" ]
			then
				echo -en "\e[${tor2}m ● $i\e[0m"
			else
				echo -n "    "
			fi
		done
	fi

	for i in {1..4}
	do
		if [ "${akf1[$i]}" != "0" ] && [ "${akf1[$i]}" != "20" ]	# 보드 위에 있으면
		then
			tmp=0
			for j in {1..4}	# 업힌 말이 있는지 확인
			do
				if [ "${akf1[$i]}" = "${akf1[$j]}" ]
				then
					let "tmp += 1"
				fi
			done
			if [ "$tmp" = "1" ]	# 업힌 말이 없으면
			then
				print_xy ${god[${akf1[$i]}]} ${duf[${akf1[$i]}]} "\e[${tor1}m● $i\e[0m"
			else
				print_xy ${god[${akf1[$i]}]} ${duf[${akf1[$i]}]} "\e[${tor1}m● x$tmp\e[0m"
				tput cup `expr ${god[${akf1[$i]}]} + 1` ${duf[${akf1[$i]}]}
				for j in {1..4}
				do
					if [ "${akf1[$i]}" = "${akf1[$j]}" ]
					then
						echo -en "\e[${tor1}m$j\e[0m"
					fi
				done
			fi
		fi
	done

	for i in {1..4}
	do
		if [ "${akf2[$i]}" != "0" ] && [ "${akf2[$i]}" != "20" ]	# 보드 위에 있으면
		then
			tmp=0
			for j in {1..4}	# 업힌 말이 있는지 확인
			do
				if [ "${akf2[$i]}" = "${akf2[$j]}" ]
				then
					let "tmp += 1"
				fi
			done
			if [ "$tmp" = "1" ]	# 업힌 말이 없으면
			then
				print_xy ${god[${akf2[$i]}]} ${duf[${akf2[$i]}]} "\e[${tor2}m● $i\e[0m"
			else
				print_xy ${god[${akf2[$i]}]} ${duf[${akf2[$i]}]} "\e[${tor2}m● x$tmp\e[0m"
				tput cup `expr ${god[${akf2[$i]}]} + 1` ${duf[${akf2[$i]}]}
				for j in {1..4}
				do
					if [ "${akf2[$i]}" = "${akf2[$j]}" ]
					then
						echo -en "\e[${tor2}m$j\e[0m"
					fi
				done
			fi
		fi
	done
}

dbc()
{
	display
	message "스페이스 키를 눌러 윷을 던지세요."
	while [ true ]
	do
		read -s -n 1 key
		case $key
		in
		q|Q) dbc=(0 0 0 1);;
		w|W) dbc=(0 0 1 1);;
		e|E) dbc=(0 1 1 1);;
		r|R) dbc=(1 1 1 1);;
		t|T) dbc=(0 0 0 0);;
		y|Y) dbc=(1 0 0 0);;
		*)
			if [ ! $key ]
			then
				dbc=(`expr $RANDOM % 2` `expr $RANDOM % 2` `expr $RANDOM % 2` `expr $RANDOM % 2`)	# 랜덤
			else	# 공백과 치트키를 제외한 나머지
				continue
			fi
		esac
		break
	done
	case `echo "${dbc[0]} + ${dbc[1]} + ${dbc[2]} + ${dbc[3]}" | bc`	# 윷모 이펙트
	in
	4)
		message ""
		for i in 31 34 32 33
		do
			echo -e "\e[${i}m"
			tput cup 11 71
			echo "┌───┐ ┌───┐ ┌───┐ ┌───┐"
			tput cup 12 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 13 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 14 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 15 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 16 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 17 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 18 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 19 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 20 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 21 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 22 71
			echo "└───┘ └───┘ └───┘ └───┘"
			sleep 0.3
			echo -e "\e[0m"
		done
	;;
	0)
		message ""
		for i in 31 34 32 33
		do
			echo -e "\e[${i}m"
			tput cup 11 71
			echo "┌───┐ ┌───┐ ┌───┐ ┌───┐"
			tput cup 12 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 13 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 14 71
			echo "│ X │ │ X │ │ X │ │ X │"
			tput cup 15 71
			echo "│ X │ │ X │ │ X │ │ X │"
			tput cup 16 71
			echo "│ X │ │ X │ │ X │ │ X │"
			tput cup 17 71
			echo "│ X │ │ X │ │ X │ │ X │"
			tput cup 18 71
			echo "│ X │ │ X │ │ X │ │ X │"
			tput cup 19 71
			echo "│ X │ │ X │ │ X │ │ X │"
			tput cup 20 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 21 71
			echo "│   │ │   │ │   │ │   │"
			tput cup 22 71
			echo "└───┘ └───┘ └───┘ └───┘"
			sleep 0.3
			echo -e "\e[0m"
		done
	;;
	esac
	for i in {0..3}	# 윷그리기
	do
		if [ "${dbc[$i]}" = "0" ]	# 앞면=1, 뒷면=0
		then
			for j in {14..19}
			do
				print_xy $j `echo "72 + $i * 6" | bc` "\e[33m X \e[0m"
			done
		else
			for j in {14..19}
			do
				tput cup $j `echo "72 + $i * 6" | bc`
				echo "   "
			done
		fi
	done
	if [ "${dbc[0]}" = "1" ] && [ "${dbc[1]}" = "0" ] && [ "${dbc[2]}" = "0" ]	&& [ "${dbc[3]}" = "0" ]	# 빽도일 경우
	then
		for i in {14..19}
		do
			print_xy $i 72 "\e[31m b \e[0m"
		done
	fi
}

move1()
{
	unset re
	message "이동할 말을 선택해주세요."
	for i in {1..4}
	do
		if [ "${akf1[$i]}" != "20" ]
		then
			echo -n " $i)"
		fi
	done
	while [ true ]
	do
		read -s -n 1 key
		key=${key//[^1-4]/}	# 1~4 빼고 삭제
		if [ $key ] && [ "${akf1[$key]}" != "20" ]
		then
			break
		fi
	done

	tmp=${akf1[$key]}
	case $tmp
	in
	5) tmp=24;;	# 모
	10) tmp=34;;	# 뒷모
	27) tmp=37;;	# 방
	esac
	case `echo "${dbc[0]} + ${dbc[1]} + ${dbc[2]} + ${dbc[3]}" | bc`
	in
	1) let "tmp += 1";;
	2) let "tmp += 2";;
	3) let "tmp += 3";;
	4) let "tmp += 4"; re=.;;
	0) let "tmp += 5"; re=.;;
	esac
	if (( "$tmp" > "29" )) && (( "$tmp" < "35" ))	# 날밭
	then
		let "tmp -= 15"
	fi

	if [ "$tmp" = "37" ]
	then
		tmp=27
	fi

	if (( "$tmp" > "20" )) && (( "$tmp" < "25" ))
	then
		tmp=20
	fi
	if (( "$tmp" >= "40" )) && (( "$tmp" < "45" ))
	then
		tmp=20
	fi

	if [ "${akf1[$key]}" != "0" ]
	then
		for i in {1..4}	# 업힌 말이 있으면 같이 이동
		do
			if [ "$key" != "$i" ] && [ "${akf1[$key]}" = "${akf1[$i]}" ]
			then
				akf1[$i]=$tmp
			fi
		done
	fi
	akf1[$key]=$tmp

	for i in {1..4}
	do
		if [ "${akf1[$key]}" = "${akf2[$i]}" ] && [ "${akf1[key]}" != "20" ]	# 말잡기
		then
			akf2[$i]=0
			re=.
		fi
	done
}

move1_back()
{
	unset re
	message "이동할 말을 선택해주세요."
	tmp=0
	for i in {1..4}
	do
		if [ "${akf1[$i]}" != "0" ] && [ "${akf1[$i]}" != "20" ]
		then
			echo -n " $i)"
			tmp=1
		fi
	done
	if [ "$tmp" = "0" ]	# 움직일 수 있는 말이 없을 때
	then
		message "움직일 수 있는 말이 없습니다. 다음 턴으로 넘어갑니다."
		sleep 3
		return
	fi
	while [ true ]
	do
		read -s -n 1 key
		key=${key//[^1-4]/}	# 1~4 빼고 삭제
		if [ $key ] && [ "${akf1[$key]}" != "0" ] && [ "${akf1[$key]}" != "20" ]
		then
			break
		fi
	done

	tmp=${akf1[$key]}
	let "tmp -= 1"
	case $tmp
	in
	0) tmp=20;;	# 도
	24) tmp=5;;	# 앞모도
	34) tmp=10;;	# 뒷모도
	esac

	if [ "$tmp" = "37" ]
	then
		tmp=27
	fi

	if [ "${akf1[$key]}" != "0" ]
	then
		for i in {1..4}	# 업힌 말이 있으면 같이 이동
		do
			if [ "$key" != "$i" ] && [ "${akf1[$key]}" = "${akf1[$i]}" ]
			then
				akf1[$i]=$tmp
			fi
		done
	fi
	akf1[$key]=$tmp

	for i in {1..4}
	do
		if [ "${akf1[$key]}" = "${akf2[$i]}" ] && [ "${akf1[key]}" != "20" ]	# 말잡기
		then
			akf2[$i]=0
			re=.
		fi
	done
}

move2()
{
	unset re
	message "이동할 말을 선택해주세요."
	for i in {1..4}
	do
		if [ "${akf2[$i]}" != "20" ]
		then
			echo -n " $i)"
		fi
	done
	while [ true ]
	do
		read -s -n 1 key
		key=${key//[^1-4]/}	# 1~4 빼고 삭제
		if [ $key ] && [ "${akf2[$key]}" != "20" ]
		then
			break
		fi
	done

	tmp=${akf2[$key]}
	case $tmp
	in
	5) tmp=24;;	# 모
	10) tmp=34;;	# 뒷모
	27) tmp=37;;	# 방
	esac
	case `echo "${dbc[0]} + ${dbc[1]} + ${dbc[2]} + ${dbc[3]}" | bc`
	in
	1) let "tmp += 1";;
	2) let "tmp += 2";;
	3) let "tmp += 3";;
	4) let "tmp += 4"; re=.;;
	0) let "tmp += 5"; re=.;;
	esac
	if (( "$tmp" > "29" )) && (( "$tmp" < "35" ))	# 날밭
	then
		let "tmp -= 15"
	fi

	if [ "$tmp" = "37" ]
	then
		tmp=27
	fi

	if (( "$tmp" > "20" )) && (( "$tmp" < "25" ))
	then
		tmp=20
	fi
	if (( "$tmp" >= "40" )) && (( "$tmp" < "45" ))
	then
		tmp=20
	fi

	if [ "${akf2[$key]}" != "0" ]
	then
		for i in {1..4}	# 업힌 말이 있으면 같이 이동
		do
			if [ "$key" != "$i" ] && [ "${akf2[$key]}" = "${akf2[$i]}" ]
			then
				akf2[$i]=$tmp
			fi
		done
	fi
	akf2[$key]=$tmp

	for i in {1..4}
	do
		if [ "${akf2[$key]}" = "${akf1[$i]}" ] && [ "${akf2[key]}" != "20" ]	# 말잡기
		then
			akf1[$i]=0
			re=.
		fi
	done
}

move2_back()
{
	unset re
	message "이동할 말을 선택해주세요."
	tmp=0
	for i in {1..4}
	do
		if [ "${akf2[$i]}" != "0" ] && [ "${akf2[$i]}" != "20" ]
		then
			echo -n " $i)"
			tmp=1
		fi
	done
	if [ "$tmp" = "0" ]	# 움직일 수 있는 말이 없을 때
	then
		message "움직일 수 있는 말이 없습니다. 다음 턴으로 넘어갑니다."
		sleep 3
		return
	fi
	while [ true ]
	do
		read -s -n 1 key
		key=${key//[^1-4]/}	# 1~4 빼고 삭제
		if [ $key ] && [ "${akf2[$key]}" != "0" ] && [ "${akf2[$key]}" != "20" ]
		then
			break
		fi
	done

	tmp=${akf2[$key]}
	let "tmp -= 1"
	case $tmp
	in
	0) tmp=20;;	# 도
	24) tmp=5;;	# 앞모도
	34) tmp=10;;	# 뒷모도
	esac

	if [ "$tmp" = "37" ]
	then
		tmp=27
	fi

	if [ "${akf2[$key]}" != "0" ]
	then
		for i in {1..4}	# 업힌 말이 있으면 같이 이동
		do
			if [ "$key" != "$i" ] && [ "${akf2[$key]}" = "${akf2[$i]}" ]
			then
				akf2[$i]=$tmp
			fi
		done
	fi
	akf2[$key]=$tmp

	for i in {1..4}
	do
		if [ "${akf2[$key]}" = "${akf1[$i]}" ] && [ "${akf2[key]}" != "20" ]	# 말잡기
		then
			akf1[$i]=0
			re=.
		fi
	done
}

game_over()	# 게임오버화면
{
	cls
	tput cup 15 0
	echo '                         ___     _    __  __ _____ _____     ______ ____'
	echo '                        / __|   / \  |  \/  | ____/ _ \ \   / / ___|  _ \'
	echo '                       | |  _  / _ \ | |\/| |  _|| | | \ \ / /|  _|| |_) |'
	echo '                       | |_| |/ ___ \| |  | | |__| |_| |\ V / | |__|  _ <'
	echo '                        \____/_/   \_\_|  |_|_____\___/  \_/  |____|_| \_\'
	print_xy 22 42 "$1"
	sleep 3
	print_xy 31 32 "종료하려면 스페이스 키를 눌러주세요."
	read -s -d ' '
	reset
	exit
}

reset	# 쉘초기화
tput civis	# 커서 안보이게
stty -echo	# 키보드 입력이 안보이게

# 로딩화면
key=.
while [ $key ]
do
	cls
	echo "┌────────────────────────────────────────────────────────────────────────────────────────────────┐"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                              __   __     _                     _                               │"
	echo "│                              \ \ / /   _| |_ _ __   ___  _ __ (_)                              │"
	echo "│                               \ V / | | | __| '_ \ / _ \| '__|| |                              │"
	echo "│                                | || |_| | |_| | | | (_) | |   | |                              │"
	echo "│                                |_| \__,_|\__|_| |_|\___/|_|   |_|                              │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│        이 화면이 깨지지 않을 때까지 아무 키를 눌러 새로고침하며 창 크기를 조절해주세요.        │"
	echo "│                                                                                                │"
	echo -e "│                              \e[1m계속하려면 스페이스 키를 눌러주세요.\e[0m                              │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "│                                                                                                │"
	echo "└────────────────────────────────────────────────────────────────────────────────────────────────┘"
	read -s -n 1 key
done

# 1P 컬러선택
cls
print_xy 14 43 "\e[31m<1P>\e[0m 컬러 선택"
print_xy 16 43 "1. \e[33m● 노랑\e[0m"
print_xy 17 43 "2. \e[31m● 빨강\e[0m"
print_xy 18 43 "3. \e[34m● 파랑\e[0m"
print_xy 19 43 "4. \e[32m● 초록\e[0m"
print_xy 21 32 "번호 입력"
while [ true ]
do
	tput cup 22 32
	read -s -n 1 -p ">> " key
	case $key
	in
	1) tor1=33;;
	2) tor1=31;;
	3) tor1=34;;
	4) tor1=32;;
	*)
		if [ $tor1 ] && [ ! $key ]	# 컬러가 지정된 상태에서 엔터를 쳐야만 다음으로 넘어감
		then
			break
		fi;;
	esac
	case $tor1
	in
	33) echo -en "\e[33m노랑\e[0m";;
	31) echo -en "\e[31m빨강\e[0m";;
	34) echo -en "\e[34m파랑\e[0m";;
	32) echo -en "\e[32m초록\e[0m";;
	esac
done

# 2P 컬러선택
print_xy 14 43 "\e[34m<2P>\e[0m"
tput cup 22 0
tput el
while [ true ]
do
	tput cup 22 32
	read -s -n 1 -p ">> " key
	tput el
	case $key
	in
	1) tor2=33;;
	2) tor2=31;;
	3) tor2=34;;
	4) tor2=32;;
	*)
		if [ $tor1 ] && [ ! $key ]
		then
			break
		fi;;
	esac
	if [ "$tor1" = "$tor2" ]	# 중복확인
	then
		echo -en "\e[35m이미 선택됨\e[0m"
		tor2=
	else
		case $tor2
		in
		33) echo -en "\e[33m노랑\e[0m";;
		31) echo -en "\e[31m빨강\e[0m";;
		34) echo -en "\e[34m파랑\e[0m";;
		32) echo -en "\e[32m초록\e[0m";;
		esac
	fi
done

# 1P 이름정하기
cls
print_xy 16 38 "\e[${tor1}m<1P>\e[0m 이름 :"
while [ ! $dlfma1 ]
do
	tput cup 16 50
	stty echo
	read dlfma1
	stty -echo
done

# 2P 이름정하기
print_xy 20 38 "\e[${tor2}m<2P>\e[0m 이름 :"
while [ ! $dlfma2 ]
do
	tput cup 20 50
	tput el
	stty echo
	read dlfma2
	stty -echo
	if [ "$dlfma1" = "$dlfma2" ]	# 중복확인
	then
		print_xy 20 50 "\e[35m중복된 이름\e[0m"
		read -s -n 1
		dlfma2=
	fi
done

# 게임화면
cls
echo -e "┌─────┐     ┌─────┐     ┌─────┐     ┌─────┐     ┌─────┐     ┌─────┐"
echo -e "│     │─────│     │─────│     │─────│     │─────│     │─────│     │"
echo -e "│     │─────│     │─────│     │─────│     │─────│     │─────│     │"
echo -e "└─────┘     └─────┘     └─────┘     └─────┘     └─────┘     └─────┘"
echo -e "  │ │  \ \                                               / /  │ │"
echo -e "  │ │     ┌─────┐                                 ┌─────┐     │ │"
echo -e "┌─────┐   │     │                                 │     │   ┌─────┐"
echo -e "│     │   │     │                                 │     │   │     │"
echo -e "│     │   └─────┘                                 └─────┘   │     │"
echo -e "└─────┘          \ \                           / /          └─────┘"
echo -e "  │ │               ┌─────┐             ┌─────┐               │ │"
echo -e "  │ │               │     │             │     │               │ │      \e[33m┌───┐ ┌───┐ ┌───┐ ┌───┐\e[0m"
echo -e "┌─────┐             │     │             │     │             ┌─────┐    \e[33m│   │ │   │ │   │ │   │\e[0m"
echo -e "│     │             └─────┘             └─────┘             │     │    \e[33m│   │ │   │ │   │ │   │\e[0m"
echo -e "│     │                    \ \       / /                    │     │    \e[33m│ X │ │ x │ │ x │ │ x │\e[0m"
echo -e "└─────┘                       ┌─────┐                       └─────┘    \e[33m│ X │ │ x │ │ x │ │ x │\e[0m"
echo -e "  │ │                         │     │                         │ │      \e[33m│ X │ │ x │ │ x │ │ x │\e[0m"
echo -e "  │ │                         │     │                         │ │      \e[33m│ X │ │ x │ │ x │ │ x │\e[0m"
echo -e "┌─────┐                       └─────┘                       ┌─────┐    \e[33m│ X │ │ x │ │ x │ │ x │\e[0m"
echo -e "│     │                    / /       \ \                    │     │    \e[33m│ X │ │ x │ │ x │ │ x │\e[0m"
echo -e "│     │             ┌─────┐             ┌─────┐             │     │    \e[33m│   │ │   │ │   │ │   │\e[0m"
echo -e "└─────┘             │     │             │     │             └─────┘    \e[33m│   │ │   │ │   │ │   │\e[0m"
echo -e "  │ │               │     │             │     │               │ │      \e[33m└───┘ └───┘ └───┘ └───┘\e[0m"
echo -e "  │ │               └─────┘             └─────┘               │ │"
echo -e "┌─────┐          / /                           \ \          ┌─────┐"
echo -e "│     │   ┌─────┐                                 ┌─────┐   │     │"
echo -e "│     │   │     │                                 │     │   │     │"
echo -e "└─────┘   │     │                                 │     │   └─────┘"
echo -e "  │ │     └─────┘                                 └─────┘     │ │"
echo -e "  │ │  / /                                               \ \  │ │"
echo -e "┌─────┐     ┌─────┐     ┌─────┐     ┌─────┐     ┌─────┐     ┌─────┐"
echo -e "│     │─────│     │─────│     │─────│     │─────│     │─────│     │"
echo -e "│     │─────│     │─────│     │─────│     │─────│     │─────│     │"
echo -e "└─────┘     └─────┘     └─────┘     └─────┘     └─────┘     └─────┘"

akf1=("" 0 0 0 0)	# 각 말의 위치는 숫자로 표시
akf2=("" 0 0 0 0)	# 0=아직출발안함, 5=모, 10=뒷모, 20=도착, 27=37=방, 30~34=날밭
#     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44
god=("" 25 19 13  7  1  1  1  1  1  1  7 13 19 25 31 31 31 31 31 "" "" "" "" ""  6 11 16 21 26 "" "" "" "" ""  6 11 16 21 26 "" "" "" "" "")
duf=("" 61 61 61 61 61 49 37 25 13  1  1  1  1  1  1 13 25 37 49 "" "" "" "" "" 51 41 31 21 11 "" "" "" "" "" 11 21 31 41 51 "" "" "" "" "")

while [ true ]
do
# 1P 턴
	print_xy 24 78 "\e[${tor1}m<1P>\e[0m 차례"
	re=.
	while [ $re ]
	do
		dbc
		if [ "${dbc[0]}" = "1" ] && [ "${dbc[1]}" = "0" ] && [ "${dbc[2]}" = "0" ] && [ "${dbc[3]}" = "0" ]	# 빽도일 경우
		then
			move1_back
		else
			move1
		fi
		if [ "${akf1[1]}" = "20" ] && [ "${akf1[2]}" = "20" ] && [ "${akf1[3]}" = "20" ] && [ "${akf1[4]}" = "20" ]
		then
			game_over "\e[${tor1}m<$dlfma1>\e[0m \e[1m승리!!!\e[0m"
		fi
	done

# 2P 턴
	print_xy 24 78 "\e[${tor2}m<2P>\e[0m 차례"
	re=.
	while [ $re ]
	do
		dbc
		if [ "${dbc[0]}" = "1" ] && [ "${dbc[1]}" = "0" ] && [ "${dbc[2]}" = "0" ] && [ "${dbc[3]}" = "0" ]	# 빽도일 경우
		then
			move2_back
		else
			move2
		fi
		if [ "${akf2[1]}" = "20" ] && [ "${akf2[2]}" = "20" ] && [ "${akf2[3]}" = "20" ] && [ "${akf2[4]}" = "20" ]
		then
			game_over "\e[${tor2}m<$dlfma2>\e[0m \e[1m승리!!!\e[0m"
		fi
	done
done
