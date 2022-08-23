    /*
    * Se realiza ingresos y actualizaciones de registros necesarios para la aplicación 'Gestión de Licitación'.
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 - 25-06-2022
    */
    --Ingresamos la cabecera de las categorías del sistema Katuk.
    INSERT INTO NAF47_TNET.ARIN_CATALOGO_KATUK_CAB (
        ID_CATALOGO,
        NOMBRE,
        NIVEL,
        TIPO,
        CODIGO,
        FECHA_CREACION,
        USUARIO_CREACION
    ) VALUES (
        NAF47_TNET.SEQ_ARIN_CATALOGO_KATUK_CAB.NEXTVAL,
        'Sin Categoría',
        '1',
        'products',
        '1',
        SYSDATE,
        'kbaque'
    );
    --Ingresamos el detalle de las categorías del sistema Katuk.
    INSERT INTO NAF47_TNET.ARIN_CATALOGO_KATUK_DET (
        ID_CATALOGO_DET,
        NOMBRE,
        NIVEL,
        TIPO,
        CODIGO,
        CATALOGO_ID,
        FECHA_CREACION,
        USUARIO_CREACION
    ) VALUES (
        NAF47_TNET.SEQ_ARIN_CATALOGO_KATUK_DET.NEXTVAL,
        'Sin Categoría',
        '2',
        'products',
        '1',
        (
            SELECT
                ID_CATALOGO
            FROM
                NAF47_TNET.ARIN_CATALOGO_KATUK_CAB
            WHERE
                    NOMBRE = 'Sin Categoría'
                AND ROWNUM = 1
        ),
        SYSDATE,
        'kbaque'
    );
    --Relacionamos todos los artículos a la categoría del sistema katuk.
    UPDATE NAF47_TNET.ARINDA
    SET
        CATALOGO_ID_DET = (
            SELECT
                ID_CATALOGO_DET
            FROM
                NAF47_TNET.ARIN_CATALOGO_KATUK_DET
            WHERE
                NOMBRE = 'Sin Categoría'
        )
    WHERE
        NO_CIA = 10;

    COMMIT;
    /