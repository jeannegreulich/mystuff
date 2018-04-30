#! /bin/sh
currentdir=`pwd`
outdir=$currentdir/output
export PUPPET_VERSION=4.10

if [ ! -d $outdir ]; then
  mkdir $outdir
fi

for module in `ls`; do
  if [ -f $outdir/$module ]; then
    rm $outdir/$module
  fi
  cd $currentdir/$module
  bundle update
  bundle exec rake test 2>&1 > $outdir/$module
 if [ $? != 0 ] ; then
   mv $outdir/$module $outdir/${module}.error
  fi
done


