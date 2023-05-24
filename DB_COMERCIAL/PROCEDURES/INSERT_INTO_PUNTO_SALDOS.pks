CREATE OR REPLACE PROCEDURE DB_COMERCIAL.INSERT_INTO_PUNTO_SALDOS
IS

  limit_in PLS_INTEGER:=5000;
  
  --  
  
  CURSOR c_infoPto(cn_idPunto NUMBER) IS SELECT punto_id,saldo FROM info_punto_saldo WHERE PUNTO_ID = cn_idPunto;    
  
  -- 
  
  CURSOR C_GetSaldosPuntosVista IS SELECT PUNTO_ID, SALDO from DB_FINANCIERO.vista_estado_cuenta_resumido;
   
  --variables 
  
  TYPE t_vista IS TABLE OF C_GetSaldosPuntosVista%ROWTYPE INDEX BY PLS_INTEGER;
  v_vista t_vista;
  
  --
  id_punto number;
  saldo number;
  commit_counter number := 0;
  --
  
BEGIN

  OPEN C_GetSaldosPuntosVista;
  
  FETCH C_GetSaldosPuntosVista bulk collect INTO v_vista ;
  
  FOR i IN 1.. v_vista.COUNT
  LOOP  
  
  commit_counter := commit_counter+1;
    
    IF c_infoPto%ISOPEN THEN
      CLOSE c_infoPto;
    END IF;
    
    OPEN c_infoPto(v_vista(i).punto_id);      
    
    id_punto := 0;
    saldo    := 0;
    
    FETCH c_infoPto INTO id_punto,saldo;      
    
    if c_infoPto%notfound THEN              
    
        insert into info_punto_saldo(punto_id,saldo) values(v_vista(i).punto_id,v_vista(i).saldo);
        commit_counter := commit_counter + 1;
        
    else          
                          
        IF v_vista(i).saldo <> saldo THEN            
            UPDATE db_comercial.info_punto_saldo SET saldo = v_vista(i).saldo  WHERE punto_id = id_punto;  
            commit_counter := commit_counter + 1;
        end if;
        
    end if;      
    
    if commit_counter > 3000 then commit; commit_counter:=0;    
    end if;
    
  END LOOP;  
  
  if commit_counter <=2999 then commit; end if;
  
END INSERT_INTO_PUNTO_SALDOS;
/