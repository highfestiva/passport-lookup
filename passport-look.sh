#!/bin/bash

while true; do
	date
	echo 'curling...'
	rm cookies.txt
	export ua='User-Agent: Mozilla/5.0'
	export accept='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'
	export ct='Content-Type: application/x-www-form-urlencoded'
	export url1='https://bokapass.nemoq.se/Booking/Booking/Index/vastragotaland'
	export url='https://bokapass.nemoq.se/Booking/Booking/Next/vastragotaland'
	curl -H "$ua" -H "$accept" -c cookies.txt $url1 2>/dev/null >r1.html
	curl -H "$ua" -H "$accept" -H "$ct" -b cookies.txt -d 'FormId=1&ServiceGroupId=40&StartNextButton=Boka+ny+tid' -L $url 2>/dev/null >r2.html
	curl -H "$ua" -H "$accept" -H "$ct" -b cookies.txt -d 'AgreementText=bes%C3%B6ket.&AcceptInformationStorage=true&AcceptInformationStorage=false&NumberOfPeople=1&Next=N%C3%A4sta' -L $url 2>/dev/null >r3.html
	curl -H "$ua" -H "$accept" -H "$ct" -b cookies.txt -d 'ServiceCategoryCustomers%5B0%5D.CustomerIndex=0&ServiceCategoryCustomers%5B0%5D.ServiceCategoryId=2&Next=N%C3%A4sta' -L $url 2>/dev/null >r4.html
	export today=`date +%Y-%m-%d -d "+1 day"`
    curl -H "$ua" -H "$accept" -H "$ct" -b cookies.txt -d "FormId=1&NumberOfPeople=1&RegionId=0&SectionId=0&NQServiceTypeId=1&FromDateString=$today&SearchTimeHour=12&TimeSearchFirstAvailableButton=F%C3%B6rsta+lediga+tid" -L $url 2>/dev/null >r5.html
	avails=$(cat r5.html | grep -E '("sectionName"|"ReservedDateTime" value)')
	# avails=`cat << EOF
						# <strong id="sectionName">Alingsås</strong>
                        # <strong id="sectionName">Borås</strong>
                        # <strong id="sectionName">Falköping</strong>
                        # <strong id="sectionName">Göteborg</strong>
                        # <strong id="sectionName">Lidköping</strong>
                        # <strong id="sectionName">Mariestad</strong>
                        # <strong id="sectionName">Mark/Kinna</strong>
                        # <strong id="sectionName">Mölndal</strong>
                        # <strong id="sectionName">Skövde</strong>
                        # <strong id="sectionName">Stenungsund</strong>
                        # <strong id="sectionName">Strömstad</strong>
                        # <strong id="sectionName">Trollhättan</strong>
                        # <strong id="sectionName">Uddevalla</strong>
                        # <strong id="sectionName">Ulricehamn</strong>
                        # <strong id="sectionName">Åmål</strong>
                # <input type="radio" id="ReservedDateTime_2022-09-20 11:00:00" name="ReservedDateTime" value="2022-09-20 11:00:00"  />
                # <input type="radio" id="ReservedDateTime_2022-09-20 11:20:00" name="ReservedDateTime" value="2022-09-20 11:20:00"  />
                # <input type="radio" id="ReservedDateTime_2022-09-20 13:00:00" name="ReservedDateTime" value="2022-09-20 13:00:00"  />
                # <input type="radio" id="ReservedDateTime_2022-09-20 13:10:00" name="ReservedDateTime" value="2022-09-20 13:10:00"  />
                # <input type="radio" id="ReservedDateTime_2022-09-20 13:20:00" name="ReservedDateTime" value="2022-09-20 13:20:00"  />
				# <input type="radio" id="ReservedDateTime_2022-09-20 13:50:00" name="ReservedDateTime" value="2022-09-20 13:50:00"  />
# EOF`
	# echo "$avails"
	avails=`echo "$avails" | sed -E 's/.*">//' | sed -E 's/<\/.*//'`
	# echo "$avails"
	avails=`echo "$avails" | sed -E 's/.*value="//' | sed -E 's/".*//'`
	# echo "$avails"
	avails=`echo "$avails" | grep -B1 2022`
	echo "$avails"
	avails=`echo "$avails" | ./dump-bad-cities.py`
	echo "$avails"
	months=`echo "$avails" | sed -E 's/2022-//' | sed -E 's/-.+//' | awk '$0*=1'`
	# echo "$months"
	for month in $months
	do
		if [[ "$month" -lt 6 ]]; then
			echo "HIT!"
			echo "$avails"
			echo 'https://bokapass.nemoq.se/Booking/Booking/Index/vastragotaland'
			for i in {1..3}; do echo -en "\007"; sleep 3; done
			break
		else
			echo "Only month $month available."
		fi
	done
	echo "sleeping..."
    sleep 60
done
