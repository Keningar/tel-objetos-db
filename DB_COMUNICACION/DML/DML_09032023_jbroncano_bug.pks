
UPDATE DB_COMUNICACION.info_documento 
SET ESTADO='Eliminado',
FE_ULT_MOD=sysdate,
USR_ULT_MOD='jbroncano'
where ID_DOCUMENTO in (
                     select IFD.ID_DOCUMENTO from DB_COMUNICACION.info_documento  IFD--1149
                      WHERE   INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'/MD/ResumenCompra/Comercial/DocResumenCompra/') >0  
                 AND IFD.FE_CREACION > sysdate -20    and IFD.fe_creacion < to_date('11/03/2023')
                 AND  IFD.ESTADO='Activo' and IFD.EMPRESA_COD=18
);



COMMIT;
/