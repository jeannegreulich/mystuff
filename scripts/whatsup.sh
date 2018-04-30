for x in  `virsh list --all | cut --bytes=8-17`; do
    if  [ "$x" != "Name      " ] && [ "$x" != "----------" ] ; then
      echo "Domain:  $x "
      virsh vncdisplay $x
    fi
done
