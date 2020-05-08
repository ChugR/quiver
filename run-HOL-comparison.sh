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

regroot=${1:-HOL-tests}
echo `date "+%Y-%m-%d %R:%S.%N"`
echo Storing regression databases in $regroot
mkdir $regroot
for configuration in "Dkgiusti_DISPATCH_1545-P0.31master"
do
	echo Please build and install proton-dispatch to support $configuration.
	echo Remember to build with -DCMAKE_BUILD_TYPE=RelWithDebInfo.
	echo Remember to rebuild quiver if a new version of proton was just installed.
	~/bin/git-proton-dispatch-state.sh
	read -p "Press enter to continue..." dummy
	~/bin/git-proton-dispatch-state.sh
	set -o xtrace
	mkdir -p $regroot/$configuration
	set +o xtrace
	
	testb=P2P
	echo "Ready to run $testb test. Ensure that no routers are running."
	read -p "Press enter to run test. Enter text to skip :" skipflag
	if [ -z ${skipflag} ];
	then
		set -o xtrace
		for testpass in `seq 1 3`;
		do
			test=${testb}_${testpass}
			mkdir $regroot/$configuration/$test
			quiver q1 --peer-to-peer --count 100000 --body-size 500000 --timeout 120000 --output $regroot/$configuration/$test   1> $regroot/$configuration/$test/console-log.txt 2>&1
		done
		set +o xtrace
	else
		echo Skipping test $testb
	fi
	
	testb=P2P-settlement
	echo "Ready to run $testb test. Ensure that no routers are running."
	read -p "Press enter to run test. Enter text to skip :" skipflag
	if [ -z ${skipflag} ];
	then
		set -o xtrace
		for testpass in `seq 1 3`;
		do
			test=${testb}_${testpass}
			mkdir $regroot/$configuration/$test
			quiver q1 --peer-to-peer --count 100000 --body-size 500000 --timeout 120000 --output $regroot/$configuration/$test --settlement 1> $regroot/$configuration/$test/console-log.txt 2>&1
		done
		#./plot-settlements.py $regroot/$configuration/$test $regroot/$configuration/$test
		set +o xtrace
	else
		echo Skipping test $testb
	fi
	
	testb=1QDR
	echo "Ready to run $testb test. Restart one router with no config file."
	read -p "ReadPress enter to run test. Enter text to skip :" skipflag
	if [ -z ${skipflag} ];
	then
		set -o xtrace
		for testpass in `seq 1 3`;
		do
			test=${testb}_${testpass}
			mkdir $regroot/$configuration/$test
			quiver q1 --count 100000 --body-size 500000 --timeout 120000 --output $regroot/$configuration/$test 1> $regroot/$configuration/$test/console-log.txt 2>&1
		done
		set +o xtrace
	else
		echo Skipping test $testb
	fi

	testb=1QDR-settlement
	echo "Ready to run $testb test. Restart one router with no config file."
	read -p "ReadPress enter to run test. Enter text to skip :" skipflag
	if [ -z ${skipflag} ];
	then
		set -o xtrace
		for testpass in `seq 1 3`;
		do
			test=${testb}_${testpass}
			mkdir $regroot/$configuration/$test
			quiver q1 --count 100000 --body-size 500000 --timeout 120000 --output $regroot/$configuration/$test --settlement 1> $regroot/$configuration/$test/console-log.txt 2>&1
		done
		#./plot-settlements.py $regroot/$configuration/$test $regroot/$configuration/$test
		set +o xtrace
	else
		echo Skipping test $testb
	fi
	
	testb=3QDR-settlement
	echo "Ready to run $testb test. Restart three routers with config files from scripts-cr/t5-A.conf, B and C ."
	read -p "Press enter to run test. Enter text to skip :" skipflag
	if [ -z ${skipflag} ];
	then
		set -o xtrace
		for testpass in `seq 1 3`;
		do
			test=${testb}_${testpass}_1
			quiver-arrow --output $regroot/$configuration/$test --count 100000 --settlement --timeout 120000 receive amqp://127.0.0.1:5676/examples &
			rpid1=$!
			quiver-arrow --output $regroot/$configuration/$test --count 100000 --body-size 500000 --settlement send amqp://127.0.0.1:5672/examples &
			spid1=$!
			
			test=${testb}_${testpass}_2
			quiver-arrow --output $regroot/$configuration/$test --count 100000 --settlement --timeout 120000 receive amqp://127.0.0.1:5676/q1 &
			rpid2=$!
			quiver-arrow --output $regroot/$configuration/$test --count 100000 --body-size 500000 --settlement send amqp://127.0.0.1:5672/q1 &
			spid2=$!
			wait $rpid1
			wait $spid1
			wait $rpid2
			wait $spid2
		done
		#./plot-settlements.py $regroot/$configuration/$test $regroot/$configuration/$test
		set +o xtrace
	else
		echo Skipping test $testb
	fi
done

