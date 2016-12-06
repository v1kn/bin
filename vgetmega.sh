#!/bin/bash
#incomplete


linklist=/home/xuval/wget.lnk
downloadedlist=$(find /media/xuval/wde2/websites/html/ -type f -daystart -mtime 0 -printf '%P\n')
pdflist=$(find /media/xuval/wde2/websites/pdf/ -type f -daystart -mtime 0 -printf '%P\n')

while read link
do
    wget -a /home/xuval/wget.log $link
    htmlfile=/home/xuval/$(tail /home/xuval/wget.log | grep "Converting" |
    cut -d\  -f2 | sed 's/html.../html/')
    cp $htmlfile /media/xuval/wde2/websites/html/
done <<< $linklist

echo $downloadedlist |
while read downloadedfile
do
    newname=$(grep "<title>" $downloadedfile | cut -d\> -f2 | cut -d\< -f1)
    mv /media/xuval/wde2/websites/html/$downloadedfile /media/xuval/wde2/websites/html/"$newname".html
    wkhtmltopdf "$newname".html /media/xuval/wde2/websites/pdf/"$newname".pdf
done


##~~~~~removing spaces and uppercase from html and pdf~~~~~##
for i in $downloadedlist
do
    sed 's/ /-/g' "$i" | tr '[:upper:]' '[:lower:]'
done

for ii in $pdflist
do
    sed 's/ /-/g' "$ii" | tr '[:upper:]' '[:lower:]'
done

