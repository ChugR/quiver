Time to keep track of some old builds so comparisons to new builds
are easier. Duh!

Things to track progress on are:
 * version of qpid-proton
 * version of qpid-dispatch
 * test harness: P2P, 1QDR, 3QDR
 * QDR: normal, link route (skipping link route for now...)
 * --settlement or not
 
For starters make these environments:

 * D1.10-P0.30
 * D1.11-P0.30
 * D1.12-P0.30
 * D1.12-Pmaster
 
Then for each environment run these tests:

 * P2P
 * P2P-settlement
 * 1QDR
 * 1QDR-settlement
 * 3QDR
 * 3QDR-settlement

Settlement plots generated only for -settlement tests.

In google docs create a doc for each test run:
 * page showing no settlement quiver output
 * page showing  --settlement quiver output
 * pages with the three settlement PDF plots

 
quiver q0 --output $VVV --count 4000 --settlement
capture quiver output copy to $VVV
IF --settlement THEN run plot-settlements.py

====
In practice:
====

The main window

(settle-track-30=8eedf *2 ?23) chug@unused quiver> export VVV=REGRESSION/D1.12-Pc2384ecdc
(settle-track-30=8eedf *2 ?23) chug@unused quiver> 
(settle-track-30=8eedf *2 ?23) chug@unused quiver> mkdir -p $VVV/P2P
(settle-track-30=8eedf *2 ?23) chug@unused quiver> mkdir $VVV/P2P-settlement
(settle-track-30=8eedf *2 ?23) chug@unused quiver> mkdir $VVV/1QDR
(settle-track-30=8eedf *2 ?23) chug@unused quiver> mkdir $VVV/1QDR-settlement
(settle-track-30=8eedf *2 ?23) chug@unused quiver> mkdir $VVV/3QDR
(settle-track-30=8eedf *2 ?23) chug@unused quiver> quiver q0 --output $VVV/P2P --peer-to-peer --count 4000 > $VVV/P2P/console-log.txt 2>&1

(settle-track-30=8eedf *2 ?23) chug@unused quiver> quiver q0 --output $VVV/P2P-settlement --peer-to-peer --count 4000 --settlement > $VVV/P2P-settlement/console-log.txt 2>&1
(settle-track-30=8eedf *2 ?23) chug@unused quiver> ./plot-settlements.py $VVV/P2P-settlement "D1.12-Pc2384ecdc-P2P-settlement"

(settle-track-30=8eedf *2 ?23) chug@unused quiver> quiver q0 --output $VVV/1QDR --count 4000 > $VVV/1QDR/console-log.txt 2>&1
(settle-track-30=8eedf *2 ?23) chug@unused quiver> quiver q0 --output $VVV/1QDR-settlement --count 4000 --settlement > $VVV/1QDR-settlement/console-log.txt 2>&1
(settle-track-30=8eedf *2 ?23) chug@unused quiver> ./plot-settlements.py $VVV/1QDR-settlement "D1.12-Pc2384ecdc-1QDR-settlement"

(settle-track-30=8eedf *2 ?23) chug@unused quiver> ./plot-settlements.py $VVV/3QDR-settlement "D1.12-Pc2384ecdc-3QDR-settlement"

In the QDR window(s)

Run straight qdrouterd for the 1QDR tests

In three windows for the 3QDR tests:

qdrouterd -c scripts-cr/t5-A.conf

In send and receive windows run:

(settle-track-30=8eedf *1 ?23) chug@unused quiver> export VVV=REGRESSION/D1.12-Pc2384ecdc
(settle-track-30=8eedf *2 ?23) chug@unused quiver> scripts-cr/t5-receiver.sh $VVV/3QDR-settlement
