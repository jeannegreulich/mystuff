#! /bin/bash

curdir=`pwd`
OUTPUTDIR=/var/jmg/OUTPUT
if [ ! -d $OUTPUTDIR ]
then
  mkdir $OUTPUTDIR
fi

DATE=`date +%Y%d%m%H%M%S`
OUTFILE=$OUTPUTDIR/output.${DATE}.txt
ERRFILE=$OUTPUTDIR/error.${DATE}.txt

if [ -f $OUTFILE ]
then
  mv $OUTFILE ${OUTFILE}.bak
fi

for x in `ls`; do
  top=`pwd`
  cd $x
  bundle install 2>>$ERRFILE  1> /dev/null
  echo "MODULE: $x" >> $OUTFILE
  bundle exec rake pkg:compare_latest_tag >> $OUTFILE 2>&1
  cd $top
done



