#!/bin/bash

fips=true
defaultonly=false
gitupdate=false
while [ $# -ne 0 ]
do
    arg="$1"
    case "$arg" in
        --nofips)
            fips=false
            ;;
        --defaultonly)
            defaultonly=true
            ;;
        --git)
            gitupdate=true
    esac
    shift
done

workingdir=`pwd`

for mod in `ls`
do
  [[ ! -d $mod ]] && continue
  if [ -f ./.mymods ] ; then
    [[ `grep "^${mod}$" ./.mymods != 0` ]] && continue
  fi

  cd $mod

  echo "Starting ${mod}"

  $gitupdate && git pull origin master
  [[ -f Gemfile.lock ]] && rm -f Gemfile.lock
  PUPPET_VERSION='~> 5.5' bundle install
  suitedir="spec/acceptance/suites/"

  echo "Working directory "  `pwd`

  if [ ! -d ./testresults ]; then
    mkdir ./testresults
  fi

  for x in `ls spec/acceptance/suites/`
  do
    if [ $defaultonly ]; then
      [[ $x != "default" ]] && continue
    fi
    echo "Starting $x"
    for n in `ls spec/acceptance/suites/${x}/nodesets`
    do
      if [ ! -L ${n} ]; then
        node=${n%.*}
        fileout="./testresults/${x}_${node}"
        echo "starting on nodeset ${node}"
        PUPPET_VERSION='~> 5.5' BEAKER_PUPPET_COLLECTION="puppet5" bundle exec  rake beaker:suites[$x,$node] |& tee $fileout
         if [ $fips ]; then
           BEAKER_fips=yes PUPPET_VERSION='~> 5.0' BEAKER_PUPPET_COLLECTION="puppet5" bundle exec  rake beaker:suites[$x,$node] |& tee ${fileout}.fips
        fi
        echo "Finish $x on nodeset ${node}"
      fi
    done
  done
  cd $workingdir
done
