UPDATE db_general.admi_parametro_det pardet
            SET pardet.VALOR1 = '7'
            WHERE pardet.descripcion = 'NUMERO DIAS PARA BARRIDO TAREAS'
            AND pardet.estado = 'Activo';
COMMIT;

/