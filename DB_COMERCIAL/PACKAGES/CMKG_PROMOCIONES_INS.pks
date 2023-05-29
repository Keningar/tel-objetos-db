CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_PROMOCIONES_INS AS 

 /**
  * Documentación para PROCESO 'P_PROCESO_MAPEO_PROM_INS'.
  *
  * Proceso encargado de evaluar reglas de configuración de una promoción, para ser otorgada a los cliente que su estado de 
  * servicio este factible.
  *
  * Costo del Query C_GetEmpresa: 0
  * Costo del Query C_GetErrorRepetido: 11
  * Costo del Query C_GetInfoServicio: 5
  * Costo del Query C_GetIdPromocion: 16
  *
  * PARAMETROS:
  * @Param Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @Param Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_Mensaje              OUT VARCHAR2
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-09-2019
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 03-09-2020 - Se realiza cambio para que se consuma el nuevo proceso que obtiene los tipos de promociones ordenados
  *                           por prioridad de sectorización.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 10-11-2020 - Se realiza cambio en el proceso para considerar los servicios que tienen como característica activa un 
  *                           código promocional.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.3  31-05-2022
  * Se agregan logs para monitorear el proceso de mapeo de promociones de Instalacion.
  */ 
  PROCEDURE P_PROCESO_MAPEO_PROM_INS(Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL,
                                     Pv_Mensaje              OUT VARCHAR2);

  /**
  * Documentación para TYPE 'Lr_ServClientesProcesar'.
  *  
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-06-2019
  */
  TYPE Lr_ServClientesProcesar IS RECORD (
    ID_PERSONA_ROL         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    ID_PUNTO               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    COD_EMPRESA            DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    SERVICIO_ID            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ESTADO                 DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    ID_PLAN                DB_COMERCIAL.INFO_SERVICIO.PLAN_ID%TYPE);

  /**
  * Documentación para TYPE 'T_ServClientesProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-06-2019
  */
  TYPE T_ServClientesProcesar IS TABLE OF Lr_ServClientesProcesar INDEX BY PLS_INTEGER;

  /**
  * Documentación para PROCEDURE 'P_MAPEO_PROMO_INS'.
  *
  * Proceso encargado de insertar todos los mapeos por la cantidad de periodos configurados en una promoción de instalación
  * generar los historiales del servicio, historial de mapeo y mapeo de servicio beneficiado.
  *
  * PARAMETROS:
  * @Param Pr_Punto                IN Lr_ServClientesProcesar
  * @Param Pa_ServiciosCumplePromo IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear
  * @Param Pr_TiposPromociones     IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar
  * @Param Pr_TipoPromoRegla       IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar
  * @Param Pv_TipoProceso          IN VARCHAR2
  * @Param Pv_Trama                IN VARCHAR2
  * @Param Pv_MsjResultado         OUT VARCHAR2
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-09-2019
  */
  PROCEDURE P_MAPEO_PROMO_INS (Pr_Punto                 IN Lr_ServClientesProcesar,
                               Pa_ServiciosCumplePromo  IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear,
                               Pr_TiposPromociones      IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar,
                               Pr_TipoPromoRegla        IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar,
                               Pv_TipoProceso           IN VARCHAR2,
                               Pv_Trama                 IN VARCHAR2,
                               Pv_MsjResultado          OUT VARCHAR2);
END CMKG_PROMOCIONES_INS;
/