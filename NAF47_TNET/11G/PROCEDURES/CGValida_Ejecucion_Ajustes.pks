create or replace procedure            CGValida_Ejecucion_Ajustes(
  pno_cia IN arcgmc.no_cia%type,
  pano    IN arcgmc.ano_proce%type,
  pmes    IN arcgmc.mes_proce%type,
  perror  IN OUT varchar2
) IS
  -- --
  -- Este procedimiento de la base de datos tiene como objetivo,
  -- verificar que los asientos de ajuste de los codigos de ajuste
  -- relacionados en la tabla arcgtai, para un ano y mes determinado
  -- se han ejecutado
  --
  -- Seccion de Variables
  --
  error_proceso      exception;
  --
  vExiste            BOOLEAN;
  vcuenta            arcgms.cuenta%type;
  vprocesado_conta   arcgcai.procesado_conta%type;
  --
  -- --
  cursor c_codigos_ajuste is
    select codigo_ajuste, indice_economico
      from arcgtai
     where no_cia =  pno_cia;
  --
  cursor c_Procesado (pCia arcgcai.no_cia%type, pIndice arcgtai.indice_economico%type) IS
      select nvl(procesado_conta,'N')
        from   arcgcai
        where  no_cia           = pCia
          and  indice_economico = pIndice
          and  ano              = pAno
          and  mes              = pMes;
  --
  cursor c_existe_cuentas(pcod_ajuste varchar2) is
    select cuenta
 from arcgms
 where no_cia     = pno_cia
   and cod_ajuste = pcod_ajuste
   and rownum     = 1;
  --

BEGIN
  perror := null;
  for tai in c_codigos_ajuste LOOP
    -- verifica que existan cuentas a las que se haya asociado el ajuste
 vcuenta := null;
    open c_existe_cuentas(tai.codigo_ajuste);
 fetch c_existe_cuentas into vcuenta;
 vexiste := c_existe_cuentas%found;
 close c_existe_cuentas;
 --
 if vexiste then
       open  c_Procesado (pNo_cia, tai.indice_economico);
       fetch c_Procesado INTO vprocesado_conta;
       vExiste := c_Procesado%FOUND;
       close c_Procesado;
       --
       if NOT vExiste OR nvl(vProcesado_Conta, 'N') = 'N' then
          perror := 'No se ha generado asiento para el codigo de Ajuste '||tai.codigo_ajuste;
          raise error_proceso;
       end if;
 end if;
  end loop;
EXCEPTION
  WHEN error_proceso THEN
    perror := nvl(pError, 'Error en CGValida_Ejecucion_Ajustes');
  WHEN others THEN
    perror := nvl(sqlerrm,'Exception en CGValida_Ejecucion_Ajustes');
END;