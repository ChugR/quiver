#!/bin/bash

# Run a series of quiver sessions with results in ./REGRESSION
# Each session requires a build configuration identifier describing the Proton-Dispatch
#  pair which is built and installed externally.
# For each configuration:
#  * prompt to verify that the Proton-Dispatch is installed
#  * For each test scenario
#    * prompt to verify that the scenario externals are in place (no routers, one router, N routers)
#    * run the scenario with and without the --settlement switch
#
# The P2P and 1QDR scenarios can run with no fanfare and quiver console output is saved in output dir.
# The 3QDR scenario requires separate sender and receiver runs

regroot=REGRESSION
mkdir $regroot
for configuration in "D1.10-P0.30" "D1.11-P0.30" "D1.12-P0.30" "D1.12-Pc2384ec"
do
	read -p "Please build and install proton-dispatch to support $configuration. Press enter to continue..." dummy
	mkdir -p $regroot/$configuration
	
	test=P2P
	mkdir $regroot/$configuration/$test
	read -p "Ready to run $test test. Ensure that no routers are running..." dummy
	quiver q1 --peer-to-peer --count 4000 --output $regroot/$configuration/$test              1> $regroot/$configuration/$test/console-log.txt 2>&1
	
	test=P2P-settlement
	mkdir $regroot/$configuration/$test
	read -p "Ready to run $test test. Ensure that no routers are running..." dummy
	quiver q1 --peer-to-peer --count 4000 --output $regroot/$configuration/$test --settlement 1> $regroot/$configuration/$test/console-log.txt 2>&1
	
	test=1QDR
	mkdir $regroot/$configuration/$test
	read -p "Ready to run $test test. Restart one router with no config file..." dummy
	quiver q1 --peer-to-peer --count 4000 --output $regroot/$configuration/$test              1> $regroot/$configuration/$test/console-log.txt 2>&1
	
	test=1QDR-settlement
	mkdir $regroot/$configuration/$test
	read -p "Ready to run $test test. Restart one router with no config file..." dummy
	quiver q1 --peer-to-peer --count 4000 --output $regroot/$configuration/$test --settlement 1> $regroot/$configuration/$test/console-log.txt 2>&1
	
	test=3QDR-settlement
	mkdir $regroot/$configuration/$test
	read -p "Ready to run $test test. Restart three routers with config files from scripts-cr/t5-A.conf, B and C ..." dummy
	echo Run this first in receiver window: scripts-cr/t5-receiver.sh $regroot/$configuration/$test
	echo Run this next  in sender   window: scripts-cr/t5-sender.sh   $regroot/$configuration/$test
done
