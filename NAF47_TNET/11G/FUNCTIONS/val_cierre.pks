create or replace function            val_cierre(no_cia varchar2,centro varchar2) RETURN VARCHAR2 IS

  vdia_proc   arincd.dia_proceso%type;
  vano_proc   arincd.ano_proce%type;
  vsem_proc   arincd.semana_proce%type;
  vid_sem     arincd.indicador_sem%type;

  cursor dia_proc IS
     select dia_proceso, ano_proce, semana_proce, indicador_sem
     from arincd
     where no_cia = no_cia and
           centro = centro;

  Cursor Sem_Proc (pano number, psem number, pid varchar2 ) IS
     Select fecha2
     from calendario
     where no_cia    = no_cia
       and ano       = pano
       and semana    = psem
       and indicador = pid;

  vfecha  calendario.fecha2%type;


BEGIN

   Open dia_proc;
   Fetch dia_proc into vdia_proc, vano_proc, vsem_proc, vid_sem;
   Close dia_proc;

   Open Sem_Proc(vano_proc, vsem_proc, vid_sem);
   Fetch Sem_Proc into vfecha;
   Close Sem_Proc;

   -- Si la fecha de fin de la semana en proceso, es menor que el
   -- dia que se quiere cerrar, se debe hacer primero el cierre semanal

   If vfecha < vdia_proc THEN
      return('Debe ejecutar el cierre periodico !!!');
   ELSE
   	  return(null);

   END IF;

END;