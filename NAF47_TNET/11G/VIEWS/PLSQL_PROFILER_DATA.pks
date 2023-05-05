CREATE  FORCE VIEW "NAF47_TNET"."PLSQL_PROFILER_DATA" ("RUNID", "UNIT_NUMBER", "LINE#", "TOTAL_OCCUR", "TOTAL_TIME", "MIN_TIME", "MAX_TIME", "SPARE1", "SPARE2", "SPARE3", "SPARE4") AS 
  SELECT "RUNID",
           "UNIT_NUMBER",
           "LINE#",
           "TOTAL_OCCUR",
           "TOTAL_TIME",
           "MIN_TIME",
           "MAX_TIME",
           "SPARE1",
           "SPARE2",
           "SPARE3",
           "SPARE4"
      FROM NAF47_TNET.PLSQL_PROFILER_DATA@GPOETNET;