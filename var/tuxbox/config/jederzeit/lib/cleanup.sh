#!/bin/sh

cleanUp () {
  log "startin function: cleanup"
  if [ -f $filmFile ]; then
    Stand
    cp $filmFile ${filmFilePrevious}
  fi
  
  files="${tmp}1 ${tmp}Filme ${tmp}Welt ${tmp}Serien ${filmFile} ${deletionExecutionFile}  ${serienFile} ${weltFile} ${filmDeletionFile}"
  dirs="${wgetDirectory} ${tmp}"
  
  for xdo in $files
  do
    if [ -f $xdo ]; then
      rm $xdo
    fi
  done
  
}

removeAlreadyTimedEntries () {
  log "startin function: removeAlreadyTimedEntries"
  for xdo in `cut -d";" -f3 ${filmStatusFile} | sed -e 's/ /(/g'`;
  do
    string=`echo $xdo | sed -e 's/(/ /g'`
    grep -v "${string}" ${filmFile} > ${tmp_file}
    mv ${tmp_file} ${filmFile}
    echo "<br><div>"${string}"</div>" >> ${mediaVerzeichnis}"/done.html"
    log "Filme aufgenommen:" ${string}
    
  done
}

Stand () {
  log "startin function: Stand"
  cp ${filmFile} $filmFilePrevious
  grep "#" ${filmFile} >> ${filmStatusFile}
  grep -v "#" ${filmFile} > ${tmp_file}
  mv $tmp_file $filmFile
}



deleteFiles() {
  deleteMovies
}
