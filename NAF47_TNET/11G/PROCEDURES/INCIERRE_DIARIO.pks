CREATE OR REPLACE PROCEDURE NAF47_TNET.INCIERRE_DIARIO(Pv_cia                IN VARCHAR2,
                                            Pv_centro             IN VARCHAR2,
                                            Pd_dia_proceso        IN DATE,
                                            Pn_anio               IN NUMBER,
                                            Pn_mes                IN NUMBER,
                                            Pd_vultimo_dia_semana OUT DATE,
                                            Pv_error              OUT VARCHAR2) IS

  

  error_proceso EXCEPTION;

BEGIN

 NAF47_TNET.INCIERRE_DIARIO@GPOETNET(Pv_cia => Pv_cia,
									 Pv_centro => Pv_centro,
									 Pd_dia_proceso => Pd_dia_proceso,
									 Pn_anio => Pn_anio,
									 Pn_mes => Pn_mes,
									 Pd_vultimo_dia_semana => Pd_vultimo_dia_semana,
									 Pv_error => Pv_error);

EXCEPTION
  WHEN OTHERS THEN
    Pv_error := 'Error en INCIERRE_DIARIO: ' || SQLERRM;
    RETURN;
END INCIERRE_DIARIO;
/