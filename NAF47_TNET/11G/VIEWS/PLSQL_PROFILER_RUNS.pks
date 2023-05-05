CREATE  FORCE VIEW "NAF47_TNET"."PLSQL_PROFILER_RUNS" ("RUNID", "RELATED_RUN", "RUN_OWNER", "RUN_DATE", "RUN_COMMENT", "RUN_TOTAL_TIME", "RUN_SYSTEM_INFO", "RUN_COMMENT1", "SPARE1") AS 
  SELECT "RUNID",
           "RELATED_RUN",
           "RUN_OWNER",
           "RUN_DATE",
           "RUN_COMMENT",
           "RUN_TOTAL_TIME",
           "RUN_SYSTEM_INFO",
           "RUN_COMMENT1",
           "SPARE1"
      FROM NAF47_TNET.PLSQL_PROFILER_RUNS@GPOETNET;