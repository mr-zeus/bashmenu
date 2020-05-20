#!/bin/bash
FILE=~/.dosprint
INPUT=/tmp/menu.sh.$$
OUTPUT="/tmp/out.txt"
printnya=~/.dosprint
FSER=/smb/admtoko/data/sls2002
SOUR=$HOME/.tmp
DIRV=$HOME/Desktop/out
bln=$(date +-%m-%G)
ext=.txt
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
ver=2.1
SAYA=$(whoami);
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


function pesan {
    trap "exit" SIGHUP SIGINT SIGTERM;
    dialog --title " [  $1  ] " --msgbox "$2 " 10  50
    return;
}
function tes {
enscript -B --margins=10:10: -o outputfile.ps -f Courier@$ukn/10 $SOUR/$dev$input$ext 
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
function tgl {	
	trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM
	dialog --title "TANGGAL PENJUALAN" \
	--backtitle "SUKA SUKA AKULAH" \
	--inputbox "MASUKKAN TANGGAL " 8 60 2>$OUTPUT

	respose=$?
	input=$(<$OUTPUT)
	topdf
}
	

function topdf {
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
while true
do
dialog --clear --begin 5 5 --no-cancel --backtitle \
 "$HARI,$(date "+%d"-"%m"-"%Y") | IP:$ipclient | USER:$SAYA | MOD-BY :$aku | VER:$ver"   \
--title " <> ==== [ MENU KU ] ==== <> " \
--menu "" 12  70 6 \
1.HARIAN " | PENJUALAN HARIAN " \
2.AKUMULASI	" | PENJUALAN AKUMULASI" \
3.MCLASS	" | PENJUALAN PERMCLASS       " \
4.SKU	" | PENJUALAN PERSKU       " \
5.LAINYA " | LAINYA " \
6.EXIT	" | ENYAHLAH...!!!               "  2> "${INPUT}"
ret=$?
case $ret in
  255)rm -f $INPUT; keluar;
esac

menuitem=$(<"${INPUT}")
# make decsion 
case $menuitem in
	1.HARIAN)dev=h;ukn=5.8;tes;;
	2.AKUMULASI)dev=a;ukn=5.8;tes;;
        3.MCLASS)dev=c;ukn=7.6;tes;;
	4.SKU)dev=s;ukn=7.6;tes;;
	5.LAINYA);;
	6.EXIT) return;;
esac
done
}
function hapus {
		dialog --title "Print Options" \
--backtitle "WARNING...!!! " \
--yesno "Hapus Semua folder yang dibuat?" 7 60


response=$?
case $response in
   0)rm -rf $DIRV;
result=$(echo "========FOLDER========\n$DIRV\n========TERHAPUS========")
		display_result "Done";;
   1) pesan " INFO " "CANCEL DELETE";;
   255) echo "[ESC] key pressed.";;
esac
}


###########################################################################################################################
#################################     MENU UTAMA   ###############################################################
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM;
while true
do
dialog --clear --begin 5 8 --no-cancel --backtitle \
 "$HARI,$(date "+%d"-"%m"-"%Y") | IP:$ipclient | USER:$SAYA | MOD-BY :$aku | VER:$ver"   \
--title " <> ==== [ MENU KU ] ==== <> " \
--menu "" 12  65 6 \
1.CRT " | CREATE DIRECTORY " \
2.CTXT	" | COPY FILE TXT DARI SERVER" \
3.TXTOPDF	" | CONVERT TXT TO PDF       " \
4.DEL	" | DELETE DIRECTORY PROGRAM       " \
5.EXIT	" | ENYAHLAH...!!!               "  2> "${INPUT}"
ret=$?
case $ret in
  255)rm -f $INPUT; return;
esac

menuitem=$(<"${INPUT}")
# make decsion 
case $menuitem in
	1.CRT) mkdir $SOUR $DIRV;
result=$(echo "========FOLDER========\n$SOUR\n$DIRV\n========DIBUAT========")
		display_result "Done";;
	2.CTXT)rsync -avzPO adm1@172.19.52.250:$FSER/*.txt $SOUR;
result=$(echo "COPY FILE DARI SERVER")
		display_result "Done";;
        3.TXTOPDF) tgl;;
	4.DEL) hapus;;
	5.EXIT) exit;;
	esac
done
rm -f $INPUT;




