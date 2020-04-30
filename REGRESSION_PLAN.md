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

 
