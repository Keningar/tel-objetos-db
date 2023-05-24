CREATE OR REPLACE PACKAGE NAF47_TNET.CC_TRX_PORTAL IS

  -- Author  : EDGAR MU�OZ AZUERO
  -- Created : 06/07/2020 09:42:23
  -- Purpose : Procesos generados desde el Portal de Security Data


  FUNCTION f_Parametro(Pv_No_Cia     IN VARCHAR2,
                       Pv_Parametro  IN VARCHAR2) 
                       RETURN VARCHAR2;

  PROCEDURE p_Inserta_Arccmd(Pv_No_Cia          IN VARCHAR2,
                             Pv_Centro          IN VARCHAR2,
                             Pv_Tipo_Doc        IN VARCHAR2,
                             Pv_Periodo         IN VARCHAR2,
                             Pv_Ruta            IN VARCHAR2,
                             Pv_No_Docu         IN VARCHAR2,
                             Pv_Tipo_Venta      IN VARCHAR2,
                             Pv_Grupo           IN VARCHAR2,
                             Pv_No_Cliente      IN VARCHAR2,
                             Pd_Fecha           IN DATE,
                             Pv_No_Agente       IN VARCHAR2,
                             Pv_Cobrador        IN VARCHAR2,
                             Pv_Num_Fisico      IN VARCHAR2,
                             Pv_Serie_Fisico    IN VARCHAR2,
                             Pn_Subtotal        IN NUMBER,
                             Pn_Exento          IN NUMBER,
                             Pn_m_Original      IN NUMBER,
                             Pn_Saldo           IN NUMBER,
                             Pn_Descuento       IN NUMBER,
                             Pn_Total_Ref       IN NUMBER,
                             Pv_Estado          IN VARCHAR2,
                             Pn_Total_Db        IN NUMBER,
                             Pn_Total_Cr        IN NUMBER,
                             Pv_Origen          IN VARCHAR2,
                             Pn_Ano             IN NUMBER,
                             Pn_Mes             IN NUMBER,
                             Pn_Semana          IN NUMBER,
                             Pv_Concepto        IN VARCHAR2,
                             Pv_No_Docu_Refe    IN VARCHAR2,
                             Pd_Fecha_Documento IN DATE,
                             Pv_Anulado         IN VARCHAR2,
                             Pn_Gravado         IN NUMBER,
                             Pn_Tot_Imp         IN NUMBER,
                             Pv_Cod_Diario      IN VARCHAR2,
                             Pn_Monto_Bienes    IN NUMBER,
                             Pn_Monto_Serv      IN NUMBER,
                             Pv_Moneda          IN VARCHAR2,
                             Pn_Tipo_Cambio     IN NUMBER,
                             Pv_Detalle         IN VARCHAR2,
                             Pv_Sub_Cliente     IN VARCHAR2,
                             Pv_Usuario         IN VARCHAR2,
                             Pv_MsgError        IN OUT VARCHAR2);


  PROCEDURE p_inserta_Arccrd(Pv_No_Cia         IN VARCHAR2,
                             Pv_Tipo_Doc       IN VARCHAR2,
                             Pv_No_Docu        IN VARCHAR2,
                             Pv_Tipo_Refe      IN VARCHAR2,
                             Pv_No_Refe        IN VARCHAR2,
                             Pd_Fecha_Vence    IN DATE,
                             Pn_Monto          IN NUMBER,
                             Pd_Fec_Aplic      IN DATE,
                             Pn_Ano            IN NUMBER,
                             Pn_Mes            IN NUMBER,
                             Pn_Monto_Refe     IN NUMBER,
                             Pv_MsgError       IN OUT VARCHAR2);
                             
  PROCEDURE p_Inserta_Arccti(Pv_No_Cia             IN VARCHAR2,
                             Pv_Grupo              IN VARCHAR2,
                             Pv_No_Cliente         IN VARCHAR2,
                             Pv_Tipo_Doc           IN VARCHAR2,
                             Pv_No_Docu            IN VARCHAR2,
                             Pv_No_Refe            IN VARCHAR2,
                             Pv_Clave              IN VARCHAR2,
                             Pn_Porcentaje         IN NUMBER,
                             Pn_Monto              IN NUMBER,
                             Pn_Base               IN NUMBER,
                             Pv_Comportamiento     IN VARCHAR2,
                             Pv_Aplica_Cred_Fiscal IN VARCHAR2,
                             Pv_Ind_Imp_Ret        IN VARCHAR2,
                             Pv_Usuario            IN VARCHAR2,
                             Pv_MsgError           IN OUT VARCHAR2);
  
  PROCEDURE p_Inserta_Arccdc(Pv_No_Cia        IN VARCHAR2,
                             Pv_Centro        IN VARCHAR2,
                             Pv_Tipo_Doc      IN VARCHAR2,
                             Pv_Periodo       IN VARCHAR2,
                             Pv_Ruta          IN VARCHAR2,
                             Pv_No_Docu       IN VARCHAR2,
                             Pv_Grupo         IN VARCHAR2,
                             Pv_No_Cliente    IN VARCHAR2,
                             Pv_Codigo        IN VARCHAR2,
                             Pv_Tipo          IN VARCHAR2,
                             Pn_Monto         IN NUMBER,
                             Pv_Centro_Costo  IN VARCHAR2,
                             Pv_Modificable   IN VARCHAR2,                           
                             Pv_Glosa         IN VARCHAR2,
                             Pv_MsgError      IN OUT VARCHAR2);                         

  PROCEDURE p_Inserta_Arinme(Pv_No_Cia          IN VARCHAR2,
                             Pv_Centro          IN VARCHAR2,
                             Pv_Tipo_Doc        IN VARCHAR2,
                             Pv_Periodo         IN VARCHAR2,
                             Pv_Ruta            IN VARCHAR2,
                             Pv_No_Docu         IN VARCHAR2,
                             Pv_Estado          IN VARCHAR2,
                             Pd_Fecha           IN DATE,
                             Pv_No_Fisico       IN VARCHAR2,
                             Pv_Serie_Fisico    IN VARCHAR2,
                             Pv_Observ1         IN VARCHAR2,
                             Pv_Tipo_Refe       IN VARCHAR2,
                             Pv_No_Refe         IN VARCHAR2,
                             Pv_Serie_Refe      IN VARCHAR2,
                             Pv_No_Docu_Refe    IN VARCHAR2,
                             Pn_Mov_Tot         IN NUMBER,
                             Pn_Tipo_Cambio     IN NUMBER,
                             Pv_Origen          IN VARCHAR2,
                             Pn_Mov_Tot2        IN NUMBER,
                             Pv_MsgError        IN OUT VARCHAR2);
                             
    
  PROCEDURE p_Inserta_Arinml(Pv_No_Cia        IN VARCHAR2,
                             Pv_Centro        IN VARCHAR2,
                             Pv_Tipo_Doc      IN VARCHAR2,
                             Pv_Periodo       IN VARCHAR2,
                             Pv_Ruta          IN VARCHAR2,
                             Pv_No_Docu       IN VARCHAR2,
                             Pn_Linea         IN NUMBER,
                             Pn_Linea_Ext     IN NUMBER,
                             Pv_Bodega        IN VARCHAR2,
                             Pv_Clase         IN VARCHAR2,
                             Pv_Categoria     IN VARCHAR2,
                             Pv_No_Arti       IN VARCHAR2,
                             Pv_Ind_Iv        IN VARCHAR2,
                             Pn_Unidades      IN NUMBER,
                             Pn_Monto         IN NUMBER,
                             Pn_Monto2        IN NUMBER,
                             Pn_Tipo_Cambio   IN NUMBER,
                             Pv_MsgError      IN OUT VARCHAR2);    
                             
                             
  PROCEDURE Cc_p_Genera_Nc_Anulacion(Pv_No_Cia           IN VARCHAR2,
                                     Pv_Cedula           IN VARCHAR2,
                                     Pv_Serie_Fisico_Fac IN VARCHAR2,
                                     Pv_Num_Fisico_Fac   IN VARCHAR2,
                                     Pv_Motivo_Anulacion IN VARCHAR2,
                                     Pv_Exito            IN OUT VARCHAR2,
                                     Pv_MsgError         IN OUT VARCHAR2);
                                     
                                     
  PROCEDURE Cc_p_Genera_Ingreso_Inv(Pv_No_Cia        IN VARCHAR2,
                                    Pv_No_Docu_Nc    IN VARCHAR2,
                                    Pv_MsgError      IN OUT VARCHAR2);



END Cc_Trx_Portal;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.CC_TRX_PORTAL IS

 Gv_Aplicacion       varchar2(2):='CC';
 Gv_Grupo_Parametro  varchar2(20):='NC_AUTOMATICAS';
 
FUNCTION f_Parametro(Pv_No_Cia     IN VARCHAR2,
                     Pv_Parametro  IN VARCHAR2) 
                     RETURN VARCHAR2 IS
                  
 CURSOR c_param IS
  SELECT Parametro_Alterno 
    FROM ge_parametros 
   WHERE id_empresa = Pv_No_Cia
     AND id_aplicacion = Gv_Aplicacion
     AND id_grupo_parametro = Gv_Grupo_Parametro
     AND Parametro = Pv_Parametro;
     
  Lv_Valor_Param    ge_parametros.Parametro_Alterno%Type;
BEGIN
  IF c_param%ISOPEN THEN 
     CLOSE c_param;
  END IF;
  --
  OPEN c_param;
  FETCH c_param INTO Lv_Valor_Param;
  CLOSE c_param;
  --
  RETURN Lv_Valor_Param;
END;
 

PROCEDURE p_Inserta_Arccmd(Pv_No_Cia          IN VARCHAR2,
                           Pv_Centro          IN VARCHAR2,
                           Pv_Tipo_Doc        IN VARCHAR2,
                           Pv_Periodo         IN VARCHAR2,
                           Pv_Ruta            IN VARCHAR2,
                           Pv_No_Docu         IN VARCHAR2,
                           Pv_Tipo_Venta      IN VARCHAR2,
                           Pv_Grupo           IN VARCHAR2,
                           Pv_No_Cliente      IN VARCHAR2,
                           Pd_Fecha           IN DATE,
                           Pv_No_Agente       IN VARCHAR2,
                           Pv_Cobrador        IN VARCHAR2,
                           Pv_Num_Fisico      IN VARCHAR2,
                           Pv_Serie_Fisico    IN VARCHAR2,
                           Pn_Subtotal        IN NUMBER,
                           Pn_Exento          IN NUMBER,
                           Pn_m_Original      IN NUMBER,
                           Pn_Saldo           IN NUMBER,
                           Pn_Descuento       IN NUMBER,
                           Pn_Total_Ref       IN NUMBER,
                           Pv_Estado          IN VARCHAR2,
                           Pn_Total_Db        IN NUMBER,
                           Pn_Total_Cr        IN NUMBER,
                           Pv_Origen          IN VARCHAR2,
                           Pn_Ano             IN NUMBER,
                           Pn_Mes             IN NUMBER,
                           Pn_Semana          IN NUMBER,
                           Pv_Concepto        IN VARCHAR2,
                           Pv_No_Docu_Refe    IN VARCHAR2,
                           Pd_Fecha_Documento IN DATE,
                           Pv_Anulado         IN VARCHAR2,
                           Pn_Gravado         IN NUMBER,
                           Pn_Tot_Imp         IN NUMBER,
                           Pv_Cod_Diario      IN VARCHAR2,
                           Pn_Monto_Bienes    IN NUMBER,
                           Pn_Monto_Serv      IN NUMBER,
                           Pv_Moneda          IN VARCHAR2,
                           Pn_Tipo_Cambio     IN NUMBER,
                           Pv_Detalle         IN VARCHAR2,
                           Pv_Sub_Cliente     IN VARCHAR2,
                           Pv_Usuario         IN VARCHAR2,
                           Pv_MsgError        IN OUT VARCHAR2) 
                           IS
BEGIN
  INSERT INTO Arccmd
    (No_Cia,
     Centro,
     Tipo_Doc,
     Periodo,
     Ruta,
     No_Docu,
     Tipo_Venta,
     Grupo,
     No_Cliente,
     Fecha,
     Fecha_Digitacion,
     No_Agente,
     Cobrador,
     No_Fisico,
     Serie_Fisico,
     Subtotal,
     Exento,
     m_Original,
     Saldo,
     Descuento,
     Total_Ref,
     Estado,
     Total_Db,
     Total_Cr,
     Origen,
     Ano,
     Mes,
     Semana,
     Concepto,
     No_Docu_Refe,
     Fecha_Documento,
     Anulado,
     Gravado,
     Tot_Imp,
     Cod_Diario,
     Monto_Bienes,
     Monto_Serv,
     Moneda,
     Tipo_Cambio,
     Detalle,
     Sub_Cliente,
     Usuario)
  VALUES
    (Pv_No_Cia,
     Pv_Centro,
     Pv_Tipo_Doc,
     Pv_Periodo,
     Pv_Ruta,
     Pv_No_Docu,
     Pv_Tipo_Venta,
     Pv_Grupo,
     Pv_No_Cliente,
     Pd_Fecha,
     Pd_Fecha_Documento,
     Pv_No_Agente,
     Pv_Cobrador,
     Pv_Num_Fisico,
     Pv_Serie_Fisico,
     Pn_Subtotal,
     Pn_Exento,
     Pn_m_Original,
     Pn_Saldo,
     Pn_Descuento,
     Pn_Total_Ref,
     Pv_Estado,
     Pn_Total_Db,
     Pn_Total_Cr,
     Pv_Origen,
     Pn_Ano,
     Pn_Mes,
     Pn_Semana,
     Pv_Concepto,
     Pv_No_Docu_Refe,
     Pd_Fecha_Documento,     
     Pv_Anulado,
     Pn_Gravado,
     Pn_Tot_Imp,
     Pv_Cod_Diario,
     Pn_Monto_Bienes,
     Pn_Monto_Serv,
     Pv_Moneda,
     Pn_Tipo_Cambio,
     Pv_Detalle,
     Pv_Sub_Cliente,
     Pv_Usuario);

EXCEPTION 
   WHEN OTHERS THEN
        Pv_MsgError := '(OTHERS)->P_Inserta_Arccmd-'||SQLERRM;
END p_Inserta_Arccmd;


PROCEDURE p_inserta_Arccrd(Pv_No_Cia         IN VARCHAR2,
                           Pv_Tipo_Doc       IN VARCHAR2,
                           Pv_No_Docu        IN VARCHAR2,
                           Pv_Tipo_Refe      IN VARCHAR2,
                           Pv_No_Refe        IN VARCHAR2,
                           Pd_Fecha_Vence    IN DATE,
                           Pn_Monto          IN NUMBER,
                           Pd_Fec_Aplic      IN DATE,
                           Pn_Ano            IN NUMBER,
                           Pn_Mes            IN NUMBER,
                           Pn_Monto_Refe     IN NUMBER,
                           Pv_MsgError       IN OUT VARCHAR2) 
                           IS 
  
BEGIN
  INSERT INTO Arccrd
    (No_Cia,
     Tipo_Doc,
     No_Docu,
     Tipo_Refe,
     No_Refe,
     Fecha_Vence,
     Monto,
     Fec_Aplic,
     Ano,
     Mes,
     Monto_Refe,
     Moneda_Refe)
  VALUES
    (Pv_No_Cia,
     Pv_Tipo_Doc,
     Pv_No_Docu,
     Pv_Tipo_Refe,
     Pv_No_Refe,
     Pd_Fecha_Vence,
     Pn_Monto,
     Pd_Fec_Aplic,
     Pn_Ano,
     Pn_Mes,
     Pn_Monto_Refe,
     'P');

EXCEPTION 
   WHEN OTHERS THEN
        Pv_MsgError := '(OTHERS)->P_Inserta_Arccrd-'||SQLERRM;

END p_inserta_Arccrd;


PROCEDURE p_Inserta_Arccti(Pv_No_Cia             IN VARCHAR2,
                           Pv_Grupo              IN VARCHAR2,
                           Pv_No_Cliente         IN VARCHAR2,
                           Pv_Tipo_Doc           IN VARCHAR2,
                           Pv_No_Docu            IN VARCHAR2,
                           Pv_No_Refe            IN VARCHAR2,
                           Pv_Clave              IN VARCHAR2,
                           Pn_Porcentaje         IN NUMBER,
                           Pn_Monto              IN NUMBER,
                           Pn_Base               IN NUMBER,
                           Pv_Comportamiento     IN VARCHAR2,
                           Pv_Aplica_Cred_Fiscal IN VARCHAR2,
                           Pv_Ind_Imp_Ret        IN VARCHAR2,
                           Pv_Usuario            IN VARCHAR2,
                           Pv_MsgError           IN OUT VARCHAR2) 
                           IS
BEGIN
  INSERT INTO Arccti
              (No_Cia,
               Grupo,
               No_Cliente,
               Tipo_Doc,
               No_Docu,
               No_Refe,
               Clave,
               Porcentaje,
               Monto,
               Base,
               Comportamiento,
               Aplica_Cred_Fiscal,
               Ind_Imp_Ret,
               Usuario_Registra,
               Tstamp)
            VALUES
              (Pv_No_Cia,
               Pv_Grupo,
               Pv_No_Cliente,
               Pv_Tipo_Doc,
               Pv_No_Docu,
               Pv_No_Refe,
               Pv_Clave,
               Pn_Porcentaje,
               Pn_Monto,
               Pn_Base,
               Pv_Comportamiento,
               Pv_Aplica_Cred_Fiscal,
               Pv_Ind_Imp_Ret,
               Pv_Usuario,
               SYSDATE);

EXCEPTION 
   WHEN OTHERS THEN
        Pv_MsgError := '(OTHERS)->P_Inserta_Arccti-'||SQLERRM;               

END;



PROCEDURE p_Inserta_Arccdc(Pv_No_Cia        IN VARCHAR2,
                           Pv_Centro        IN VARCHAR2,
                           Pv_Tipo_Doc      IN VARCHAR2,
                           Pv_Periodo       IN VARCHAR2,
                           Pv_Ruta          IN VARCHAR2,
                           Pv_No_Docu       IN VARCHAR2,
                           Pv_Grupo         IN VARCHAR2,
                           Pv_No_Cliente    IN VARCHAR2,
                           Pv_Codigo        IN VARCHAR2,
                           Pv_Tipo          IN VARCHAR2,
                           Pn_Monto         IN NUMBER,
                           Pv_Centro_Costo  IN VARCHAR2,
                           Pv_Modificable   IN VARCHAR2,                           
                           Pv_Glosa         IN VARCHAR2,
                           Pv_MsgError      IN OUT VARCHAR2)
                           IS

BEGIN
 INSERT INTO Arccdc
  (No_Cia,
   Centro,
   Tipo_Doc,
   Periodo,
   Ruta,
   No_Docu,
   Grupo,
   No_Cliente,
   Codigo,
   Tipo,
   Monto,
   Monto_Dol,
   Tipo_Cambio,
   Moneda,
   Ind_Con,
   Centro_Costo,
   Modificable,
   Monto_Dc,
   Glosa)
VALUES
  (Pv_No_Cia,
   Pv_Centro,
   Pv_Tipo_Doc,
   Pv_Periodo,
   Pv_Ruta,
   Pv_No_Docu,
   Pv_Grupo,
   Pv_No_Cliente,
   Pv_Codigo,
   Pv_Tipo,
   Pn_Monto,
   Pn_Monto,
   1,
   'P',
   'P',
   Pv_Centro_Costo,
   Pv_Modificable,
   Pn_Monto,
   Pv_Glosa);
   
EXCEPTION 
   WHEN OTHERS THEN
        Pv_MsgError := '(OTHERS)->p_Inserta_Arccdc-'||SQLERRM;  
        
END;

PROCEDURE p_Inserta_Arinme(Pv_No_Cia          IN VARCHAR2,
                           Pv_Centro          IN VARCHAR2,
                           Pv_Tipo_Doc        IN VARCHAR2,
                           Pv_Periodo         IN VARCHAR2,
                           Pv_Ruta            IN VARCHAR2,
                           Pv_No_Docu         IN VARCHAR2,
                           Pv_Estado          IN VARCHAR2,
                           Pd_Fecha           IN DATE,
                           Pv_No_Fisico       IN VARCHAR2,
                           Pv_Serie_Fisico    IN VARCHAR2,
                           Pv_Observ1         IN VARCHAR2,
                           Pv_Tipo_Refe       IN VARCHAR2,
                           Pv_No_Refe         IN VARCHAR2,
                           Pv_Serie_Refe      IN VARCHAR2,
                           Pv_No_Docu_Refe    IN VARCHAR2,
                           Pn_Mov_Tot         IN NUMBER,
                           Pn_Tipo_Cambio     IN NUMBER,
                           Pv_Origen          IN VARCHAR2,
                           Pn_Mov_Tot2        IN NUMBER,
                           Pv_MsgError        IN OUT VARCHAR2)
                           IS 
  
BEGIN
  INSERT INTO Arinme
        (No_Cia,
         Centro,
         Tipo_Doc,
         Periodo,
         Ruta,
         No_Docu,
         Estado,
         Fecha,
         No_Fisico,
         Serie_Fisico,
         Observ1,
         Tipo_Refe,
         No_Refe,
         Serie_Refe,
         No_Docu_Refe,
         Mov_Tot,
         Tipo_Cambio,
         Origen,
         Mov_Tot2)
      VALUES
        (Pv_No_Cia,
         Pv_Centro,
         Pv_Tipo_Doc,
         Pv_Periodo,
         Pv_Ruta,
         Pv_No_Docu,
         Pv_Estado,
         Pd_Fecha,
         Pv_No_Fisico,
         Pv_Serie_Fisico,
         Pv_Observ1,
         Pv_Tipo_Refe,
         Pv_No_Refe,
         Pv_Serie_Refe,
         Pv_No_Docu_Refe,
         Pn_Mov_Tot,
         Pn_Tipo_Cambio,
         Pv_Origen,
         Pn_Mov_Tot2);

EXCEPTION 
   WHEN OTHERS THEN
        Pv_MsgError := '(OTHERS)->p_Inserta_Arinme-'||SQLERRM;  
END;


PROCEDURE p_Inserta_Arinml(Pv_No_Cia        IN VARCHAR2,
                           Pv_Centro        IN VARCHAR2,
                           Pv_Tipo_Doc      IN VARCHAR2,
                           Pv_Periodo       IN VARCHAR2,
                           Pv_Ruta          IN VARCHAR2,
                           Pv_No_Docu       IN VARCHAR2,
                           Pn_Linea         IN NUMBER,
                           Pn_Linea_Ext     IN NUMBER,
                           Pv_Bodega        IN VARCHAR2,
                           Pv_Clase         IN VARCHAR2,
                           Pv_Categoria     IN VARCHAR2,
                           Pv_No_Arti       IN VARCHAR2,
                           Pv_Ind_Iv        IN VARCHAR2,
                           Pn_Unidades      IN NUMBER,
                           Pn_Monto         IN NUMBER,
                           Pn_Monto2        IN NUMBER,
                           Pn_Tipo_Cambio   IN NUMBER,
                           Pv_MsgError      IN OUT VARCHAR2)
                           IS
  
BEGIN
  INSERT INTO Arinml
  (No_Cia,
   Centro,
   Tipo_Doc,
   Periodo,
   Ruta,
   No_Docu,
   Linea,
   Linea_Ext,
   Bodega,
   Clase,
   Categoria,
   No_Arti,
   Ind_Iv,
   Unidades,
   Monto,
   Monto2,
   Tipo_Cambio)
VALUES
  (Pv_No_Cia,
   Pv_Centro,
   Pv_Tipo_Doc,
   Pv_Periodo,
   Pv_Ruta,
   Pv_No_Docu,
   Pn_Linea,
   Pn_Linea_Ext,
   Pv_Bodega,
   Pv_Clase,
   Pv_Categoria,
   Pv_No_Arti,
   Pv_Ind_Iv,
   Pn_Unidades,
   Pn_Monto,
   Pn_Monto2,
   Pn_Tipo_Cambio);

EXCEPTION 
   WHEN OTHERS THEN
        Pv_MsgError := '(OTHERS)->p_Inserta_Arinml-'||SQLERRM;  

END;


PROCEDURE Cc_p_Genera_Nc_Anulacion(Pv_No_Cia           IN VARCHAR2,
                                   Pv_Cedula           IN VARCHAR2,
                                   Pv_Serie_Fisico_Fac IN VARCHAR2,
                                   Pv_Num_Fisico_Fac   IN VARCHAR2,
                                   Pv_Motivo_Anulacion IN VARCHAR2,
                                   Pv_Exito            IN OUT VARCHAR2,
                                   Pv_MsgError         IN OUT VARCHAR2) IS
                                   
 CURSOR c_centro(Cv_Centro VARCHAR2) IS
    SELECT Cd.Ano_Proce_Cxc,
           Cd.Mes_Proce_Cxc,
           Cd.Semana_Proce_Cxc,
           Cd.Dia_Proceso_Cxc
      FROM Arincd Cd
     WHERE Cd.No_Cia = Pv_No_Cia
       AND Cd.Centro = Cv_Centro;
       
       
  CURSOR c_formulario(Cv_Tipo_Doc VARCHAR2) IS 
    SELECT formulario
      FROM arcctd 
     WHERE no_cia = Pv_No_Cia
       AND tipo = Cv_Tipo_Doc;
     

  CURSOR c_Fac IS
    SELECT Fac.No_Cia, 
           Fac.Centro, 
           Fac.Ruta, 
           Fac.Tipo_Venta, 
           Fac.Grupo, 
           Fac.No_Cliente, 
           Fac.No_Agente, 
           Cli.Cobrador,
           Fac.Tipo_Doc,
           Fac.Fecha,
           Fac.Fecha_Vence,
           Fac.No_Docu, 
           Fac.Serie_Fisico,
           Fac.No_Fisico,
           Fac.Cod_Diario, 
           Fac.Moneda, 
           Fac.Sub_Cliente
      FROM Arccmd Fac, Arccmc Cli
     WHERE Fac.No_Cia = Pv_No_Cia --'12'
       AND Cli.Cedula = Pv_Cedula --'2100755699001'
       AND Fac.Serie_Fisico = Pv_Serie_Fisico_Fac --'001011'
       AND Fac.No_Fisico = lpad(Pv_Num_Fisico_Fac,9,'0') --'000023926'
       AND Fac.No_Cia = Cli.No_Cia
       AND Fac.Grupo = Cli.Grupo
       AND Fac.No_Cliente = Cli.No_Cliente;
  
  
 CURSOR c_saldo_fac(Cv_No_Factu VARCHAR2) IS
    SELECT fa.saldo, 
           fa.m_original total
      FROM arccmd fa
     WHERE fa.no_cia = Pv_No_Cia
       AND fa.no_docu = Cv_No_Factu;
       
       
 CURSOR c_nc_pend (Cv_No_Factu VARCHAR2) IS
    SELECT rd.tipo_doc, rd.no_docu 
      FROM arccrd rd, arccmd nc
     WHERE rd.no_cia = Pv_No_Cia
       AND rd.no_refe = Cv_No_Factu
       AND nc.estado = 'P'
       AND nc.no_cia = rd.no_cia
       AND nc.no_docu = rd.no_docu;
       
  
 CURSOR c_aux_deb(Cv_No_Factu VARCHAR2) IS
    SELECT dfa.no_factu, 
           dfa.no_linea, 
           dfa.no_arti, 
           da.grupo, 
           dfa.bodega, 
           dfa.total - Nvl(dfa.descuento,0) Monto,
           cc.centro_costo,
           decode(dfa.i_ven,'S',cc.cta_venta_gravada_cre, 'N', cc.cta_venta_exenta_cre) cta_servicio_producto
     FROM arfafl dfa, arinda da, arincc cc
    WHERE dfa.no_cia = Pv_No_Cia
      AND dfa.no_factu = Cv_No_Factu
      AND dfa.no_cia = da.no_cia
      AND dfa.no_arti = da.no_arti
      AND da.no_cia = cc.no_cia
      AND da.grupo = cc.grupo
      AND dfa.bodega = cc.bodega;
      
      
 CURSOR c_aux_iva(Cv_No_Factu VARCHAR2) IS
    SELECT imp.no_cia, 
           imp.clave,
           cgi.cuenta,
           imp.porc_imp, 
           sum(imp.base) base, 
           sum(imp.monto_imp) monto_iva 
      FROM arfafli imp, arcgimp cgi
     WHERE imp.no_cia = Pv_No_Cia
       AND imp.no_factu = Cv_No_Factu
       AND imp.no_cia = cgi.no_cia
       AND imp.clave = cgi.clave
    GROUP BY imp.no_cia, imp.clave, cgi.cuenta, imp.porc_imp;
   
   
 CURSOR c_cta_cliente(Cv_Grupo VARCHAR2) IS
     SELECT gr.cta_cliente
       FROM arccgr gr
      WHERE gr.no_cia = Pv_No_Cia
        AND gr.grupo = Cv_Grupo;  
        
            
 CURSOR c_tot_fac(Cv_No_Factu VARCHAR2) IS
    SELECT dfa.no_cia,
           dfa.no_factu,             
           SUM(dfa.total) subtotal,
           SUM(dfa.total - nvl(dfa.descuento,0)) neto,
           SUM(decode(dfa.i_ven,'S',dfa.total - nvl(dfa.descuento,0),0)) gravado,
           SUM(decode(dfa.i_ven,'N',dfa.total - nvl(dfa.descuento,0),0)) exento,
           SUM(dfa.i_ven_n) tot_imp,
           SUM(dfa.total - nvl(dfa.descuento,0) + nvl(dfa.i_ven_n,0)) total
      FROM arfafl dfa
     WHERE dfa.no_cia = Pv_No_Cia
       AND dfa.no_factu = Cv_No_Factu 
     GROUP BY dfa.no_cia, dfa.no_factu;
   
   
   CURSOR c_tot_aux(Cv_No_Factu VARCHAR2) IS 
     SELECT sum(decode(dc.tipo, 'D', dc.monto, 0)) tot_db,
            sum(decode(dc.tipo, 'C', dc.monto, 0)) tot_cr
       FROM arccdc dc 
      WHERE dc.no_cia = Pv_No_Cia
        AND dc.no_docu = Cv_No_Factu;
      
  Lv_Concepto          Arccmd.Concepto%Type;
  Lv_Tipo_Doc          Arccmd.Tipo_Doc%Type;
  Lv_Usuario           Arccmd.Usuario%Type;
  --
  Lc_centro            c_centro%ROWTYPE;
  Lc_saldo_fac         c_saldo_fac%ROWTYPE;
  Lc_nc_pend           c_nc_pend%ROWTYPE;
  Lv_Num_Fisico_Nc     Arccmd.No_Fisico%TYPE;
  Lv_Serie_Fisico_Nc   Arccmd.Serie_Fisico%TYPE;
  Lv_Formulario        Control_Formu.Formulario%TYPE;  
  Lv_No_Docu_Nc        VARCHAR2(15);
  Lv_Existe_Fact       VARCHAR2(15);

  Ln_Total_Documento   NUMBER;
  --
  Lv_MsgError          VARCHAR2(2000);
  Le_Error_Proceso     EXCEPTION;
  Le_Error_Valida      EXCEPTION;

BEGIN
    Lv_Existe_Fact := 'N';
    --
 --    UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
    --
    FOR Lc_Fac IN c_Fac LOOP
  --      UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, 'loop '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
        --VALIDACIONES PREVIAS
        Lv_Existe_Fact := 'S';
        
        ------------------------------------------------------------------------
        --Se valida que la factura tenga su saldo total para poder ser anulada.
        ------------------------------------------------------------------------
        IF c_saldo_fac%ISOPEN THEN 
           CLOSE c_saldo_fac;
        END IF;
        --
        OPEN c_saldo_fac(Lc_Fac.No_Docu);
        FETCH c_saldo_fac INTO Lc_saldo_fac;
        CLOSE c_saldo_fac;
        --
        IF Lc_saldo_fac.Saldo = 0 OR (Lc_saldo_fac.Saldo < Lc_saldo_fac.total) THEN
           Lv_MsgError := '(A)Cc_p_Genera_Nc_Anulacion-> La factura # '||Pv_Serie_Fisico_Fac||'-'||Pv_Num_Fisico_Fac||' No tiene Saldo para ser Anulada...';
           RAISE Le_Error_Valida;
        END IF;
        
     --   UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL,'Se verifica que la factura no tenga una NC en curso. NC en Estado'|| to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
        ----------------------------------------------------------------------------------
        --Se verifica que la factura no tenga una NC en curso. NC en Estado "PENDIENTE"
        ----------------------------------------------------------------------------------        
        IF c_nc_pend%ISOPEN THEN 
           CLOSE c_nc_pend;
        END IF;
        --
        OPEN c_nc_pend(Lc_Fac.No_Docu);
        FETCH c_nc_pend INTO Lc_nc_pend;
        IF c_nc_pend%FOUND THEN
           CLOSE c_nc_pend;
           Lv_MsgError := '(B)Cc_p_Genera_Nc_Anulacion-> La factura # '||Pv_Serie_Fisico_Fac||'-'||Pv_Num_Fisico_Fac||' ya tiene vinculada una NC en proceso:'||Lc_nc_pend.Tipo_doc||'-'||Lc_nc_pend.No_Docu;
           RAISE Le_Error_Valida;
        ELSE
           CLOSE c_nc_pend;
        END IF;
          
  --       UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, '1.- Se extrae los parametros generales '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
        -----------------------------------------------
        --1.- Se extrae los parametros generales
        -----------------------------------------------
         Lv_Concepto := Cc_Trx_Portal.f_Parametro(Pv_No_Cia,'CONCEPTO');
         Lv_Tipo_Doc := Cc_Trx_Portal.f_Parametro(Pv_No_Cia,'TDOC_NCRED');
         Lv_Usuario  := Cc_Trx_Portal.f_Parametro(Pv_No_Cia,'USUARIO');
         
         IF Lv_Concepto IS NULL OR Lv_Tipo_Doc IS NULL OR Lv_Usuario IS NULL THEN
            Lv_MsgError := '(1)Cc_p_Genera_Nc_Anulacion-> No se han creado todos los parametros generales para ejecutar este proceso...';
            RAISE Le_Error_Valida;
         END IF;
        
    --     UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, '2.- e extrae el periodo del centro '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));        
        -----------------------------------------------
        --2.- Se extrae el periodo del centro 
        -----------------------------------------------        
        IF c_centro%ISOPEN THEN
           CLOSE c_centro;
        END IF;
        --
        OPEN c_centro(Lc_Fac.Centro);
        FETCH c_centro INTO Lc_centro;
        CLOSE c_centro;
        
        
        ---------------------------------------------------------------------------
        --3.- Se genera el # transaccion y el numero fisico de la nota de credito
        ---------------------------------------------------------------------------
        Lv_No_Docu_Nc := Transa_Id.Cc(Pv_No_Cia);
        
        
        IF c_formulario%ISOPEN THEN
           CLOSE c_formulario;
        END IF;
        --
        OPEN c_formulario(Lv_Tipo_Doc);
        FETCH c_formulario INTO Lv_Formulario;
        CLOSE c_formulario;

  --       UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, 'Formulario.Consulta_Siguiente '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
                
        Formulario.Consulta_Siguiente(Pv_No_Cia,
                                      Lv_Formulario, 
                                      (Lc_centro.Ano_Proce_Cxc * 100) + Lc_centro.Mes_Proce_Cxc,
                                      Lv_Num_Fisico_Nc,
                                      Lv_Serie_Fisico_Nc);

        Lv_Num_Fisico_Nc := Formulario.Siguiente(Pv_No_Cia,
                                                 Lv_Formulario,
                                                 Lc_centro.Ano_Proce_Cxc);
                                                 
        Lv_Num_Fisico_Nc := Lpad(Lv_Num_Fisico_Nc, 9, '0');        
        
   --      UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, '4.- Cc_Trx_Portal.p_Inserta_Arccmd '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));       
        -----------------------------------------------
        --4.- Registra la nota de cr�dito en ARCCMD 
        -----------------------------------------------              
        Cc_Trx_Portal.p_Inserta_Arccmd(Pv_No_Cia          => Lc_Fac.No_Cia,
                                       Pv_Centro          => Lc_Fac.Centro,
                                       Pv_Tipo_Doc        => Lv_Tipo_Doc,
                                       Pv_Periodo         => Lc_centro.Ano_Proce_Cxc,
                                       Pv_Ruta            => Lc_Fac.Ruta,
                                       Pv_No_Docu         => Lv_No_Docu_Nc,
                                       Pv_Tipo_Venta      => Lc_Fac.Tipo_Venta,
                                       Pv_Grupo           => Lc_Fac.Grupo,
                                       Pv_No_Cliente      => Lc_Fac.No_Cliente,
                                       Pd_Fecha           => Lc_centro.Dia_Proceso_Cxc,
                                       Pv_No_Agente       => Lc_Fac.No_Agente,
                                       Pv_Cobrador        => Lc_Fac.Cobrador,
                                       Pv_Num_Fisico      => Lv_Num_Fisico_Nc,
                                       Pv_Serie_Fisico    => Lv_Serie_Fisico_Nc,
                                       Pn_Subtotal        => 0,
                                       Pn_Exento          => 0,
                                       Pn_m_Original      => 0,
                                       Pn_Saldo           => 0,
                                       Pn_Descuento       => 0,
                                       Pn_Total_Ref       => 0,
                                       Pv_Estado          => 'P',
                                       Pn_Total_Db        => 0,
                                       Pn_Total_Cr        => 0,
                                       Pv_Origen          => 'CC',
                                       Pn_Ano             => Lc_centro.Ano_Proce_Cxc,
                                       Pn_Mes             => Lc_centro.Mes_Proce_Cxc,
                                       Pn_Semana          => Lc_centro.Semana_Proce_Cxc,
                                       Pv_Concepto        => Lv_Concepto,
                                       Pv_No_Docu_Refe    => Lc_Fac.No_Docu,
                                       Pd_Fecha_Documento => Lc_centro.Dia_Proceso_Cxc,
                                       Pv_Anulado         => 'N',
                                       Pn_Gravado         => 0,
                                       Pn_Tot_Imp         => 0,
                                       Pv_Cod_Diario      => Lc_Fac.Cod_Diario,
                                       Pn_Monto_Bienes    => 0,
                                       Pn_Monto_Serv      => 0,
                                       Pv_Moneda          => Lc_Fac.Moneda,
                                       Pn_Tipo_Cambio     => 1,
                                       Pv_Detalle         => Pv_Motivo_Anulacion,
                                       Pv_Sub_Cliente     => Lc_Fac.Sub_Cliente,
                                       Pv_Usuario         => Lv_Usuario,
                                       Pv_MsgError        => Lv_MsgError);
                --
        IF Lv_MsgError IS NOT NULL THEN 
           Lv_MsgError := '(2)Cc_p_Genera_Nc_Anulacion->'||Lv_MsgError;
           RAISE Le_Error_Proceso;
        END IF;
        
      --   UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, ' 5.- Cc_Trx_Portal.p_Inserta_Arccdc '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));        
        -----------------------------------------------------------------------------------------------
        --5.- Se genera las lineas del auxiliar en Debito por los bienes/servicios facturados. ARCCDC 
        -----------------------------------------------------------------------------------------------
        FOR Lc_aux_deb IN c_aux_deb(Lc_Fac.No_Docu) LOOP
            Cc_Trx_Portal.p_Inserta_Arccdc(Pv_No_Cia        => Lc_Fac.No_Cia,
                                           Pv_Centro        => Lc_Fac.Centro,
                                           Pv_Tipo_Doc      => Lv_Tipo_Doc,
                                           Pv_Periodo       => Lc_centro.Ano_Proce_Cxc,
                                           Pv_Ruta          => Lc_Fac.Ruta,
                                           Pv_No_Docu       => Lv_No_Docu_Nc,
                                           Pv_Grupo         => Lc_Fac.Grupo,
                                           Pv_No_Cliente    => Lc_Fac.No_Cliente,
                                           Pv_Codigo        => Lc_aux_deb.cta_servicio_producto,
                                           Pv_Tipo          => 'D',
                                           Pn_Monto         => Lc_aux_deb.monto,
                                           Pv_Centro_Costo  => Lc_aux_deb.centro_costo,
                                           Pv_Modificable   => 'S',                           
                                           Pv_Glosa         => 'Ingreso automatico por anulacion de fact.#'||Lc_Fac.Serie_Fisico||'-'||Lc_Fac.No_Fisico,
                                           Pv_MsgError      => Lv_MsgError);
            
            IF Lv_MsgError IS NOT NULL THEN 
               Lv_MsgError := '(3)Cc_p_Genera_Nc_Anulacion->'||Lv_MsgError;
               RAISE Le_Error_Proceso;
            END IF;
        
        END LOOP;
        
      --   UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, '6.- Cc_Trx_Portal.p_Inserta_Arccdc '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));        
        -----------------------------------------------------------------------------------------------
        --6.- Se genera la linea del auxiliar en Debito por el iva. ARCCDC 
        -----------------------------------------------------------------------------------------------
        FOR Lc_aux_iva IN c_aux_iva(Lc_Fac.No_Docu) LOOP
            Cc_Trx_Portal.p_Inserta_Arccdc(Pv_No_Cia        => Lc_Fac.No_Cia,
                                           Pv_Centro        => Lc_Fac.Centro,
                                           Pv_Tipo_Doc      => Lv_Tipo_Doc,
                                           Pv_Periodo       => Lc_centro.Ano_Proce_Cxc,
                                           Pv_Ruta          => Lc_Fac.Ruta,
                                           Pv_No_Docu       => Lv_No_Docu_Nc,
                                           Pv_Grupo         => Lc_Fac.Grupo,
                                           Pv_No_Cliente    => Lc_Fac.No_Cliente,
                                           Pv_Codigo        => Lc_aux_iva.cuenta,
                                           Pv_Tipo          => 'D',
                                           Pn_Monto         => Lc_aux_iva.monto_iva,
                                           Pv_Centro_Costo  => '000000000',
                                           Pv_Modificable   => 'N',                           
                                           Pv_Glosa         => 'Ingreso automatico por anulacion de fact.#'||Lc_Fac.Serie_Fisico||'-'||Lc_Fac.No_Fisico,
                                           Pv_MsgError      => Lv_MsgError);
            
            IF Lv_MsgError IS NOT NULL THEN 
               Lv_MsgError := '(4)Cc_p_Genera_Nc_Anulacion->'||Lv_MsgError;
               RAISE Le_Error_Proceso;
            END IF;
            
       --     UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, '7.- Cc_Trx_Portal.p_Inserta_Arccmd '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));            
            --------------------------------------------------------------------
            --7.- Se registra el iva en Cuentas por Cobrar. ARCCTI
            --------------------------------------------------------------------
            Cc_Trx_Portal.p_Inserta_Arccti(Pv_No_Cia             => Lc_Fac.No_Cia,
                                           Pv_Grupo              => Lc_Fac.Grupo,
                                           Pv_No_Cliente         => Lc_Fac.No_Cliente,
                                           Pv_Tipo_Doc           => Lv_Tipo_Doc,
                                           Pv_No_Docu            => Lv_No_Docu_Nc,
                                           Pv_No_Refe            => Lv_No_Docu_Nc,
                                           Pv_Clave              => Lc_aux_iva.Clave,
                                           Pn_Porcentaje         => Lc_aux_iva.porc_imp,
                                           Pn_Monto              => Lc_aux_iva.monto_iva,
                                           Pn_Base               => Lc_aux_iva.base,
                                           Pv_Comportamiento     => 'E',
                                           Pv_Aplica_Cred_Fiscal => 'S',
                                           Pv_Ind_Imp_Ret        => 'I',
                                           Pv_Usuario            => Lv_Usuario,
                                           Pv_Msgerror           => Lv_MsgError);
                                          
            IF Lv_MsgError IS NOT NULL THEN 
               Lv_MsgError := '(5)Cc_p_Genera_Nc_Anulacion->'||Lv_MsgError;
               RAISE Le_Error_Proceso;
            END IF;
            
        END LOOP;    
        
        
        
       FOR Lc_tot_fac IN c_tot_fac(Lc_Fac.No_Docu) LOOP
       --     UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, '8.- Actualiza los Totales en ARCCMD y registra la referencia '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));       
           --------------------------------------------------------------------
           --8.- Actualiza los Totales en ARCCMD y registra la referencia.
           -------------------------------------------------------------------- 
            UPDATE Arccmd Nc
              SET Nc.Gravado = Lc_tot_fac.Gravado,
                  Nc.Exento =  Lc_tot_fac.Exento,
                  Nc.Subtotal = Lc_tot_fac.Subtotal,
                  Nc.Tot_Imp = Lc_tot_fac.tot_imp,
                  Nc.M_Original = Lc_tot_fac.Total,
                  Nc.Saldo = -(Lc_tot_fac.Total),
                  Nc.Total_Ref = Lc_tot_fac.Total
            WHERE Nc.No_Cia = Lc_Fac.No_Cia
              AND Nc.No_Docu = Lv_No_Docu_Nc;
              
        --    UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, '9.- Registra la referencia nc/factura en ARCCRD '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));              
           ----------------------------------------------------
           --9.- Registra la referencia nc/factura en ARCCRD 
           ----------------------------------------------------    
           Cc_Trx_Portal.p_Inserta_Arccrd(Pv_No_Cia      => Lc_Fac.No_Cia,
                                          Pv_Tipo_Doc    => Lv_Tipo_Doc,
                                          Pv_No_Docu     => Lv_No_Docu_Nc,
                                          Pv_Tipo_Refe   => Lc_Fac.Tipo_Doc,
                                          Pv_No_Refe     => Lc_Fac.No_Docu,
                                          Pd_Fecha_Vence => Lc_Fac.Fecha_Vence,
                                          Pn_Monto       => Lc_tot_fac.Total,
                                          Pd_Fec_Aplic   => Lc_centro.Dia_Proceso_Cxc,
                                          Pn_Ano         => Lc_centro.Ano_Proce_Cxc,
                                          Pn_Mes         => Lc_centro.Mes_Proce_Cxc,
                                          Pn_Monto_Refe  => Lc_tot_fac.Total,
                                          Pv_MsgError    => Lv_MsgError);
            
            IF Lv_MsgError IS NOT NULL THEN  
               Lv_MsgError := '(6)Cc_p_Genera_Nc_Anulacion->'||Lv_MsgError;
               RAISE Le_Error_Proceso;
            END IF;
            --
            Ln_Total_Documento := Lc_tot_fac.Total;
            
            
       END LOOP;
      
        --    UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, '11.- Se genera la linea del auxiliar en Credito por el Total del Documento. ARCCDC '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
       -----------------------------------------------------------------------------------------------
       --11.- Se genera la linea del auxiliar en Credito por el Total del Documento. ARCCDC 
       -----------------------------------------------------------------------------------------------      
       FOR Lc_cta_cliente IN c_cta_cliente(Lc_Fac.Grupo) LOOP
           Cc_Trx_Portal.p_Inserta_Arccdc(Pv_No_Cia        => Lc_Fac.No_Cia,
                                          Pv_Centro        => Lc_Fac.Centro,
                                          Pv_Tipo_Doc      => Lv_Tipo_Doc,
                                          Pv_Periodo       => Lc_centro.Ano_Proce_Cxc,
                                          Pv_Ruta          => Lc_Fac.Ruta,
                                          Pv_No_Docu       => Lv_No_Docu_Nc,
                                          Pv_Grupo         => Lc_Fac.Grupo,
                                          Pv_No_Cliente    => Lc_Fac.No_Cliente,
                                          Pv_Codigo        => Lc_cta_cliente.cta_Cliente,
                                          Pv_Tipo          => 'C',
                                          Pn_Monto         =>  Ln_Total_Documento,
                                          Pv_Centro_Costo  => '000000000',
                                          Pv_Modificable   => 'N',                           
                                          Pv_Glosa         => 'Ingreso automatico por anulacion de fact.#'||Lc_Fac.Serie_Fisico||'-'||Lc_Fac.No_Fisico,
                                          Pv_MsgError      => Lv_MsgError);
            
           IF Lv_MsgError IS NOT NULL THEN 
              Lv_MsgError := '(8)Cc_p_Genera_Nc_Anulacion->'||Lv_MsgError;
              RAISE Le_Error_Proceso;
           END IF;
       END LOOP;
       --     UTL_MAIL.send ('dba@telconet.ec','jfmartinez@telconet.ec, sfernandez@telconet.ec',NULL, NULL, '12.- Actualiza los Totales del Auxiliar (Tot_Deb y Tot_Cre) en ARCCMD. '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));       
       -----------------------------------------------------------------------------------------------
       --12.- Actualiza los Totales del Auxiliar (Tot_Deb y Tot_Cre) en ARCCMD. 
       -----------------------------------------------------------------------------------------------           
       FOR Lc_tot_aux IN c_tot_aux(Lv_No_Docu_Nc) LOOP
           UPDATE Arccmd Nc
              SET Nc.total_db = Lc_tot_aux.tot_db,
                  Nc.total_cr = Lc_tot_aux.tot_cr
            WHERE Nc.No_Cia = Lc_Fac.No_Cia
              AND Nc.No_Docu = Lv_No_Docu_Nc;
       END LOOP;
       

    END LOOP;
    --
    IF Lv_Existe_Fact = 'N' THEN
       Lv_MsgError := '(9)Cc_p_Genera_Nc_Anulacion->Factura '||Pv_Serie_Fisico_Fac||'-'||Pv_Num_Fisico_Fac||' No Existe...';
      RAISE Le_Error_Valida;  
    END IF;
    --
    Pv_Exito := 'S'; 
		--
		COMMIT;
                                   

EXCEPTION 
	 WHEN Le_Error_Valida THEN 
        Pv_MsgError := Lv_MsgError;
        Pv_Exito    := 'N';  
	 WHEN Le_Error_Proceso THEN 
        Pv_MsgError := Lv_MsgError;
        Pv_Exito    := 'N';
				ROLLBACK;
   WHEN OTHERS THEN 
        Pv_MsgError := '(Others)-Cc_p_Genera_Nc_Anulacion->'||SQLERRM;
        Pv_Exito    := 'N';
				ROLLBACK; 
END Cc_p_Genera_Nc_Anulacion;



PROCEDURE Cc_p_Genera_Ingreso_Inv(Pv_No_Cia        IN VARCHAR2,
                                  Pv_No_Docu_Nc    IN VARCHAR2,
                                  Pv_MsgError      IN OUT VARCHAR2) 
                                  IS

  CURSOR c_centro(Cv_Centro VARCHAR2) IS
    SELECT Cd.Ano_Proce,
           Cd.Mes_Proce,
           Cd.Semana_Proce,
           Cd.Dia_Proceso
      FROM Arincd Cd
     WHERE Cd.No_Cia = Pv_No_Cia
       AND Cd.Centro = Cv_Centro;
  
  CURSOR c_cab_inv IS 
    SELECT Fac.No_Cia, 
           Fac.Centrod, 
           Fac.Ruta,
           Fac.Tipo_Doc, 
           Fac.No_Factu, 
           Fac.No_Fisico,
           Fac.Serie_Fisico
      FROM Arfafe Fac
     WHERE (Fac.No_Cia, Fac.No_Factu) IN
           (SELECT Nc.No_Cia, Nc.No_Refe
              FROM Arccrd Nc
             WHERE Nc.No_Cia = Pv_No_Cia
               AND Nc.No_Docu = Pv_No_Docu_Nc);
      
  CURSOR c_det_inv(Cv_No_Factu VARCHAR2) IS 
    SELECT Dfa.No_Linea,
           Dfa.Bodega,
           Dfa.No_Arti,
           Dfa.Pedido,
           Da.Clase     Clase_Articulo,
           Da.Categoria Categoria_Articulo,
           Decode(Da.Aplica_Impuesto, 'G', 'S', 'E', 'N', 'X') Ind_Iv
      FROM Arfafl Dfa, Arinda Da, Grupos Gr
     WHERE Dfa.No_Cia = Pv_No_Cia
       AND Dfa.No_Factu = Cv_No_Factu
       AND Gr.Ind_Prod_Serv = 'P' --Solo Productos, no Servicios.
       --
       AND Da.No_Cia = Gr.No_Cia
       AND Da.Grupo = Gr.Grupo
       --
       AND Dfa.No_Cia = Da.No_Cia
       AND Dfa.No_Arti = Da.No_Arti;
  
  Ln_No_Docu_Inv  Arinme.No_Docu%Type;
  Ln_Costo_Uni    Arinma.Costo_Uni%type;
  Ln_Costo_Uni2   Arinma.Costo2%type;
  --
  Lv_Tipo_Doc_Inv Arinme.Tipo_Doc%Type;
  Ln_Tot_Monto    Arinme.Mov_Tot%type;
  Ln_Tot_Monto2   Arinme.Mov_Tot%type;
  Lc_centro       c_centro%ROWTYPE;
  --
  Lv_Ingresa      VARCHAR2(1);
  Lv_Msgerror     VARCHAR2(2000);
  Le_Error        EXCEPTION;
  

--Procedimiento interno 
procedure p_Costos_Articulo_Bod(Cv_No_Cia    in varchar2, 
                                Cv_No_Arti   in varchar2,
                                Cv_Bodega    in varchar2,
                                Pn_Costo_Uni in out number,
                                Pn_Costo2    in out number)
                                is
cursor c_costo is
 select ma.costo_uni, ma.costo2 
  from arinma ma
  where ma.no_cia = Cv_No_Cia
   and ma.bodega = Cv_Bodega
   and ma.no_arti = Cv_No_Arti; 

begin
  for Lc_costo in c_costo loop
      Pn_Costo_Uni := Lc_costo.costo_uni;
      Pn_Costo2    := Lc_costo.costo2;
  end loop;
end;
--------------
   
  
BEGIN
  FOR Lc_cab_inv IN c_cab_inv LOOP

      -----------------------------------------------
      --1.- Se extrae los parametros generales
      -----------------------------------------------
      Lv_Tipo_Doc_Inv := Cc_Trx_Portal.f_Parametro(Pv_No_Cia,'TDOC_INVE');
         
      IF Lv_Tipo_Doc_Inv IS NULL THEN
        Lv_MsgError := '(1)Cc_Genera_Ingreso_Inv-> No se han creado todos los parametros generales para ejecutar este proceso...';
        RAISE Le_Error;
      END IF;
      
      
      -----------------------------------------------
      --2.- Se extrae el periodo del centro 
      -----------------------------------------------        
      IF c_centro%ISOPEN THEN
         CLOSE c_centro;
      END IF;
      --
      OPEN c_centro(Lc_cab_inv.Centrod);
      FETCH c_centro INTO Lc_centro;
      CLOSE c_centro;  
      
      
      --------------------------------------------------------------------
      --3.- Inserta la cabecera de la transaccion de Inventario. ARINME
      -------------------------------------------------------------------- 
      Ln_No_Docu_Inv := Transa_Id.Inv(Lc_cab_inv.No_Cia);
      
      Cc_Trx_Portal.p_Inserta_Arinme(Pv_No_Cia       => Lc_cab_inv.No_Cia,
                                     Pv_Centro       => Lc_cab_inv.Centrod,
                                     Pv_Tipo_Doc     => Lv_Tipo_Doc_Inv,
                                     Pv_Periodo      => Lc_centro.Ano_Proce,
                                     Pv_Ruta         => Lc_cab_inv.Ruta,
                                     Pv_No_Docu      => Ln_No_Docu_Inv,
                                     Pv_Estado       => 'P',
                                     Pd_Fecha        => Lc_centro.Dia_Proceso,
                                     Pv_No_Fisico    => Ln_No_Docu_Inv, 
                                     Pv_Serie_Fisico => '0',
                                     Pv_Observ1      => 'Ingreso Generado por Anulaci�n de Factura, trans. # '||Lc_cab_inv.No_Factu,
                                     Pv_Tipo_Refe    => Lc_cab_inv.Tipo_Doc,
                                     Pv_No_Refe      => Lc_cab_inv.No_Factu,
                                     Pv_Serie_Refe   => Lc_cab_inv.Serie_Fisico,
                                     Pv_No_Docu_Refe => Pv_No_Docu_Nc,
                                     Pn_Mov_Tot      => 0,
                                     Pn_Tipo_Cambio  => 1,
                                     Pv_Origen       => 'CC',
                                     Pn_Mov_Tot2     => 0,
                                     Pv_Msgerror     => Lv_Msgerror);
                                     
      IF Lv_MsgError IS NOT NULL THEN 
         Lv_MsgError := '(1)Cc_Genera_Ingreso_Inventario->'||Lv_MsgError;
         RAISE Le_Error;
      END IF;
      
      --------------------------------------------------------------------
      --3.- Inserta el detalle de la transaccion de Inventario. ARINML
      --------------------------------------------------------------------    
      Lv_Ingresa := 'N';
      FOR Lc_det_inv IN c_det_inv(Lc_cab_inv.No_Factu) LOOP
      
          p_Costos_Articulo_Bod(Lc_cab_inv.No_Cia, 
                                Lc_det_inv.No_Arti,
                                Lc_det_inv.Bodega,
                                Ln_Costo_Uni,
                                Ln_Costo_Uni2); 
      
          Cc_Trx_Portal.p_Inserta_Arinml(Pv_No_Cia      => Lc_cab_inv.No_Cia,
                                         Pv_Centro      => Lc_cab_inv.Centrod,
                                         Pv_Tipo_Doc    => Lv_Tipo_Doc_Inv,
                                         Pv_Periodo     => Lc_centro.Ano_Proce,
                                         Pv_Ruta        => Lc_cab_inv.Ruta,
                                         Pv_No_Docu     => Ln_No_Docu_Inv,
                                         Pn_Linea       => Lc_det_inv.No_Linea,
                                         Pn_Linea_Ext   => Lc_det_inv.No_Linea,
                                         Pv_Bodega      => Lc_det_inv.Bodega,
                                         Pv_Clase       => Lc_det_inv.Clase_Articulo,
                                         Pv_Categoria   => Lc_det_inv.Categoria_Articulo,
                                         Pv_No_Arti     => Lc_det_inv.No_Arti,
                                         Pv_Ind_Iv      => Lc_det_inv.Ind_Iv,
                                         Pn_Unidades    => Lc_det_inv.Pedido,
                                         Pn_Monto       => (Nvl(Ln_Costo_Uni,0)*Lc_det_inv.Pedido),
                                         Pn_Monto2      => (Nvl(Ln_Costo_Uni2,0)*Lc_det_inv.Pedido),
                                         Pn_Tipo_Cambio => 1,
                                         Pv_Msgerror    => Lv_Msgerror);
                                                   
          IF Lv_MsgError IS NOT NULL THEN 
             Lv_MsgError := '(2)Cc_Genera_Ingreso_Inventario->'||Lv_MsgError;
             RAISE Le_Error;
          END IF;
          --
          Ln_Tot_Monto    := Nvl(Ln_Tot_Monto,0) + (Nvl(Ln_Costo_Uni,0)*Lc_det_inv.Pedido);
          Ln_Tot_Monto2   := Nvl(Ln_Tot_Monto2,0) + (Nvl(Ln_Costo_Uni2,0)*Lc_det_inv.Pedido);
          --
          Lv_Ingresa := 'S';
      END LOOP;
      
      
      IF NVL(Lv_Ingresa,'N') = 'S' THEN
          --------------------------------------------------------------------
          --4.- Registra los Totales en la Cabecera ARINME
          --------------------------------------------------------------------     
          UPDATE Arinme Me
             SET Me.Mov_Tot = Ln_Tot_Monto,
                 Me.Mov_Tot2 = Ln_Tot_Monto2
           WHERE Me.No_Cia = Lc_cab_inv.No_Cia
             AND Me.No_Docu = Ln_No_Docu_Inv;
          
          --------------------------------------------------------------------
          --5.- Actualiza el documento en Inventario
          --------------------------------------------------------------------       
          Inactualiza(Pno_Cia     => Lc_cab_inv.No_Cia,
                      Ptipo_Doc   => Lv_Tipo_Doc_Inv,
                      Pno_Docu    => Ln_No_Docu_Inv,
                      Msg_Error_p => Lv_Msgerror);
                      
          IF Lv_MsgError IS NOT NULL THEN 
             Lv_MsgError := '(1)Cc_Genera_Ingreso_Inventario->'||Lv_MsgError;
             RAISE Le_Error;
          END IF;
      ELSE
          --Borra la cabecera en caso que no haya encontrado/ingresado lineas de detalle.
          DELETE FROM Arinme WHERE No_Cia = Lc_cab_inv.No_Cia AND No_Docu = Ln_No_Docu_Inv;
      END IF;
  END LOOP;


EXCEPTION 
   WHEN Le_Error THEN 
        Pv_MsgError := Lv_MsgError;

   WHEN OTHERS THEN 
        Pv_MsgError := '(Others)-Cc_Genera_Ingreso_Inventario->'||SQLERRM;  
END;

END Cc_Trx_Portal;
/