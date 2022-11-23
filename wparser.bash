# Name: Rambod Azimi
# Student ID: 260911967
# Department: Software Engineering

# Mini 3 - Comp 206 - Winter 2022

#!/bin/bash


# Check to make sure there is only 1 parameter
if [[ $# -eq 1 ]]
then
	
	# Check to make sure the parameter is a directory
	if [[ -d $1 ]]
	then
		path_to_dir=$(pwd)
		cd $1
	# Look for data files with the pattern weather_info_*.data
	x=$(find -name 'weather_info_*.data' -type f | sed -e 's/.//' -e 's///')
	else
		echo "Error! $1 is not a valid directory name"
		exit 1
	fi
else
	echo "Usage ./wparser.bash <weatherdatadir>"
	exit 1
fi

# This function will produce an output in a special format
extractData () {
	echo "Processing Data From <$(pwd $i)/$i>"
	echo "===================================="
	echo "Year,Month,Day,Hour,TempS1,TempS2,TempS3,TempS4,TempS5,WindS1,WindS2,WindS3,WinDir"

# Using several features of both sed and awk commands to parse the data files into an appropriate format
grep -v "Rambod" $i | sed -e 's/observation//g' -e 's/line//g' -e 's/performing diagnostics on temp.*//g' -e 's/active power disengaged//g' -e 's/signal strength low.//g' -e 's/data log flushed//g' -e 's/MISSED SYNC STEP/M/g' -e 's/NOINF/M/g' -e 's/\[\]//g' -e 's/-/,/' -e 's/-/,/' -e 's/    / /' -e 's/  / /' -e 's/ /,/g' -e 's/:..:..//g' -e '/,$/d' -e 's/,0$/,N/' -e 's/,1$/,NE/' -e 's/,2$/,E/' -e 's/,3$/,SE/' -e 's/,4$/,S/' -e 's/,5$/,SW/' -e 's/,6$/,W/' -e 's/,7$/,NW/'| awk 'BEGIN{FS=","}

{if ($6 == "M"){$6=$5}}
{if ($7 == "M"){$7=$6}}
{if ($8 == "M"){$8=$7}}
{if ($9 == "M"){$9=$8}}
{print $0}' | sed 's/ /,/g'
	echo "===================================="

# Creating Observation Summary	

	echo "Observation Summary"
	echo "Year,Month,Day,Hour,MaxTemp,MinTemp,MaxWS,MinWS"

# Creating 4 variables to save the minimum and maximum values for wind and temperature
maxTemp=-1000
minTemp=1000
maxWind=-1000
minWind=1000

# Using several features of both sed and awk commands to parse the data files into an appropriate format
grep -v "Rambod" $i | sed -e 's/observation//g' -e 's/line//g' -e 's/performing diagnostics on temp.*//g' -e 's/active power disengaged//g' -e 's/signal strength low.//g' -e 's/data log flushed//g' -e 's/MISSED SYNC STEP/M/g' -e 's/NOINF/M/g' -e 's/\[\]//g' -e 's/-/,/' -e 's/-/,/' -e 's/    / /' -e 's/  / /' -e 's/ /,/g' -e 's/:..:..//g' -e '/,$/d' -e 's/,0$/,N/' -e 's/,1$/,NE/' -e 's/,2$/,E/' -e 's/,3$/,SE/' -e 's/,4$/,S/' -e 's/,5$/,SW/' -e 's/,6$/,W/' -e 's/,7$/,NW/'| awk 'BEGIN{FS=","}
maxTemp=-1000
{for(counter=5; counter <= 9; counter++){
	maxTemp=$5
	if($counter > maxTemp && $counter != "M"){
		maxTemp=$counter;
	}
}
minTemp=1000
{for(counter=5; counter <=9; counter++){
	minTemp=$5
	if($counter < minTemp && $counter != "M"){
		minTemp=$counter;
	}
}

maxWind=-1000
{for(counter=10; counter <= 12; counter++){
	maxWind=$10
	if($counter > maxWind){
		maxWind=$counter;
	}
}
minWind=1000
{for(counter=10; counter <= 12; counter++){
	minWind=$10
	if($counter < minWind){
		minWind=$counter;
	}
}
}
$9=""
$10=""
$11=""
$12=""
$13=""
$5=maxTemp
$6=minTemp
$7=maxWind
$8=minWind
print $0

}
}
}' | sed -e 's/    / /g' -e 's/ /,/g' -e 's/,$//' -e '/N/d' -e '/NE/d' -e '/E/d' -e '/SE/d' -e '/S/d' -e '/SW/d' -e '/W/d' -e '/NW/d' -e 's/,$//'
	echo "===================================="
}

# Calling the extractData function iteratively with different files as its argument
for i in $x
do
	extractData $i
done

cd $path_to_dir
echo "" > sensorstats.html
cd $1

path="$path_to_dir/"


# Generating HTML Table to store statistics for each sensor across all days in the data files
for i in $x
do

grep -v "Rambod" $i | sed -e 's/observation//g' -e 's/line//g' -e 's/performing diagnostics on temp.*//g' -e 's/active power disengaged//g' -e 's/signal strength low.//g' -e 's/data log flushed//g' -e 's/MISSED SYNC STEP/M/g' -e 's/NOINF/M/g' -e 's/\[\]//g' -e 's/-/,/' -e 's/-/,/' -e 's/    / /' -e 's/   / /' -e 's/ /,/g' -e 's/:..:..//g' -e '/,$/d' -e 's/,,/,/g' | awk 'BEGIN{FS=","}
$4=""
$10=""
$11=""
$12=""
$13=""
{print $0}' | sed -e 's/  / /g' -e 's/ /,/g' -e 's/,,//g' | awk 'BEGIN{FS=",";s1=0;s2=0;s3=0;s4=0;s5=0;total=0}
{if($4 == "M"){s1++}}
{if($5 == "M"){s2++}}
{if($6 == "M"){s3++}}
{if($7 == "M"){s4++}}
{if($8 == "M"){s5++}}
{total=s1+s2+s3+s4+s5}
{print $0, s1, s2, s3, s4, s5, total}' | sed -e 's/ /,/g' | awk -v p="$path" 'BEGIN{FS=","}
{print "<tr><td>" $1 "</td><td>" $2 "</td><td>" $3 "</td><td>" $9 "</td><td>" $10 "</td><td>" $11 "</td><td>" $12 "</td><td>" $13 "</td><td>" $14 "</td></tr>" >> p  "sensorstats.html"}'
done

cd $path_to_dir
# Sorting the file in descending order
sort -rk 9 -o sensorstats.html sensorstats.html

echo "</table>" >> sensorstats.html
echo "<script type=\"text/javascript\" src=\"/d2l/common/math/MathML.js?v=20.22.1.34798 \"></script><script type=\"text/javascript\">document.addEventListener('DOMContentLoaded', function() { D2LMathML.DesktopInit('https://s.brightspace.com/lib/mathjax/2.7.4/MathJax.js?config=MML_HTMLorMML','https://s.brightspace.com/lib/mathjax/2.7.4/MathJax.js?config=TeX-AMS-MML_HTMLorMML','130',true); });</script></body></html>" >> sensorstats.html

echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html><head></head><body><h2>Sensor error statistics</h2><table><tr><th>Year</th><th>Month</th><th>Day</th><th>TempS1</th><th>TempS2</th><th>TempS3</th><th>TempS4</th><th>TempS5</th><th>Total</th></tr><tr></tr>$(cat sensorstats.html)" > sensorstats.html

#end!

