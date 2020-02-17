
#!/bin/sh


rm -rf /home/$(whoami)/.ytcache
/bin/clear
re=1
#redo
while [  $re != q  ]
do


echo  "\e[1;34m*********************************\e[0m" m    

echo   "\e[1;34m*********youtube script **********\e[0m"

echo  "\e[1;34m*********************************\e[0m"

echo  "\e[1;31m Enter what you want to search:\e[0m"
read x ;
clear
#echo $x

#re view search result
re2=1
while [ $re2 -eq 1 ]
do

y=1
echo "$(firejail wget -qO-  https://www.youtube.com/results?search_query="$x"&spfreload=10)"  | grep '<a href="/watch?v=' > /home/$(whoami)/.ytcache

z=$(cat /home/$(whoami)/.ytcache | cut -c282-400 | sed 's/" aria.*//g'  | sed 's/^/ 1. /g'  | wc -l)

#echo "$(firejail wget -qO-  https://www.youtube.com/results?search_query="$x"&spfreload=10)"  | grep '<a href="/watch?v=' 


while [ $y  -le $z ]
do

printf " $y. "
#cat /home/$(whoami)/.ytcache |  sed   's/.*"  title="//g'  | sed 's/" aria.*//g'  | head -$y | tail -1
#cat /home/$(whoami)/.ytcache | cut -c282-400 | sed 's/.*title="//g' | sed 's/" aria.*//g' | head -$y | tail -1
#echo   "\e[1;33m$(cat /home/$(whoami)/.ytcache  | sed 's/.*"  title="//g' | sed 's/" aria.*//g'| sed 's/rel="spf-prefetch//g'| head -$y | tail -1)\e[0m"
echo  "\e[1;31m$(cat /home/$(whoami)/.ytcache | sed 's/.*"  title="//g' | sed 's/" aria.*//g'| sed 's/" rel="spf-prefetch//g'| head -$y | tail -1)\e[0m"


#channel
#cat .ytcache  | grep /channel/  | sed 's/.*><a href="//g' | sed 's/" class="yt-uix-sessionlink.*//g' | head -$y | tail -1
#cat .ytcache  | grep /channel/  | sed 's/.*><a href="//g' | sed 's/.*" >//g' | sed 's/<\/a><\/div>.*//g' 

#cat /home/$(whoami)/.ytcache | cut -c282-400  | sed 's/" aria.*//g' | head -$y | tail -1
cat /home/$(whoami)/.ytcache | cut -c85-95| head -$y | tail -1

echo " " 

y=$( expr $y + 1 )

done
echo " enter the number you want to watch or enter q to exit"
#echo " enter d to show only discription"
read p ;


if [ $p != q ]
then
q=$(cat /home/$(whoami)/.ytcache | cut -c85-95 | head -$p | tail -1 )
clear

echo  "\e[0;37m Now Playing: \e[0m"
echo " "
echo  "\e[1;31m$(cat /home/$(whoami)/.ytcache | cut -c282-400 | sed 's/.*title="//g' | sed 's/" aria.*//g'| sed 's/rel="spf-prefetch//g'| head -$p | tail -1)\e[0m"
echo  "\e[1;31m$(echo "Link: https://www.youtube.com/watch?v=$q")\e[0m"

echo " "
echo  "\e[0;37m Description: \e[0m"
#if [ $p -eq d ]
#then
#echo : enter the number you want to see"
#read q
echo   "\e[1;34m$(firejail wget -qO-  "https://www.youtube.com/watch?v=$q" | grep "watch-description-extras"  | sed 's/<br[^>]*>/\n/g' |sed -e 's/<[^>]*>//g')\e[0m"
#fi
echo "" 


firejail --quiet   mpv --ytdl-format=best --quiet "https://www.youtube.com/watch?v=$q"
fi


if [ $p == q ]
then
clear
re2=0
rm -rf /home/$(whoami)/.ytcache
fi
#echo "see the search result again? press 1"
#read re2;
#re2=p
done






clear
#echo "search again? if yes press 1"
#read  re;
clear
done
rm -rf /home/$(whoami)/.ytcache
