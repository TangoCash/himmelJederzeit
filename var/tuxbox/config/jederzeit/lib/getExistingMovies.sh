#!/bin/sh

getExistingMovies()
{
  log "starting function getExistingMovies"
  mediaVerzeichnis=`grep "network_nfs_recordingdir" /var/tuxbox/config/neutrino.conf | cut -d"=" -f2`
  rm -f $mediaVerzeichnis/myFile
  rm -f $existingMoviesFile
  /var/tuxbox/plugins/listdir $mediaVerzeichnis/myFile ${mediaVerzeichnis}
  for xdo in `cat $mediaVerzeichnis/myFile`
  do
    /var/tuxbox/plugins/getEpgTitle $xdo >> $existingMoviesFile
  done
  log "end of function getExistingMovies"
}
#github test
