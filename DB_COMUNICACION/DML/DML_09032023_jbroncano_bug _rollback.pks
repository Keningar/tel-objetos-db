
UPDATE DB_COMUNICACION.info_documento 
SET ESTADO='Activo',
FE_ULT_MOD=null,
USR_ULT_MOD=''
where ID_DOCUMENTO in (
                     select IFD.ID_DOCUMENTO from DB_COMUNICACION.info_documento  IFD--1149
                      WHERE   INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'/MD/ResumenCompra/Comercial/DocResumenCompra/') >0  
                 AND IFD.FE_CREACION > sysdate -20    and IFD.fe_creacion < to_date('11/03/2023')
                 AND  IFD.ESTADO='Eliminado' and IFD.EMPRESA_COD=18 AND IFD.USR_ULT_MOD='jbroncano'
);

COMMIT;
/