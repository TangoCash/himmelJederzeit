#!/bin/sh

createBouquet() {
	if  [ -d ${wgetDirectory} ];
	then
		rm -rf ${wgetDirectory}
	fi
	mkdir ${wgetDirectory}
	log "startin function: createBouquet" 
	wget -O ${wgetDirectory}eins "http://127.0.0.1/control/addbouquet?name=himmelJederzeit"
	getHimmelJederzeitBouquet
	#wget -O ${wgetDirectory}eins.2 "http://127.0.0.1/control/setbouquet?selected=${bouquetId}&action=show"
	wget -O ${wgetDirectory}eins.2.1 "http://127.0.0.1/control/setbouquet?selected=${bouquetId}&action=unlock"

}
identifyAndAddChannels() {
	
	    log "startin function: identifyAndAddChannels" 
        wget -O ${wgetDirectory}channellist "http://127.0.0.1/control/channellist"
        sort -u ${wgetDirectory}channellist > ${wgetDirectory}channellist.sorted

        ids=`grep "Sky Cinema HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "Sky Action HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "Sky Hits HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "Disney Channel HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "Disney Cinemagic HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "Sky Comedy" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "Sky Emotion" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
        ids=$ids","`grep "MGM HD" ${wgetDirectory}channellist.sorted | cut -f1 -d" "`
                
	BODY="selected=${bouquetId}&bchannels=${ids}"
	BODY_LEN=$( busybox echo -n ${BODY} | wc -c )
	busybox echo -ne "POST /control/changebouquet HTTP/1.0\r\nHost: 127.0.0.1\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: ${BODY_LEN}\r\n\r\n${BODY}" | nc -i 3 127.0.0.1 80
        
        #wget -O ${wgetDirectory}zwo  "http://127.0.0.1/control/changebouquet?selected=${bouquetId}&bchannels=${ids}"

        echo "wget -O ${wgetDirectory}zwo  \"http://127.0.0.1/control/changebouquet?selected=${bouquetId}&bchannels=${ids}\""
	wget -O ${wgetDirectory}drei "http://127.0.0.1/control/setbouquet?selected=${bouquetId}&action=show"
        wget -O ${wgetDirectory}vier "http://127.0.0.1/control/savebouquet"
}

getHimmelJederzeitBouquet() {
	bouquetId=`/usr/local/bin/pzapit | grep himmelJederzeit | cut -d":" -f1`
	if [[ $bouquetId == "" ]]
	then
		echo "himmelJederzeit Bouquet nicht gefunden"
		exit;
	fi
}
