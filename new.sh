#!/bin/bash
FILE=~/.dosprint
INPUT=/tmp/menu.sh.$$
OUTPUT="/tmp/input.txt"
printnya=~/.dosprint
FSER=/smb/admtoko/data/sls2002
FIN=$HOME/.tmp
SOUR=$HOME/.tmp
DIRV=$HOME/Desktop/out
bln=$(date +-%m-%g)
ext=.txt
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
ver=2.1
SAYA=$(whoami);
#ipclient=$(echo $SSH_CLIENT |awk '{print $1 }')
#tu=$(echo -n "ip: " && read ip );
#SSH_CLIENT=$(ifconfig);
#-- Variable Hari
aku=@dhii_mr
ipclient=$(ip route get 1 | awk '{print $NF;exit}')
date=$(date +%u)
case $date in
1)HARI=Senen;;
2)HARI=Seloso;;
3)HARI=Rebo;;
4)HARI=Kemes;;
5)HARI=Jumat;;
6)HARI=Setu;;
7)HARI=Minggu;;
esac

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0
display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

###############################################################
#Jalankan Menu SPV
###############################################################
function spv {
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
while true
do
dialog --clear --begin 5 8  --no-cancel --backtitle \
 "$HARI,$(date "+%d"-"%m"-"%Y") | IP:$ipclient | USER:$SAYA | MOD-BY :$aku | VER:$ver"   \
--title " <> ==== [ MENU SPV R52 ] ==== <> " \
--menu "" 9  72 13 \
1.SPV-R		"MENU R          " \
2.SPV-S		"MENU S            " \
3.BACK		"Kembali Ke menu Utama                      " 2>"${INPUT}"
ret=$?
case $ret in
  255)rm -f $INPUT; return;;
esac
menuitem=$(<"${INPUT}")
# make decision 
case $menuitem in
        1.SPV-R)ssh r52.spv@172.19.52.250 ;;
        2.SPV-S)ssh s052.spv@172.19.52.250 ;;
        3.BACK) return;;
esac
done
}
###############################################################
#Jalankan Menu SPV
###############################################################
function SCP {
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
while true
do
dialog --clear --begin 5 8  --no-cancel --backtitle \
 "$HARI,$(date "+%d"-"%m"-"%Y") | IP:$ipclient | USER:$SAYA | MOD-BY :$aku | VER:$ver"   \
--title " <> ==== [ MENU RSYNC ] ==== <> " \
--menu "" 12  72 13 \
1.COPY		"Copy File           " \
2.TRANS		"Transfer File            " \
3.BACK		"Kembali Ke menu Utama                      " 2>"${INPUT}"
ret=$?
case $ret in
  255)rm -f $INPUT; return;;
esac
menuitem=$(<"${INPUT}")
# make decision 
case $menuitem in
        1.COPY)cpy
		result=$(less $HOME/scp.log)
		rm $HOME/scp.log
		display_result "Done";;
        2.TRANS)cpi
		result=$(less $HOME/scp.log)
		rm $HOME/scp.log
		display_result "Done";;
        3.BACK) return;;
esac
done
}
function cpyy {
                echo -n "USER : "
                read us
                echo -n "IP TARGET : 172.19.52."
                read ipi
                echo " FOLDER/FILE TARGET :"
		echo -n "$HOME/"
                read fol
                echo " FOLDER/FILE TUJUAN :"
                echo -n "$HOME/"
                read fold
		echo "rsync -avzPO $us@172.19.52.$ipi:~/$fol $HOME/$fold"
                rsync -avzPO $us@172.19.52.$ipi:$fol $HOME/$fold >> $HOME/scp.log
}
function cpy {
	trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM
	dialog --title "MASUKKAN USER" \
	--backtitle "SUKA SUKA AKULAH" \
	--inputbox "MASUKKAN USER " 8 60 2>$OUTPUT

	respose=$?
	us=$(<$OUTPUT)
	dialog --title "IP BOS IP....!!!" \
	--backtitle "exp : 172.19.52.1" \
	--inputbox "MASUKKAN IP " 8 60 2>$OUTPUT

	respose=$?
	ipi=$(<$OUTPUT)
	dialog --title "FOLDER ATAU FILE TARGET" \
	--backtitle "Example : Desktop/contoh.pdf" \
	--inputbox "MASUKKAN IP " 8 60 2>$OUTPUT

	respose=$?
	fol=$(<$OUTPUT)
	dialog --title "FOLDER ATAU FILE TUJUAN" \
	--backtitle "Example : Desktop/" \
	--inputbox "MASUKKAN IP " 8 60 2>$OUTPUT

	respose=$?
	fold=$(<$OUTPUT)
	case $respose in
	  0)rsync -avzPO $us@$ipi:~/$fol $HOME/$fold >> $HOME/scp.log;return;;
	  1) 
	  	echo "Cancel pressed." ;;
	  255) 
	   echo "[ESC] key pressed.";;
	esac
}
function cpi {
                echo " FOLDER/FILE SUMBER :"
		echo -n "$HOME/"
                read fol
                echo -n "USER : "
                read us
                echo -n "IP TARGET : 172.19.52."
                read ipi
                echo " FOLDER/FILE TUJUAN :"
                echo -n "~/"
                read fold
		echo "rsync -avzPO $HOME/$fol $us@172.19.52.$ipi:~/$fold"
                rsync -avzPO $HOME/$fol $us@172.19.52.$ipi:~/$fold >> scp.log
}
###############################################################
#Jalankan Menu SSH
###############################################################
function uji {
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
while true
do
dialog --clear --begin 5 8  --no-cancel --backtitle \
 "$HARI,$(date "+%d"-"%m"-"%Y") | IP:$ipclient | USER:$SAYA | MOD-BY :$aku | VER:$ver"   \
--title " <> ==== [ PILIH USER SSH ] ==== <> " \
--menu "" 11  72 13 \
1.root		"user root (PC & ANDRO " \
2.kasir		"user kasir PC ONLY" \
3.adm1		"user adm1 (PC & ANDRO " \
4.spar		"user spar (PC & ANDRO " \
5.BACK		"Kembali Ke menu Utama                      " 2>"${INPUT}"
ret=$?
case $ret in
  255)rm -f $INPUT; return;;
esac
menuitem=$(<"${INPUT}")
# make decision 
case $menuitem in
        1.root)
	trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM
	dialog --title "IP BOS IP....!!!" \
	--backtitle "SUKA SUKA AKULAH" \
	--inputbox "MASUKKAN IP " 8 60 2>$OUTPUT

	respose=$?
	nam=$(<$OUTPUT)
	case $respose in
	  0)ssh root@$nam ;;
	  1) 
	  	echo "Cancel pressed." ;;
	  255) 
	   echo "[ESC] key pressed."
	esac;;
        2.kasir)
	trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM
	dialog --title "IP BOS IP....!!!" \
	--backtitle "SUKA SUKA AKULAH" \
	--inputbox "MASUKKAN IP " 8 60 2>$OUTPUT

	respose=$?
	namk=$(<$OUTPUT)
	case $respose in
	  0) mate-terminal -x ssh kasir@$namk ;;
	  1) 
	  	echo "Cancel pressed." ;;
	  255) 
	   echo "[ESC] key pressed."
	esac;;
        3.adm1)	
	trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM
	dialog --title "IP BOS IP....!!!" \
	--backtitle "SUKA SUKA AKULAH" \
	--inputbox "MASUKKAN IP " 8 60 2>$OUTPUT

	respose=$?
	nam=$(<$OUTPUT)
	case $respose in
	  0) ssh adm1@$nam;;
	  1) 
	  	echo "Cancel pressed." ;;
	  255) 
	   echo "[ESC] key pressed."
	esac;;
	4.spar)ssh -X spar2.s052@172.16.1.173
		result=$(echo "Log Out")
		display_result "Done";;
        5.BACK) return;;
esac
done
}
###############################################################
#Jalankan Menu SPV
###############################################################
function print {
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
while true
do
dialog --clear --begin 5 8  --no-cancel --backtitle \
 "$HARI,$(date "+%d"-"%m"-"%Y") | IP:$ipclient | USER:$SAYA | MOD-BY :$aku | VER:$ver"   \
--title " <> ==== [ MENU PRINTER SETTING ] ==== <> " \
--menu "" 15 71 7 \
1.CANCEL		"Cancel All Jobs          " \
2.DELETE		"Hapus HP-LASER Ganda           " \
3.LIST		"List Printer            " \
4.STATUS		"Status Printer           " \
5.RESTART		"Restart Printer            " \
6.ENABLE		"Mengaktifkan Printer            " \
7.BACK		"Kembali Ke menu Utama                      " 2>"${INPUT}"
ret=$?
case $ret in
  255)rm -f $INPUT; return;;
esac
menuitem=$(<"${INPUT}")
# make decision 
case $menuitem in
        1.CANCEL)(sudo cancel -a)
		result=$(echo "Canceled")
		display_result "Done";;
        2.DELETE)(sudo lpadmin -x HP-LaserJet-Professional-P1102)
		result=$(echo "Removed")
		display_result "Done";;
        3.LIST)(lpstat -p | awk '{print $2" "$5}'> list.txt)
		result=$(cat list.txt;rm list.txt)
		display_result "List Printer";;
        4.STATUS)(sudo service cups status | awk '{print $1" "$2}' | grep -w 'Active' > /home/adm1/status.txt)
		result=$(cat status.txt )
		(rm /home/adm1/status.txt)
		display_result "Status Printer";;
        5.RESTART)(sudo service cups restart)
		result=$(echo "MANTAP BOSKU")
		display_result " Sukses";;
        6.ENABLE)(sudo cupsenable HP_LaserJet_Professional_P1102)
		(sudo cupsenable lq2190)
		result=$(echo "OK")
		display_result " Sukses";;
        7.BACK) return;;
esac
done
}
###################################################################
#=====================================================================================================================================================
function men {
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
while true
do
dialog --clear --begin 5 8  --no-cancel --backtitle \
 "$HARI,$(date "+%d"-"%m"-"%Y") | IP:$ipclient | USER:$SAYA | MOD-BY :$aku | VER:$ver"   \
--title " <> ==== [ MENU PRINTER SETTING ] ==== <> " \
--menu "" 15 71 9 \
1.WIRELESS		"Set To Wireless          " \
2.ETHERNET		"Set To Ethernet        " \
3.BACK		"Kembali Ke menu Utama                      " 2>"${INPUT}"
ret=$?
case $ret in
  255)rm -f $INPUT; return;;
esac
menuitem=$(<"${INPUT}")
# make decision 
case $menuitem in
        1.WIRELESS)(sudo cp /etc/sysconfig/network-scripts/ifcfg-enp2s0-wir /etc/sysconfig/network-scripts/ifcfg-enp2s0)
		(sudo ifconfig wlp0s20u8 up)
		(sudo service network restart)
		sleep 2
		result=$(echo "Done")
		display_result "Done";;
        2.ETHERNET)(sudo cp /etc/sysconfig/network-scripts/ifcfg-enp2s0-eth /etc/sysconfig/network-scripts/ifcfg-enp2s0)
		(sudo service network restart)
		(sudo ifconfig enp2s0 up)
		sleep 2
		result=$(echo "Removed")
		display_result "Done";;
        3.BACK) return;;
esac
done
}
#=======================================================================================================================================================
function all { clear
python - << END
import random
import sys
import time
def mengetik(s):
    for c in s + '\n':
        sys.stdout.write(c)
        sys.stdout.flush()
        time.sleep(random.random() * 0.03)
mengetik('Created By @dhii_mr\nsudo cancel -a \nsudo lpadmin -x HP-LaserJet-Professional-P1102\nsudo cupsenable HP_LaserJet_Professional_P1102\nsudo cupsenable lq2190\nsudo cupsenable barcode')

END
		sudo cancel -a
		sudo lpadmin -x HP-LaserJet-Professional-P1102
		sudo cupsenable HP_LaserJet_Professional_P1102
		sudo cupsenable lq2190
		sudo cupsenable barcode
		clear
}
function bongko {
		clear
		echo -n " IP 172.19.52."
		read pp
		ssh root@172.19.52.$pp \
		sudo poweroff
}
#=======================================================================================================================================================
function dev {
data=/tmp/update.$$ 
dialog --title " [  MENU KU ] " --clear --insecure --passwordbox "Masukkan Password untuk melanjutkan\nTekan [ESC] / [Cancel] untuk batal" 10  65  2> $data
ret=$?
# make decision
pass=$(<$data)
case $ret in
  0)rm -rf $data;;
  #jika tombol cancel ditekan   
  1)rm -rf $data; return;;
  #jika tombol esc ditekan      
  255)rm -rf $data; return;;
esac
if  [ $pass == "263" ] ; then
        rm -rf $data;
 	OUTPUT=/tmp/update.$$
#        dialog --title "[ Hanya Untuk Pengembang ]" --yesno "\nYakin Untuk Melanjutkan ??\nTekan [ESC] / [NO]  Untuk Batal "  10 65 2> $OUTPUT;
          response=$?
          rm -rf $OUTPUT;
          case $response in
           0)devc;return;;
           1)pesan " Masuk Menu " "Masuk Menu Di batalkan";return;;
           255)pesan " Masuk Menu " "Masuk Menu Di batalkan";return;;
         esac
else #jika password yg diinput salah    
        pesan " WARNING !!! " "PASWOORD SALAH !!!";
        return;
fi
return;
}
#===================================================================================================================================================
function pesan {
    trap "exit" SIGHUP SIGINT SIGTERM;
    dialog --title " [  $1  ] " --msgbox "$2 " 10  50
    return;
}
function editor {
dosemu -quiet $HOME/.dosemu/drive_c/exe/editor.bat
cd $HOME
:
}
function devc {
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
while true
do
dialog --clear --begin 5 8  --no-cancel --backtitle \
 "$HARI,$(date "+%d"-"%m"-"%Y") | IP:$ipclient | USER:$SAYA | MOD-BY :$aku | VER:$ver"   \
--title " <> ==== [ MODE PENGEMBANG ] ==== <> " \
--menu "" 17 71 24 \
1.SSH	" | Secure Shell            " \
2.VNC	" | Vncviewer For Pc Only          " \
3.MENU-SPV	" | Jalankan Program SPV       " \
4.RSYNC	" | Copy File With Rsync " \
5.EDITOR " | Editor " \
6.MENU	" | Menu Lainya " \
7.FREE	" | FREE" \
8.DOWN " | BONGKO" \
9.PRINT " | print file " \
10.OFF	" | KILL ME " \
11.BACK	" | Kembali Ke menu Utama                      " 2>"${INPUT}"
ret=$?
case $ret in
  255)rm -f $INPUT; return;;
esac
menuitem=$(<"${INPUT}")
# make decision 
case $menuitem in
        1.SSH)uji;;
	2.VNC)vnc2;;
        3.MENU-SPV) spv;;
	4.RSYNC)SCP;;
	5.EDITOR)editor;;
	6.MENU)men;;
	7.FREE)
	clear
	bash
	(history -c)
	result=$(echo "KELUAR DARI TERMINAL")
	display_result " OK";;
	8.DOWN) bongko 
	pesan " INFO " "MODAR";;
	9.PRINT) coba ;; 
	10.OFF) power ;;
        11.BACK) return;;
esac
done
}
function power {
		dialog --title "Print Options" \
--backtitle "WARNING...!!! " \
--yesno "Matikan PC ini ?" 7 60


response=$?
case $response in
   0)poweroff;;
   1) pesan " INFO " "gak jadi mati BOS";;
   255) echo "[ESC] key pressed.";;
esac
}
function vnc2 {
trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM
dialog --title "IP BOS IP....!!!" \
--backtitle "SUKA SUKA AKULAH" \
--inputbox "MASUKKAN IP " 8 60 2>$OUTPUT

respose=$?
nam=$(<$OUTPUT)
case $respose in
  0) vncviewer $nam -passwd ~/.vnc/passwd;;
  1) 
  	echo "Cancel pressed." ;;
  255) 
   echo "[ESC] key pressed."
esac
}
###############################################################
function yesno {
		dialog --title "Print Options" \
--backtitle "Pilihan printer ==> ($printer) <== | file : $name " \
--yesno "pinter : $printer \nFile : $name" 7 60

# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
case $response in
   0)lp -d $printer -o fit-to-page $name
	result=$(OKE)
	display_result " OK";;
   1)
#echo "File not deleted."
coba;;
   255) echo "[ESC] key pressed.";;
esac
}
###############################################################
function inp {
trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM
dialog --title "INFO" \
--backtitle "@dhii_mr" \
--inputbox "Masuk direktori dan file berada " 8 60 2>$OUTPUT

respose=$?
name=$(<$OUTPUT)
case $respose in
  0)
	yesno ;;
  1) 
  	echo "Cancel pressed." ;;
  255) 
   echo "[ESC] key pressed."
esac
}
###############################################################
function coba {
trap "rm -f  $tmpprt ; rm -f $outprt ; exit" SIGHUP SIGINT SIGTERM;

tmpprt=/tmp/print.$$
outprt=/tmp/outprint.$$
no=1;
if [ -s $FILE  ]; then
        printer=$(cat ~/.dosprint |awk '{print $7}' | tr -d [[:space:]])
else
        printer=$(echo "$printer");       
fi
lpstat -p | awk '{print $2}' > $HOME/print.lst
cat $HOME/print.lst |  while read print ; do
     if [[ $print ==  $printer ]] ; then             
        x=On;
        echo  $print $no  $x  >> ${tmpprt}
     else 
	x=Off;        
        echo  $print $no  $x >> ${tmpprt}     
     fi 
     no=$((no+1)) 
done
hasil=$(<${tmpprt});
rm -rf $tmpprt;
dialog --title " [ Pilih printer ] " --clear \
        --radiolist "Pastikan terdapat $file\nPrinter Lama = $printer" 18 50 8	 $hasil 2> $outprt;
retval=$?
pilih=$(<$outprt);
rm -rf $outprt;
rm -rf $tmpprt;
case $retval in
     0)echo '$_lpt1 = " lpr -l -P ' $pilih' " '  >  $printnya; 
	inp ;
       return;;
     1)rm -f  $tmpprt ; rm -f $outprt ;return;;
     255)rm -f  $tmpprt ; rm -f $outprt ;return;;	
esac
return;
}
function asu {
		dialog --title "Santuy Boss" \
--backtitle "WARNING...!!! " \
--yesno "Kembali kemenu utama ?" 7 60


response=$?
case $response in
   0)return;;
   1)exit;;
   255) echo "[ESC] key pressed.";;
esac
}

function penj {
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
while true
do
dialog --clear --begin 5 5 --no-cancel --backtitle \
 "$HARI,$(date "+%d"-"%m"-"%Y") | IP:$ipclient | USER:$SAYA | MOD-BY :$aku | VER:$ver"   \
--title " <> ==== [ MENU KU ] ==== <> " \
--menu "" 12  70 6 \
1.CRT "  | CREATE DIRECTORY " \
2.CTXT	" | COPY FILE TXT DARI SERVER" \
3.TXTOPDF	" | CONVERT TXT TO PDF       " \
4.DEL	" | DELETE DIRECTORY PROGRAM       " \
5.EXIT	" | ENYAHLAH...!!!               "  2> "${INPUT}"
ret=$?
case $ret in
  255)rm -f $INPUT; keluar;
esac

menuitem=$(<"${INPUT}")
# make decsion 
case $menuitem in
	1.CRT) mkdir $SOUR $DIRV $FIN;;
	2.CTXT)scp adm1@172.19.52.250:"$FSER/h*.txt $FSER/a*.txt $FSER/c*.txt $FSER/s*.txt" $FIN;;
        3.TXTOPDF) topdf;;
	4.DEL) rm -rf $SOUR $DIRV $FIN;;
	5.EXIT) return;;
esac
done
}
function topdf {
clear
echo "                  SCRIPT TXT TO PDF "
echo " "
echo -n "Masukkan tanggal : "
read input
clear
echo "		 ====PILIH BENAR SATU===="
echo " 		h) PENJUALAN HARIAN "
echo " 		a) PENJUALAN AKUMULASI "
echo " 		c) PERJUALAN PERMCLAS "
echo "		s) PENJUALAN PERSKU "
echo " 		v) LAPORAN VOID "
echo " 		========================"
echo -n "		 PILIHAN : "
read dev
clear
enscript -B --margins=10:10: -o outputfile.ps -f Courier@5.8/10 $SOUR/$dev$input$ext
ps2pdfwr outputfile.ps $SOUR/$dev$input$bln.pdf
rm outputfile.ps
echo -n " Page : "
read pag
if [ ! -f $DIRV/$dev ]
then
    mkdir $DIRV/$dev
fi
clear
pdftk $SOUR/$dev$input$bln.pdf cat $pag output  $DIRV/$dev/templ.pdf
mv $DIRV/$dev/templ.pdf $DIRV/$dev/$input$bln.pdf
rm $SOUR/*.pdf
}
###############################################################
###############################################################
#Tampilan Menu Utama
###############################################################
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
while true
do
dialog --clear --begin 5 8 --no-cancel --backtitle \
 "$HARI,$(date "+%d"-"%m"-"%Y") | IP:$ipclient | USER:$SAYA | MOD-BY :$aku | VER:$ver"   \
--title " <> ==== [ MENU KU ] ==== <> " \
--menu "" 12  70 6 \
1.ALL	" | CANCEL ALL PRINT & DELETE DUPLICATE" \
2.PRINTER	" | SETTING PRINTER       " \
3.PENJ " | LAPORAN PENJUALAN " \
4.DEV	" | *^#*%^@&*%@&$%%($*^      " \
5.EXIT	" | ENYAHLAH...!!!               "  2> "${INPUT}"
ret=$?
case $ret in
  255)rm -f $INPUT; keluar;
esac

menuitem=$(<"${INPUT}")
# make decsion 
case $menuitem in
	1.ALL)all ;asu ;;
        2.PRINTER) print;;
	3.PENJ) penj ;;
        4.DEV) dev;;
        5.EXIT)history -c :
	rm ~/.bash_history ;
	exit;;
esac
done
rm -f $INPUT;

