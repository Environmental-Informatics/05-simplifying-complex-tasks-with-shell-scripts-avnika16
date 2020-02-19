#!/bin/bash


# Part I: Identify and separate out "high elevation" stations from the rest

## Checking if directory exists
if [ -d "./HigherElevation" ]
then
	echo "Higher Elevation directory already exists!"
else 
	mkdir ./HigherElevation
fi 

## Separating Higher Elevation Stations
for file in ./StationData/*
do 
	name=`basename "$file"`
	if 
	grep 'Altitude: [=>200]' $file
	then cp ./StationData/$name ./HigherElevation/$name 
	fi
done

# Part II: Plot locations of stations, highlighting higher elevation stations

## Extracting Longitude and Latitude Data

awk '/Longitude/ {print -1 * $NF}' StationData/Station_*.txt > Long.list
awk '/Latitude/ {print -1 * $NF}' StationData/Station_*.txt > Lat.list
awk '/Longitude/ {print -1 * $NF}' HigherElevation/Station_*.txt > LongHE.list
awk '/Latitude/ {print -1 * $NF}' HigherElevation/Station_*.txt > LatHE.list
paste Long.list Lat.list > AllStations.xy
paste LongHE.list LatHE.list > HEStations.xy

## Loading gmt package

. /etc/profile
module load gmt

## Plotting Figure

gmt pscoast -JU16/4i -R-93/-86/36/43 -B2f0.5 -Cl/bue -Dh[+] -Ia/blue -Na/orange -P -K -V > SoilMoistureStations.ps
gmt psxy AllStations.xy -J -R -Sc0.15 -Gblack -K -O -V >> SoilMoistureStations.ps
gmt psxy HEStations.xy -J -R -Sc0.15 -Gred -O -V >> SoilMoistureStations.ps

## Displaying Figure

gv SoilMoistureStations.ps &

