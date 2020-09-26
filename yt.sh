#!/bin/env bash 
umask 0034
unalias -a 
unset  $GROUPS
unset PATH
export PATH=$PATH:/usr/bin/:~/.local/bin:~/my\ scripts
rm -rf $imputdir 

player="/usr/bin/mpv   --really-quiet " 
imageviewer="tiv" #-h 40 -w 40  "

sandbox=/opt/firejail/bin/firejail 
f='--noroot --private-cache  --quiet  --noroot --nonewprivs    --seccomp  '   ## firejail config for this script
sandbox_flag="$sandbox $f " 
scraper_flag="$scraper $scrap_flag"

scraper="/bin/wget"
scrap_flag='--user-agent="$useragent"  -qO -   '  #scrap_flag=' -s  -H "User-Agent: $useragent" -A "$useragent" '

useragent="`random.exe`"                         #useragent="Mozilla/5.0 (X11; Linux x86_64; rv:52.9) Gecko/20100101 Firefox/52.9 (Pale Moon)"

searchlink="https://youtube.com/results?search_query="
watchlink="https://www.youtube.com/watch?v="

#####################################################################################  
case "$@" in
    --help|-h) 
echo "Usage:  yt.sh 
    
    Youtube Viewer 

    Just execute this script and Enter search terms at prompt 
    And select the number to play when the search results shown

Options: 

    --help                  Show this message and exit
    --history               Shows previous search history
    --clear                 clears search history
    --image                 enables image
" 
      ;;
  --history)
if      [ -d ~/.config/youtube\ bash\ script ] &&  [ -f  ~/.config/youtube\ bash\ script/history ]  ; then 
    cat ~/.config/"youtube bash script/history"
else  
    echo " No history to show "
    fi
      ;;  
  --clear)
if      [ -f  ~/.config/youtube\ bash\ script/history ]  ; then 
    rm  ~/.config/"youtube bash script/history"
    fi
      ;;  

  ""|--image)
###########################     variables  ##################
color1="tput setaf 15" #white
color2='tput setaf 05' #pink
color3='tput setaf 6'  #blue 
color4='tput setaf 11' #yelow
color5='tput setaf 1'  #red
color6='tput setaf 14'  

 ##  0 disable 1 to enable 
if [ "$1"  == "--image" ] ;  then imageenable=1 ; else   imageenable=0;  fi  
#### image folder #####
imputdir=$HOME/.ytimg
imputfile=$HOME/.ytimgs
cleaning_cache
clear
re=1
#redo

###################################################



########### function  #############

function parsing() 
{
## name
cat /tmp/.ytcache   | grep '{"accessibilityData":{"label":"' -F  | sed 's/"}],"accessibility":{"accessibilityData":{"label":"/\n/g' | cut -d' ' -f1-10  | tail -n +2   > /tmp/.ytname
## link
cat /tmp/.ytcache  | grep '","webPageType' | sed 's/\",\"webPageType/\n/g'  | grep watch?v | sed 's/.*\/watch?v=//g' | cut -d' ' -f1   > /tmp/.ytlink

}

function clearing_cache()
{
rm -rf /tmp/.ytcache
rm -rf /tmp/.ytlink
rm -rf /tmp/.ytname
rm -rf $imputfile
}
function startup_name() {
echo $($color1)  "*********youtube script **********$(tput sgr 0)"
echo $($color2)  "                 by alan sarkar$(tput sgr 0)"
echo $($color1)  "*********************************$(tput sgr 0)"
echo $($color3)  " Enter what you want to search:$(tput sgr 0)"
}

function image_parsing()
{
if [ -d $imputdir  ] 
then
    ypeg=$(expr $y - 1 ) 
if [ $y -eq 1 ];  then  $imageviewer "$imputdir/$(cat $imputfile | cut -c 36-50  | head -1 | tail -1)";  
else $imageviewer "$imputdir/$(cat $imputfile | cut -c 36-50  | head -$y | tail -1).$ypeg";  fi 
fi
}

function history() {
[ ! -d  $HOME/.config/"youtube bash script" ]  && touch $HOME/.config/"youtube bash script" ;

echo "$@" >> $HOME/.config/"youtube bash script/history"
 

}

#########################

while [  $re != q  ]
do
startup_name
read input1 ;
x="$input1"
clear

##########   pulling name ######   
xyz="`echo "$x" | sed 's/ /+/g'`"
echo "$( $sandbox_flag  $scraper_flag  "$searchlink"$xyz"&spfreeload=10")" > /tmp/.ytcache 

#### imagescrape 
#if [ $imageenable  -eq 1 ] ;  then mkdir $imputdir ; fi 
cat /tmp/.ytcache | sed 's/thumb/\n/g'  | grep jpg | cut -c 17-64 | uniq -u | grep http   |sed 's/jpg.*/jpg/g' > "$imputfile"
if [ $imageenable  -eq 1 ] ; then $sandbox_flag  /usr/bin/wget --user-agent="$useragent" -q   --input-file=$imputfile -P  $imputdir/  ;  fi 

re2=1

while [ $re2 -eq 1 ]
do
y=1
parsing
z=$(cat /tmp/.ytname | wc -l ) 

while [ $y  -le $z ]
do
printf  " $($color3) $y. "
## echo  name
echo $($color4)  "$(cat /tmp/.ytname  |head -$y | tail -1)$(tput sgr 0)"
## echo link : 
cat /tmp/.ytlink | head -$y | tail -1

image_parsing
y=$( expr $y + 1 )
done


echo $($color3)  "Enter the number you want to watch or enter q to exit $(tput sgr 0)"
echo  "$($color3) Enter n to go to other pages"$(tput sgr 0)
read input2 ;
p="$input2" ;

if [ "$p" != n ] ;then clear ;  fi




if [[ "$p" != q ]] && [[ "$p" != n ]] && [[ "$p" =~ ^[0-9]+$ ]]
then
q=$(cat /tmp/.ytlink | head -$p | tail -1 )
clear

show_title="`cat /tmp/.ytname | head -$p | tail -1`"
echo $($color1)  " Now Playing: "
echo " "
echo $($color4)  "$show_title$(tput sgr 0)"
echo $($color4)  "$(echo "Link: "$watchlink"$q")$(tput sgr 0)"

echo " "
echo $($color1)  " Description: $(tput sgr 0)"


##################        discreaption ######################

echo $($color6)  "$( $sandbox_flag  $scraper_flag  "$watchlink$q" |  grep '},\"description\":{\"simpleText\":\"'  | sed 's/.*},\"description\":{\"simpleText\":\"//g;s/"},"lengthSeconds":".*//g;s/\\n/\n/g'   )$(tput sgr 0)"
#fi
echo "" 


#####  video play ###########

$HOME/my\ scripts/mpdl.sh "$watchlink$q"

#$sandbox  youtube-dl  -q --user-agent "$useragent"  -c  "$watchlink$q" -o - |   $player   -
history "$show_title: $watchlink$q "
mpv=1 # for conflict
#clear

fi
########################
## exit ##
if [ "$p" = q ] 
then
clear

re2=0
clearing_cache
fi

######## next page   ######
if [ "$p" = n ] 
then
echo $(tput sgr 15)"Enter the page number$(tput sgr 0)"
read input3
xx="$input3"

clear

if [ "$xx" != 1 ] && [[ "$xx" =~ ^[0-9]+$ ]] 
then
xyz="`echo "$x" | sed 's/ /+/g'`"
echo "$( $sandbox_flag  $scraper_flag  "$searchlink"$xyz"&pbjreload=101&page=$xx" )"       > /tmp/.ytcache
parsing
image_parsing
page=$(cat /tmp/.ytname  | head -$xx | tail -1 )
rage="$x&sp$page"
echo $($color2)"page no $(expr $xx + 1)$(tput sgr 0)"
echo "URL: $searchlink="$rage" "
echo ""
fi

fi 
####################### 

#############  search again ##############
if  (([ "$p" != n ] && [ "$p" != q  ]) && [ "$mpv" != 1 ])
then
    pqr=="`echo "$p" | sed 's/ /+/g'`"
echo "$( $sandbox_flag  $scraper_flag  "$searchlink"$pqr"&spfreeload=10")"      > /tmp/.ytcache
rm -rf $imputdir

#### imagescrape 
#if [ $imageenable  -eq 1 ] ;  then mkdir $imputdir ; fi 
cat /tmp/.ytcache | sed 's/thumb/\n/g'  | grep jpg | cut -c 17-64 | uniq -u | grep http   |sed 's/jpg.*/jpg/g' > "$imputfile"
if [ $imageenable  -eq 1 ] ; then $sandbox_flag  $scraper_flag -q   --input-file=$imputfile -P  $imputdir/  ;  fi 
#########

x="$p"
fi

#######################

mpv=0 # reset conflict var

#clear
done
clear
done
clearing_cache
      ;;
esac

