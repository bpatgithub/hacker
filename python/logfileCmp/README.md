# Project Title

Comparing two treatment files for Dialysis treatment records.  It identifies
missing records and also mis-matched fields with in the file.

## Getting Started

Install python2.x, preferably 2.7.

### Testing
**Sample Input**
(python2) Bhaveshs-MacBook-Air:logfileCmp admin$ python fileCmp.py
Enter Tablo Script File Name: ts.csv
Enter PHI Web File Name: web.csv

**Sample Output**
ts seq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
total cols are  44
pw seq [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
TabloScript is missing these seuqneces  []
PHI web is missing these seuqneces  [1, 2, 3, 4, 5, 6, 7]
####  Missing records ####
Missing in PHI [ ('stateChanged', 1, 'N/A', -1, 'PRETREATMENT', 24, 'Fri 10/7/2016 7:18:21 PM', 'PST', 1506007, '123-45-6789', 3600, 0, 350, 300, 0, False, 0.0, 300.0, 0.0, 0.0, 54.9375, 0.0, 0, 1.03125, 2.03125, 1.816406, 37, 26.0, 108.625, 0, 1800, 1, 0, 0, 0, 0, 0, 0, 0, 70, 33, 0, 80, 37)]
Missing in PHI [ ('emrPretreatmentStarted', 2, 'Alarm', -1, 'PRETREATMENT', 24, 'Fri 10/7/2016 7:18:21 PM', 'PST', 1506007, '123-45-6789', 3600, 0, 350, 300, 0, False, 0.0, 300.0, 0.0, 0.0, 54.9375, 0.0, 0, 1.03125, 2.03125, 1.816406, 37, 26.0, 108.625, 0, 1800, 1, 0, 0, 0, 0, 0, 0, 0, 70, 33, 0, 80, 37)]
Missing in PHI [ ('AlarmOnData', 3, 'ALARM_ST_USER_CONFIRMATION_SCREEN', 102, 'PRETREATMENT', 24, 'Fri 10/7/2016 7:18:25 PM', 'PST', 1506007, '123-45-6789', 3600, 0, 350, 300, 0, False, 0.0, 300.0, 0.0, 0.0, 54.9375, 0.0, 0, 1.03125, 2.03125, 1.613281, 37, 26.0, 109.28125, 0, 1800, 1, 0, 0, 0, 0, 0, 0, 0, 70, 33, 0, 80, 37)]
Missing in PHI [ ('AlarmOffData', 4, 'ALARM_ST_USER_CONFIRMATION_SCREEN', 102, 'PRETREATMENT', 24, 'Fri 10/7/2016 7:18:29 PM', 'PST', 1506007, '123-45-6789', 3600, 0, 350, 300, 0, False, 0.0, 300.0, 0.0, 0.0, 54.9375, 0.0, 0, 1.03125, 2.03125, 1.816406, 37, 26.0, 111.34375, 0, 1800, 1, 0, 0, 0, 0, 0, 0, 0, 70, 33, 0, 80, 37)]
Missing in PHI [ ('AlarmOnData', 5, 'ALARM_ST_PRE_ARTERIAL_SALINE_PRIME_FAILURE', 73, 'PRETREATMENT', 24, 'Fri 10/7/2016 7:27:13 PM', 'PST', 1506007, '123-45-6789', 1800, 0, 350, 300, 0, False, 0.0, 600.0, 0.0, 0.0, 54.9375, 0.0, 0, 1.03125, 2.625, -103.226562, 37, 37.25, 18950.5, 0, 1800, 1, 0, 0, 0, 0, 0, 0, 5, 70, 33, 0, 80, 37)]
Missing in PHI [ ('AlarmOffData', 6, 'ALARM_ST_PRE_ARTERIAL_SALINE_PRIME_FAILURE', 73, 'PRETREATMENT', 24, 'Fri 10/7/2016 7:27:32 PM', 'PST', 1506007, '123-45-6789', 1800, 0, 350, 300, 0, False, 0.0, 600.0, 0.0, 0.0, 54.9375, 0.0, 0, 2.03125, 14.34375, -95.550781, 37, 37.28125, 17539.5, 0, 1800, 1, 0, 0, 0, 0, 0, 0, 5, 70, 33, 0, 80, 37)]
Missing in PHI [ ('settingChangeAuto', 7, 'fluid removal on', -1, 'PRETREATMENT', 24, 'Fri 10/7/2016 7:38:20 PM', 'PST', 1506007, '123-45-6789', 1800, 0, 350, 300, 0, False, 0.0, 600.0, 0.0, 410.8125, 54.9375, 0.300781, 0, 3.0625, -68.875, -93.328125, 37, 37.03125, 13856.75, 0, 1800, 1, 0, 0, 0, 0, 0, 0, 5, 70, 33, 0, 80, 37)]
*****Field mismatch for seq no  8
TS : PHI  stateChanged  :  EMR_EVENT_STATE_CHANGED
TS : PHI  Fri 10/7/2016 7:38:20 PM  :  Fri Oct 07 19:38:20 2016
TS : PHI  1506007  :  LL1
TS : PHI  0.300781  :  0.30078125
*****Field mismatch for seq no  9
TS : PHI  emrAlertOn  :  EMR_EVENT_ALERT_ON
TS : PHI  Fri 10/7/2016 7:40:00 PM  :  Fri Oct 07 19:40:00 2016
TS : PHI  1506007  :  LL1
*****Field mismatch for seq no  10
TS : PHI  dynamicPressure  :  EMR_EVENT_DYNAMIC_PRESSURE
TS : PHI  Fri 10/7/2016 7:40:21 PM  :  Fri Oct 07 19:40:21 2016
TS : PHI  1506007  :  LL1
TS : PHI  0.410156  :  0.41015625
*****Field mismatch for seq no  11
TS : PHI  emrAlertOff  :  EMR_EVENT_ALERT_OFF
TS : PHI  Fri 10/7/2016 7:40:57 PM  :  Fri Oct 07 19:40:57 2016
TS : PHI  1506007  :  LL1
TS : PHI  1.082031  :  1.0820312
TS : PHI  0.441406  :  0.44140625
*****Field mismatch for seq no  12
TS : PHI  emrScheduled  :  EMR_EVENT_SCHEDULED
TS : PHI  Fri 10/7/2016 7:55:57 PM  :  Fri Oct 07 19:55:57 2016
TS : PHI  1506007  :  LL1
TS : PHI  125.964844  :  125.96484
TS : PHI  600.101562  :  600.10156
TS : PHI  7.675781  :  7.6757812
*****Field mismatch for seq no  13
TS : PHI  emrScheduled  :  EMR_EVENT_SCHEDULED
TS : PHI  Fri 10/7/2016 8:10:57 PM  :  Fri Oct 07 20:10:57 2016
TS : PHI  1506007  :  LL1
TS : PHI  276.039062  :  276.03906
TS : PHI  601.242188  :  601.2422
TS : PHI  2.089844  :  2.0898438
*****Field mismatch for seq no  14
TS : PHI  emrAlertOn  :  EMR_EVENT_ALERT_ON
TS : PHI  Fri 10/7/2016 8:11:16 PM  :  Fri Oct 07 20:11:16 2016
TS : PHI  1506007  :  LL1
TS : PHI  279.285156  :  279.28516
TS : PHI  601.242188  :  601.2422
*****Field mismatch for seq no  15
TS : PHI  emrAlertOff  :  EMR_EVENT_ALERT_OFF
TS : PHI  Fri 10/7/2016 8:11:35 PM  :  Fri Oct 07 20:11:35 2016
TS : PHI  1506007  :  LL1
TS : PHI  282.429688  :  282.4297
TS : PHI  601.242188  :  601.2422
TS : PHI  -6.664062  :  -6.6640625
*****Field mismatch for seq no  16
TS : PHI  dialysateFlowChanged  :  EMR_EVENT_DIALYSATE_FLOW_CHANGED
TS : PHI  Fri 10/7/2016 8:13:20 PM  :  Fri Oct 07 20:13:20 2016
TS : PHI  1506007  :  LL1
TS : PHI  300.109375  :  300.10938
TS : PHI  601.242188  :  601.2422
TS : PHI  2.222656  :  2.2226562
TS : PHI  6.261719  :  6.2617188
*****Field mismatch for seq no  17
TS : PHI  stateChanged  :  EMR_EVENT_STATE_CHANGED
TS : PHI  Fri 10/7/2016 8:13:20 PM  :  Fri Oct 07 20:13:20 2016
TS : PHI  1506007  :  LL1
TS : PHI  300.109375  :  300.10938
TS : PHI  601.242188  :  601.2422
TS : PHI  2.222656  :  2.2226562
TS : PHI  6.261719  :  6.2617188
*****Field mismatch for seq no  18
TS : PHI  stateChanged  :  EMR_EVENT_STATE_CHANGED
TS : PHI  Fri 10/7/2016 8:19:01 PM  :  Fri Oct 07 20:19:01 2016
TS : PHI  1506007  :  LL1
TS : PHI  300.167969  :  300.16797
TS : PHI  601.242188  :  601.2422
TS : PHI  2.222656  :  2.2226562
TS : PHI  -0.605469  :  -0.60546875
*****Field mismatch for seq no  19
TS : PHI  dialysateFlowChanged  :  EMR_EVENT_DIALYSATE_FLOW_CHANGED
TS : PHI  Fri 10/7/2016 8:22:25 PM  :  Fri Oct 07 20:22:25 2016
TS : PHI  1506007  :  LL1
TS : PHI  1.542969  :  1.5429688
TS : PHI  596.914062  :  596.91406
TS : PHI  2.222656  :  2.2226562
TS : PHI  -87.871094  :  -87.87109
*****Field mismatch for seq no  20
TS : PHI  stateChanged  :  EMR_EVENT_STATE_CHANGED
TS : PHI  Fri 10/7/2016 8:22:25 PM  :  Fri Oct 07 20:22:25 2016
TS : PHI  1506007  :  LL1
TS : PHI  1.542969  :  1.5429688
TS : PHI  596.914062  :  596.91406
TS : PHI  2.222656  :  2.2226562
TS : PHI  -87.871094  :  -87.87109
*****Field mismatch for seq no  21
TS : PHI  postAssess  :  EMR_EVENT_POST_ASSESS_COMPLETE
TS : PHI  Fri 10/7/2016 8:22:25 PM  :  Fri Oct 07 20:22:25 2016
TS : PHI  1506007  :  LL1
TS : PHI  1.542969  :  1.5429688
TS : PHI  596.914062  :  596.91406
TS : PHI  2.222656  :  2.2226562
TS : PHI  -87.871094  :  -87.87109
(python2) Bhaveshs-MacBook-Air:logfileCmp admin$

### Results


## Authors

* **Bhavesh Patel**

## License

## Acknowledgments
