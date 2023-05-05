CREATE EDITIONABLE FUNCTION                    get_elemento_padre(
    idParametroIngresoP  IN NUMBER,
    tipoParametroIngreso IN VARCHAR2,
    tipoElementoPadre    IN VARCHAR2)
  RETURN NUMBER
IS
  banderaSalir       VARCHAR2(2) :='NO';
  idElementoRetornar NUMBER;
  mensajeSalida      VARCHAR2(20) := 'NO ENCONTRADO';
  idIntarfeInicio    NUMBER;
  idPuertoTmp        NUMBER;
  idPuerto           NUMBER;
  idPuertoInicio     NUMBER;
  tipoElemento       VARCHAR2(10);
  idCantidadLoop     NUMBER :=50;
  intContador        NUMBER :=0;
  idParametroIngreso NUMBER :=idParametroIngresoP;
BEGIN
  IF (idParametroIngreso >0) THEN
    --
    IF (tipoParametroIngreso = 'ELEMENTO') THEN
      BEGIN
        SELECT INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO
        INTO idParametroIngreso
        FROM INFO_ELEMENTO,
          INFO_INTERFACE_ELEMENTO
        WHERE INFO_ELEMENTO.ID_ELEMENTO=idParametroIngreso
        AND INFO_ELEMENTO.ID_ELEMENTO  = INFO_INTERFACE_ELEMENTO.ELEMENTO_ID
        AND INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO LIKE 'IN%';
      EXCEPTION
      WHEN OTHERS THEN
        idParametroIngreso:=0;
      END;
    END IF;
    --
    IF (idParametroIngreso>0) THEN
      --
      WHILE banderaSalir = 'NO'
      LOOP
        intContador := intContador +1;
        BEGIN
          SELECT INTERFACE_ELEMENTO_INI_ID
          INTO idIntarfeInicio
          FROM INFO_ENLACE
          WHERE INTERFACE_ELEMENTO_FIN_ID=idParametroIngreso
          AND ESTADO                     ='Activo';
        EXCEPTION
        WHEN OTHERS THEN
          idIntarfeInicio:=0;
        END;
        --
        IF (idIntarfeInicio>0) THEN
          --
          BEGIN
            SELECT cc.NOMBRE_TIPO_ELEMENTO,
              ID_ELEMENTO
            INTO tipoElemento,
              idElementoRetornar
            FROM INFO_INTERFACE_ELEMENTO,
              INFO_ELEMENTO aa,
              ADMI_MODELO_ELEMENTO bb,
              ADMI_TIPO_ELEMENTO cc
            WHERE ID_INTERFACE_ELEMENTO=idIntarfeInicio
            AND ELEMENTO_ID            =ID_ELEMENTO
            AND aa.modelo_elemento_id  =bb.ID_MODELO_ELEMENTO
            AND bb.TIPO_ELEMENTO_ID    =cc.ID_TIPO_ELEMENTO;
          EXCEPTION
          WHEN OTHERS THEN
            idElementoRetornar:=0;
            tipoElemento      :='';
          END;
          --
          IF (tipoElemento     ='') THEN
            banderaSalir      := 'SI';
            idElementoRetornar:=NULL;
          ELSE
            --
            IF (tipoElemento      =tipoElementoPadre) THEN
              banderaSalir       :='SI';
              mensajeSalida      :='ENCONTRADO';
              idElementoRetornar :=idIntarfeInicio;
            ELSE
              idParametroIngreso:=idIntarfeInicio;
            END IF;
            --
          END IF;
          --
        ELSE
          banderaSalir      :='SI';
          idElementoRetornar:=NULL;
        END IF;
        --
        --
        IF (intContador     >=idCantidadLoop) THEN
          banderaSalir      :='SI';
          idElementoRetornar:=NULL;
        END IF;
        --
      END LOOP;
    ELSE
        --EMPRESA TN, DADO UN SW BUSCA SU PE
        idParametroIngreso:=idParametroIngresoP;
        FOR INTERFAZ IN
        (
            SELECT INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO ID_INTERFACE
              FROM  INFO_ELEMENTO,
                    INFO_INTERFACE_ELEMENTO
              WHERE INFO_ELEMENTO.ID_ELEMENTO = idParametroIngreso
              AND INFO_ELEMENTO.ID_ELEMENTO   = INFO_INTERFACE_ELEMENTO.ELEMENTO_ID
        )
        LOOP
            --CONTENIDO
            intContador       := 0;
            banderaSalir      :='NO';
            idIntarfeInicio   :=INTERFAZ.ID_INTERFACE;
            WHILE banderaSalir = 'NO'
                LOOP
                    idPuertoTmp := idIntarfeInicio;
                    intContador := intContador +1;
                    BEGIN
                        SELECT INTERFACE_ELEMENTO_INI_ID
                            INTO idIntarfeInicio
                            FROM INFO_ENLACE
                            WHERE INTERFACE_ELEMENTO_FIN_ID = idIntarfeInicio
                            AND ESTADO                      = 'Activo'
                            AND TIPO_ENLACE                 IN ('PRINCIPAL');
                    EXCEPTION
                    WHEN OTHERS THEN
                        idIntarfeInicio:=0;
                    END;
                    --
                    IF (idIntarfeInicio>0) THEN
                    --
                        BEGIN
                            SELECT cc.NOMBRE_TIPO_ELEMENTO,
                                  ID_ELEMENTO
                              INTO  tipoElemento,
                                    idElementoRetornar
                              FROM  INFO_INTERFACE_ELEMENTO,
                                    INFO_ELEMENTO aa,
                                    ADMI_MODELO_ELEMENTO bb,
                                    ADMI_TIPO_ELEMENTO cc
                              WHERE ID_INTERFACE_ELEMENTO=idIntarfeInicio
                              AND ELEMENTO_ID            =ID_ELEMENTO
                              AND aa.modelo_elemento_id  =bb.ID_MODELO_ELEMENTO
                              AND bb.TIPO_ELEMENTO_ID    =cc.ID_TIPO_ELEMENTO;
                        EXCEPTION
                        WHEN OTHERS THEN
                            idElementoRetornar:=0;
                            tipoElemento      :='';
                        END;
                        --
                        IF (tipoElemento = '') THEN
                            banderaSalir      := 'SI';
                            idElementoRetornar:=NULL;
                        --IF (tipoElemento = '') THEN
                        ELSE
                            IF (tipoElemento = tipoElementoPadre) THEN
                                banderaSalir       :='SI';
                                mensajeSalida      :='ENCONTRADO';
                                idElementoRetornar :=idIntarfeInicio;
                                RETURN(idElementoRetornar);
                            --IF (tipoElemento = tipoElementoPadre) THEN
                            ELSE
                                idParametroIngreso:=idIntarfeInicio;
                            --IF (tipoElemento = tipoElementoPadre) THEN
                            END IF;
                        --IF (tipoElemento = '') THEN
                        END IF;
                    --IF (idIntarfeInicio>0) THEN
                    ELSE
                        BEGIN
                            SELECT ID_ELEMENTO,
                                    cc.NOMBRE_TIPO_ELEMENTO
                              INTO  idElementoRetornar,
                                    tipoElemento
                              FROM  INFO_INTERFACE_ELEMENTO,
                                    INFO_ELEMENTO aa,
                                    ADMI_MODELO_ELEMENTO bb,
                                    ADMI_TIPO_ELEMENTO cc
                              WHERE ID_INTERFACE_ELEMENTO=idPuertoTmp
                              AND ELEMENTO_ID            =ID_ELEMENTO
                              AND aa.modelo_elemento_id  =bb.ID_MODELO_ELEMENTO
                              AND bb.TIPO_ELEMENTO_ID    =cc.ID_TIPO_ELEMENTO;
                        EXCEPTION
                        WHEN OTHERS THEN
                            idElementoRetornar:=0;
                            tipoElemento      :='';
                        END;
                        
                        IF(tipoElemento = 'SWITCH' OR tipoElemento = 'ROUTER') THEN
                            FOR PUERTO IN
                            (
                                SELECT INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO ID_INTERFACE
                                  FROM  INFO_ELEMENTO,
                                        INFO_INTERFACE_ELEMENTO
                                  WHERE INFO_ELEMENTO.ID_ELEMENTO = idElementoRetornar
                                  AND INFO_ELEMENTO.ID_ELEMENTO   = INFO_INTERFACE_ELEMENTO.ELEMENTO_ID
                            )
                            LOOP
                                --
                                idPuertoInicio   := PUERTO.ID_INTERFACE;
                                idPuerto         := PUERTO.ID_INTERFACE;
                                BEGIN
                                    SELECT INTERFACE_ELEMENTO_INI_ID
                                        INTO idPuertoInicio
                                        FROM INFO_ENLACE
                                        WHERE INTERFACE_ELEMENTO_FIN_ID = idPuertoInicio
                                        AND ESTADO                      = 'Activo'
                                        AND TIPO_ENLACE                 IN ('PRINCIPAL');
                                EXCEPTION
                                WHEN OTHERS THEN
                                    idPuertoInicio:=0;
                                END;
                                
                                IF (idPuertoInicio > 0) THEN
                                    idIntarfeInicio := idPuerto;
                                    EXIT;
                                END IF;
                                --
                            END LOOP;
                        --IF(tipoElemento = 'SWITCH' OR tipoElemento = 'ROUTER')
                        END IF;                        
                        
                        IF (idIntarfeInicio = 0) THEN
                            banderaSalir      :='SI';
                            idElementoRetornar:=NULL;
                        END IF;
                    --IF (idIntarfeInicio>0) THEN
                    END IF;
                    --
                    IF (intContador >= idCantidadLoop) THEN
                        banderaSalir      :='SI';
                        idElementoRetornar:=NULL;
                    END IF;
                --
                END LOOP;
        END LOOP;
    END IF;
  END IF;
  RETURN(idElementoRetornar);
EXCEPTION
WHEN OTHERS THEN
  idElementoRetornar:=NULL;
  tipoElemento      :='';
END get_elemento_padre;
/