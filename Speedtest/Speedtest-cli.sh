#!/bin/bash

#echo -e "Server ID\tSponsor\tServer NameTimestamp\tDistance\tPing\tDownload\tUpload\tShare\tIP Address\n" \
#> ./Speedtest-naja.csv
speedtest-cli --csv-header > Speedtest-naja.csv

speedtest-cli --list --secure | tail -n +2 > test-server.txt

echo "Server list: "; cat test-server.txt
echo "======================"; 

awk -F')' '{print $1}' test-server.txt > buffer.txt

tr '\n' ' ' < buffer.txt > test-server.txt; sed 's/ $//' buffer.txt > test-server.txt; rm buffer.txt


for ip in $(<test-server.txt); do
	speedtest-cli --secure --csv --server $ip >> Speedtest-naja.csv
	if test $? -ne 0; then
		echo "Error at $ip" >> Speedtest-naja.csv
	else
		echo "server-list successfully at $ip"
	fi
done

