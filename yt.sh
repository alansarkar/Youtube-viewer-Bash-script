#!/usr/bin/env bash 
color1="tput setaf 15" #white
color2='tput setaf 05' #pink
color3='tput setaf 6'  #blue 
color4='tput setaf 11' #yelow
color5='tput setaf 1'  #red
color6='tput setaf 14'  

sandbox="firejail "
##sandbox-flags=" --private --noroot --nonewprivs --quiet "
#$names='| grep '{"accessibilityData":{"label":"' -F  | sed 's/"}],"accessibility":{"accessibilityData":{"label":"/\n/g' | cut -d' ' -f1-10  | tail -n +2 '
#$links='| grep '","webPageType' \| sed 's/\",\"webPageType/\n/g'  | grep watch?v | sed 's/.*\/watch?v=//g' | cut -d' ' -f1 '

tag="$@"
rm -rf /tmp/.ytcache
/bin/clear
re=1
#redo
player="/usr/bin/mpv   --really-quiet " 

while [  $re != q  ]
do


echo $($color1)  "*********youtube script **********$(tput sgr 0)"
echo $($color2)  "                 by alan sarkar$(tput sgr 0)"
echo $($color1)  "*********************************$(tput sgr 0)"

echo $($color3)  " Enter what you want to search:$(tput sgr 0)"
read x ;
clear

##   pulling name ######    


#echo "$($sandbox /usr/bin/wget -qO-  https://www.youtube.com/results?search_query="$x"&spfreeload=10)"      | grep '<a href="/watch?v=' | grep -v  '<li><div class="yt-lockup yt-lockup-tile yt-lockup-play    list vve-check clearfix"' | grep -v '<li class="yt-lockup-playlist-item clearfix"><span class="    yt-lockup-playlist-item-length">' > /tmp/.ytcache

echo "$($sandbox /usr/bin/wget --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:52.9) Gecko/20100101 Firefox/52.9 (Pale Moon)" -qO-  https://www.youtube.com/results?search_query="$x"&spfreeload=10)" > /tmp/.ytcache 


#re view search result
re2=1
while [ $re2 -eq 1 ]
do
y=1
## name
cat /tmp/.ytcache   | grep '{"accessibilityData":{"label":"' -F  | sed 's/"}],"accessibility":{"accessibilityData":{"label":"/\n/g' | cut -d' ' -f1-10  | tail -n +2   > /tmp/.ytname
## link
cat /tmp/.ytcache  | grep '","webPageType' | sed 's/\",\"webPageType/\n/g'  | grep watch?v | sed 's/.*\/watch?v=//g' | cut -d' ' -f1   > /tmp/.ytlink


z=$(cat /tmp/.ytname | wc -l ) 

#echo "$($sandbox /usr/bin//usr/bin/wget -qO-  https://www.youtube.com/results?search_query="$x"&spfreload=10)"  | grep '<a href="/watch?v=' 


while [ $y  -le $z ]
do

printf  " $($color3) $y. "

## echo  name
echo $($color4)  "$(cat /tmp/.ytname  |head -$y | tail -1)$(tput sgr 0)"

## echo channel
cat /tmp/.ytlink | head -$y | tail -1

echo " " 

y=$( expr $y + 1 )

done
echo $($color3)  "Enter the number you want to watch or enter q to exit $(tput sgr 0)"
#echo " enter d to show only discription"
echo  "$($color3) Enter n to go to other pages"$(tput sgr 0)
read p ;


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
#if [ $p -eq d ]
#then
#echo : enter the number you want to see"
#read q

##################        discreaption ######################

echo $($color6)  "$($sandbox /usr/bin/wget  --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:52.9) Gecko/20100101 Firefox/52.9 (Pale Moon)"  -qO-  "https://www.youtube.com/watch?v=$q" |  grep '},\"description\":{\"simpleText\":\"'  | sed 's/.*},\"description\":{\"simpleText\":\"//g;s/"},"lengthSeconds":".*//g;s/\\n/\n/g'   )$(tput sgr 0)"
#fi
echo "" 


#####  video play ###########

#### #mpv
#"$sandbox" --quiet  --private --disable-mnt --noexec=all --nonewprivs --noroot mpv --brightness 7 --geometry 800x450 --quiet   $tag  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.129 Safari/537.36" --ytdl-format=best  "https://www.youtube.com/watch?v=$q"
#### ffplay 
#"$sandbox"  --private --noroot --quiet youtube-dl  --user-agent "fucku" -f best -c -q  "https://www.youtube.com/watch?v=$q" -o - |   ffplay -loglevel quiet  -
$sandbox  /usr/bin/youtube-dl  -q --user-agent "fucku"  -c  "https://www.youtube.com/watch?v=$q" -o - |   $player   -
#/bin/sh /home/$(whoami)/my\ scripts/mpv.sh "https://www.youtube.com/watch?v=$q" 

mpv=1 # for conflict
#clear

fi


if [ "$p" = q ]
then
clear
re2=0
#re=q   # complete exit var
rm -rf /tmp/.ytcache
rm -rf /tmp/.ytlink
rm -rf /tmp/.ytname
fi
#echo "see the search result again? press 1"
#read re2;
#re2=p




######## next page   ######
if [ "$p" = n ]
then
echo $(tput sgr 15)"Enter the page number$(tput sgr 0)"
read xx


if [ "$xx" != 1 ] && [[ "$xx" =~ ^[0-9]+$ ]]
then
#xx=$(expr $xx - 1)  ### exclude page 1
clear
#### page number main search ####
echo "$($sandbox /usr/bin/wget -qO-  https://www.youtube.com/results?search_query="$x"&page=$xx)"       > /tmp/.ytcache


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
 
echo "$($sandbox /usr/bin/wget  --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:52.9) Gecko/20100101 Firefox/52.9 (Pale Moon)" -qO-  https://www.youtube.com/results?search_query="$p"&spfreeload=10)"      > /tmp/.ytcache
x="$p"
fi



mpv=0 # reset conflict var



done
clear
#echo "search again? if yes press 1"
#read  re;
clear
done
rm -rf /tmp/.ytlink
rm -rf /tmp/.ytname
rm -rf /tmp/.ytcache
