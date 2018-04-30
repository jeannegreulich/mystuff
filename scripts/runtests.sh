#! /bin/sh

wdir=`pwd`
outdir=${wdir}/output

if [ ! -d $outdir ]; then
  mkdir $outdir
fi

export PUPPET_VERSION=4.10.6
for mod in `ls`; do
  echo "Executing $mod"
  if [[ -d $mod ]] && [[ $mod != 'output' ]] && [[ $mod != 'augeasproviders' ]]; then
    cd $mod
    if [ -f Gemfile.lock ]; then
      rm Gemfile.lock
    fi
    bundle update > ${outdir}/beaker.${mod}
    gem uninstall vagrant-wrapper
    if [ -d spec/acceptance/suites ]; then
      bundle exec rake beaker:suites >> ${outdir}/beaker.${mod} 2>&1
    elif [ -d spec/acceptance ]; then
      bundle exec rake acceptance >> ${outdir}/beaker.${mod} 2>&1
    else
      echo "No Acceptance tests found for $mod" >> ${outdir}/beaker.${mod} 2>&1
    fi
    if [ $? != 0 ]; then
      mv ${outdir}/beaker.${mod} ${outdir}/beaker.${mod}.error
    fi
  fi
  cd $wdir
done
