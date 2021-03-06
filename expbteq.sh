#!/bin/bash
#------------------------------------------------------------------------------------------#
#  SCRIPT:   BTEQ DYNAMIC EXPORT TO CSV                                                    #
#  VERSION:  1.0                                                                           #
#  RELEASED: 28/09/2017                                                                    #
#  AUTHOR:   James Armitage, Teradata                                                      #
#  EMAIL:    james.armitage@teradata.com                                                   #
#  STYLE:    https://google.github.io/styleguide/shell.xml                                 #
#  DESC:     script reads in tables\views from param\objects.txt and generates bteq export #
#            scripts.  The scripts are then executed and the whitespace removed from the   #
#            output files using sed. BTEQ does not do csv by default if select * is used   #
#------------------------------------------------------------------------------------------#

#******************************************************************************************#
# STEP 1 declare bteq path constants and variables and setup logging                       #
#******************************************************************************************#

# set path for bteq
PATH="$PATH":/opt/teradata/client/15.10/bin/bteq

# declare constants
readonly DIROUT=output
readonly DIRSQL=sql
readonly DIRBTQ=bteq
readonly DIRLOG=log
readonly DIRPRM=param

# declare variables
sq=bteqexp.sql
bt=bteqexp.bteq
st="$(cat $DIRSQL"/"$sq)"
rf=objects.txt

# stdout and stderr to terminal and log file
exec > >(tee $DIRLOG"/"job.log)

#*****************************************************************************************#
# STEP 2 loop through object.txt file and generate bteq export script                     #
#*****************************************************************************************#

# declare international field seperator
IFS="|"

# assign ref.txt to fl
fl="$DIRPRM"/"$rf"

# loop through file and use echo to generate terminal messages and script. echo not ideal /
# but quick, simple and works
while read -r db ob; do

  echo BUILD BTEQ EXPORT SCRIPT FOR "$db"."$ob" STARTED

  # add your tdip, username and password
  echo ".logon [tdip/username],[password] ;" > "$DIRBTQ"/"$bt"
  echo ".EXPORT REPORT FILE = "$PWD"/"$DIROUT"/"$ob".txt" >> "$DIRBTQ"/"$bt"
  echo ".SET WIDTH 6531;" >> "$DIRBTQ"/"$bt"
  echo ".SET TITLEDASHES OFF;" >> "$DIRBTQ"/"$bt"
  echo ".SET SEPARATOR ',';" >> "$DIRBTQ"/"$bt"
  echo "$st" "$db"."$ob;" >> "$DIRBTQ"/"$bt"
  echo ".Export RESET" >> "$DIRBTQ"/"$bt"
  echo ".logoff;" >> "$DIRBTQ"/"$bt"

  echo BUILD BTEQ EXPORT SCRIPT FOR "$db"."$ob" COMPLETE

  echo RUN BTEQ EXPORT
  bteq < "$DIRBTQ"/"$bt"

  echo REMOVE WHITESPACE FROM BTEQ OUTPUT FILE

  sed -i -e 's/ //g' "$DIROUT"/"$ob".txt

done < $fl



