The scripts:

1) The puppet_wait script is copied to the baseline machine in /etc/init.d and configured to run (chkconfig puppet_wait on)
   This will run puppet for the firstime on the machine with a wait for certificates and then it will disable itself. 
   We changed /etc/puppet/autosign.conf to have *.fun.domain in it so certs will be signed off immediately.  Chris copied all the names into the togen file an currently generating certificates... it is taking a while.

2) scrub.sh is used on the baseline client (in this case simp-cli)  to clean up the junk left behind by the old machine.
   To create a baseline i run scrub.sh on the clinet and it cleans up and shuts down the client.
   you then dump the xml  (virsh dumpxml simp-cli > v6.template.xml) and copy the v6.template.xml to /scratch2/cr8_data and copy the disk from the system to /scratch2/cr8_data/v6.disk.

  The scratch2/cr8_data is teh repository that the compute nodes will download from.

  When you create the 7 node, do the same thing but name them v7.template.xml and v7.disk.

3) The script that generates all the machines is cr8machines.sh.   It needs to be copied to the node on which the machines
   are goingt o be created.  before you run it edit the x1,x2, y1,y2 values.  It will run in for loop and create 
	172.19.y1.x1 ... 172.19.y1.x2
        ...
        172.19.y2.x1 ... 172.19.y2.x2

   the name of the client is clienty-x so 172.19.32.178 will be client32-178 with a mac of cc:cc:cc:03:21:78

   The script will check the local /data/cr8_data directory for the v6.* files (if y is below 128.  if y is above 128 it will    look for the v7.* file).
   If it does not find them locally it will scp them from service2:/scratch2/cr8_data and put them in /data2/cr8_data.

   So if you have updated the files on service2 make sure you remove /data2/cr8_data so it will download the new ones.
   (it only takes about 20 seconds to download the new files so if you are not sure then delete the directory.)

   So once you have but in the values you want for x1, x2, y1 and y2, just the script.  It will mod the x value and place
  the files for the new client in /hdfs/mod(x)/clientname.  So client123-2 will go into /hdfs/02/client123-2/
  It does not check if the disk is full, it jsut puts it there.  

  
