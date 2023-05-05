CREATE  FORCE VIEW "NAF47_TNET"."V_INFO_EMPLEADO" ("DEP_DEPTO", "DEP_DESCRI", "ARE_AREA", "ARE_DESCRI", "PRO_PROVINCIA", "PRO_DESCRIPCION", "CIA_NO_CIA", "CIA_NOMBRE", "CIA_NOMBRE_CORTO", "CIA_DOMINIO", "PUESTO_", "PUESTO_ANT_", "TIT_TITULO", "TIT_DESCRIPCION", "LOGIN", "TIPO_EMP_NAF", "TIPO_EMPLEADO", "TIPO_EMPLEADO_ANT", "TIPO_EMPLEADO_DESCRIP", "NO_CIA", "NO_EMPLE", "TIPO_EMP", "NOMBRE", "NOMBRE_PILA", "APE_PAT", "APE_MAT", "ESTADO", "CEDULA", "CIUDAD_CEDULA", "NACION", "ASEGU", "AFP", "SUB_NIVEL", "FORMA_PAGO", "ID_CTA", "TIPO_CTA", "NUM_CUENTA", "SANGRE", "TELEFONO", "DIRECCION", "APARTADO", "F_INGRESO", "F_EGRESO", "F_FIN_CONTRATO", "F_REINGRESO", "CONDICION", "E_CIVIL", "NO_HORA", "F_NACIMI", "CATEGORIA", "TITULO", "TIT_PROV_NAL", "TARJETA", "PROCESA_TARJ", "LICENCIA", "AREA", "DEPTO", "DIVISION", "SECCION", "PUESTO", "SEXO", "ACUMULA_VACAC", "PLAZO_VACAC", "PORC_ADELANTO", "ADELANTO", "ULT_ACC", "GANA_EXTRAS", "TIPO_SEGURO", "OBSERV_INS", "ADE_IMPSAL", "CENTRO_COSTO", "ESTADO_PROP", "SAL_BAS", "NOTIFICA", "TEL_NOTI", "ID_PROVINCIA", "MAIL", "CELULAR", "LIBRETA_MILITAR", "LOCALIDAD", "NOMBRE_SEGUNDO", "PAIS_NACIMIENTO", "PROVIN_NACIMIENTO", "CANTON_NACIMIENTO", "PARRO_NACIMIENTO", "NOTAS", "SERV_MILITAR", "SALDO_IVA_DOL", "IND_LIQUIDACION", "ID_REGION_PATRONAL", "IND_NIVEL_SALARIAL", "GRUPO", "NIVEL", "MOTIVO_SALIDA", "IND_VISTO_BUENO", "DEDUCCIONES_FAM", "DEDUCCIONES_OTR", "DETALLE_CARGO", "DEDUCCIONES_OING", "PORDISCAPACIDAD", "TERCERAEDAD", "SEQUENCIA", "COBRA_UTILIDADES", "IND_AVISO_SALIDA", "CALLE", "NUMERO", "NO_CLIENTE", "IND_REGION", "USUARIO", "IND_FDO_RES", "IND_DECIMOS", "IND_APLICA_935", "TIPO_ID_TRIBUTARIO", "SERVICIOS_PRESTADOS", "PORC_ADE_SERV_PREST", "ID_CIUDAD_DIREC", "ID_PROVINCIA_DIREC", "IND_IMP_RENTA", "TIPO_DISCAPACIDAD", "VIRTUAL_INI", "IND_ORDEN_JUDICIAL", "MONTO_ORDEN_JUDICIAL", "TEXTO_JUDICIAL", "DETALLE_SALIDA", "ID_JEFE", "NO_CIA_JEFE", "CELULAR2", "CELULAR3", "MAIL_CIA", "OBSERVACION", "NO_CIA_RELACIONADA", "F_INGRESO_RELACIONADA", "OFICINA", "PUESTO_ANT", "TIPO_EMP_ANT", "ID_OTRO_BANCO", "IND_DEC_TERCERO", "IND_DEC_CUARTO", "FOTO") AS 
  SELECT DEP.DEPA
               AS DEP_DEPTO,
           DEP.DESCRI
               AS DEP_DESCRI,
           ARE.AREA
               AS ARE_AREA,
           ARE.DESCRI
               AS ARE_DESCRI,
           PRO.PROVINCIA
               AS PRO_PROVINCIA,
           PRO.DESCRIPCION
               AS PRO_DESCRIPCION,
           CIA.NO_CIA
               AS CIA_NO_CIA,
           CIA.NOMBRE
               AS CIA_NOMBRE,
           CIA.NOMBRE_CORTO
               AS CIA_NOMBRE_CORTO,
           CIA.DOMINIO
               AS CIA_DOMINIO,
           (SELECT PUESTO || ';' || DESCRI || ';' || JEFE
              FROM NAF47_TNET.ARPLMP
             WHERE PUESTO = EMP.PUESTO AND NO_CIA = EMP.NO_CIA)
               AS PUESTO_,
           (SELECT PUESTO || ';' || DESCRI || ';' || JEFE
              FROM NAF47_TNET.ARPLMP
             WHERE PUESTO = EMP.PUESTO_ANT AND NO_CIA = EMP.NO_CIA)
               AS PUESTO_ANT_,
           TIT.TITULO
               AS TIT_TITULO,
           TIT.DESCRIPCION
               AS TIT_DESCRIPCION,
           (SELECT LOGIN
              FROM NAF47_TNET.LOGIN_EMPLEADO
             WHERE NO_EMPLE = EMP.NO_EMPLE AND NO_CIA = EMP.NO_CIA)
               AS LOGIN,
           EMP.TIPO_EMP
               AS TIPO_EMP_NAF,
           (SELECT PARAMETRO_ALTERNO
              FROM NAF47_TNET.GE_PARAMETROS
             WHERE     ESTADO = 'A'
                   AND ID_APLICACION = 'PL'
                   AND ID_GRUPO_PARAMETRO = 'TIPO_EMPL'
                   AND PARAMETRO = EMP.TIPO_EMP
                   AND ID_EMPRESA = EMP.NO_CIA)
               AS TIPO_EMPLEADO,
           (SELECT PARAMETRO_ALTERNO
              FROM NAF47_TNET.GE_PARAMETROS
             WHERE     ID_APLICACION = 'PL'
                   AND ID_GRUPO_PARAMETRO = 'TIPO_EMPL'
                   AND PARAMETRO = EMP.TIPO_EMP_ANT
                   AND ID_EMPRESA = EMP.NO_CIA)
               AS TIPO_EMPLEADO_ANT,
           (SELECT TE.DESCRIP
              FROM NAF47_TNET.ARPLTE TE
             WHERE TE.TIPO_EMP = EMP.TIPO_EMP AND TE.NO_CIA = EMP.NO_CIA)
               AS TIPO_EMPLEADO_DESCRIP,
           EMP."NO_CIA",
           EMP."NO_EMPLE",
           EMP."TIPO_EMP",
           EMP."NOMBRE",
           EMP."NOMBRE_PILA",
           EMP."APE_PAT",
           EMP."APE_MAT",
           EMP."ESTADO",
           EMP."CEDULA",
           EMP."CIUDAD_CEDULA",
           EMP."NACION",
           EMP."ASEGU",
           EMP."AFP",
           EMP."SUB_NIVEL",
           EMP."FORMA_PAGO",
           EMP."ID_CTA",
           EMP."TIPO_CTA",
           EMP."NUM_CUENTA",
           EMP."SANGRE",
           EMP."TELEFONO",
           EMP."DIRECCION",
           EMP."APARTADO",
           EMP."F_INGRESO",
           EMP."F_EGRESO",
           EMP."F_FIN_CONTRATO",
           EMP."F_REINGRESO",
           EMP."CONDICION",
           EMP."E_CIVIL",
           EMP."NO_HORA",
           EMP."F_NACIMI",
           EMP."CATEGORIA",
           EMP."TITULO",
           EMP."TIT_PROV_NAL",
           EMP."TARJETA",
           EMP."PROCESA_TARJ",
           EMP."LICENCIA",
           EMP."AREA",
           EMP."DEPTO",
           EMP."DIVISION",
           EMP."SECCION",
           EMP."PUESTO",
           EMP."SEXO",
           EMP."ACUMULA_VACAC",
           EMP."PLAZO_VACAC",
           EMP."PORC_ADELANTO",
           EMP."ADELANTO",
           EMP."ULT_ACC",
           EMP."GANA_EXTRAS",
           EMP."TIPO_SEGURO",
           EMP."OBSERV_INS",
           EMP."ADE_IMPSAL",
           EMP."CENTRO_COSTO",
           EMP."ESTADO_PROP",
           EMP."SAL_BAS",
           EMP."NOTIFICA",
           EMP."TEL_NOTI",
           EMP."ID_PROVINCIA",
           EMP."MAIL",
           EMP."CELULAR",
           EMP."LIBRETA_MILITAR",
           EMP."LOCALIDAD",
           EMP."NOMBRE_SEGUNDO",
           EMP."PAIS_NACIMIENTO",
           EMP."PROVIN_NACIMIENTO",
           EMP."CANTON_NACIMIENTO",
           EMP."PARRO_NACIMIENTO",
           EMP."NOTAS",
           EMP."SERV_MILITAR",
           EMP."SALDO_IVA_DOL",
           EMP."IND_LIQUIDACION",
           EMP."ID_REGION_PATRONAL",
           EMP."IND_NIVEL_SALARIAL",
           EMP."GRUPO",
           EMP."NIVEL",
           EMP."MOTIVO_SALIDA",
           EMP."IND_VISTO_BUENO",
           EMP."DEDUCCIONES_FAM",
           EMP."DEDUCCIONES_OTR",
           EMP."DETALLE_CARGO",
           EMP."DEDUCCIONES_OING",
           EMP."PORDISCAPACIDAD",
           EMP."TERCERAEDAD",
           EMP."SEQUENCIA",
           EMP."COBRA_UTILIDADES",
           EMP."IND_AVISO_SALIDA",
           EMP."CALLE",
           EMP."NUMERO",
           EMP."NO_CLIENTE",
           EMP."IND_REGION",
           EMP."USUARIO",
           EMP."IND_FDO_RES",
           EMP."IND_DECIMOS",
           EMP."IND_APLICA_935",
           EMP."TIPO_ID_TRIBUTARIO",
           EMP."SERVICIOS_PRESTADOS",
           EMP."PORC_ADE_SERV_PREST",
           EMP."ID_CIUDAD_DIREC",
           EMP."ID_PROVINCIA_DIREC",
           EMP."IND_IMP_RENTA",
           EMP."TIPO_DISCAPACIDAD",
           EMP."VIRTUAL_INI",
           EMP."IND_ORDEN_JUDICIAL",
           EMP."MONTO_ORDEN_JUDICIAL",
           EMP."TEXTO_JUDICIAL",
           EMP."DETALLE_SALIDA",
           EMP."ID_JEFE",
           EMP."NO_CIA_JEFE",
           EMP."CELULAR2",
           EMP."CELULAR3",
           EMP."MAIL_CIA",
           EMP."OBSERVACION",
           EMP."NO_CIA_RELACIONADA",
           EMP."F_INGRESO_RELACIONADA",
           EMP."OFICINA",
           EMP."PUESTO_ANT",
           EMP."TIPO_EMP_ANT",
           EMP."ID_OTRO_BANCO",
           EMP."IND_DEC_TERCERO",
           EMP."IND_DEC_CUARTO",
           EMP."FOTO"
      FROM ARPLME  EMP
           INNER JOIN NAF47_TNET.ARCGMC CIA ON EMP.NO_CIA = CIA.NO_CIA
           INNER JOIN NAF47_TNET.ARPLAR ARE ON EMP.AREA = ARE.AREA
           INNER JOIN NAF47_TNET.ARPLDP DEP ON EMP.DEPTO = DEP.DEPA
           LEFT JOIN NAF47_TNET.ARPLDIV DIV
               ON     EMP.DIVISION = DIV.DIVISION
                  AND DIV.AREA = EMP.AREA
                  AND DIV.DEPA = EMP.DEPTO
                  AND DIV.NO_CIA = EMP.NO_CIA
           INNER JOIN NAF47_TNET.ARGEPRO PRO
               ON EMP.ID_PROVINCIA = PRO.PROVINCIA
           INNER JOIN NAF47_TNET.ARPLTIT TIT ON EMP.TITULO = TIT.TITULO
     WHERE     DEP.NO_CIA = EMP.NO_CIA
           AND ARE.NO_CIA = EMP.NO_CIA
           AND DEP.AREA = ARE.AREA
           AND PRO.PAIS = (SELECT PAIS
                             FROM NAF47_TNET.ARPLMC
                            WHERE NO_CIA = EMP.NO_CIA);