CREATE OR REPLACE PACKAGE DB_COMERCIAL.VALIDA_IDENTIFICACION is
/**
* Documentacion para el package VALIDA_IDENTIFICACION
* Valida numeros de identificacion tipo Cedula y RUC
* @author telcos
* @version 1.0 09-04-2016
*/
--

  /**
  * Documentaci�n para el procedimiento VALIDA_CEDULA
  * @param varchar2   cedula: n�mero de c�dula
  * @param varchar2   mensaje: vac�o en caso que sea correcta la c�dula ingresada
  * @author telcos
  * @version 1.0 09-04-2016
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1 28-06-2017
  * Se modifica el mensaje de error que se muestra al usuario final.
  */
  PROCEDURE VALIDA_CEDULA(CEDULA VARCHAR2, MENSAJE OUT VARCHAR2);

  PROCEDURE VALIDA_RUC0_5(ruc VARCHAR2, MENSAJE OUT VARCHAR2);

  PROCEDURE VALIDA_RUC6(RUC VARCHAR2, MENSAJE OUT VARCHAR2);

  PROCEDURE VALIDA_RUC9(RUC VARCHAR2, MENSAJE OUT VARCHAR2);

  /**
  * Documentaci�n para el procedimiento VALIDA
  * @param varchar2   p_tipo_ident: Tipo de identificaci�n
  * @param varchar2   p_identificacion: Identificaci�n a validar
  * @param varchar2   p_mensaje: '' en caso que la identificaci�n est� correcta.
  * @author telcos
  * @version 1.0 09-04-2016
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1 28-06-2017
  * Se agrega la validaci�n para llamar al procedimiento de Panam�
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.2 21-09-2017
  * Se separa la l�gica para validar �nicamente a las identificaciones ecuatorianas.
  *
  * @author Walther Joao Gaibor C <wgaibor@telconet.ec>
  * @version 1.3 10-01-2022
  * Se adiciona el parametro empresa para poder determinar si la misma debe realizar las validaciones correspondiente
  * a la identificaci�n ingresada.
  */
  PROCEDURE VALIDA(p_tipo_ident       varchar2,
                 p_identificacion     varchar2,
                 pv_CodEmpresa        varchar2,
                 pv_tipoTributario    varchar2,
                 p_mensaje            in out varchar2);

  /**
  * Documentaci�n para el procedimiento VALIDA
  * @param varchar2   p_tipo_ident: Tipo de identificaci�n
  * @param varchar2   p_identificacion: Identificaci�n a validar
  * @param varchar2   p_mensaje: '' en caso que la identificaci�n est� correcta.
  * @author telcos
  * @version 1.0 09-04-2016
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1 28-06-2017
  * Se agrega la validaci�n para llamar al procedimiento de Panam�
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.2 21-09-2017
  * Se separa la l�gica para validar �nicamente a las identificaciones ecuatorianas.
  */
  PROCEDURE VALIDA(p_tipo_ident     varchar2,
                 p_identificacion varchar2,
                 p_mensaje        in out varchar2);
  /**
  * Documentaci�n para el procedimiento P_VALIDA_FORMATO_PANAMA
  * Procedimiento que valida la c�dula paname�a en base a los par�metros registrados en la tabla ADMI_PARAMETRO_CAB y ADMI_PARAMETRO_DET
  * @param varchar2   pv_identificacion: Identificaci�n a validar
  * @param varchar2   pv_tipo_identificacion: Tipo de identificaci�n 'CED' o 'RUC'
  * @param varchar2   Pv_mensaje: 'OK' en caso que la c�dula est� correcta en base a los par�metros registrados, caso contrario se env�a un mensaje.
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.0 28-06-2017
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1 20-09-2017 Se modifica la validaci�n a nivel de RUC y PASAPORTE. Debido a que no existe un formato predeterminado.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.2 09-02-2018 Se aumenta longitud de variable que almacena valor de la identificaci�n.
  */
  PROCEDURE P_VALIDA_FORMATO_PANAMA(
      Pv_identificacion VARCHAR2,
      Pv_tipo_identificacion VARCHAR2,
      Pv_mensaje OUT VARCHAR2) ;

  /**
  * Documentaci�n para la funci�n IS_NUMBER
  * Funci�n que valida si una cadena ingresada es un n�mero.
  * @param varchar2   pv_string: cadena a evaluar
  * @return int       Devuelve 1 si la validaci�n es verdadera, 0 si es falso.
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.0 28-06-2017
  */
  FUNCTION IS_NUMBER(
      PV_STRING IN VARCHAR2)
    RETURN INT;

  /**
  * Documentaci�n para el procedimiento P_VALIDA_NIT
  * Procedimiento que valida el formato del n�mero de identificaci�n tributaria NIT (Guatemala).
  * @param varchar2   Pv_Identificacion: Numero de nit a validar
  * @param varchar2   Pv_Mensaje: 'OK' en caso que el nit est� correcto , caso contrario se env�a un mensaje.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 14-03-2019
  */
  PROCEDURE P_VALIDA_NIT(
      Pv_Identificacion IN  VARCHAR2,
      Pv_Mensaje        OUT VARCHAR2);

  /**
  * Documentaci�n para el procedimiento P_VALIDA_DPI
  * Procedimiento que valida el formato del c�digo �nico de identificaci�n del DPI (Guatemala).
  * @param varchar2   Pv_Identificacion: Numero de nit a validar
  * @param varchar2   Pv_Mensaje: 'OK' en caso que el nit est� correcto , caso contrario se env�a un mensaje.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 14-03-2019
  */
  PROCEDURE P_VALIDA_DPI(
      Pv_Identificacion IN  VARCHAR2,
      Pv_Mensaje        OUT VARCHAR2);

end VALIDA_IDENTIFICACION;

/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.VALIDA_IDENTIFICACION is

  PROCEDURE VALIDA_CEDULA(CEDULA VARCHAR2, MENSAJE OUT VARCHAR2) IS
    coeficiente VARCHAR2(9) := '212121212';
    i           NUMBER(1);
    suma        NUMBER(3) := 0;
    producto    NUMBER(3) := 0;
    verificador NUMBER(3) := 0;
    error_proceso EXCEPTION;

  BEGIN
    mensaje := NULL;
    -- Se verifica la longitud de la cedula
    IF LENGTH(cedula) != 10 Then
      mensaje := 'El numero de cedula no es valido.';
      raise error_proceso;
    END IF;
    -- Se verifica el codigo de la Provincia que debe estar entre 01 y 24
    -- Provincia 30 - Consulados
    IF TO_NUMBER(SUBSTR(cedula, 1, 2)) NOT BETWEEN 1 AND 24 AND
      (TO_NUMBER(SUBSTR(cedula,1,2)) <> 30) THEN
      mensaje := 'El codigo de la provincia NO es valido.';
      RAISE error_proceso;
    END IF;
    -- 6 EXTRANJEROS
    IF TO_NUMBER(SUBSTR(cedula, 3, 1)) NOT BETWEEN 0 AND 6 THEN
      mensaje := 'El numero de cedula no es valido.';
      RAISE error_proceso;
    END IF;
    --
    FOR i IN 1 .. 9 LOOP
      producto := TO_NUMBER(SUBSTR(coeficiente, i, 1)) *
                  TO_NUMBER(SUBSTR(cedula, i, 1));
      IF producto > 9 THEN
        producto := producto - 9;
      END IF;
      -- Acumulo el valor resultado del coeficiente con la cedula.
      suma := suma + producto;
    END LOOP;
    IF MOD(suma, 10) <> 0 THEN
      verificador := 10 - MOD(suma, 10);
    ELSE
      verificador := 0;
    END IF;

    IF TO_NUMBER(SUBSTR(cedula, 10, 1)) != verificador THEN
      mensaje := 'El digito verificador no es valido.';
      RAISE error_proceso;
    END IF;

  EXCEPTION
    WHEN error_proceso THEN
      mensaje := NVL(mensaje, ' en VALIDA_CEDULA');
    WHEN OTHERS THEN
      mensaje := 'Documento de identificaci�n incorrecto';
  END;

  --***********
  PROCEDURE VALIDA_RUC0_5(ruc VARCHAR2, MENSAJE OUT VARCHAR2) IS
    coeficiente VARCHAR2(9) := '212121212';
    i           NUMBER(1);
    suma        NUMBER(3) := 0;
    producto    NUMBER(3) := 0;
    verificador NUMBER(3) := 0;
    error_proceso EXCEPTION;

  BEGIN
    mensaje := NULL;
    -- Se verifica la longitud de la cedula
    IF LENGTH(ruc) != 13 THEN
      mensaje := 'El numero de Ruc no es valido.';
      RAISE error_proceso;
    END IF;
    -- Se verifica el codigo de la Provincia que debe estar entre 01 y 24
    -- Provincia 30 - Consulados
    IF (TO_NUMBER(SUBSTR(ruc, 1, 2)) NOT BETWEEN 1 AND 24) AND
      (TO_NUMBER(SUBSTR(ruc,1,2)) <> 30)  THEN
      mensaje := 'El codigo de la provincia NO es valido.';
      RAISE error_proceso;
    END IF;

    IF TO_NUMBER(SUBSTR(ruc, 3, 1)) NOT BETWEEN 0 AND 5 THEN
      mensaje := 'El numero de Ruc NO es valido.';
      RAISE error_proceso;
    END IF;

    IF TO_NUMBER(SUBSTR(ruc, 11, 3)) <> 1 THEN
      mensaje := 'El numero de establecimiento NO es valido.';
      RAISE error_proceso;
    END IF;
    --
    FOR i IN 1 .. 9 LOOP
      producto := TO_NUMBER(SUBSTR(coeficiente, i, 1)) *
                  TO_NUMBER(SUBSTR(ruc, i, 1));
      IF producto > 9 THEN
        producto := producto - 9;
      END IF;
      -- Acumulo el valor resultado del coeficiente con la cedula.
      suma := suma + producto;
    END LOOP;

    IF MOD(suma, 10) <> 0 THEN
      verificador := 10 - MOD(suma, 10);
    ELSE
      verificador := 0;
    END IF;

    IF TO_NUMBER(SUBSTR(ruc, 10, 1)) != verificador THEN
      mensaje := 'El digito verificador NO es valido.';
      RAISE error_proceso;
    END IF;

  EXCEPTION
    WHEN error_proceso THEN
      mensaje := NVL(mensaje, ' en VALIDA_RUC0_5');
    WHEN OTHERS THEN
      mensaje := 'VALIDA_RUC0_5: ' || sqlerrm;
  END;

  --***********
  PROCEDURE VALIDA_RUC6(RUC VARCHAR2, MENSAJE OUT VARCHAR2) IS
    coeficiente varchar2(8) := '32765432';
    suma        number(3) := 0;
    producto    number(3) := 0;
    verificador number(3) := 0;
    error_proceso EXCEPTION;

  BEGIN
    mensaje := null;
    -- Se verifica la longitud de la cedula
    If length(ruc) != 13 Then
      mensaje := 'El numero de Ruc no es valido.';
      raise error_proceso;
    End if;
    -- Se verifica el codigo de la Provincia que debe estar entre 01 y 24
    -- Provincia 30 - Consulados
    If (To_number(Substr(ruc, 1, 2)) not between 1 and 24) AND
      (TO_NUMBER(SUBSTR(ruc,1,2)) <> 30)  Then
      mensaje := 'El codigo de la provincia es valido.';
      raise error_proceso;
    End if;
    If To_number(Substr(ruc, 3, 1)) != 6 Then
      mensaje := 'El numero de ruc no es valido.';
      raise error_proceso;
    End if;

    If To_number(Substr(ruc, 10, 4)) <> 1 Then
      mensaje := 'El numero de establecimiento no es valido.';
      raise error_proceso;
    End if;

    For i in 1 .. 8 Loop
      producto := To_number(Substr(coeficiente, i, 1)) *
                  To_number(Substr(ruc, i, 1));
      -- Acumulo el valor resultado del coeficiente con la cedula.
      suma := suma + producto;
    End loop;

    if mod(suma, 11) > 0 then
      verificador := 11 - mod(suma, 11);
      if verificador = 10 then
        verificador := 0;
      End if;
    else
      verificador := 0;
    end if;

    If To_number(Substr(ruc, 9, 1)) != verificador then
      mensaje := 'El digito verificador no es valido.';
      raise error_proceso;
    end if;

  EXCEPTION
    WHEN error_proceso THEN
      mensaje := nvl(mensaje, ' en CPVALIDA_RUC6');

    WHEN OTHERS THEN
      mensaje := 'CPVALIDA_RUC6 : ' || sqlerrm;
  END;

  --***********
  PROCEDURE VALIDA_RUC9(RUC VARCHAR2, MENSAJE OUT VARCHAR2) IS
    coeficiente varchar2(9) := '432765432';
    suma        number(3) := 0;
    producto    number(3) := 0;
    verificador number(3) := 0;
    error_proceso EXCEPTION;

  BEGIN
    mensaje := null;
    -- Se verifica la longitud de la cedula
    If length(ruc) != 13 Then
      mensaje := 'El numero de Ruc no es valido.';
      raise error_proceso;
    End if;
    -- Se verifica el codigo de la Provincia que debe estar entre 01 y 24
    -- Provincia 30 - Consulados
    If (To_number(Substr(ruc, 1, 2)) not between 1 and 24) AND
      (TO_NUMBER(SUBSTR(ruc,1,2)) <> 30) Then
      mensaje := 'El codigo de la provincia NO es valido.';
      raise error_proceso;
    End if;
    If To_number(Substr(ruc, 3, 1)) != 9 Then
      mensaje := 'El numero de ruc no es valido.';
      raise error_proceso;
    End if;

    If To_number(Substr(ruc, 11, 3)) <> 1 Then
      mensaje := 'El numero de establecimiento no es valido.';
      raise error_proceso;
    End if;

    For i in 1 .. 9 Loop
      producto := To_number(Substr(coeficiente, i, 1)) *
                  To_number(Substr(ruc, i, 1));
      -- Acumulo el valor resultado del coeficiente con la cedula.
      suma := suma + producto;
    End loop;

    if mod(suma, 11) <> 0 then
      verificador := 11 - mod(suma, 11);
    else
      verificador := 0;
    End if;
    If To_number(Substr(ruc, 10, 1)) != verificador then
      mensaje := 'El digito verificador no es valido.';
      raise error_proceso;
    end if;

  EXCEPTION
    WHEN error_proceso THEN
      mensaje := nvl(mensaje, ' en CPVALIDA_RUC9');

    WHEN OTHERS THEN
      mensaje := 'CPVALIDA_RUC9 : ' || sqlerrm;

  END;

  --***********


  PROCEDURE VALIDA(p_tipo_ident         varchar2,
                   p_identificacion     varchar2,
                   pv_CodEmpresa        varchar2,
                   pv_tipoTributario    varchar2,
                   p_mensaje            in out varchar2) is

    mensaje                 varchar2(100) := NULL;
    ln_valida_empresa       number;
    Lv_paramCabValidaId     varchar2(100) := 'VALIDA_IDENTIFICACION_POR_EMPRESA';
    Lv_estadoActivo         varchar2(100) := 'Activo';
    Lv_QueryValidaEmpresa   varchar2(1000) := '';

  begin

    -- Initialization
    If (UPPER(p_tipo_ident) = 'CED' OR UPPER(p_tipo_ident) = 'C') and
       (length(p_identificacion) <> 10) Then
      mensaje   := 'La cantidad digitos del documento NO es valido.';
      p_mensaje := mensaje;
      RETURN;
    End if;

    If (p_tipo_ident in ('RUC') OR p_tipo_ident in ('R')) and
       (length(p_identificacion) <> 13) Then
      mensaje   := 'La cantidad digitos del documento NO es valido.';
      p_mensaje := mensaje;
      RETURN;
    End if;

    -- Validaci�n de empresas que deben realizar estas validaciones
    Lv_QueryValidaEmpresa   := 'SELECT COUNT(*)
                                FROM   DB_GENERAL.ADMI_PARAMETRO_DET DET
                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                                  ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
                                WHERE CAB.NOMBRE_PARAMETRO = :Bv_ParamCab
                                  AND DET.VALOR1           = :Bv_CodEmpresa
                                  AND (DET.VALOR2          = :Bv_tipo_ident OR
                                      DET.VALOR3           = :Bv_tipo_ident2)
                                  AND CAB.ESTADO           = :Bv_estadoActivoCab
                                  AND DET.ESTADO           = :Bv_estadoActivoDet';

    IF pv_tipoTributario IS NOT NULL OR LENGTH(pv_tipoTributario) > 1 THEN
        Lv_QueryValidaEmpresa := Lv_QueryValidaEmpresa || ' AND DET.VALOR5 = :Bv_tipoTributario';
        EXECUTE IMMEDIATE Lv_QueryValidaEmpresa INTO ln_valida_empresa 
        USING Lv_paramCabValidaId,pv_CodEmpresa,p_tipo_ident,p_tipo_ident,
              Lv_estadoActivo, Lv_estadoActivo,pv_tipoTributario;
    ELSE
        EXECUTE IMMEDIATE Lv_QueryValidaEmpresa INTO ln_valida_empresa
        USING Lv_paramCabValidaId,pv_CodEmpresa,p_tipo_ident,p_tipo_ident,
              Lv_estadoActivo, Lv_estadoActivo;
    END IF;

    If ln_valida_empresa = 0 Then
      mensaje   := '';
      p_mensaje := mensaje;
      RETURN;
    End if;
    --

    If (p_tipo_ident in ('CED') OR p_tipo_ident in ('C')) and
       (To_number(Substr(p_identificacion, 3, 1)) not in (0, 1, 2, 3, 4, 5,6)) Then
      mensaje   := 'El tercer digito debe estar entre 0 y 5.';
      p_mensaje := mensaje;
      RETURN;
    End if;

    If (p_tipo_ident in ('RUC') OR p_tipo_ident in ('R')) and
       (To_number(Substr(p_identificacion, 3, 1)) in (7, 8)) Then
      mensaje   := 'El tercer digito debe ser menor a 7 o igual a 9.';
      p_mensaje := mensaje;
      RETURN;
    End if;

    --
    -- Tercer digito < 6
    If (p_tipo_ident = 'CED' OR p_tipo_ident = 'C') and
       (length(p_identificacion) = 10) and
       Substr(p_identificacion, 3, 1) in ('0', '1', '2', '3', '4', '5', '6') Then
      valida_cedula(p_identificacion, mensaje);
      if mensaje is not null then
        p_mensaje := mensaje;
        RETURN;
      end if;
    End if;
    --
    -- Tercer digito < 6
    If (p_tipo_ident = 'RUC' OR p_tipo_ident = 'R') and
       (length(p_identificacion) = 13) and
       Substr(p_identificacion, 3, 1) in ('0', '1', '2', '3', '4', '5') Then
      valida_ruc0_5(p_identificacion, mensaje);
      if mensaje is not null then
        p_mensaje := mensaje;
        RETURN;
      end if;

    End if;
    --
    -- Tercer digito = 6
    If (p_tipo_ident = 'RUC' OR p_tipo_ident = 'R') and
       (length(p_identificacion) = 13) and
       Substr(p_identificacion, 3, 1) = '6' Then
      valida_ruc6(p_identificacion, mensaje);
      if mensaje is not null then
        p_mensaje := mensaje;
        RETURN;
      end if;

    End if;
    --
    -- Tercer digito = 9
    If (p_tipo_ident = 'RUC' OR p_tipo_ident = 'R') and
       (length(p_identificacion) = 13) and
       Substr(p_identificacion, 3, 1) = '9' Then
      valida_ruc9(p_identificacion, mensaje);
      if mensaje is not null then
        p_mensaje := mensaje;
        RETURN;
      end if;
    End if;
  EXCEPTION
    WHEN OTHERS THEN
      mensaje := ('Error en Valida: ' || SQLCODE || ' - ' || SQLERRM);
  end valida;

  PROCEDURE VALIDA(p_tipo_ident     varchar2,
                   p_identificacion varchar2,
                   p_mensaje        in out varchar2) is

    mensaje varchar2(100) := NULL;

  begin
    -- Initialization
    If (UPPER(p_tipo_ident) = 'CED' OR UPPER(p_tipo_ident) = 'C') and
       (length(p_identificacion) <> 10) Then
      mensaje   := 'La cantidad digitos del documento NO es valido.';
      p_mensaje := mensaje;
      RETURN;
    End if;

    If (p_tipo_ident in ('RUC') OR p_tipo_ident in ('R')) and
       (length(p_identificacion) <> 13) Then
      mensaje   := 'La cantidad digitos del documento NO es valido.';
      p_mensaje := mensaje;
      RETURN;
    End if;

    If (p_tipo_ident in ('CED') OR p_tipo_ident in ('C')) and
       (To_number(Substr(p_identificacion, 3, 1)) not in (0, 1, 2, 3, 4, 5,6)) Then
      mensaje   := 'El tercer digito debe estar entre 0 y 5.';
      p_mensaje := mensaje;
      RETURN;
    End if;

    If (p_tipo_ident in ('RUC') OR p_tipo_ident in ('R')) and
       (To_number(Substr(p_identificacion, 3, 1)) in (7, 8)) Then
      mensaje   := 'El tercer digito debe ser menor a 7 o igual a 9.';
      p_mensaje := mensaje;
      RETURN;
    End if;

    --
    -- Tercer digito < 6
    If (p_tipo_ident = 'CED' OR p_tipo_ident = 'C') and
       (length(p_identificacion) = 10) and
       Substr(p_identificacion, 3, 1) in ('0', '1', '2', '3', '4', '5', '6') Then
      valida_cedula(p_identificacion, mensaje);
      if mensaje is not null then
        p_mensaje := mensaje;
        RETURN;
      end if;
    End if;
    --
    -- Tercer digito < 6
    If (p_tipo_ident = 'RUC' OR p_tipo_ident = 'R') and
       (length(p_identificacion) = 13) and
       Substr(p_identificacion, 3, 1) in ('0', '1', '2', '3', '4', '5') Then
      valida_ruc0_5(p_identificacion, mensaje);
      if mensaje is not null then
        p_mensaje := mensaje;
        RETURN;
      end if;

    End if;
    --
    -- Tercer digito = 6
    If (p_tipo_ident = 'RUC' OR p_tipo_ident = 'R') and
       (length(p_identificacion) = 13) and
       Substr(p_identificacion, 3, 1) = '6' Then
      valida_ruc6(p_identificacion, mensaje);
      if mensaje is not null then
        p_mensaje := mensaje;
        RETURN;
      end if;

    End if;
    --
    -- Tercer digito = 9
    If (p_tipo_ident = 'RUC' OR p_tipo_ident = 'R') and
       (length(p_identificacion) = 13) and
       Substr(p_identificacion, 3, 1) = '9' Then
      valida_ruc9(p_identificacion, mensaje);
      if mensaje is not null then
        p_mensaje := mensaje;
        RETURN;
      end if;
    End if;
  EXCEPTION
    WHEN OTHERS THEN
      mensaje := ('Error en Valida: ' || SQLCODE || ' - ' || SQLERRM);
  end valida;

  PROCEDURE P_VALIDA_FORMATO_PANAMA(Pv_identificacion VARCHAR2,
                                    Pv_tipo_identificacion VARCHAR2,
                                    Pv_mensaje        OUT VARCHAR2) AS
    LV_PREFIJO             VARCHAR2(5)   := NULL;
    LV_IDENTIFICACION      VARCHAR2(100) := TRIM(' ' FROM UPPER(PV_IDENTIFICACION));
    LV_MENSAJE             VARCHAR2(50)  := 'Documento de identificaci�n incorrecto.';
    LV_SEPARADOR           VARCHAR2(1)   := '-';
    LV_NOMBRE_PARAMETRO    VARCHAR2(30)  := '''CEDULA_PANAMA''';
    LN_POSICION            NUMBER := 0;
    LE_ERROR               EXCEPTION;
    LE_NO_CEDULA           EXCEPTION;
    LV_DESCRIPCION         VARCHAR2(100);
    LV_DESCRIPCION_INICIAL VARCHAR2(100);
    LV_VALOR1              VARCHAR2(100);
    LV_VALOR2              VARCHAR2(100);
    LV_VALOR3              VARCHAR2(100);
    LV_BANDERA_NUM         VARCHAR2(1) := 0;
    LV_BANDERA_CEDULA      VARCHAR2(1) := 0;
    LV_VALOR_FORMATO       VARCHAR2(10) := 0;
    LN_ID_PARAMETRO        NUMBER;
    LN_VECES_SEPARADOR     NUMBER;
    LN_VECES_REGISTRO      NUMBER;
    TYPE CUR_TYP IS REF CURSOR;
    LC_CURSOR              CUR_TYP;
    LV_QUERY_FORMATO       VARCHAR2(350) := 'SELECT D.VALOR1, D.VALOR2, D.VALOR3, D.DESCRIPCION, C.ID_PARAMETRO 
FROM ADMI_PARAMETRO_CAB C, ADMI_PARAMETRO_DET D       
WHERE C.ID_PARAMETRO = D.PARAMETRO_ID         
AND C.MODULO = ''COMERCIAL PANAMA''         
AND C.ESTADO = ''Activo''         
AND D.ESTADO = ''Activo''  
AND C.NOMBRE_PARAMETRO = ';
    LV_QUERY_FORMATO_NUM     VARCHAR2(30) := ' AND D.VALOR1 = ''NUM''';
    LV_QUERY_FORMATO_ALFANUM VARCHAR2(30) := ' AND D.VALOR1 != ''NUM''';
    CURSOR LC_FORMATO_CAB(C_NOMBRE_PARAMETRO VARCHAR2) IS
      SELECT DESCRIPCION, ID_PARAMETRO
        FROM ADMI_PARAMETRO_CAB
       WHERE NOMBRE_PARAMETRO = C_NOMBRE_PARAMETRO
         AND ESTADO = 'Activo';
    CURSOR LC_FORMATO_DET(C_PARAMETRO_ID VARCHAR2) IS
      SELECT DESCRIPCION, VALOR1, VALOR2
        FROM ADMI_PARAMETRO_DET
       WHERE PARAMETRO_ID = C_PARAMETRO_ID
         AND ESTADO = 'Activo'
       ORDER BY VALOR1;
  BEGIN
    IF (LV_IDENTIFICACION IS NULL) THEN
      RAISE LE_ERROR;
    END IF;
    IF (Pv_tipo_identificacion IS NOT NULL) THEN
      IF (PV_TIPO_IDENTIFICACION = 'PAS') THEN
        RAISE LE_NO_CEDULA;
      END IF;
      IF (PV_TIPO_IDENTIFICACION = 'RUC') THEN
        --No existe un formato para regirse de �l. En caso que exista utilizar como nombre de par�metro 'RUC_PANAMA'
        --VALIDO �NICAMENTE EL TAMA�O DE LOS CARACTERES
        OPEN LC_CURSOR FOR LV_QUERY_FORMATO || '''RUC_PANAMA_GENERAL''';
        FETCH LC_CURSOR
          --VALOR1 = M�NIMO, VALOR2= M�XIMO, VALOR3 = EXPRESI�N REGULAR
          INTO LV_VALOR1, LV_VALOR2, LV_VALOR3, LV_DESCRIPCION, LN_ID_PARAMETRO;
        CLOSE LC_CURSOR;
        IF(REGEXP_COUNT(LV_IDENTIFICACION, LV_VALOR3, 1, 'i') > 0) THEN
          RAISE LE_ERROR;
        ELSIF (LENGTH(LV_IDENTIFICACION) < LV_VALOR1 OR LENGTH(LV_IDENTIFICACION) > LV_VALOR2) THEN
          RAISE LE_ERROR;
        ELSE
          RAISE LE_NO_CEDULA;
        END IF;
      END IF;
    END IF;
    LV_QUERY_FORMATO := LV_QUERY_FORMATO || LV_NOMBRE_PARAMETRO;
    -- OBTENGO EL PREFIJO --
    LN_POSICION      := INSTR(LV_IDENTIFICACION, LV_SEPARADOR);
    LV_PREFIJO       := TRIM(SUBSTR(LV_IDENTIFICACION, 1, LN_POSICION - 1));
    LV_VALOR_FORMATO := LV_PREFIJO;
    --- FIN OBTENGO EL PREFIJO -----
    -- OBTENGO EL NUMERO DE INCIDENCIAS ----
    LN_VECES_SEPARADOR := LENGTH(LV_IDENTIFICACION) -
                          LENGTH(REPLACE(LV_IDENTIFICACION,
                                         LV_SEPARADOR,
                                         ''));
    --- VALIDO EL PREFIJO -----
    IF (IS_NUMBER(LV_PREFIJO) = 1) THEN
      LV_QUERY_FORMATO := LV_QUERY_FORMATO || LV_QUERY_FORMATO_NUM;
      LV_BANDERA_NUM   := '1';
    ELSE
      LV_QUERY_FORMATO := LV_QUERY_FORMATO || LV_QUERY_FORMATO_ALFANUM;
    END IF;
    OPEN LC_CURSOR FOR LV_QUERY_FORMATO;
    LOOP
      FETCH LC_CURSOR
        INTO LV_VALOR1, LV_VALOR2, LV_VALOR3, LV_DESCRIPCION, LN_ID_PARAMETRO;
      EXIT WHEN LC_CURSOR%NOTFOUND;
      FOR C_FORMATO_CAB IN LC_FORMATO_CAB(LV_DESCRIPCION) LOOP
        IF (LV_BANDERA_CEDULA = 1) THEN
          LV_MENSAJE := 'OK';
          RAISE LE_ERROR;
        END IF;

        FOR C_FORMATO_DETALLE IN LC_FORMATO_DET(C_FORMATO_CAB.ID_PARAMETRO) LOOP
          ---------VALIDO LA DESCRIPCION------------
          IF (LV_DESCRIPCION_INICIAL is null or
             LV_DESCRIPCION_INICIAL != LV_DESCRIPCION) THEN
            LV_IDENTIFICACION      := TRIM(' ' FROM
                                           UPPER(PV_IDENTIFICACION));
            LV_DESCRIPCION_INICIAL := LV_DESCRIPCION;
            -- SEPARO POR PRIMERA VEZ EL NUMERO 
            LN_POSICION      := INSTR(LV_IDENTIFICACION, LV_SEPARADOR);
            LV_PREFIJO       := TRIM(SUBSTR(LV_IDENTIFICACION,
                                            1,
                                            LN_POSICION - 1));
            LV_VALOR_FORMATO := LV_PREFIJO;
          END IF;
          -- CUENTO EL NUMERO DE REGISTROS PARA VALIDAR  CONTRA EL NUMERO DE RENGLONES DEL PARAMETRO
          SELECT COUNT(*) - 1
            INTO LN_VECES_REGISTRO
            FROM ADMI_PARAMETRO_DET
           WHERE PARAMETRO_ID = C_FORMATO_CAB.ID_PARAMETRO
             AND ESTADO = 'Activo';
          IF (LV_IDENTIFICACION IS NULL) THEN
            EXIT;
          END IF;
          IF (LN_VECES_REGISTRO != LN_VECES_SEPARADOR) THEN
            LV_MENSAJE := 'Documento de identificaci�n incorrecto.';

            EXIT;
          END IF;

          LV_BANDERA_NUM := IS_NUMBER(LV_VALOR_FORMATO);
          IF (LV_BANDERA_NUM = '1') THEN
            IF (TO_NUMBER(LV_VALOR_FORMATO) < 0 OR
               TO_NUMBER(LV_VALOR_FORMATO) >
               TO_NUMBER(C_FORMATO_DETALLE.VALOR2)) THEN
              EXIT;
            END IF;
          ELSE
            IF (LV_VALOR_FORMATO != C_FORMATO_DETALLE.VALOR2) THEN
              EXIT;
            END IF;
          END IF;
          LV_IDENTIFICACION := LTRIM(LV_IDENTIFICACION, LV_VALOR_FORMATO);
          LV_IDENTIFICACION := SUBSTR(LV_IDENTIFICACION,
                                      2,
                                      LENGTH(LV_IDENTIFICACION));
          LN_POSICION := INSTR(LV_IDENTIFICACION, LV_SEPARADOR);
          IF (LN_POSICION != 0) THEN
            LV_VALOR_FORMATO := TRIM(SUBSTR(LV_IDENTIFICACION,
                                            1,
                                            LN_POSICION - 1));
          ELSE
            LV_VALOR_FORMATO := LV_IDENTIFICACION;
          END IF;
          IF (LN_VECES_SEPARADOR + 1 = LC_FORMATO_DET%ROWCOUNT) THEN
            LV_BANDERA_CEDULA := 1;
            LV_MENSAJE        := 'OK';
            RAISE LE_ERROR;
          END IF;
        END LOOP;
      END LOOP;
    END LOOP;
    CLOSE LC_CURSOR;
    PV_MENSAJE := LV_MENSAJE;
  EXCEPTION
    WHEN LE_ERROR THEN
      PV_MENSAJE := LV_MENSAJE;
    WHEN LE_NO_CEDULA THEN
      PV_MENSAJE := 'OK';
    WHEN OTHERS THEN
      PV_MENSAJE := LV_MENSAJE;
  END P_VALIDA_FORMATO_PANAMA;

  FUNCTION IS_NUMBER(PV_STRING IN VARCHAR2) RETURN INT AS
    v_new_num NUMBER;
  BEGIN
    v_new_num := TO_NUMBER(PV_STRING);
    RETURN 1;
  EXCEPTION
    WHEN VALUE_ERROR THEN
      RETURN 0;
  END IS_NUMBER;

  PROCEDURE P_VALIDA_NIT(
      Pv_Identificacion IN  VARCHAR2,
      Pv_Mensaje        OUT VARCHAR2) IS

    CURSOR C_GET_PARAMETRO_DET(Cv_EmpresaCod VARCHAR2, 
                               Cv_NombreParametro VARCHAR2,
                               Cv_Modulo VARCHAR2,
                               Cv_Valor1 VARCHAR2,
                               Cv_Valor2 VARCHAR2,
                               Cv_Estado VARCHAR2) IS
      SELECT DET.VALOR3
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
           DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
      AND CAB.ESTADO           =  Cv_Estado
      AND DET.ESTADO           =  Cv_Estado
      AND CAB.MODULO           =  Cv_Modulo
      AND DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND DET.VALOR1           =  Cv_Valor1
      AND DET.VALOR2           =  Cv_Valor2
      AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;

    Lv_ParamLongitudNit    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'MAX_IDENTIFICACION';
    Lv_ModuloComercial     DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE           := 'COMERCIAL';
    Lv_EstadoActivo        DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE              := 'Activo';
    Lv_TipoIdentificacion  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           := 'NIT';
    Lv_Pais                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE           := 'GUATEMALA';
    Lv_EmpresaCod          DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE    := '27';
    Ln_LongitudNit         NUMBER                                              := 0;
    Ln_Posicion            NUMBER                                              := 0;
    Ln_DigitoVerificador   NUMBER                                              := 0;
    Ln_Suma                NUMBER                                              := 0;
    Ln_Valor               NUMBER                                              := 0;
    Ln_Inicio              NUMBER                                              := 2;
    Ln_Indx                NUMBER;
    Lv_Numero              VARCHAR2(13)                                        := '';
    Lv_Identificacion      VARCHAR2(13)                                        := '';
    Lv_Mensaje             VARCHAR2(4000)                                      := '';
    Lc_ParamLongitudNit    C_GET_PARAMETRO_DET%ROWTYPE;
    Le_Exception           EXCEPTION;

  BEGIN

    OPEN C_GET_PARAMETRO_DET(Lv_EmpresaCod,Lv_ParamLongitudNit,Lv_ModuloComercial,Lv_TipoIdentificacion,Lv_Pais,Lv_EstadoActivo);
     FETCH C_GET_PARAMETRO_DET 
        INTO Lc_ParamLongitudNit;
    CLOSE C_GET_PARAMETRO_DET;

    Ln_LongitudNit := TO_NUMBER(NVL(Lc_ParamLongitudNit.VALOR3,0));

    IF LENGTH(Pv_Identificacion) > Ln_LongitudNit THEN
      Lv_Mensaje := 'El n�mero documento de identificaci�n no debe ser mayor a '||Ln_LongitudNit;
      RAISE Le_Exception;
    END IF;

    IF Pv_Identificacion = 'C/F' THEN
      Lv_Mensaje := 'OK';
    ELSE
      IF INSTR(Pv_Identificacion,'-') != 0  THEN
        Lv_Identificacion := REPLACE(Pv_Identificacion,'-','');
      ELSE
        Lv_Identificacion := Pv_Identificacion;
      END IF;

      Ln_Posicion := LENGTH(Lv_Identificacion);

      FOR Ln_Indx IN Ln_Inicio..LENGTH(Lv_Identificacion) LOOP
        Lv_Numero   := SUBSTR(Lv_Identificacion,Ln_Indx-1,1) * Ln_Posicion;
        Ln_Suma     := Ln_Suma + TO_NUMBER(Lv_Numero) ;
        Ln_Posicion := Ln_Posicion - 1;

      END LOOP; 

      Ln_DigitoVerificador := (11-(Ln_Suma MOD 11)) MOD 11;

      IF (Ln_DigitoVerificador = 10 AND (UPPER(SUBSTR(Lv_Identificacion,LENGTH(Lv_Identificacion), 1)) = 'K'))
                      OR  (Ln_DigitoVerificador = SUBSTR(Lv_Identificacion,LENGTH(Lv_Identificacion))) THEN
        Lv_Mensaje := 'OK';
      ELSE
        Lv_Mensaje := 'Documento de identificaci�n incorrecto';
      END IF;

    END IF;

  Pv_Mensaje := Lv_Mensaje;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Mensaje := Lv_Mensaje;
    WHEN OTHERS THEN
      Pv_Mensaje :='Error Interno. Favor notificar a Sistemas.';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'DB_COMERCIAL.VALIDA_IDENTIFICACION.P_VALIDA_NIT',
                                            Lv_Mensaje || ' - '|| SQLCODE ||' -ERROR- ' || SQLERRM || ' - ' ||
                                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.0') ); 
  END;

  PROCEDURE P_VALIDA_DPI(
      Pv_Identificacion IN  VARCHAR2,
      Pv_Mensaje        OUT VARCHAR2) IS

    CURSOR C_GET_PARAMETRO_DET(Cv_EmpresaCod VARCHAR2, 
                               Cv_NombreParametro VARCHAR2,
                               Cv_Modulo VARCHAR2,
                               Cv_Valor1 VARCHAR2,
                               Cv_Valor2 VARCHAR2,
                               Cv_Estado VARCHAR2) IS
      SELECT DET.VALOR3,DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
           DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
      AND CAB.ESTADO           =  Cv_Estado
      AND DET.ESTADO           =  Cv_Estado
      AND CAB.MODULO           =  Cv_Modulo
      AND DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND DET.VALOR1           =  Cv_Valor1
      AND DET.VALOR2           =  Cv_Valor2
      AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;

    CURSOR C_GET_PARAMETRO_DETB(Cv_EmpresaCod VARCHAR2, 
                               Cv_NombreParametro VARCHAR2,
                               Cv_Modulo VARCHAR2,
                               Cv_Valor2 VARCHAR2,
                               Cv_Estado VARCHAR2) IS
      SELECT DET.VALOR3,DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
           DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
      AND CAB.ESTADO           =  Cv_Estado
      AND DET.ESTADO           =  Cv_Estado
      AND CAB.MODULO           =  Cv_Modulo
      AND DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND DET.VALOR2           =  Cv_Valor2
      AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;

    CURSOR C_GET_NUM_DPTOS(Cv_EmpresaCod VARCHAR2, 
                           Cv_NombreParametro VARCHAR2,
                           Cv_Modulo VARCHAR2,
                           Cv_Estado VARCHAR2) IS
      SELECT COUNT(DET.ID_PARAMETRO_DET) AS NUM_DPTOS
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
           DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
      AND CAB.ESTADO           =  Cv_Estado
      AND DET.ESTADO           =  Cv_Estado
      AND CAB.MODULO           =  Cv_Modulo
      AND DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;

    Lv_ParamLongitudNit    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'MAX_IDENTIFICACION';
    Lv_ParamNumMunDepto    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'NUM_MUNIC_DPTO';
    Lv_ModuloComercial     DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE           := 'COMERCIAL';
    Lv_EstadoActivo        DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE              := 'Activo';
    Lv_TipoIdentificacion  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           := 'DPI';
    Lv_Pais                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE           := 'GUATEMALA';
    Lv_EmpresaCod          DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE    := '27';
    Ln_LongitudDpi         NUMBER                                              := 0;
    Ln_Posicion            NUMBER                                              := 0;
    Ln_DigitoVerificador   NUMBER                                              := 0;
    Ln_Suma                NUMBER                                              := 0;
    Ln_Valor               NUMBER                                              := 0;
    Ln_Indx                NUMBER;
    Ln_Departamento        NUMBER                                              := 0;
    Ln_Municipio           NUMBER                                              := 0;
    Ln_NumDptos            NUMBER                                              := 0;
    Ln_NumMunDptoParam     NUMBER                                              := 0;
    Ln_DigVerificador      NUMBER                                              := 0;
    Lv_DptoDpi             VARCHAR2(2)                                         := '';
    Lv_NumMunDptoParam     VARCHAR2(2)                                         := '';
    Lv_Numero              VARCHAR2(13)                                        := '';
    Lv_Identificacion      VARCHAR2(13)                                        := '';
    Lv_ExpRegularDpi       VARCHAR2(35)                                        := '';
    Lv_Mensaje             VARCHAR2(4000)                                      := '';
    Lc_ParametroDpi        C_GET_PARAMETRO_DET%ROWTYPE;
    Lc_ParamMunDpto        C_GET_PARAMETRO_DETB%ROWTYPE;
    Lc_ParamNumDpto        C_GET_NUM_DPTOS%ROWTYPE;
    Le_Exception           EXCEPTION;

  BEGIN

    OPEN C_GET_PARAMETRO_DET(Lv_EmpresaCod,Lv_ParamLongitudNit,Lv_ModuloComercial,Lv_TipoIdentificacion,Lv_Pais,Lv_EstadoActivo);
     FETCH C_GET_PARAMETRO_DET 
        INTO Lc_ParametroDpi;
    CLOSE C_GET_PARAMETRO_DET;

    OPEN C_GET_NUM_DPTOS(Lv_EmpresaCod,Lv_ParamNumMunDepto,Lv_ModuloComercial,Lv_EstadoActivo);
     FETCH C_GET_NUM_DPTOS 
        INTO Lc_ParamNumDpto;
    CLOSE C_GET_NUM_DPTOS;

    Ln_NumDptos      := NVL(Lc_ParamNumDpto.NUM_DPTOS,0);
    Ln_LongitudDpi   := TO_NUMBER(NVL(Lc_ParametroDpi.VALOR3,0));
    Lv_ExpRegularDpi := NVL(Lc_ParametroDpi.VALOR4,'');

    Lv_Identificacion := Pv_Identificacion;
    Lv_DptoDpi        := SUBSTR(Lv_Identificacion,10,2);

    Ln_Departamento   := TO_NUMBER(SUBSTR(Lv_Identificacion,10,2));
    Ln_Municipio      := TO_NUMBER(SUBSTR(Lv_Identificacion,12,2));
    Ln_DigVerificador := TO_NUMBER(SUBSTR(Lv_Identificacion,9,1));
    Lv_Numero         := SUBSTR(Lv_Identificacion,1,8);

    OPEN C_GET_PARAMETRO_DETB(Lv_EmpresaCod,Lv_ParamNumMunDepto,Lv_ModuloComercial,Lv_DptoDpi,Lv_EstadoActivo);
     FETCH C_GET_PARAMETRO_DETB 
        INTO Lc_ParamMunDpto;
    CLOSE C_GET_PARAMETRO_DETB;

    Ln_NumMunDptoParam := TO_NUMBER(Lc_ParamMunDpto.VALOR3);

    IF NOT REGEXP_LIKE(Pv_Identificacion,Lv_ExpRegularDpi) OR 
           ((Ln_Departamento = 0 OR Ln_Municipio = 0) OR (Ln_Departamento = 0 AND Ln_Municipio = 0) )  OR 
           (Ln_Departamento > Ln_NumDptos) OR
           (Ln_Municipio    > Ln_NumMunDptoParam) THEN
      Lv_Mensaje := 'Documento de identificaci�n incorrecto';
      RAISE Le_Exception;
    ELSE

      FOR Ln_Indx IN 0..(LENGTH(Lv_Numero)-1) LOOP

        Ln_Suma := Ln_Suma + TO_NUMBER(SUBSTR(Lv_Numero,Ln_Indx+1,1)) * (Ln_Indx+2) ;

      END LOOP; 

      Ln_Valor := Ln_Suma MOD 11; 

    IF (Ln_Valor = Ln_DigVerificador) THEN
      Lv_Mensaje := 'OK';
    ELSE
      Lv_Mensaje := 'Documento de identificaci�n incorrecto';
    END IF;


    END IF;

  Pv_Mensaje := Lv_Mensaje;  

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Mensaje := Lv_Mensaje; 
    WHEN OTHERS THEN
      Pv_Mensaje :='Error Interno. Favor notificar a Sistemas.';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'DB_COMERCIAL.VALIDA_IDENTIFICACION.P_VALIDA_DPI',
                                            Lv_Mensaje || ' - '|| SQLCODE ||' -ERROR- ' || SQLERRM || ' - ' ||
                                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') ); 
  END;

end VALIDA_IDENTIFICACION;
/