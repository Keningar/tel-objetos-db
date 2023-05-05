create or replace PROCEDURE CPACTUALIZA (pCia   IN arcpmd.no_cia%TYPE, --  varchar2,
                                         pProve IN arcpmd.no_prove%TYPE,--varchar2,
                                         pTipo  IN arcpmd.tipo_doc%TYPE,--varchar2,
                                         pDocu  IN arcpmd.no_docu%TYPE,--  varchar2,
                                         pError IN OUT VARCHAR2) IS
BEGIN
  
CPACTUALIZA@GPOETNET(pCia => pCia,
              pProve => pProve,
              pTipo => pTipo,
              pDocu => pDocu,
              pError => pError);

EXCEPTION
  
   WHEN OTHERS THEN
     pError := 'CPActualiza : ' || SQLERRM;
     RETURN;
END CPActualiza;
