#!/bin/env bash 
umask 0034
set bell-style none
set input-meta off
unalias -a 
unset  $GROUPS
unset PATH
export PATH=$PATH:/usr/bin/:~/.local/bin:~/my\ scripts

scraper=/usr/bin/wget  
scrap_flag='--user-agent="$useragent"  -qO -   '


color1="tput setaf 15" #white
color2='tput setaf 05' #pink
color3='tput setaf 6'  #blue 
color4='tput setaf 11' #yelow
color5='tput setaf 1'  #red
color6='tput setaf 14'  


imageenable=0  ##  0 disable 1 to enable 
#sandbox=/opt/firejail/bin/firejail 
#f='--noroot --private-cache  --quiet  --noroot --nonewprivs    --seccomp  '

sandbox_flag="$sandbox $f " 
scraper_flag="$scraper $scrap_flag"

#useragent="Mozilla/5.0 (X11; Linux x86_64; rv:52.9) Gecko/20100101 Firefox/52.9 (Pale Moon)"
useragent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0 Safari/605.1.15"


#$names='| grep '{"accessibilityData":{"label":"' -F  | sed 's/"}],"accessibility":{"accessibilityData":{"label":"/\n/g' | cut -d' ' -f1-10  | tail -n +2 '
#$links='| grep '","webPageType' \| sed 's/\",\"webPageType/\n/g'  | grep watch?v | sed 's/.*\/watch?v=//g' | cut -d' ' -f1 '
#$image='| sed 's/thumb/\n/g'  | grep jpg | cut -c 17-64 | uniq -u | grep http |sed 's/jpg.*//g''

#### image folder #####
imputdir=$HOME/.ytimg
imputfile=$HOME/.ytimgs

tag="$@"
rm -rf $imputdir 
cleaning_cache
clear
re=1
#redo
player="/usr/bin/mpv   --really-quiet " 

imageviewer="tiv"
#-h 40 -w 40  "



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

function image_parsing()
{
#cat $imputfile  | head -$y | tail -1 
if [ -d $imputdir  ] 
then
    ypeg=$(expr $y - 1 ) 
if [ $y -eq 1 ];  then  $imageviewer "$imputdir/$(cat $imputfile | cut -c 36-50  | head -1 | tail -1)";  
else $imageviewer "$imputdir/$(cat $imputfile | cut -c 36-50  | head -$y | tail -1).$ypeg";  fi 
fi
}


while [  $re != q  ]
do
echo $($color1)  "*********youtube script **********$(tput sgr 0)"
echo $($color2)  "                 by alan sarkar$(tput sgr 0)"
echo $($color1)  "*********************************$(tput sgr 0)"
echo $($color3)  " Enter what you want to search:$(tput sgr 0)"
read input1 ;
x="$input1"
clear



##########   pulling name ######   
xyz="`echo "$x" | sed 's/ /+/g'`"
echo "$( $sandbox_flag   /usr/bin/wget --user-agent="$useragent" -qO-  https://www.youtube.com/results?search_query="$xyz"&spfreeload=10)" > /tmp/.ytcache 
#### imagescrape 
#if [ $imageenable  -eq 1 ] ;  then mkdir $imputdir ; fi 
cat /tmp/.ytcache | sed 's/thumb/\n/g'  | grep jpg | cut -c 17-64 | uniq -u | grep http   |sed 's/jpg.*/jpg/g' > "$imputfile"
if [ $imageenable  -eq 1 ] ; then $sandbox_flag  /usr/bin/wget --user-agent="$useragent" -q   --input-file=$imputfile -P  $imputdir/  ;  fi 


#re view search result
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
#echo link : 
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

echo $($color1)  " Now Playing: "
echo " "
echo $($color4)  "$(cat /tmp/.ytname | head -$p | tail -1)$(tput sgr 0)"
echo $($color4)  "$(echo "Link: https://www.youtube.com/watch?v=$q")$(tput sgr 0)"

echo " "
echo $($color1)  " Description: $(tput sgr 0)"






##################        discreaption ######################

echo $($color6)  "$( $sandbox_flag   /usr/bin/wget  --user-agent="$useragent"  -qO-  "https://www.youtube.com/watch?v=$q" |  grep '},\"description\":{\"simpleText\":\"'  | sed 's/.*},\"description\":{\"simpleText\":\"//g;s/"},"lengthSeconds":".*//g;s/\\n/\n/g'   )$(tput sgr 0)"
#fi
echo "" 


#####  video play ###########

#$HOME/my\ scripts/mpdl.sh "https://www.youtube.com/watch?v=$q"

$sandbox  youtube-dl  -q --user-agent "$useragent"  -c  "https://www.youtube.com/watch?v=$q" -o - |   $player   -


mpv=1 # for conflict
#clear

fi


if [ "$p" = q ] 
then
clear


re2=0
#re=q   # complete exit var
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
#### page number main search ####
xyz="`echo "$x" | sed 's/ /+/g'`"
echo "$( $sandbox_flag   /usr/bin/wget     --user-agent="$useragent"  -qO-  "https://youtube.com/results?search_query="$xyz"&pbjreload=101&page=$xx" )"       > /tmp/.ytcache
parsing
image_parsing
page=$(cat /tmp/.ytname  | head -$xx | tail -1 )
rage="$x&sp$page"
echo $rage
echo $($color2)"page no $(expr $xx + 1)$(tput sgr 0)"
echo "URL: https://www.youtube.com/results?search_query="$rage" "
echo ""
fi



fi # end of $p = n



if  (([ "$p" != n ] && [ "$p" != q  ]) && [ "$mpv" != 1 ])
then
    pqr=="`echo "$p" | sed 's/ /+/g'`"
echo "$( $sandbox_flag   /usr/bin/wget  --user-agent="$useragent" -qO-  https://www.youtube.com/results?search_query="$pqr"&spfreeload=10)"      > /tmp/.ytcache
rm -rf $imputdir

#### imagescrape 
#if [ $imageenable  -eq 1 ] ;  then mkdir $imputdir ; fi 
cat /tmp/.ytcache | sed 's/thumb/\n/g'  | grep jpg | cut -c 17-64 | uniq -u | grep http   |sed 's/jpg.*/jpg/g' > "$imputfile"
if [ $imageenable  -eq 1 ] ; then $sandbox_flag  /usr/bin/wget --user-agent="$useragent" -q   --input-file=$imputfile -P  $imputdir/  ;  fi 


x="$p"
fi



mpv=0 # reset conflict var


#clear
done
clear
done
clearing_cache

