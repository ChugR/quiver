#!/bin/bash

# Run a series of quiver sessions with results in $1 directory
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

regroot=${1:-REGRESSION-20200501}
echo `date "+%Y-%m-%d %R:%S.%N"`
echo Storing regression databases in $regroot
mkdir $regroot
for configuration in "D1.10-P0.30" "D1.11-P0.30" "D1.12-P0.30" "D1.12-Pc2384ec"
do
	echo Please build and install proton-dispatch to support $configuration.
	echo Remember to build with -DCMAKE_BUILD_TYPE=RelWithDebInfo.
	echo Remember to rebuild quiver if a new version of proton was just installed.
	read -p "Press enter to continue..." dummy
	set -o xtrace
	mkdir -p $regroot/$configuration
	set +o xtrace
	
	test=P2P
	read -p "Ready to run $test test. Ensure that no routers are running..." dummy
	set -o xtrace
	mkdir $regroot/$configuration/$test
	quiver q1 --peer-to-peer --count 4000 --output $regroot/$configuration/$test              1> $regroot/$configuration/$test/console-log.txt 2>&1
	set +o xtrace
	
	test=P2P-settlement
	read -p "Ready to run $test test. Ensure that no routers are running..." dummy
	set -o xtrace
	mkdir $regroot/$configuration/$test
	quiver q1 --peer-to-peer --count 4000 --output $regroot/$configuration/$test --settlement 1> $regroot/$configuration/$test/console-log.txt 2>&1
	./plot-settlements.py $regroot/$configuration/$test $regroot/$configuration/$test
	set +o xtrace
	
	test=1QDR
	read -p "Ready to run $test test. Restart one router with no config file..." dummy
	set -o xtrace
	mkdir $regroot/$configuration/$test
	quiver q1 --count 4000 --output $regroot/$configuration/$test              1> $regroot/$configuration/$test/console-log.txt 2>&1	
	set +o xtrace

	test=1QDR-settlement
	read -p "Ready to run $test test. Restart one router with no config file..." dummy
	set -o xtrace
	mkdir $regroot/$configuration/$test
	quiver q1 --count 4000 --output $regroot/$configuration/$test --settlement 1> $regroot/$configuration/$test/console-log.txt 2>&1
	./plot-settlements.py $regroot/$configuration/$test $regroot/$configuration/$test
	set +o xtrace
	
	test=3QDR-settlement
	read -p "Ready to run $test test. Restart three routers with config files from scripts-cr/t5-A.conf, B and C ..." dummy
	echo Run this first in receiver window: scripts-cr/t5-receiver.sh $regroot/$configuration/$test
	echo Run this next  in sender   window: scripts-cr/t5-sender.sh   $regroot/$configuration/$test
	read -p "Press enter when the scripts have completed..." dummy
	set -o xtrace
	./plot-settlements.py $regroot/$configuration/$test $regroot/$configuration/$test
	set +o xtrace
done
