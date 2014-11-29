#!/bin/awk -f
BEGIN {
FS = "|";
ausgabe = "starting match for Typereplacement:";
ausgabe = ausgabe "\nBouquet Nr.:"bouquet ;
hans=1;
}
// {

  if ( substr($9,0,3) == "Kom" )
  {
    $9 = "Comedy";
  }
  if ( substr($9,0,6) == "Sci-Fi" || substr($9,0,5) == "SciFi" ) 
  {
    $9 = "SciFi";
  }
  if ( substr($9,0,5) == "Drama") 
  {
    $9 = "Drama";
  }
  if ( substr($9,0,9) =="Abenteuer" )
  {
    $9 = "Adventure";
  }
  if ( substr($9,0,7) =="Familie")
  {
    $9 = "Family";
  }
 
 if ( length($2) > 0 )
 {
	if ( timeSpan != "" )
  	{
    	printf("*%s;*,%s;%s,!Making;O;%sanytime/%s\n",bouquet,timeSpan,$2,mediaVerzeichnis,$9) >> output_file
  	}
  	else if ( NF > 0 )
  	{
     	printf("*%s;*;%s,!Making;O;%sanytime/%s\n",bouquet,$2,mediaVerzeichnis,$9) >> output_file
  	}
  	if ( length($6) > 0 )
  	{
		printf("%s|%s|%sanytime/%s\n",$2,$6,mediaVerzeichnis,$9) >> deletionFile
	}
	else
	{
		printf("no deletiondate delivered %s\n",$2);
	}
  }
}
END {
print ausgabe;
}
