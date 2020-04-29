Let's say you want to run quiver against a current build of proton and 
dispatch. Now what?

1. Build proton, dispatch, quiver. RELEASE build has way better numbers

2. Set up qpid-dispatch or whatever to run against
   qdrouterd (-c some-config.conf) > qdrouterd.log 2>&1

3. Set up shell to run quiver
    . ./devel.sh

4. Run quiver
    chug@unused quiver> quiver q0 --output 20200108-dispatch-master-proton-master --count 4000 --settlement

    This saved the output into the directory. It runs proton-c arrows.

5. Run analysis
	
	chug@unused quiver> plot-settlements <directory> <plot-title>
	quiver  20200108-dispatch-master-proton-master "Dispatch 1.12, proton master"
	
6. Enjoy the output
     .pdf        - the main output
	 -credit.pdf - plots latencies, transfer/settlement in flight, credit
	 -vlines.pdf - plots on diagonal with time on both axes
 
	
