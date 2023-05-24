CREATE OR REPLACE TRIGGER NAF47_TNET.TR_ARINMCNT_INFO_PERSONA
  after insert or update ON NAF47_TNET.ARINMCNT  
  for each row
declare
  -- local variables here
  cursor c_persona (Cv_Identificacion Varchar2) is
    select identificacion_cliente, id_persona
      from db_comercial.info_persona
     where identificacion_cliente like Cv_Identificacion||'%';
  --
 cursor c_PersonaRol (Cv_IdPersona Number) is
   select estado, id_persona_rol
     from db_comercial.info_persona_empresa_rol
   where empresa_rol_id = 4 -- rol fijo de contratista
     and persona_id = Cv_IdPersona;

  Lr_Persona      db_comercial.info_persona%rowtype := null;
  Lv_IdenAux      db_comercial.info_persona.identificacion_cliente%type := null; 
  Lv_MensajeError Varchar2(3000) := null;
  Le_Error        Exception;
  Lv_EstadoRol    db_comercial.info_empresa_rol.estado%type := null;
  Ln_SecEmpRol    db_comercial.info_persona_empresa_rol.id_persona_rol%type  := null;
  --
begin

  if c_persona%isopen then close c_persona; end if;
  if length(:new.cedula) = 13 then
    open c_persona (substr(:new.cedula,1,10));
  else
    open c_persona (:new.cedula);
  end if;
  fetch c_persona into Lv_IdenAux, Lr_Persona.Id_Persona;
  if c_persona%notfound then
    Lv_IdenAux := null;
  end if;
  close c_persona;

  if :new.cedula != Lv_IdenAux and Lv_IdenAux is not null then
    Goto Fin;
  end if;

  --Tipo de identificacion CED: cedula o RUC: ruc PAS: pasaporte
  case
    when :new.tipo_id_tributario = 'R' then
      Lr_Persona.Razon_Social := :new.nombre;
      Lr_Persona.tipo_identificacion := 'RUC';
    when :new.tipo_id_tributario = 'C' then
      Lr_Persona.nombres := :new.nombre_pila||' '||:new.nombre_segundo;
      Lr_Persona.apellidos := :new.ape_pat||' '||:new.ape_mat;
      Lr_Persona.tipo_identificacion := 'CED';
    when :new.tipo_id_tributario = 'P' then
      Lr_Persona.nombres := :new.nombre_pila||' '||:new.nombre_segundo;
      Lr_Persona.apellidos := :new.ape_pat||' '||:new.ape_mat;
      Lr_Persona.tipo_identificacion := 'PAS';
  end case;

  Lr_Persona.identificacion_cliente := :new.cedula;
  Lr_Persona.estado := 'Activo';
  Lr_Persona.usr_creacion := user;
  Lr_Persona.ip_creacion := sys_context('userenv','ip_address');

  if Lv_IdenAux is null then

    Lr_Persona.id_persona := DB_COMERCIAL.SEQ_INFO_PERSONA.NEXTVAL;

    insert into db_comercial.info_persona
              ( id_persona,
                tipo_identificacion,
                identificacion_cliente,
                nombres,
                apellidos,
                razon_social,
                estado,
                usr_creacion,
                ip_creacion,
                fe_creacion)
       values ( Lr_Persona.id_persona,
                Lr_Persona.tipo_identificacion,
                Lr_Persona.identificacion_cliente,
                Lr_Persona.nombres,
                Lr_Persona.apellidos,
                Lr_Persona.razon_social,
                Lr_Persona.estado,
                Lr_Persona.usr_creacion,
                Lr_Persona.ip_creacion,
                Lr_Persona.fe_creacion);
  else

    update db_comercial.info_persona
       set estado = Lr_Persona.Estado
     where identificacion_cliente = Lr_Persona.identificacion_cliente;
  end if;

  -- se verifica rol contratista
  if c_PersonaRol%isopen then close c_PersonaRol; end if;
  open c_PersonaRol (Lr_Persona.Id_Persona);
  fetch c_PersonaRol into Lv_EstadoRol, Ln_SecEmpRol;
  if c_PersonaRol%notfound then -- no existe se inserta

    Ln_SecEmpRol := DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL.NEXTVAL;

    insert into db_comercial.info_persona_empresa_rol
              ( id_persona_rol,
                persona_id,
                empresa_rol_id,
                estado,
                usr_creacion,
                fe_creacion,
                ip_creacion)
       values ( Ln_SecEmpRol,
                Lr_Persona.Id_Persona,
                4, -- codigo Fijo Contratista indicado por TELCOS
                'Activo',
                user,
                sysdate,
                Lr_Persona.ip_creacion);

  elsif Lv_EstadoRol = 'Inactivo' then -- solo si se encuentra inactivo se actualiza 

    update db_comercial.info_persona_empresa_rol
       set estado = 'Activo',
           usr_creacion = user,
           fe_creacion = sysdate,
           ip_creacion = Lr_Persona.ip_creacion
     where empresa_rol_id = 4
       and persona_id = Lr_Persona.Id_Persona;
  end if;
  close c_PersonaRol;

  <<Fin>>
  Lv_IdenAux := null;

EXCEPTION
  when Le_Error then
    Raise_Application_Error('-20002', Lv_MensajeError);
  when others then
    Raise_Application_Error('-20002', 'TR_ARINMCNT_INFO_PERSONA: '||sqlerrm);
end TR_ARINMCNT_INFO_PERSONA;

/