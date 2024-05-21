#!/bin/bash

#Extract all timestamps and add them into timestamp.txt
cat $1 | grep 'UTC' | sed -e '/<dtg>/d' -e '/tr/d' -e 's/<name>//g' -e 's/<\/name>//g' | awk '{print $1 " " $2 " " $3 " " $4}' > timestamp.txt
echo 'Timestamps collected'

#Extract all latitudes and add them with units into lat.txt
cat $1 | grep '<lat>' | sed -e '/tr/d' -e 's/<lat>//g' -e 's/<\/lat>//g' | awk '{print $1 " N"}' > lat.txt
echo 'Latitudes collected'

#Extract all longitudes and add them with units into long.txt
cat $1 | grep '<lon>' | sed -e '/tr/d' -e 's/<lon>//g' -e 's/<\/lon>//g' | awk '{print $1 " W"}' > long.txt
echo 'Longitudes collected'

#Extract minSeaLevelPressure with units and add them into minSeaLevelPres.txt
cat $1 | grep 'minSeaLevelPres' | sed -e 's/<minSeaLevelPres>//g' -e 's/<\/minSeaLevelPres>//g' | awk '{print $1 " mb"}' > minSeaLevelPres.txt
echo 'MinSeaLevelPressures collected'

#Extract maxIntensity with units and add them into maxIntensity.txt
cat $1 | grep 'knots' | sed 's/<tr><td>//g' | awk '{print $1 " "  $2}' | sed 's/;//g' > maxIntensity.txt
echo 'MaxIntensities collected'

echo 'Converting' $1 '-> ' $2
#Merge timestamp.txt, lat.txt, long.txt, minSeaLevelPres.txt, and maxIntensity.txt with',' and result stored in csv file
paste -d , timestamp.txt lat.txt long.txt minSeaLevelPres.txt maxIntensity.txt > $2

#Add the appropriate heading to newly created csv file
sed -i '1 i Timestamp,Latitude,Longitude,MinSeaLevelPressure,MaxIntensity' $2

#Remove unnecessary files
rm timestamp.txt lat.txt long.txt minSeaLevelPres.txt maxIntensity.txt

echo 'Done!'
