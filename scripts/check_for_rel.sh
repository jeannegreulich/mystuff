# -la /bin/bash

curdir=`pwd`
OUTPUTDIR=/var/jmg/OUTPUT
if [ ! -d $OUTPUTDIR ]
then
  mkdir $OUTPUTDIR
fi

DATE=`date +%Y%d%m%H%M%S`
OUTFILE=$OUTPUTDIR/output.${DATE}.txt
ERRFILE=$OUTPUTDIR/error.${DATE}.txt
CHANGELOG=$OUTPUTDIR/changelog.${DATE}.txt

if [ -f $OUTFILE ]
then
  mv $OUTFILE ${OUTFILE}.bak
fi

for x in `ls`; do
  top=`pwd`
  cd $x
  bundle install 2>>$ERRFILE  1> /dev/null
  echo "MODULE: $x" >> $OUTFILE
  echo "--------------------------------------" >> $OUTFILE
  bundle exec rake pkg:compare_latest_tag >> $OUTFILE 2>&1
  cd $top
  echo "MODULE: $x" >> $CHANGELOG
  echo "--------------------------------------" >> $CHANGELOG
  bundle exec rake  changelog_annotation >> $CHANGELOG 2>&1
done



