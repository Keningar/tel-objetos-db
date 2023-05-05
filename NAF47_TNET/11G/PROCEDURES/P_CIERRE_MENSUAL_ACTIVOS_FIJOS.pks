create or replace procedure            P_CIERRE_MENSUAL_ACTIVOS_FIJOS (Pv_cia   IN varchar2,
                                                                       Pn_ano   IN number,
                                                                       Pn_mes   IN number,
                                                                       Pv_Error IN OUT varchar2 ) IS
/**
Documentacion para P_CIERRE_MENSUAL_ACTIVOS_FIJOS
Procedimiento que realiza el Cierre Mensual del modulo de Activos Fijos

@author  Martha Navarrete Martinez <mnavarrete@telconet.ec>
@version 1.0  17/05/2017

@param  Pv_cia IN varchar2  Recibe el codigo de la empresa 
@param  Pn_ano IN number Recibe el anio de proceso del modulo
@param  Pn_mes IN number Recibe el mes de proceso del modulo
@param  Pv_Error IN OUT varchar2 Retorna mensaje de error
**/

  CURSOR C_MesCierre IS
    SELECT mes_cierre
    FROM arcgmc
    WHERE no_cia = Pv_cia;

  CURSOR C_ActivosDepreciados IS
    SELECT no_acti
    FROM arafma
    WHERE no_cia = Pv_cia
    AND f_egre  is null
    AND (nvl(val_original,0) + nvl(mejoras,0) + nvl(rev_tecs,0) - (nvl(depacum_valorig_ant,0) + 
      nvl(depacum_mejoras_ant,0)+nvl(depacum_revtecs_ant,0) )) > desecho; 
     
   Lv_MesCierre   arcgmc.mes_cierre%TYPE;
  
BEGIN
  -- Resetea los valores de la depreciacion en ejercicio al cierre del anio fiscal
  IF C_MesCierre%ISOPEN THEN CLOSE C_MesCierre; END IF;
  OPEN C_MesCierre;
  FETCH C_MesCierre INTO Lv_MesCierre;
  CLOSE C_MesCierre;
  
  IF Lv_MesCierre = Pn_mes   THEN
    UPDATE arafma
    SET depre_ejer_vo       = 0,
      depre_ejer_mej        = 0,
      depre_ejer_revtec     = 0,
                   
      depre_ejer_vo_ant     = 0,
      depre_ejer_mej_ant    = 0,
      depre_ejer_revtec_ant = 0,
                   
      depre_ejer_vo_dol     = 0,
      depre_ejer_mej_dol    = 0,        
      depre_ejer_revtec_dol = 0,
                   
      depre_ejer_vo_ant_dol     = 0,
      depre_ejer_mej_ant_dol    = 0,
      depre_ejer_revtec_ant_dol = 0         
    WHERE no_cia = Pv_cia;          
  END IF;   

  IF C_ActivosDepreciados%ISOPEN THEN CLOSE C_ActivosDepreciados; END IF;
  For Lc_Activo in C_ActivosDepreciados loop
    -- Actualiza las depreciaciones acumuladas
    UPDATE arafma
    SET ult_ano_cierre  = Pn_ano,
      ult_mes_cierre  = Pn_mes,
                
      depacum_valorig_ant = nvl(depacum_valorig,0),
      depacum_mejoras_ant = nvl(depacum_mejoras,0),
      depacum_revtecs_ant = nvl(depacum_revtecs,0),
                
      depacum_valorig_ant_dol = nvl(depacum_valorig_dol,0),
      depacum_mejoras_ant_dol = nvl(depacum_mejoras_dol,0),
      depacum_revtecs_ant_dol = nvl(depacum_revtecs_dol,0),
                
      depre_ejer_vo_ant     = nvl(depre_ejer_vo,0),
      depre_ejer_mej_ant    = nvl(depre_ejer_mej,0),
      depre_ejer_revtec_ant = nvl(depre_ejer_revtec,0),
               
      depre_ejer_vo_ant_dol     = nvl(depre_ejer_vo_dol,0),
      depre_ejer_mej_ant_dol    = nvl(depre_ejer_mej_dol,0),
      depre_ejer_revtec_ant_dol = nvl(depre_ejer_revtec_dol,0)
    WHERE  no_cia = Pv_cia and no_acti =  Lc_Activo.no_acti; 
  END LOOP;

    --Actualiza el mes y anio de cierre
    UPDATE arafmc
    SET ult_ano_cierre = Pn_ano,
      ult_mes_cierre   = Pn_mes, 
      mes              = decode(Pn_mes,12,1,Pn_mes+1),
      ano              = decode(Pn_mes,12,Pn_ano+1,Pn_ano),
      ind_calculo_dep    = 'N',
      ind_depre_generada = 'N'
    WHERE no_cia         = Pv_cia;

  --Borra los movimientos para el mes 
  DELETE FROM ARAFDC
  WHERE NO_CIA  = Pv_cia
  AND ANO = Pn_ano
  AND MES = Pn_mes;

  DELETE ARAFMM
  WHERE no_cia  = Pv_cia 
  and ano = Pn_ano
  and mes = Pn_mes;

EXCEPTION
  WHEN others THEN
    Pv_Error := sqlerrm;
End;