create or replace FUNCTION            JavaRunCommand(p_command varchar2) RETURN varchar2
AS LANGUAGE JAVA 
NAME 'JavaRunCommand.executeCommand(java.lang.String) return java.lang.String';