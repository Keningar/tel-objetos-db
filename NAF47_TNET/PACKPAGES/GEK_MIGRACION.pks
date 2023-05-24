CREATE OR REPLACE package NAF47_TNET.GEK_MIGRACION is

  /**
  * Documentacion para el procedimiento P_INSERTA_MIGRA_ARCGAE
  * Procedimiento que registra la informacion en cabecera de repositorio contable
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 04-08-2017
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 03-10-2018 -  Se modifica para asignar forma de pago cero como valor por defecto
  *
  * @param Pr_MigraArcga   IN NAF47_TNET.MIGRA_ARCGAE recibe variable registro de tabla
  * @param Pv_MensajeError IN OUT VARCHAR2            retorna mensaje de errores
  */
  PROCEDURE P_INSERTA_MIGRA_ARCGAE(Pr_MigraArcga   IN NAF47_TNET.MIGRA_ARCGAE%ROWTYPE,
                                   Pv_MensajeError OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_INSERTA_MIGRA_ARCGAL
  * Procedimiento que registra la informacion en detalle de repositorio contable
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 04-08-2017
  *
  * @param Pr_MigraArcga   IN NAF47_TNET.MIGRA_ARCGAL recibe variable registro de tabla
  * @param Pv_MensajeError IN OUT VARCHAR2            retorna mensaje de errores
  */
  PROCEDURE P_INSERTA_MIGRA_ARCGAL(Pr_MigraArcgal  IN NAF47_TNET.MIGRA_ARCGAL%ROWTYPE,
                                   Pv_MensajeError OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_INSERTA_MIGRA_ARCGAE_MASIVO
  * Procedimiento que registra la informacion en cabecera de repositorio contable
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 13/01/2023
  *
  * @param Pr_MigraArcga   IN NAF47_TNET.MIGRA_ARCGAE recibe variable registro de tabla
  * @param Pv_MensajeError IN OUT VARCHAR2            retorna mensaje de errores
  */
  type lstMigraArcgaeType is table of NAF47_TNET.MIGRA_ARCGAE%ROWTYPE;

  PROCEDURE P_INSERTA_MIGRA_ARCGAE_MASIVO(Pr_MigraArcga   IN lstMigraArcgaeType,
                                          Pv_MensajeError OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_INSERTA_MIGRA_ARCGAL_MASIVO
  * Procedimiento que registra la informacion en detalle de repositorio contable
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 13/01/2023
  *
  * @param Pr_MigraArcga   IN NAF47_TNET.MIGRA_ARCGAL recibe variable registro de tabla
  * @param Pv_MensajeError IN OUT VARCHAR2            retorna mensaje de errores
  */
  type lstMigraArcgalType is table of NAF47_TNET.MIGRA_ARCGAl%ROWTYPE;
  PROCEDURE P_INSERTA_MIGRA_ARCGAL_MASIVO(Pr_MigraArcga  IN lstMigraArcgalType,
                                          Pv_MensajeError OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_INSERTA_MIGRA_ARCKMM
  * Procedimiento que registra la informacion en cabecera de repositorio Bancos
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 04-08-2017
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 03-10-2018 -  Se modifica para asignar forma de pago cero como valor por defecto
  *
  * @param Pr_MigraArcga   IN NAF47_TNET.MIGRA_ARCKMM recibe variable registro de tabla
  * @param Pv_MensajeError IN OUT VARCHAR2            retorna mensaje de errores
  */
  PROCEDURE P_INSERTA_MIGRA_ARCKMM(Pr_MigraArckmm  IN NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
                                   Pv_MensajeError OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_INSERTA_MIGRA_ARCKML
  * Procedimiento que registra la informacion en detalle de repositorio Bancos
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 04-08-2017
  *
  * @param Pr_MigraArcga   IN NAF47_TNET.MIGRA_ARCKML recibe variable registro de tabla
  * @param Pv_MensajeError IN OUT VARCHAR2            retorna mensaje de errores
  */
  PROCEDURE P_INSERTA_MIGRA_ARCKML(Pr_MigraArckml  IN NAF47_TNET.MIGRA_ARCKML%ROWTYPE,
                                   Pv_MensajeError OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_MIGRACION_CG
  * Procedimiento central que realiza el llamado a los procedimientos de migracion de asientos contables.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 01-10-2016
  */
  PROCEDURE P_MIGRACION_CG(Pv_NoCia           IN Varchar2,
                           Pn_Anio            IN Number,
                           Pn_Mes             IN Number,
                           Pv_Fecha           IN Varchar2,
                           Pv_DescripcionCab  IN Varchar2,
                           Pn_TDebitos        IN Number,
                           Pn_TCreditos       IN Number,
                           Pv_UsuarioCreacion IN Varchar2,
                           Pclob_ListDistCont IN CLOB,
                           Pv_Salida          OUT VARCHAR2,
                           Pv_Mensaje         OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_MIGRACION_CK
  * Procedimiento central que realiza el llamado a los procedimientos de migracion de transacciones bancarias.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 04-10-2016
  */
  PROCEDURE P_MIGRACION_CK(Pv_NoCia              IN Varchar2,
                           Pn_Anio               IN Number,
                           Pn_Mes                IN Number,
                           Pv_Fecha              IN Varchar2,
                           Pclob_ListTransaccion IN CLOB,
                           Pv_UsuarioCreacion    IN Varchar2,
                           Pv_Salida             OUT VARCHAR2,
                           Pv_Mensaje            OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_MIGRACION_RH
  * Procedimiento que realiza el llamado a los procedimientos de migracion de empleados.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 14-11-2016
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.1 14-02-2018 Se quita la insercion de la oficina, ya que este debe de realizarse primero en Telcos
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.2 26-04-2018 Se agregan parametros
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.3 28-01-2019 Se agrega llamado a nuevo prodedimiento de sincronizacion de empleados.
  *
  * @author Jefferson Soria <jesoria@telconet.ec>
  * @version 1.4 28-02-2023 Se agrega llamado a nuevo prodedimiento de sincronizacion de empleados con TelcoU.
  */
  PROCEDURE P_MIGRACION_RH(Pv_NoCia               IN Varchar2,
                           Pv_NombrePila          IN Varchar2,
                           Pv_TipoIdentificacion  IN Varchar2,
                           Pv_Cedula              IN Varchar2,
                           Pv_Mail                IN Varchar2,
                           Pv_Telefono            IN Varchar2,
                           Pv_Celular             IN Varchar2,
                           Pv_Celular2            IN Varchar2,
                           Pv_Celular3            IN Varchar2,
                           Pv_NombreSegundo       IN Varchar2,
                           Pv_ApePat              IN Varchar2,
                           Pv_ApeMat              IN Varchar2,
                           Pv_Direccion           IN Varchar2,
                           Pv_Oficina             IN Varchar2,
                           Pv_FechaIngreso        IN Varchar2,
                           Pv_FechaEgreso         IN Varchar2,
                           Pv_FechaNacimiento     IN Varchar2,
                           Pv_Sexo                IN Varchar2,
                           Pv_Estado              IN Varchar2,
                           Pv_EstadoCivil         IN Varchar2,
                           Pv_Provincia           IN Varchar2,
                           Pv_Canton              IN Varchar2,
                           Pv_Area                IN Varchar2,
                           Pv_Departamento        IN Varchar2,
                           Pv_Puesto              IN Varchar2,
                           Pv_PuestoAnterior      IN Varchar2,
                           Pv_EsJefe              IN Varchar2,
                           Pv_Titulo              IN Varchar2,
                           Pv_TipoEmpleado        IN Varchar2,
                           Pv_CalleDireccion      IN Varchar2,
                           Pv_ProvinciaDireccion  IN Varchar2,
                           Pv_CantonDireccion     IN Varchar2,
                           Pn_Sueldo              IN Number,
                           Pv_PaisNacimiento      IN Varchar2,
                           Pv_ProvinciaNacimiento IN Varchar2,
                           Pv_CantonNacimiento    IN Varchar2,
                           Pn_AdelantoQuincenal   IN Number,
                           Pv_CuentaEmpresa       IN Varchar2,
                           Pv_FormaPago           IN Varchar2,
                           Pv_BancoEmpleado       IN Varchar2,
                           Pv_TipoCuenta          IN Varchar2,
                           Pv_NumeroCuenta        IN Varchar2,
                           Pv_CentroCosto         IN Varchar2,
                           Pv_NoCiaJefe           IN Varchar2,
                           Pv_IdJefe              IN Varchar2,
                           Pv_FormaPagoBcoEmp     IN Varchar2,
                           Pv_Banco               IN Varchar2,
                           Pclob_Foto             IN Clob,
                           Pv_Salida              OUT Varchar2,
                           Pv_Mensaje             OUT Varchar2);

  /**
  * Documentacion para el procedimiento RHP_INSERTA_ARPLME
  * Procedimiento que realiza la creacion de empleados.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 14-11-2016
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.1 06-06-2018 Se agregan parametros para la insercion.
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.2 26-04-2018 Se agregan parametros para la insercion.
  */
  PROCEDURE RHP_INSERTA_ARPLME(Pv_NoCia               IN Varchar2,
                               Pv_NombrePila          IN Varchar2,
                               Pv_Cedula              IN Varchar2,
                               Pv_Mail                IN Varchar2,
                               Pv_Telefono            IN Varchar2,
                               Pv_Celular             IN Varchar2,
                               Pv_Celular2            IN Varchar2,
                               Pv_Celular3            IN Varchar2,
                               Pv_NombreSegundo       IN Varchar2,
                               Pv_ApePat              IN Varchar2,
                               Pv_ApeMat              IN Varchar2,
                               Pv_Direccion           IN Varchar2,
                               Pv_Oficina             IN Varchar2,
                               Pv_FechaIngreso        IN Varchar2,
                               Pv_FechaNacimiento     IN Varchar2,
                               Pv_Sexo                IN Varchar2,
                               Pv_Estado              IN Varchar2,
                               Pv_EstadoCivil         IN Varchar2,
                               Pv_IdProvincia         IN Varchar2,
                               Pv_IdCanton            IN Varchar2,
                               Pv_IdArea              IN Varchar2,
                               Pv_IdDepartamento      IN Varchar2,
                               Pv_Puesto              IN Varchar2,
                               Pv_Titulo              IN Varchar2,
                               Pv_TipoEmpleado        IN Varchar2,
                               Pv_CalleDireccion      IN Varchar2,
                               Pv_ProvinciaDireccion  IN Varchar2,
                               Pv_CantonDireccion     IN Varchar2,
                               Pn_Sueldo              IN Number,
                               Pv_PaisNacimiento      IN Varchar2,
                               Pv_ProvinciaNacimiento IN Varchar2,
                               Pv_CantonNacimiento    IN Varchar2,
                               Pn_AdelantoQuincenal   IN Number,
                               Pv_CuentaEmpresa       IN Varchar2,
                               Pv_FormaPago           IN Varchar2,
                               Pv_BancoEmpleado       IN Varchar2,
                               Pv_TipoCuenta          IN Varchar2,
                               Pv_NumeroCuenta        IN Varchar2,
                               Pv_CentroCosto         IN Varchar2,
                               Pv_NoCiaJefe           IN Varchar2,
                               Pv_IdJefe              IN Varchar2,
                               Pv_TipoIdentificacion  IN Varchar2,
                               Pclob_Foto             IN Clob,
                               Pv_NoEmple             OUT Varchar2,
                               Pv_Salida              OUT Varchar2,
                               Pv_Mensaje             OUT Varchar2);

  /**
  * Documentacion para el procedimiento RHP_ACTUALIZA_ARPLME
  * Procedimiento que realiza la actualizacion de empleados.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 14-11-2016
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.1 06-02-2018 Se agregan parametros para la actualiacion
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.2 26-04-2018 Se agregan parametros para actualizacion.
  */
  PROCEDURE RHP_ACTUALIZA_ARPLME(Pv_NoCia               IN Varchar2,
                                 Pv_NoEmple             IN Varchar2,
                                 Pv_NombrePila          IN Varchar2,
                                 Pv_Telefono            IN Varchar2,
                                 Pv_Celular             IN Varchar2,
                                 Pv_Celular2            IN Varchar2,
                                 Pv_Celular3            IN Varchar2,
                                 Pv_NombreSegundo       IN Varchar2,
                                 Pv_ApePat              IN Varchar2,
                                 Pv_ApeMat              IN Varchar2,
                                 Pv_Direccion           IN Varchar2,
                                 Pv_Oficina             IN Varchar2,
                                 Pv_FechaIngreso        IN Varchar2,
                                 Pv_FechaEgreso         IN Varchar2,
                                 Pv_Estado              IN Varchar2,
                                 Pv_EstadoCivil         IN Varchar2,
                                 Pv_IdProvincia         IN Varchar2,
                                 Pv_IdCanton            IN Varchar2,
                                 Pv_IdArea              IN Varchar2,
                                 Pv_IdDepartamento      IN Varchar2,
                                 Pv_Puesto              IN Varchar2,
                                 Pv_PuestoAnterior      IN Varchar2,
                                 Pv_Titulo              IN Varchar2,
                                 Pv_TipoEmpleado        IN Varchar2,
                                 Pv_CalleDireccion      IN Varchar2,
                                 Pv_ProvinciaDireccion  IN Varchar2,
                                 Pv_CantonDireccion     IN Varchar2,
                                 Pn_Sueldo              IN Number,
                                 Pv_PaisNacimiento      IN Varchar2,
                                 Pv_ProvinciaNacimiento IN Varchar2,
                                 Pv_CantonNacimiento    IN Varchar2,
                                 Pn_AdelantoQuincenal   IN Number,
                                 Pv_CuentaEmpresa       IN Varchar2,
                                 Pv_FormaPago           IN Varchar2,
                                 Pv_BancoEmpleado       IN Varchar2,
                                 Pv_TipoCuenta          IN Varchar2,
                                 Pv_NumeroCuenta        IN Varchar2,
                                 Pv_CentroCosto         IN Varchar2,
                                 Pv_NoCiaJefe           IN Varchar2,
                                 Pv_IdJefe              IN Varchar2,
                                 Pclob_Foto             IN Clob,
                                 /*Pv_FormaPagoBcoEmp  IN Varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Pv_Banco            IN Varchar2,*/
                                 Pv_Salida  OUT Varchar2,
                                 Pv_Mensaje OUT Varchar2);

  /**
  * Documentacion para el procedimiento P_ELIMINA_MIGRA_CG
  * Procedimiento que elimina migracion para ser reprocesada en modulo contable
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 22-02-2017
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 21/03/2017 Se modifica para agregar parametro Pv_NoAsiento que eliminara individualmente registros
  *
  * @param Pd_Fecha        IN DATE         Recibe fecha de asiento contables, solo aplica para eliminacion masiva
  * @param Pv_NoAsiento    IN VARCHAR2     recibe numero de asiento contable, solo aplica para eliminacion individual
  * @param Pv_CodDiario    IN VARCHAR2     recibe tipo de asiento contable
  * @param Pv_NoCia        IN VARCHAR2     recibe codigo de empresa
  * @param Pv_MensajeError IN OUT VARCHAR2 retorna mensaje de errores
  */
  PROCEDURE P_ELIMINA_MIGRA_CG(Pd_Fecha        IN DATE,
                               Pv_NoAsiento    IN VARCHAR2,
                               Pv_CodDiario    IN VARCHAR2,
                               Pv_NoCia        IN VARCHAR2,
                               Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_ELIMINA_MIGRA_CK
  * Procedimiento que elimina migracion para ser reprocesada en modulo bancos
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 17-03-2017
  *
  * @param Pv_NoDocu       IN VARCHAR2     recibe numero de transaccion
  * @param Pv_NoCia        IN VARCHAR2     recibe codigo de empresa
  * @param Pv_MensajeError IN OUT VARCHAR2 retorna mensaje de errores
  */
  PROCEDURE P_ELIMINA_MIGRA_CK(Pv_NoDocu       IN VARCHAR2,
                               Pv_NoCia        IN VARCHAR2,
                               Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento F_VALIDA_ELIMINAR_MIGRA
  * Procedimiento que valida si existen asientos contables o documentos bancos generados por documento migra
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 02-08-2017
  *
  * @param Pv_IdMigracion   IN VARCHAR2     recibe numero de documento migra
  * @param Pv_TipoMigracion IN VARCHAR2     recibe Tipo de Migracion [CK] Bancos; [CG] Contabilidad
  * @param Pv_NoCia         IN VARCHAR2     recibe codigo de empresa
  * @retun boolean          retorna verdadero o falso
  */
  FUNCTION F_VALIDA_ELIMINAR_MIGRA(Pv_IdMigracion   IN VARCHAR2,
                                   Pv_TipoMigracion IN VARCHAR2,
                                   Pv_NoCia         IN VARCHAR2)
    RETURN BOOLEAN;

  /**
  * Documentacion para el procedimiento P_ELIMINA_DOCUMENTO_MIGRADO
  * Procedimiento que elimina del repositorio migracion BANCOS / CONTABILIDAD
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 02-08-2017
  *
  * @param Pv_IdMigracion   IN VARCHAR2     recibe numero de documento migrado
  * @param Pv_TipoMigracion IN VARCHAR2     recibe Tipo de Migracion [CK] Bancos; [CG] Contabilidad
  * @param Pv_NoCia         IN VARCHAR2     recibe codigo de empresa
  * @param Pv_MensajeError  IN OUT VARCHAR2 retorna mensaje de errores
  */
  PROCEDURE P_ELIMINA_DOCUMENTO_MIGRADO(Pv_IdMigracion   IN VARCHAR2,
                                        Pv_TipoMigracion IN VARCHAR2,
                                        Pv_NoCia         IN VARCHAR2,
                                        Pv_MensajeError  IN OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_PROCESA_MIGRA_DOC_ASOCIADO
  * Procedimiento que registra datso de documentos asociados TELCOS / NAF
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 03-08-2017
  *
  * @param Pr_MigraDocAsociado IN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO recibe variable registro de tabla
  * @param Pv_TipoProceso      IN VARCHAR2                            recibe Tipo de proceso [I] Ingresar; [E] Eliminar
  * @param Pv_MensajeError     IN OUT VARCHAR2                        retorna mensaje de errores
  */
  type lstDocumentosAsociadosType is table of NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
  
  PROCEDURE P_PROCESA_MIGRA_DOC_ASOCIADO(Pr_MigraDocAsociado IN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE,
                                         Pv_TipoProceso      IN VARCHAR2,
                                         Pv_MensajeError     IN OUT VARCHAR2);
                                         
  /**
  * Documentacion para el procedimiento P_PROCESA_MIGRA_DOC_ASOC_MAS
  * Procedimiento que registra datso de documentos asociados TELCOS / NAF
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 03-08-2017
  *
  * @param Pr_MigraDocAsociado IN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO recibe variable registro de tabla
  * @param Pv_TipoProceso      IN VARCHAR2                            recibe Tipo de proceso [I] Ingresar; [E] Eliminar
  * @param Pv_MensajeError     IN OUT VARCHAR2                        retorna mensaje de errores
  */       
  PROCEDURE P_PROCESA_MIGRA_DOC_ASOC_MAS(Pr_MigraDocAsociado IN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE,
                                         Pv_TipoProceso      IN VARCHAR2,
                                         Pv_MensajeError     IN OUT VARCHAR2,
                                         Pv_EsProcesoMasivo  IN BOOLEAN DEFAULT FALSE,
                                         Pr_MigraDocAsociadoMas IN lstDocumentosAsociadosType default null);                                      

  /**
  * Documentacion para el procedimiento P_INSERTA_ARCCMD
  * Procedimiento que inserta en la tabla ARCCMD.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 21-08-2018
  */
  PROCEDURE P_INSERTA_ARCCMD(Pr_Arccmd  IN ARCCMD%ROWTYPE,
                             Pv_Salida  OUT VARCHAR2,
                             Pv_Mensaje OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_INSERTA_ARCCFPAGOS
  * Procedimiento que inserta en la tabla ARCCFPAGOS.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 21-08-2018
  */
  PROCEDURE P_INSERTA_ARCCFPAGOS(Pr_ARCCFPAGOS IN ARCCFPAGOS%ROWTYPE,
                                 Pv_Salida     OUT VARCHAR2,
                                 Pv_Mensaje    OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_INSERTA_ARCCRD
  * Procedimiento que inserta en la tabla ARCCRD.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_INSERTA_ARCCRD(Pr_ARCCRD  IN ARCCRD%ROWTYPE,
                             Pv_Salida  OUT VARCHAR2,
                             Pv_Mensaje OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_INSERTA_ARCCTI
  * Procedimiento que inserta en la tabla ARCCTI.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_INSERTA_ARCCTI(Pr_ARCCTI  IN ARCCTI%ROWTYPE,
                             Pv_Salida  OUT VARCHAR2,
                             Pv_Mensaje OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_INSERTA_ARCCDC
  * Procedimiento que inserta en la tabla ARCCDC.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_INSERTA_ARCCDC(Pr_ARCCDC  IN ARCCDC%ROWTYPE,
                             Pv_Salida  OUT VARCHAR2,
                             Pv_Mensaje OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_ACTUALIZA_ARCCMD
  * Procedimiento que actualizacion en la tabla ARCCMD.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_ACTUALIZA_ARCCMD(Pr_ARCCMD     IN ARCCMD%ROWTYPE,
                               Pv_formulario IN VARCHAR2,
                               Pv_Salida     OUT VARCHAR2,
                               Pv_Mensaje    OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_MIGRACION_CXC
  * Procedimiento main para sincronizacion de cuentas por cobrar.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 22-08-2018
  */

  PROCEDURE P_MIGRACION_CXC(Pv_NoCia                  IN Varchar2,
                            Pv_Centro                 IN Varchar2,
                            Pv_TipoDoc                IN Varchar2,
                            Pv_Fecha                  IN Varchar2,
                            Pv_Grupo                  IN Varchar2,
                            Pv_TipoIdentificacion     IN Varchar2,
                            Pv_NoIdentificacion       IN Varchar2,
                            Pv_DetalleCobro           IN Varchar2,
                            Pv_NoCobrador             IN Varchar2,
                            Pv_UsuarioCreacion        IN Varchar2,
                            Pv_RefFecha               IN Varchar2,
                            Pclob_ListFormaPago       IN Varchar2,
                            Pclob_ListReferencia      IN Varchar2,
                            Pclob_ListRetencion       IN Varchar2,
                            Pclob_ListDetalleContable IN Varchar2,
                            Pn_SaldoFactura           OUT VARCHAR2,
                            Pv_Salida                 OUT VARCHAR2,
                            Pv_Mensaje                OUT VARCHAR2 /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        Pn_SaldoFactura           OUT Number*/);

  /**
  * Documentacion para el procedimiento P_MIGRACION_CXC
  * Procedimiento main para sincronizacion de cuentas por cobrar.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_INSERTA_DIVIDENDO(Pr_Dividendo IN ARCCRD_DIVIDENDOS_MANUAL%ROWTYPE,
                                Pv_Salida    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento RHP_REGISTRA_HISTORICO_DE_REINGRESO
  * Procedimiento para el registro de reingreso de empleados
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 30-08-2022
  */
  PROCEDURE RHP_REGISTRA_HIST_DE_REINGRESO(Pv_NoCia   IN VARCHAR2,
                                           Pv_NoEmple IN VARCHAR2,
                                           Pv_Estado  IN VARCHAR2,
                                           PB_RHREMP  OUT BOOLEAN,
                                           Pv_Salida  OUT VARCHAR2,
                                           Pv_Mensaje OUT VARCHAR2);
end GEK_MIGRACION;
/

CREATE OR REPLACE package body NAF47_TNET.GEK_MIGRACION is

  PROCEDURE P_INSERTA_MIGRA_ARCGAE(Pr_MigraArcga   IN NAF47_TNET.MIGRA_ARCGAE%ROWTYPE,
                                   Pv_MensajeError OUT VARCHAR2) IS
    --
    Le_Error Exception;
    --
  BEGIN
    INSERT INTO NAF47_TNET.MIGRA_ARCGAE
      (NO_CIA,
       ID_MIGRACION,
       ANO,
       MES,
       NO_ASIENTO,
       FECHA,
       DESCRI1,
       T_DEBITOS,
       T_CREDITOS,
       COD_DIARIO,
       USUARIO_CREACION,
       FECHA_CREACION,
       ID_FORMA_PAGO,
       ID_OFICINA_FACTURACION,
       ORIGEN,
       TIPO_COMPROBANTE,
       TRANSFERIDO,
       IMPRESO,
       ESTADO,
       AUTORIZADO,
       T_CAMB_C_V,
       TIPO_CAMBIO,
       ANULADO)
    VALUES
      (Pr_MigraArcga.no_cia,
       Pr_MigraArcga.id_migracion,
       Pr_MigraArcga.ano,
       Pr_MigraArcga.mes,
       Pr_MigraArcga.no_asiento,
       TRUNC(Pr_MigraArcga.fecha),
       Pr_MigraArcga.descri1,
       Pr_MigraArcga.t_debitos,
       Pr_MigraArcga.t_creditos,
       Pr_MigraArcga.cod_diario,
       Pr_MigraArcga.usuario_creacion,
       SYSDATE,
       NVL(Pr_MigraArcga.id_forma_pago,0),
       Pr_MigraArcga.id_oficina_facturacion,
       Pr_MigraArcga.origen,
       NVL(Pr_MigraArcga.tipo_comprobante, 'T'),
       NVL(Pr_MigraArcga.transferido, 'N'),
       NVL(Pr_MigraArcga.impreso, 'N'),
       NVL(Pr_MigraArcga.estado, 'P'),
       NVL(Pr_MigraArcga.autorizado, 'N'),
       NVL(Pr_MigraArcga.t_camb_c_v, 'C'),
       NVL(Pr_MigraArcga.tipo_cambio, 1),
       NVL(Pr_MigraArcga.anulado, 'N'));

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_MIGRA_ARCGAE;

  PROCEDURE P_INSERTA_MIGRA_ARCGAL(Pr_MigraArcgal  IN NAF47_TNET.MIGRA_ARCGAL%ROWTYPE,
                                   Pv_MensajeError OUT VARCHAR2) IS
    --
    Le_Error EXCEPTION;
    --
  BEGIN

    INSERT INTO MIGRA_ARCGAL
      (NO_CIA,
       MIGRACION_ID,
       ANO,
       MES,
       NO_ASIENTO,
       NO_LINEA,
       CUENTA,
       DESCRI,
       COD_DIARIO,
       MONTO,
       MONTO_DOL,
       TIPO,
       CENTRO_COSTO,
       CC_1,
       CC_2,
       CC_3,
       MONEDA,
       TIPO_CAMBIO,
       LINEA_AJUSTE_PRECISION,
       TRANSFERIDO)
    VALUES
      (Pr_MigraArcgal.no_cia,
       Pr_MigraArcgal.migracion_id,
       Pr_MigraArcgal.ano,
       Pr_MigraArcgal.mes,
       Pr_MigraArcgal.no_asiento,
       Pr_MigraArcgal.no_linea,
       Pr_MigraArcgal.cuenta,
       Pr_MigraArcgal.descri,
       Pr_MigraArcgal.cod_diario,
       Pr_MigraArcgal.monto,
       Pr_MigraArcgal.monto_dol,
       Pr_MigraArcgal.tipo,
       Pr_MigraArcgal.centro_costo,
       Pr_MigraArcgal.cc_1,
       Pr_MigraArcgal.cc_2,
       Pr_MigraArcgal.cc_3,
       NVL(Pr_MigraArcgal.moneda, 'P'),
       NVL(Pr_MigraArcgal.tipo_cambio, 1),
       NVL(Pr_MigraArcgal.linea_ajuste_precision, 'N'),
       NVL(Pr_MigraArcgal.Transferido, 'N'));

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_MIGRA_ARCGAL;
  --
  PROCEDURE P_INSERTA_MIGRA_ARCGAE_MASIVO(Pr_MigraArcga   IN lstMigraArcgaeType,
                                          Pv_MensajeError OUT VARCHAR2) IS

  LE_ERROR EXCEPTION;

  BEGIN
    FORALL idx_ IN 1..Pr_MigraArcga.LAST
      INSERT INTO NAF47_TNET.MIGRA_ARCGAE
      (NO_CIA,
       ID_MIGRACION,
       ANO,
       MES,
       NO_ASIENTO,
       FECHA,
       DESCRI1,
       T_DEBITOS,
       T_CREDITOS,
       COD_DIARIO,
       USUARIO_CREACION,
       FECHA_CREACION,
       ID_FORMA_PAGO,
       ID_OFICINA_FACTURACION,
       ORIGEN,
       TIPO_COMPROBANTE,
       TRANSFERIDO,
       IMPRESO,
       ESTADO,
       AUTORIZADO,
       T_CAMB_C_V,
       TIPO_CAMBIO,
       ANULADO)
    VALUES
      (Pr_MigraArcga(idx_).no_cia,
       Pr_MigraArcga(idx_).id_migracion,
       Pr_MigraArcga(idx_).ano,
       Pr_MigraArcga(idx_).mes,
       Pr_MigraArcga(idx_).no_asiento,
       TRUNC(Pr_MigraArcga(idx_).fecha),
       Pr_MigraArcga(idx_).descri1,
       Pr_MigraArcga(idx_).t_debitos,
       Pr_MigraArcga(idx_).t_creditos,
       Pr_MigraArcga(idx_).cod_diario,
       Pr_MigraArcga(idx_).usuario_creacion,
       SYSDATE,
       NVL(Pr_MigraArcga(idx_).id_forma_pago,0),
       Pr_MigraArcga(idx_).id_oficina_facturacion,
       Pr_MigraArcga(idx_).origen,
       NVL(Pr_MigraArcga(idx_).tipo_comprobante, 'T'),
       NVL(Pr_MigraArcga(idx_).transferido, 'N'),
       NVL(Pr_MigraArcga(idx_).impreso, 'N'),
       NVL(Pr_MigraArcga(idx_).estado, 'P'),
       NVL(Pr_MigraArcga(idx_).autorizado, 'N'),
       NVL(Pr_MigraArcga(idx_).t_camb_c_v, 'C'),
       NVL(Pr_MigraArcga(idx_).tipo_cambio, 1),
       NVL(Pr_MigraArcga(idx_).anulado, 'N'));
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE_MASIVO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE_MASIVO: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE_MASIVO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_MIGRA_ARCGAE_MASIVO;
  --
  PROCEDURE P_INSERTA_MIGRA_ARCGAL_MASIVO(Pr_MigraArcga   IN lstMigraArcgalType,
                                          Pv_MensajeError OUT VARCHAR2) IS

  LE_ERROR EXCEPTION;

  BEGIN
    FORALL idx_ IN 1..Pr_MigraArcga.LAST
      INSERT INTO MIGRA_ARCGAL
      (NO_CIA,
       MIGRACION_ID,
       ANO,
       MES,
       NO_ASIENTO,
       NO_LINEA,
       CUENTA,
       DESCRI,
       COD_DIARIO,
       MONTO,
       MONTO_DOL,
       TIPO,
       CENTRO_COSTO,
       CC_1,
       CC_2,
       CC_3,
       MONEDA,
       TIPO_CAMBIO,
       LINEA_AJUSTE_PRECISION,
       TRANSFERIDO)
    VALUES
      (Pr_MigraArcga(idx_).no_cia,
       Pr_MigraArcga(idx_).migracion_id,
       Pr_MigraArcga(idx_).ano,
       Pr_MigraArcga(idx_).mes,
       Pr_MigraArcga(idx_).no_asiento,
       Pr_MigraArcga(idx_).no_linea,
       Pr_MigraArcga(idx_).cuenta,
       Pr_MigraArcga(idx_).descri,
       Pr_MigraArcga(idx_).cod_diario,
       Pr_MigraArcga(idx_).monto,
       Pr_MigraArcga(idx_).monto_dol,
       Pr_MigraArcga(idx_).tipo,
       Pr_MigraArcga(idx_).centro_costo,
       Pr_MigraArcga(idx_).cc_1,
       Pr_MigraArcga(idx_).cc_2,
       Pr_MigraArcga(idx_).cc_3,
       NVL(Pr_MigraArcga(idx_).moneda, 'P'),
       NVL(Pr_MigraArcga(idx_).tipo_cambio, 1),
       NVL(Pr_MigraArcga(idx_).linea_ajuste_precision, 'N'),
       NVL(Pr_MigraArcga(idx_).Transferido, 'N'));
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL_MASIVO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL_MASIVO: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL_MASIVO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_MIGRA_ARCGAL_MASIVO;
  --

  PROCEDURE P_INSERTA_MIGRA_ARCKMM(Pr_MigraArckmm  IN NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
                                   Pv_MensajeError OUT VARCHAR2) IS
    --
    Le_Error EXCEPTION;
    --
  BEGIN

    INSERT INTO MIGRA_ARCKMM
      (NO_CIA,
       ID_MIGRACION,
       NO_CTA,
       TIPO_DOC,
       NO_DOCU,
       FECHA,
       FECHA_DOC,
       COMENTARIO,
       MONTO,
       MES,
       ANO,
       USUARIO_CREACION,
       FECHA_CREACION,
       NO_FISICO,
       BENEFICIARIO,
       ID_FORMA_PAGO,
       ID_OFICINA_FACTURACION,
       ORIGEN,
       COD_DIARIO,
       ESTADO,
       CONCILIADO,
       PROCEDENCIA,
       IND_OTROMOV,
       MONEDA_CTA,
       IND_OTROS_MESES,
       IND_CON,
       SERIE_FISICO,
       PROCESADO,
       IND_DIVISION,
       TIPO_CAMBIO,
       T_CAMB_C_V)
    VALUES
      (Pr_MigraArckmm.no_cia,
       Pr_MigraArckmm.id_migracion,
       Pr_MigraArckmm.no_cta,
       Pr_MigraArckmm.tipo_doc,
       Pr_MigraArckmm.no_docu,
       TRUNC(Pr_MigraArckmm.fecha),
       TRUNC(Pr_MigraArckmm.fecha_doc),
       Pr_MigraArckmm.comentario,
       Pr_MigraArckmm.monto,
       Pr_MigraArckmm.mes,
       Pr_MigraArckmm.ano,
       Pr_MigraArckmm.usuario_creacion,
       SYSDATE,
       Pr_MigraArckmm.no_fisico,
       Pr_MigraArckmm.beneficiario,
       NVL(Pr_MigraArckmm.id_forma_pago,0),
       Pr_MigraArckmm.id_oficina_facturacion,
       Pr_MigraArckmm.origen,
       Pr_MigraArckmm.COD_DIARIO,
       NVL(Pr_MigraArckmm.estado, 'P'),
       NVL(Pr_MigraArckmm.conciliado, 'N'),
       NVL(Pr_MigraArckmm.procedencia, 'C'),
       NVL(Pr_MigraArckmm.ind_otromov, 'S'),
       NVL(Pr_MigraArckmm.moneda_cta, 'P'),
       NVL(Pr_MigraArckmm.ind_otros_meses, 'N'),
       NVL(Pr_MigraArckmm.ind_con, 'P'),
       NVL(Pr_MigraArckmm.serie_fisico, '0'),
       NVL(Pr_MigraArckmm.procesado, 'N'),
       NVL(Pr_MigraArckmm.ind_division, 'N'),
       NVL(Pr_MigraArckmm.tipo_cambio, 1),
       NVL(Pr_MigraArckmm.t_camb_c_v, 'C'));

  EXCEPTION
    WHEN Le_Error THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := Pr_MigraArckmm.no_cia || ' - ' ||
                         Pr_MigraArckmm.id_migracion ||
                         '. Error en GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
      ROLLBACK;
  END P_INSERTA_MIGRA_ARCKMM;

  PROCEDURE P_INSERTA_MIGRA_ARCKML(Pr_MigraArckml  IN NAF47_TNET.MIGRA_ARCKML%ROWTYPE,
                                   Pv_MensajeError OUT VARCHAR2) IS
    --
    CURSOR C_LINEA IS
      SELECT MAX(LINEA)
        FROM NAF47_TNET.MIGRA_ARCKML
       WHERE MIGRACION_ID = Pr_MigraArckml.Migracion_Id
         AND NO_CIA = Pr_MigraArckml.No_Cia;
    --
    Le_Error EXCEPTION;
    Ln_Linea NAF47_TNET.MIGRA_ARCKML.LINEA%TYPE := 0;
    --
  BEGIN
    --
    IF C_LINEA%ISOPEN THEN
      CLOSE C_LINEA;
    END IF;
    --
    OPEN C_LINEA;
    FETCH C_LINEA
      INTO Ln_Linea;
    IF C_LINEA%NOTFOUND THEN
      Ln_Linea := 0;
    END IF;
    CLOSE C_LINEA;
    --
    Ln_Linea := NVL(Ln_Linea, 0) + 1;
    --
    INSERT INTO NAF47_TNET.MIGRA_ARCKML
      (NO_CIA,
       MIGRACION_ID,
       LINEA,
       TIPO_DOC,
       NO_DOCU,
       COD_CONT,
       TIPO_MOV,
       MONTO,
       MONTO_DOL,
       MONTO_DC,
       GLOSA,
       ANO,
       MES,
       MODIFICABLE,
       COD_DIARIO,
       CENTRO_COSTO,
       PROCEDENCIA,
       TIPO_CAMBIO,
       MONEDA,
       IND_CON)
    values
      (Pr_MigraArckml.no_cia,
       Pr_MigraArckml.migracion_id,
       Ln_Linea,
       Pr_MigraArckml.tipo_doc,
       Pr_MigraArckml.no_docu,
       Pr_MigraArckml.cod_cont,
       Pr_MigraArckml.tipo_mov,
       Pr_MigraArckml.monto,
       Pr_MigraArckml.monto_dol,
       Pr_MigraArckml.monto_dc,
       Pr_MigraArckml.glosa,
       Pr_MigraArckml.ano,
       Pr_MigraArckml.mes,
       Pr_MigraArckml.modificable,
       Pr_MigraArckml.COD_DIARIO,
       NVL(Pr_MigraArckml.centro_costo, '000000000'),
       NVL(Pr_MigraArckml.procedencia, 'C'),
       NVL(Pr_MigraArckml.tipo_cambio, 1),
       NVL(Pr_MigraArckml.moneda, 'P'),
       NVL(Pr_MigraArckml.ind_con, 'P'));

  EXCEPTION
    WHEN Le_Error THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
      ROLLBACK;
  END P_INSERTA_MIGRA_ARCKML;

  PROCEDURE P_MIGRACION_CG(Pv_NoCia           IN Varchar2,
                           Pn_Anio            IN Number,
                           Pn_Mes             IN Number,
                           Pv_Fecha           IN Varchar2,
                           Pv_DescripcionCab  IN Varchar2,
                           Pn_TDebitos        IN Number,
                           Pn_TCreditos       IN Number,
                           Pv_UsuarioCreacion IN Varchar2,
                           Pclob_ListDistCont IN CLOB,
                           Pv_Salida          OUT VARCHAR2,
                           Pv_Mensaje         OUT VARCHAR2) IS

    Lx_xml          XMLTYPE;
    Lr_MigraArcgae  NAF47_TNET.MIGRA_ARCGAE%ROWTYPE;
    Lr_MigraArcgal  NAF47_TNET.MIGRA_ARCGAL%ROWTYPE;
    Lv_TipoDiario   ARCGCD.COD_DIARIO%TYPE := 'M_ROL';
    Ln_ContadorC    Number := 0;
    Ln_ContadorD    Number := 0;
    Ln_TotalC       Number := 0;
    Ln_TotalD       Number := 0;
    Lv_MensajeError Varchar2(500);

    Le_Error Exception;

  BEGIN
    Lr_MigraArcgae.Id_Migracion := TRANSA_ID.MIGRA_CG(Pv_NoCia);
    Lr_MigraArcgae.No_Asiento   := Lr_MigraArcgae.Id_Migracion;

    Lx_xml := XMLTYPE.createXML(Pclob_ListDistCont);
    IF Pn_TDebitos <= 0 OR Pn_TCreditos <= 0 THEN
      Lv_MensajeError := 'Los valores para Debito o Credito no pueden ser menor o igual a 0 ';
      RAISE Le_Error;
    ELSIF Pn_TDebitos <> Pn_TCreditos THEN
      Lv_MensajeError := 'Los valores para Debito o Credito no pueden ser diferentes';
      RAISE Le_Error;
    END IF;

    FOR C IN (SELECT montoCon, tipo
                FROM xmltable('//lineas' pASsing Lx_xml columns montoCon
                              VARCHAR2(100) PATH './montoCon',
                              tipo VARCHAR2(100) PATH './tipo')) LOOP

      IF C.tipo = 'C' THEN
        Ln_ContadorC := Ln_ContadorC + 1;
        Ln_TotalC    := Ln_TotalC + ABS(C.montoCon);
      ELSIF C.tipo = 'D' THEN
        Ln_ContadorD := Ln_ContadorD + 1;
        Ln_TotalD    := Ln_TotalD + C.montoCon;
      END IF;
    END LOOP;

    IF Ln_ContadorC > 0 AND Ln_ContadorD > 0 THEN
      IF Ln_TotalD = Pn_TDebitos AND Ln_TotalC = Pn_TCreditos THEN
        Lr_MigraArcgae.No_Cia           := Pv_NoCia;
        Lr_MigraArcgae.Ano              := Pn_Anio;
        Lr_MigraArcgae.Mes              := Pn_Mes;
        Lr_MigraArcgae.Fecha            := TO_DATE(TO_CHAR(TO_DATE(Pv_Fecha,
                                                                   'DD/MM/YYYY'),
                                                           'DD/MM') || '/' ||
                                                   Pn_Anio,
                                                   'DD/MM/YYYY');
        Lr_MigraArcgae.Descri1          := Pv_DescripcionCab;
        Lr_MigraArcgae.t_Debitos        := Pn_TDebitos;
        Lr_MigraArcgae.t_Creditos       := Pn_TCreditos;
        Lr_MigraArcgae.Cod_Diario       := Lv_TipoDiario;
        Lr_MigraArcgae.Usuario_Creacion := Pv_UsuarioCreacion;
        Lr_MigraArcgae.Origen           := 'WS';
        --
        P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae, Lv_MensajeError);
        --
        IF Lv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;

        Lr_MigraArcgal.No_Linea := 0;

        FOR C IN (SELECT cuenta,
                         descripcionDet,
                         montoCon,
                         centroCostoCon,
                         tipo
                    FROM xmltable('//lineas' pASsing Lx_xml columns cuenta
                                  VARCHAR2(100) PATH './cuenta',
                                  descripcionDet VARCHAR2(100) PATH
                                  './descripcionDet',
                                  montoCon VARCHAR2(100) PATH './montoCon',
                                  centroCostoCon VARCHAR2(100) PATH
                                  './centroCostoCon',
                                  tipo VARCHAR2(100) PATH './tipo')) LOOP
          Lr_MigraArcgal.No_Cia       := Lr_MigraArcgae.No_Cia;
          Lr_MigraArcgal.Migracion_Id := Lr_MigraArcgae.Id_Migracion;
          Lr_MigraArcgal.No_Asiento   := Lr_MigraArcgae.No_Asiento;
          Lr_MigraArcgal.No_Linea     := Lr_MigraArcgal.No_Linea + 1;
          Lr_MigraArcgal.Ano          := Lr_MigraArcgae.Ano;
          Lr_MigraArcgal.Mes          := Lr_MigraArcgae.Mes;
          Lr_MigraArcgal.Cod_Diario   := Lr_MigraArcgae.Cod_Diario;

          Lr_MigraArcgal.Cuenta       := c.cuenta;
          Lr_MigraArcgal.Descri       := c.descripcionDet;
          Lr_MigraArcgal.Monto        := c.montoCon;
          Lr_MigraArcgal.Centro_Costo := c.centroCostoCon;
          Lr_MigraArcgal.Cc_1         := NVL(SUBSTR(Lr_MigraArcgal.Centro_Costo,
                                                    1,
                                                    3),
                                             '000');
          Lr_MigraArcgal.Cc_2         := NVL(SUBSTR(Lr_MigraArcgal.Centro_Costo,
                                                    4,
                                                    3),
                                             '000');
          Lr_MigraArcgal.Cc_3         := NVL(SUBSTR(Lr_MigraArcgal.Centro_Costo,
                                                    7,
                                                    3),
                                             '000');
          Lr_MigraArcgal.Tipo         := c.tipo;
          --
          P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal, Lv_MensajeError);
          --
          IF Lv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
        END LOOP;
      ELSE
        Lv_MensajeError := 'Total Debito = ' || Ln_TotalD ||
                           ' total Credito = ' || Ln_TotalC ||
                           ' diferentes';
        RAISE Le_Error;
      END IF;
    ELSE
      Lv_MensajeError := 'Contador Debito = ' || Ln_ContadorD ||
                         ' contador Credito = ' || Ln_ContadorC ||
                         ' diferentes';
      RAISE Le_Error;
    END IF;
    Pv_Salida  := '200';
    Pv_Mensaje := 'Transaccion Realizada Correctamente';

  EXCEPTION
    WHEN LE_ERROR THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH',
                                           'GEK_MIGRACION.P_MIGRACION_CG',
                                           'LE_ERROR en P_MIGRACION_CG: ' ||
                                           Lv_MensajeError || ' ' ||
                                           SQLERRM,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               USER),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error en P_MIGRACION_CG: ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH',
                                           'GEK_MIGRACION.P_MIGRACION_CG',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               USER),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
  END P_MIGRACION_CG;

  PROCEDURE P_MIGRACION_CK(Pv_NoCia              IN Varchar2,
                           Pn_Anio               IN Number,
                           Pn_Mes                IN Number,
                           Pv_Fecha              IN Varchar2,
                           Pclob_ListTransaccion IN CLOB,
                           Pv_UsuarioCreacion    IN Varchar2,
                           Pv_Salida             OUT VARCHAR2,
                           Pv_Mensaje            OUT VARCHAR2) IS
    Lx_xml         XMLTYPE;
    Lr_MigraArckmm NAF47_TNET.MIGRA_ARCKMM%ROWTYPE;
    Lr_MigraArckml NAF47_TNET.MIGRA_ARCKML%ROWTYPE;
    --
    --Lv_NoDocu ARCKMM.NO_DOCU%TYPE;
    Lv_MensajeError Varchar2(500);
    Ld_Fecha        Date;
    Ln_ContadorC    Number := 0;
    Ln_ContadorD    Number := 0;
    Ln_TotalC       Number := 0;
    Ln_TotalD       Number := 0;

    Le_Error Exception;

  BEGIN

    Lx_xml   := XMLTYPE.createXML(Pclob_ListTransaccion);
    Ld_Fecha := TO_DATE(TO_CHAR(TO_DATE(Pv_Fecha, 'DD/MM/YYYY'), 'DD/MM') || '/' ||
                        Pn_Anio,
                        'DD/MM/YYYY');

    FOR C IN (SELECT noCta,
                     tipoDocu,
                     montoBanCab,
                     beneficiario,
                     comentario,
                     distribucionCon
                FROM xmltable('//cabecera' pASsing Lx_xml columns noCta
                              VARCHAR2(100) PATH './noCta',
                              tipoDocu VARCHAR2(100) PATH './tipoDocu',
                              montoBanCab VARCHAR2(100) PATH './montoBanCab',
                              beneficiario VARCHAR2(100) PATH
                              './beneficiario',
                              comentario VARCHAR2(100) PATH './comentario',
                              distribucionCon XMLTYPE PATH
                              './distribucionCon')) LOOP
      IF c.montoBanCab <= 0 THEN
        Lv_MensajeError := 'Los valores para Credito o Credito no pueden ser menor o igual a 0 ';
        RAISE Le_Error;
      END IF;
      -- Se asigna monto cabecera
      Lr_MigraArckmm.Monto := C.MontoBanCab;

      -- se recupera valores detalle para validar totales con monto cabecera
      FOR D IN (SELECT montoCon, tipo
                  FROM xmltable('//lineasCon' pASsing c.distribucionCon
                                columns montoCon VARCHAR2(100) PATH
                                './montoCon',
                                tipo VARCHAR2(100) PATH './tipo')) LOOP

        IF D.tipo = 'C' THEN
          Ln_ContadorC := Ln_ContadorC + 1;
          Ln_TotalC    := Ln_TotalC + ABS(D.montoCon);
        ELSIF D.tipo = 'D' THEN
          Ln_ContadorD := Ln_ContadorD + 1;
          Ln_TotalD    := Ln_TotalD + D.montoCon;
        END IF;
      END LOOP;

      -- si recupero registro de cabecera y detalle se procede a insetar
      IF Ln_ContadorC > 0 AND Ln_ContadorD > 0 THEN
        IF Ln_TotalD = Lr_MigraArckmm.Monto AND
           Ln_TotalC = Lr_MigraArckmm.Monto THEN
          Lr_MigraArckmm.No_Cia           := Pv_NoCia;
          Lr_MigraArckmm.No_Cta           := c.noCta;
          Lr_MigraArckmm.Tipo_Doc         := c.tipoDocu;
          Lr_MigraArckmm.Beneficiario     := c.beneficiario;
          Lr_MigraArckmm.Comentario       := c.comentario;
          Lr_MigraArckmm.Id_Migracion     := NAF47_TNET.TRANSA_ID.MIGRA_CK(Lr_MigraArckmm.No_Cia);
          Lr_MigraArckmm.No_Docu          := Lr_MigraArckmm.Id_Migracion;
          Lr_MigraArckmm.Ano              := Pn_Anio;
          Lr_MigraArckmm.Mes              := Pn_Mes;
          Lr_MigraArckmm.Fecha            := TO_DATE(TO_CHAR(Ld_Fecha,
                                                             'DD/MM') || '/' ||
                                                     Lr_MigraArckmm.Ano,
                                                     'DD/MM/YYYY');
          Lr_MigraArckmm.Fecha_Doc        := Lr_MigraArckmm.Fecha;
          Lr_MigraArckmm.Usuario_Creacion := Pv_UsuarioCreacion;
          Lr_MigraArckmm.Origen           := 'WS';
          Lr_MigraArckmm.Cod_Diario       := 'M_ROL';
          -- se inserta cabecera ck
          P_INSERTA_MIGRA_ARCKMM(Lr_MigraArckmm, Lv_MensajeError);
          --
          IF Lv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;

          -- se recuperan valores detalle
          FOR D IN (SELECT cuenta, montoCon, centroCostoCon, tipo
                      FROM xmltable('//lineasCon' pASsing c.distribucionCon
                                    columns cuenta VARCHAR2(100) PATH
                                    './cuenta',
                                    montoCon VARCHAR2(100) PATH './montoCon',
                                    centroCostoCon VARCHAR2(100) PATH
                                    './centroCostoCon',
                                    tipo VARCHAR2(100) PATH './tipo')) LOOP
            Lr_MigraArckml.No_Cia       := Lr_MigraArckmm.No_Cia;
            Lr_MigraArckml.Tipo_Doc     := Lr_MigraArckmm.Tipo_Doc;
            Lr_MigraArckml.Migracion_Id := Lr_MigraArckmm.Id_Migracion;
            Lr_MigraArckml.No_Docu      := Lr_MigraArckmm.No_Docu;
            Lr_MigraArckml.Ano          := Lr_MigraArckmm.Ano;
            Lr_MigraArckml.Mes          := Lr_MigraArckmm.Mes;
            Lr_MigraArckml.Cod_Cont     := d.cuenta;
            Lr_MigraArckml.Monto        := d.montoCon;
            Lr_MigraArckml.Monto_Dol    := Lr_MigraArckml.Monto;
            Lr_MigraArckml.Monto_Dc     := Lr_MigraArckml.Monto;
            Lr_MigraArckml.Centro_Costo := d.centroCostoCon;
            Lr_MigraArckml.Tipo_Mov     := d.tipo;
            Lr_MigraArckml.Glosa        := Lr_MigraArckmm.Comentario;
            Lr_MigraArckml.Modificable  := 'S';
            Lr_MigraArckml.Cod_Diario   := Lr_MigraArckmm.Cod_Diario;
            -- se inserta detalle
            P_INSERTA_MIGRA_ARCKML(Lr_MigraArckml, Lv_MensajeError);
            --
            IF Lv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
          END LOOP;
        ELSE
          Lv_MensajeError := 'Cabecera = ' || Lr_MigraArckmm.Monto ||
                             ' total Debito = ' || Ln_TotalD ||
                             ' total Credito = ' || Ln_TotalC ||
                             ' diferentes';
          RAISE Le_Error;
        END IF;
      ELSE
        Lv_MensajeError := 'Contador Debito = ' || Ln_ContadorD ||
                           ' contador Credito = ' || Ln_ContadorC ||
                           ' diferentes';
        RAISE Le_Error;
      END IF;
      Ln_ContadorC := 0;
      Ln_ContadorD := 0;
      Ln_TotalD    := 0;
      Ln_TotalC    := 0;

    END LOOP;
    Pv_Salida  := '200';
    Pv_Mensaje := 'Transaccion Realizada Correctamente';

  EXCEPTION
    WHEN LE_ERROR THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH',
                                           'GEK_MIGRACION.P_MIGRACION_CK',
                                           'LE_ERROR en P_MIGRACION_CK: ' ||
                                           ' - ' || Lv_MensajeError || ' ' ||
                                           SQLERRM,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               USER),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH',
                                           'GEK_MIGRACION.P_MIGRACION_CK',
                                           'Error en P_MIGRACION_CK: ' ||
                                           SQLERRM,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               USER),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
  END P_MIGRACION_CK;

  PROCEDURE P_MIGRACION_RH(Pv_NoCia               IN Varchar2,
                           Pv_NombrePila          IN Varchar2,
                           Pv_TipoIdentificacion  IN Varchar2,
                           Pv_Cedula              IN Varchar2,
                           Pv_Mail                IN Varchar2,
                           Pv_Telefono            IN Varchar2,
                           Pv_Celular             IN Varchar2,
                           Pv_Celular2            IN Varchar2,
                           Pv_Celular3            IN Varchar2,
                           Pv_NombreSegundo       IN Varchar2,
                           Pv_ApePat              IN Varchar2,
                           Pv_ApeMat              IN Varchar2,
                           Pv_Direccion           IN Varchar2,
                           Pv_Oficina             IN Varchar2,
                           Pv_FechaIngreso        IN Varchar2,
                           Pv_FechaEgreso         IN Varchar2,
                           Pv_FechaNacimiento     IN Varchar2,
                           Pv_Sexo                IN Varchar2,
                           Pv_Estado              IN Varchar2,
                           Pv_EstadoCivil         IN Varchar2,
                           Pv_Provincia           IN Varchar2,
                           Pv_Canton              IN Varchar2,
                           Pv_Area                IN Varchar2,
                           Pv_Departamento        IN Varchar2,
                           Pv_Puesto              IN Varchar2,
                           Pv_PuestoAnterior      IN Varchar2,
                           Pv_EsJefe              IN Varchar2,
                           Pv_Titulo              IN Varchar2,
                           Pv_TipoEmpleado        IN Varchar2,
                           Pv_CalleDireccion      IN Varchar2,
                           Pv_ProvinciaDireccion  IN Varchar2,
                           Pv_CantonDireccion     IN Varchar2,
                           Pn_Sueldo              IN Number,
                           Pv_PaisNacimiento      IN Varchar2,
                           Pv_ProvinciaNacimiento IN Varchar2,
                           Pv_CantonNacimiento    IN Varchar2,
                           Pn_AdelantoQuincenal   IN Number,
                           Pv_CuentaEmpresa       IN Varchar2,
                           Pv_FormaPago           IN Varchar2,
                           Pv_BancoEmpleado       IN Varchar2,
                           Pv_TipoCuenta          IN Varchar2,
                           Pv_NumeroCuenta        IN Varchar2,
                           Pv_CentroCosto         IN Varchar2,
                           Pv_NoCiaJefe           IN Varchar2,
                           Pv_IdJefe              IN Varchar2,
                           Pv_FormaPagoBcoEmp     IN Varchar2,
                           Pv_Banco               IN Varchar2,
                           Pclob_Foto             IN Clob,
                           Pv_Salida              OUT Varchar2,
                           Pv_Mensaje             OUT Varchar2) IS

    CURSOR C_EMPLEADO(Cv_NoCia Varchar2, Cv_Cedula Varchar2) IS
      SELECT NO_EMPLE
        FROM ARPLME
       WHERE CEDULA = Cv_Cedula
         AND NO_CIA = Cv_NoCia;

    CURSOR C_EMPLEADO_OLD(Cv_NoCia Varchar2, Cv_NoEmple Varchar2) IS
      SELECT NO_EMPLE, OFICINA, ESTADO, TITULO, AREA, DEPTO, ID_JEFE
        FROM ARPLME
       WHERE NO_CIA = Cv_NoCia
          AND NO_EMPLE = Cv_NoEmple;

    CURSOR C_PAIS(Cv_NoCia Varchar2) IS
      SELECT PAIS FROM ARPLMC WHERE NO_CIA = Cv_NoCia;

    CURSOR C_BANCO_EMPLE(Cv_Descripcion Varchar2, Cv_IdBanco Varchar2) IS
      SELECT CODIGO
        FROM GE_HOMOLOGACION_CODIGOS
       WHERE DESCRIPCION = Cv_Descripcion
         AND ID_BANCO = Cv_IdBanco;

    CURSOR C_PAISDESC(Cv_Pais Varchar2) IS
      SELECT PAIS
        FROM ARGEPAI
       WHERE UPPER(DESCRIPCION) =
             UPPER(TRANSLATE(Cv_Pais, 'AEIOU?aeiou', 'AEIOUNaeiou'));

    CURSOR C_PROVINCIADESC(Cv_Pais Varchar2, Cv_Provincia Varchar2) IS
      SELECT R.PROVINCIA
        FROM ARGEPRO R
       WHERE R.PAIS = Cv_Pais
         AND UPPER(R.DESCRIPCION) =
             UPPER(TRANSLATE(Cv_Provincia, 'AEIOU?aeiou', 'AEIOUNaeiou'));

    CURSOR C_PROVINCIA(Cv_Pais Varchar2, Cv_IdProvincia Varchar2) IS
      SELECT 'X'
        FROM ARGEPRO R
       WHERE R.PAIS = Cv_Pais
         AND R.PROVINCIA = Cv_IdProvincia;

    CURSOR C_CANTONDESC(Cv_Pais        Varchar2,
                        Cv_IdProvincia Varchar2,
                        Cv_Canton      Varchar2) IS
      SELECT CANTON
        FROM ARGECAN
       WHERE PAIS = Cv_Pais
         AND PROVINCIA = Cv_IdProvincia
         AND UPPER(DESCRIPCION) =
             UPPER(TRANSLATE(Cv_Canton, 'AEIOU?aeiou', 'AEIOUNaeiou'));

    CURSOR C_CANTON(Cv_Pais        Varchar2,
                    Cv_IdProvincia Varchar2,
                    Cv_IdCanton    Varchar2) IS
      SELECT 'X'
        FROM ARGECAN
       WHERE PAIS = Cv_Pais
         AND PROVINCIA = Cv_IdProvincia
         AND CANTON = Cv_IdCanton;

    CURSOR C_OFICINADESC(Cv_NoCia Varchar2) IS
      SELECT OFICINA
        FROM ARPLOFICINA
       WHERE NO_CIA = Cv_NoCia
         AND UPPER(NOMBRE_OFICINA) =
             UPPER(TRANSLATE(Pv_Oficina, 'AEIOU?aeiou', 'AEIOUNaeiou'));

    /*     CURSOR C_OFICINA (Cv_NoCia Varchar2,Cv_IdOficina Varchar2) IS
    SELECT 'X'
      FROM ARPLOFICINA
     WHERE NO_CIA  = Cv_NoCia
       AND OFICINA = Cv_IdOficina;*/

    CURSOR C_AREADESC IS
      SELECT AREA
        FROM ARPLAR
       WHERE NO_CIA = Pv_NoCia
         AND UPPER(DESCRI) =
             UPPER(TRANSLATE(Pv_Area, 'AEIOU?aeiou', 'AEIOUNaeiou'));

    CURSOR C_AREA(Cv_NoCia Varchar2, Cv_IdArea Varchar2) IS
      SELECT 'X'
        FROM ARPLAR
       WHERE NO_CIA = Cv_NoCia
         AND AREA = Cv_IdArea;

    CURSOR C_DEPARTAMENTODESC(Cv_NoCia Varchar2, Cv_IdArea Varchar2) IS
      SELECT DEPA
        FROM ARPLDP
       WHERE NO_CIA = Cv_NoCia
         AND AREA = Cv_IdArea
         AND UPPER(DESCRI) =
             UPPER(TRANSLATE(Pv_Departamento, 'AEIOU?aeiou', 'AEIOUNaeiou'));

    CURSOR C_DEPARTAMENTO(Cv_NoCia          Varchar2,
                          Cv_IdArea         Varchar2,
                          Cv_IdDepartamento Varchar2) IS
      SELECT 'X'
        FROM ARPLDP
       WHERE NO_CIA = Cv_NoCia
         AND AREA = Cv_IdArea
         AND DEPA = Cv_IdDepartamento;

    CURSOR C_PUESTODESC(Cv_NoCia Varchar2) IS
      SELECT PUESTO
        FROM ARPLMP
       WHERE NO_CIA = Cv_NoCia
         AND UPPER(DESCRI) =
             UPPER(TRANSLATE(Pv_Puesto, 'AEIOU?aeiou', 'AEIOUNaeiou'));

    CURSOR C_PUESTO(Cv_NoCia Varchar2, Cv_Puesto Varchar2) IS
      SELECT 'X'
        FROM ARPLMP
       WHERE NO_CIA = Cv_NoCia
         AND PUESTO = Cv_Puesto;

    CURSOR C_TITULODESC IS
      SELECT TITULO
        FROM ARPLTIT
       WHERE UPPER(DESCRIPCION) =
             UPPER(TRANSLATE(Pv_Titulo, 'AEIOU?aeiou', 'AEIOUNaeiou'));

    CURSOR C_TITULO(Cv_Titulo Varchar2) IS
      SELECT 'X' FROM ARPLTIT WHERE TITULO = Cv_Titulo;

    CURSOR C_TIPOEMPDESC(Cv_NoCia Varchar2) IS
      SELECT TIPO_EMP
        FROM ARPLTE
       WHERE NO_CIA = Cv_NoCia
         AND UPPER(DESCRIP) =
             UPPER(TRANSLATE(Pv_TipoEmpleado, 'AEIOU?aeiou', 'AEIOUNaeiou'));

    CURSOR C_TIPOEMP(Cv_NoCia Varchar2, Cv_TipoEmp Varchar2) IS
      SELECT 'X'
        FROM ARPLTE
       WHERE NO_CIA = Cv_NoCia
         AND TIPO_EMP = Cv_TipoEmp;

    CURSOR C_CUENTA_EMPRESA(Cv_NoCta     Varchar2,
                            Cv_NoCia     Varchar2,
                            Cv_FormaPago Varchar2,
                            Cv_Banco     Varchar2) IS
      SELECT ID_CTA
        FROM ARPLCB
       WHERE NO_CTA = Cv_NoCta
         AND NO_CIA = Cv_NoCia
         AND FORMA_PAGO = Cv_FormaPago
         AND BANCO = Cv_Banco;

    CURSOR C_CENTROCOSTO(Cv_NoCia Varchar2, Cv_DescriCc Varchar2) IS
      SELECT CENTRO
        FROM ARCGCECO
       WHERE NO_CIA = Cv_NoCia
         AND UPPER(DESCRIP_CC) = UPPER(Cv_DescriCc);

    Lv_Pais              Varchar2(3);
    Lv_PaisNacimi        Varchar2(3);
    Lv_NoEmple           ARPLME.NO_EMPLE%TYPE;
    Lv_CentroCosto       ARCGCECO.CENTRO%TYPE;
    Lv_IdCta             ARPLCB.ID_CTA%TYPE;
    Lv_NoEmpleJefe       ARPLME.NO_EMPLE%TYPE;
    Lv_IdProvincia       ARGEPRO.PROVINCIA%TYPE;
    Lv_IdProvinciaDirecc ARGEPRO.PROVINCIA%TYPE;
    Lv_IdProvinciaNacimi ARGEPRO.PROVINCIA%TYPE;
    Lv_IdCanton          ARGECAN.CANTON%TYPE;
    Lv_IdCantonDirecc    ARGECAN.CANTON%TYPE;
    Lv_IdCantonNacimi    ARGECAN.CANTON%TYPE;
    Lv_IdOficina         ARPLOFICINA.OFICINA%TYPE;
    Lv_IdArea            ARPLAR.AREA%TYPE;
    Lv_IdDepartamento    ARPLDP.DEPA%TYPE;
    Lv_Puesto            ARPLMP.PUESTO%TYPE;
    Lv_PuestoAnterior    ARPLMP.PUESTO%TYPE;
    Lv_Titulo            ARPLTIT.TITULO%TYPE;
    Lv_TipoEmpleado      ARPLTE.TIPO_EMP%TYPE;
    Lv_CodigoBcoEmple    GE_HOMOLOGACION_CODIGOS.CODIGO%TYPE;
    Lv_MensajeError      Varchar2(500);
    Lv_Salida            Varchar2(10);
    Lv_Mensaje           Varchar2(500);
    Lv_Existe            Varchar2(1);
    Lb_Nuevo             Boolean := FALSE;
    Lv_Entorno           Varchar2(50) := 'production';
    Lv_Status            VARCHAR2(4000) := NULL;
    Lv_Code              VARCHAR2(4000) := NULL;
    Lv_Msn               VARCHAR2(4000) := NULL;
    --Lv_RumCommand     Varchar2(32767);
    --Lv_Habil          Varchar2(1)    ;
    Lv_Ejecutar Varchar2(32767);
    Le_Error Exception;

    --
    Lr_ObtenerEmpleadoOld C_EMPLEADO_OLD%ROWTYPE;
    Lb_IsNew              Boolean:= NULL;
    --
  
  BEGIN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH',
                                         'GEK_MIGRACION.P_MIGRACION_RH',
                                         'BEGIN ',
                                         USER,
                                         SYSDATE,
                                         '127.0.0.1');

    VALIDA_IDENTIFICACION.VALIDA(Pv_TipoIdentificacion,
                                 Pv_Cedula,
                                 Lv_MensajeError);
    IF Lv_MensajeError IS NOT NULL THEN
      RAISE LE_ERROR;
    END IF;

    IF C_CENTROCOSTO%ISOPEN THEN
      CLOSE C_CENTROCOSTO;
    END IF;
    OPEN C_CENTROCOSTO(Pv_NoCia, Pv_CentroCosto);
    FETCH C_CENTROCOSTO
      INTO Lv_CentroCosto;
    IF C_CENTROCOSTO%NOTFOUND THEN
      Lv_MensajeError := 'Centro de costo  NO existe: ' || Pv_CentroCosto;
      RAISE Le_Error;
    END IF;

    CLOSE C_CENTROCOSTO;
    --
    IF C_PAIS%ISOPEN THEN
      CLOSE C_PAIS;
    END IF;
    OPEN C_PAIS(Pv_NoCia);
    FETCH C_PAIS
      INTO Lv_Pais;
    IF C_PAIS%NOTFOUND THEN
      Lv_MensajeError := 'Pais NO existe para empresa: ' || Pv_NoCia;
      RAISE Le_Error;
    END IF;
    CLOSE C_PAIS;
    --
    IF C_PROVINCIADESC%ISOPEN THEN
      CLOSE C_PROVINCIADESC;
    END IF;
    OPEN C_PROVINCIADESC(Lv_Pais, Pv_Provincia);
    FETCH C_PROVINCIADESC
      INTO Lv_IdProvincia;
    IF C_PROVINCIADESC%NOTFOUND THEN
      Lv_MensajeError := 'Provincia NO existe: ' || Pv_Provincia;
      RAISE Le_Error;
    END IF;
    CLOSE C_PROVINCIADESC;
    --
    IF C_PROVINCIA%ISOPEN THEN
      CLOSE C_PROVINCIA;
    END IF;
    OPEN C_PROVINCIA(Lv_Pais, Lv_IdProvincia);
    FETCH C_PROVINCIA
      INTO Lv_Existe;
    IF C_PROVINCIA%NOTFOUND THEN
      Lv_MensajeError := 'Id Provincia NO existe: ' || Pv_Provincia;
      RAISE Le_Error;
    END IF;
    CLOSE C_PROVINCIA;
    Lv_Existe := NULL;
    --
    IF C_CANTONDESC%ISOPEN THEN
      CLOSE C_CANTONDESC;
    END IF;
    OPEN C_CANTONDESC(Lv_Pais, Lv_IdProvincia, Pv_Canton);
    FETCH C_CANTONDESC
      INTO Lv_IdCanton;
    IF C_CANTONDESC%NOTFOUND THEN
      Lv_MensajeError := 'Canton NO existe: ' || Pv_Canton;
      RAISE Le_Error;
    END IF;
    CLOSE C_CANTONDESC;
    --
    IF C_CANTON%ISOPEN THEN
      CLOSE C_CANTON;
    END IF;
    OPEN C_CANTON(Lv_Pais, Lv_IdProvincia, Lv_IdCanton);
    FETCH C_CANTON
      INTO Lv_Existe;
    IF C_CANTON%NOTFOUND THEN
      Lv_MensajeError := 'Id Canton NO existe: ' || Pv_Canton;
      RAISE Le_Error;
    END IF;
    CLOSE C_CANTON;
    Lv_Existe := NULL;
    --
    --Direccion
    IF C_PROVINCIADESC%ISOPEN THEN
      CLOSE C_PROVINCIADESC;
    END IF;
    OPEN C_PROVINCIADESC(Lv_Pais, Pv_ProvinciaDireccion);
    FETCH C_PROVINCIADESC
      INTO Lv_IdProvinciaDirecc;
    IF C_PROVINCIADESC%NOTFOUND THEN
      Lv_MensajeError := 'Provincia NO existe: ' || Pv_ProvinciaDireccion;
      RAISE Le_Error;
    END IF;
    CLOSE C_PROVINCIADESC;
    --
    Lv_Existe := NULL;
    --
    IF C_CANTONDESC%ISOPEN THEN
      CLOSE C_CANTONDESC;
    END IF;
    OPEN C_CANTONDESC(Lv_Pais, Lv_IdProvinciaDirecc, Pv_CantonDireccion);
    FETCH C_CANTONDESC
      INTO Lv_IdCantonDirecc;
    IF C_CANTONDESC%NOTFOUND THEN
      Lv_MensajeError := 'Canton NO existe: ' || Pv_CantonDireccion;
      RAISE Le_Error;
    END IF;
    CLOSE C_CANTONDESC;
    --
    Lv_Existe := NULL;
    --
    --Direccion
    --Nacimiento

    IF C_PAISDESC%ISOPEN THEN
      CLOSE C_PAISDESC;
    END IF;
    OPEN C_PAISDESC(Pv_PaisNacimiento);
    FETCH C_PAISDESC
      INTO Lv_PaisNacimi;
    IF C_PAISDESC%NOTFOUND THEN
      Lv_MensajeError := 'Pais NO existe: ' || Pv_PaisNacimiento;
      RAISE Le_Error;
    END IF;
    CLOSE C_PAISDESC;

    IF C_PROVINCIADESC%ISOPEN THEN
      CLOSE C_PROVINCIADESC;
    END IF;
    OPEN C_PROVINCIADESC(Lv_Pais, Pv_ProvinciaNacimiento);
    FETCH C_PROVINCIADESC
      INTO Lv_IdProvinciaNacimi;
    IF C_PROVINCIADESC%NOTFOUND THEN
      Lv_MensajeError := 'Provincia NO existe: ' || Pv_ProvinciaNacimiento;
      RAISE Le_Error;
    END IF;
    CLOSE C_PROVINCIADESC;
    --
    Lv_Existe := NULL;
    --
    IF C_CANTONDESC%ISOPEN THEN
      CLOSE C_CANTONDESC;
    END IF;
    OPEN C_CANTONDESC(Lv_Pais, Lv_IdProvinciaNacimi, Pv_CantonNacimiento);
    FETCH C_CANTONDESC
      INTO Lv_IdCantonNacimi;
    IF C_CANTONDESC%NOTFOUND THEN
      Lv_MensajeError := 'Canton NO existe: ' || Pv_CantonNacimiento;
      RAISE Le_Error;
    END IF;
    CLOSE C_CANTONDESC;
    --
    Lv_Existe := NULL;
    --Nacimiento

    IF C_OFICINADESC%ISOPEN THEN
      CLOSE C_OFICINADESC;
    END IF;
    OPEN C_OFICINADESC(Pv_NoCia);
    FETCH C_OFICINADESC
      INTO Lv_IdOficina;
    IF C_OFICINADESC%NOTFOUND THEN
      Lv_MensajeError := 'Id Oficina NO existe: ' || Lv_IdOficina;
      RAISE Le_Error;
    END IF;
    CLOSE C_OFICINADESC;
    Lb_Nuevo := FALSE;

    Lv_Existe := NULL;
    --
    IF C_AREADESC%ISOPEN THEN
      CLOSE C_AREADESC;
    END IF;
    OPEN C_AREADESC;
    FETCH C_AREADESC
      INTO Lv_IdArea;
    IF C_AREADESC%NOTFOUND THEN
      INSERT INTO ARPLAR
        (NO_CIA, AREA, DESCRI)
      VALUES
        (Pv_NoCia,
         '0' || (SELECT MAX(TO_NUMBER(AREA)) + 1
                   FROM ARPLAR
                  WHERE NO_CIA = Pv_NoCia),
         Pv_Area);
      Lb_Nuevo := TRUE;
    END IF;
    CLOSE C_AREADESC;

    IF Lb_Nuevo = TRUE THEN
      IF C_AREADESC%ISOPEN THEN
        CLOSE C_AREADESC;
      END IF;
      OPEN C_AREADESC;
      FETCH C_AREADESC
        INTO Lv_IdArea;
      IF C_AREADESC%NOTFOUND THEN
        Lv_MensajeError := 'Area NO existe: ' || Pv_Area;
        RAISE Le_Error;
      END IF;
      CLOSE C_AREADESC;
    END IF;
    Lb_Nuevo := FALSE;
    --

    IF C_AREA%ISOPEN THEN
      CLOSE C_AREA;
    END IF;
    OPEN C_AREA(Pv_NoCia, Lv_IdArea);
    FETCH C_AREA
      INTO Lv_Existe;
    IF C_AREA%NOTFOUND THEN
      Lv_MensajeError := 'Id. Area NO existe: ' || Pv_Area;
      RAISE Le_Error;
    END IF;
    CLOSE C_AREA;
    Lv_Existe := NULL;
    --
    IF C_DEPARTAMENTODESC%ISOPEN THEN
      CLOSE C_DEPARTAMENTODESC;
    END IF;
    OPEN C_DEPARTAMENTODESC(Pv_NoCia, Lv_IdArea);
    FETCH C_DEPARTAMENTODESC
      INTO Lv_IdDepartamento;
    IF C_DEPARTAMENTODESC%NOTFOUND THEN
      INSERT INTO ARPLDP
        (NO_CIA, AREA, DEPA, DESCRI)
      VALUES
        (Pv_NoCia,
         Lv_IdArea,
         '0' || (SELECT MAX(TO_NUMBER(DEPA)) + 1
                   FROM ARPLDP
                  WHERE NO_CIA = Pv_NoCia
                    AND AREA = Lv_IdArea),
         Pv_Departamento);
      Lb_Nuevo := TRUE;
    END IF;
    CLOSE C_DEPARTAMENTODESC;

    IF Lb_Nuevo = TRUE THEN
      IF C_DEPARTAMENTODESC%ISOPEN THEN
        CLOSE C_DEPARTAMENTODESC;
      END IF;
      OPEN C_DEPARTAMENTODESC(Pv_NoCia, Lv_IdArea);
      FETCH C_DEPARTAMENTODESC
        INTO Lv_IdDepartamento;
      IF C_DEPARTAMENTODESC%NOTFOUND THEN
        Lv_MensajeError := 'Id Departamento NO existe:' || Pv_Departamento;
        RAISE Le_Error;
      END IF;
      CLOSE C_DEPARTAMENTODESC;
    END IF;
    Lb_Nuevo := FALSE;
    --
    IF C_DEPARTAMENTO%ISOPEN THEN
      CLOSE C_DEPARTAMENTO;
    END IF;
    OPEN C_DEPARTAMENTO(Pv_NoCia, Lv_IdArea, Lv_IdDepartamento);
    FETCH C_DEPARTAMENTO
      INTO Lv_Existe;
    IF C_DEPARTAMENTO%NOTFOUND THEN
      Lv_MensajeError := 'Departamento NO existe:' || Pv_Departamento;
      RAISE Le_Error;
    END IF;
    CLOSE C_DEPARTAMENTO;
    Lv_Existe := NULL;
    --
    IF C_PUESTODESC%ISOPEN THEN
      CLOSE C_PUESTODESC;
    END IF;
    OPEN C_PUESTODESC(Pv_NoCia);
    FETCH C_PUESTODESC
      INTO Lv_Puesto;
    IF C_PUESTODESC%NOTFOUND THEN
      INSERT INTO ARPLMP
        (NO_CIA, PUESTO, DESCRI, JEFE)
      VALUES
        (Pv_NoCia, SEQ_ARPLMP.NEXTVAL, Pv_Puesto, Pv_EsJefe);
      Lb_Nuevo := TRUE;
    END IF;
    CLOSE C_PUESTODESC;

    IF Lb_Nuevo = TRUE THEN
      IF C_PUESTODESC%ISOPEN THEN
        CLOSE C_PUESTODESC;
      END IF;
      OPEN C_PUESTODESC(Pv_NoCia);
      FETCH C_PUESTODESC
        INTO Lv_Puesto;
      IF C_PUESTODESC%NOTFOUND THEN
        Lv_MensajeError := 'Puesto NO existe: ' || Pv_Puesto;
        RAISE Le_Error;
      END IF;
      CLOSE C_PUESTODESC;
    END IF;
    Lb_Nuevo := FALSE;
    --
    IF C_PUESTO%ISOPEN THEN
      CLOSE C_PUESTO;
    END IF;
    OPEN C_PUESTO(Pv_NoCia, Lv_Puesto);
    FETCH C_PUESTO
      INTO Lv_Existe;
    IF C_PUESTO%NOTFOUND THEN
      Lv_MensajeError := 'Id. Puesto NO existe: ' || Pv_Puesto;
      RAISE Le_Error;
    END IF;
    CLOSE C_PUESTO;
    Lv_Existe := NULL;
    --
    IF C_TITULODESC%ISOPEN THEN
      CLOSE C_TITULODESC;
    END IF;
    OPEN C_TITULODESC;
    FETCH C_TITULODESC
      INTO Lv_Titulo;
    IF C_TITULODESC%NOTFOUND THEN
      INSERT INTO ARPLTIT
        (TITULO, DESCRIPCION)
      VALUES
        ((SELECT MAX(TO_NUMBER(TITULO)) + 1 FROM ARPLTIT), Pv_Titulo);
      Lb_Nuevo := TRUE;
    END IF;
    CLOSE C_TITULODESC;

    IF Lb_Nuevo = TRUE THEN
      IF C_TITULODESC%ISOPEN THEN
        CLOSE C_TITULODESC;
      END IF;
      OPEN C_TITULODESC;
      FETCH C_TITULODESC
        INTO Lv_Titulo;
      IF C_TITULODESC%NOTFOUND THEN
        Lv_MensajeError := 'Titulo NO existe: ' || Pv_Titulo;
        RAISE Le_Error;
      END IF;
      CLOSE C_TITULODESC;
    END IF;
    Lb_Nuevo := FALSE;

    IF C_TITULO%ISOPEN THEN
      CLOSE C_TITULO;
    END IF;
    OPEN C_TITULO(Lv_Titulo);
    FETCH C_TITULO
      INTO Lv_Existe;
    IF C_TITULO%NOTFOUND THEN
      Lv_MensajeError := 'Id. Titulo NO existe: ' || Pv_Titulo;
      RAISE Le_Error;
    END IF;
    CLOSE C_TITULO;
    Lv_Existe := NULL;
    --
    IF C_TIPOEMPDESC%ISOPEN THEN
      CLOSE C_TIPOEMPDESC;
    END IF;
    OPEN C_TIPOEMPDESC(Pv_NoCia);
    FETCH C_TIPOEMPDESC
      INTO Lv_TipoEmpleado;
    IF C_TIPOEMPDESC%NOTFOUND THEN
      INSERT INTO ARPLTE
        (NO_CIA, TIPO_EMP, JORNADA, ES_TRABAJADOR)
      VALUES
        (Pv_NoCia,
         '0' || (SELECT MAX(TO_NUMBER(TIPO_EMP)) + 1
                   FROM ARPLTE
                  WHERE NO_CIA = Pv_NoCia),
         'M',
         'S');
    END IF;
    CLOSE C_TIPOEMPDESC;

    IF Lb_Nuevo = TRUE THEN
      IF C_TIPOEMPDESC%ISOPEN THEN
        CLOSE C_TIPOEMPDESC;
      END IF;
      OPEN C_TIPOEMPDESC(Pv_NoCia);
      FETCH C_TIPOEMPDESC
        INTO Lv_TipoEmpleado;
      IF C_TIPOEMPDESC%NOTFOUND THEN
        Lv_MensajeError := 'Tipo Empleado NO existe: ' || Pv_TipoEmpleado;
        RAISE Le_Error;
      END IF;
      CLOSE C_TIPOEMPDESC;
    END IF;

    IF C_TIPOEMP%ISOPEN THEN
      CLOSE C_TIPOEMP;
    END IF;
    OPEN C_TIPOEMP(Pv_NoCia, Lv_TipoEmpleado);
    FETCH C_TIPOEMP
      INTO Lv_Existe;
    IF C_TIPOEMP%NOTFOUND THEN
      Lv_MensajeError := 'Id. Tipo Empleado NO existe: ' || Pv_TipoEmpleado;
      RAISE Le_Error;
    END IF;
    CLOSE C_TIPOEMP;
    Lv_Existe := NULL;

    IF C_BANCO_EMPLE %ISOPEN THEN
      CLOSE C_TIPOEMP;
    END IF;
    OPEN C_BANCO_EMPLE(Pv_BancoEmpleado, Pv_Banco);
    FETCH C_BANCO_EMPLE
      INTO Lv_CodigoBcoEmple;
    IF C_BANCO_EMPLE %NOTFOUND THEN
      Lv_CodigoBcoEmple := NULL;
    END IF;
    CLOSE C_BANCO_EMPLE;

    IF C_EMPLEADO%ISOPEN THEN
      CLOSE C_EMPLEADO;
    END IF;
    OPEN C_EMPLEADO(Pv_NoCiaJefe, Pv_IdJefe);
    FETCH C_EMPLEADO
      INTO Lv_NoEmpleJefe;
    IF C_EMPLEADO %NOTFOUND THEN
      Lv_MensajeError := 'Jefe del empleado NO existe: ' || Pv_IdJefe;
      RAISE Le_Error;
    END IF;
    CLOSE C_EMPLEADO;

    IF C_CUENTA_EMPRESA %ISOPEN THEN
      CLOSE C_CUENTA_EMPRESA;
    END IF;
    OPEN C_CUENTA_EMPRESA(Pv_CuentaEmpresa,
                          Pv_NoCia,
                          Pv_FormaPagoBcoEmp,
                          Pv_Banco);
    FETCH C_CUENTA_EMPRESA
      INTO Lv_IdCta;
    IF C_CUENTA_EMPRESA %NOTFOUND THEN
      Lv_MensajeError := 'Cuenta Bancaria de Empresa no Existe: ' || ' ' ||
                         Pv_CuentaEmpresa || ' ' || Pv_FormaPagoBcoEmp || ' ' ||
                         Pv_Banco;
      RAISE Le_Error;
    END IF;
    CLOSE C_CUENTA_EMPRESA;

    IF C_EMPLEADO%ISOPEN THEN
      CLOSE C_EMPLEADO;
    END IF;
    OPEN C_EMPLEADO(Pv_NoCia, Pv_Cedula);
    FETCH C_EMPLEADO
      INTO Lv_NoEmple;
    IF C_EMPLEADO%NOTFOUND THEN
      Lb_IsNew:=TRUE;
      RHP_INSERTA_ARPLME(Pv_NoCia,
                         gek_consulta.gef_elimina_caracter_esp(Pv_NombrePila),
                         Pv_Cedula,
                         Pv_Mail,
                         Pv_Telefono,
                         Pv_Celular,
                         Pv_Celular2,
                         Pv_Celular3,
                         gek_consulta.gef_elimina_caracter_esp(Pv_NombreSegundo),
                         gek_consulta.gef_elimina_caracter_esp(Pv_ApePat),
                         gek_consulta.gef_elimina_caracter_esp(Pv_ApeMat),
                         Pv_Direccion,
                         Lv_IdOficina,
                         Pv_FechaIngreso,
                         Pv_FechaNacimiento,
                         Pv_Sexo,
                         Pv_Estado,
                         Pv_EstadoCivil,
                         Lv_IdProvincia,
                         Lv_IdCanton,
                         Lv_IdArea,
                         Lv_IdDepartamento,
                         Lv_Puesto,
                         Lv_Titulo,
                         Lv_TipoEmpleado,
                         Pv_CalleDireccion,
                         Lv_IdProvinciaDirecc,
                         Lv_IdCantonDirecc,
                         Pn_Sueldo,
                         Lv_PaisNacimi,
                         Lv_IdProvinciaNacimi,
                         Lv_IdCantonNacimi,
                         Pn_AdelantoQuincenal,
                         Lv_IdCta,
                         Pv_FormaPago,
                         Lv_CodigoBcoEmple,
                         Pv_TipoCuenta,
                         Pv_NumeroCuenta,
                         Lv_CentroCosto,
                         Pv_NoCiaJefe,
                         Lv_NoEmpleJefe,
                         Pv_TipoIdentificacion,
                         Pclob_Foto,
                         /*                                Pv_FormaPagoBcoEmp,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Pv_Banco,*/
                         Lv_NoEmple,
                         Lv_Salida,
                         Lv_Mensaje);
      IF Lv_Salida IS NOT NULL OR Lv_Mensaje IS NOT NULL THEN
        Lv_MensajeError := Lv_Mensaje;
        RAISE LE_ERROR;
      END IF;
    ELSE
      Lb_IsNew:=FALSE;

      IF C_EMPLEADO_OLD%ISOPEN THEN
        CLOSE C_EMPLEADO_OLD;
      END IF;
      OPEN C_EMPLEADO_OLD(Pv_NoCia, Lv_NoEmple);
      FETCH C_EMPLEADO_OLD INTO Lr_ObtenerEmpleadoOld;
      CLOSE C_EMPLEADO_OLD;

      RHP_ACTUALIZA_ARPLME(Pv_NoCia,
                           Lv_NoEmple,
                           gek_consulta.gef_elimina_caracter_esp(Pv_NombrePila),
                           Pv_Telefono,
                           Pv_Celular,
                           Pv_Celular2,
                           Pv_Celular3,
                           gek_consulta.gef_elimina_caracter_esp(Pv_NombreSegundo),
                           gek_consulta.gef_elimina_caracter_esp(Pv_ApePat),
                           gek_consulta.gef_elimina_caracter_esp(Pv_ApeMat),
                           Pv_Direccion,
                           Lv_IdOficina,
                           Pv_FechaIngreso,
                           Pv_FechaEgreso,
                           Pv_Estado,
                           Pv_EstadoCivil,
                           Lv_IdProvincia,
                           Lv_IdCanton,
                           Lv_IdArea,
                           Lv_IdDepartamento,
                           Lv_Puesto,
                           Lv_PuestoAnterior,
                           Lv_Titulo,
                           Lv_TipoEmpleado,
                           Pv_CalleDireccion,
                           Lv_IdProvinciaDirecc,
                           Lv_IdCantonDirecc,
                           Pn_Sueldo,
                           Lv_PaisNacimi,
                           Lv_IdProvinciaNacimi,
                           Lv_IdCantonNacimi,
                           Pn_AdelantoQuincenal,
                           Lv_IdCta,
                           Pv_FormaPago,
                           Lv_CodigoBcoEmple,
                           Pv_TipoCuenta,
                           Pv_NumeroCuenta,
                           Lv_CentroCosto,
                           Pv_NoCiaJefe,
                           Lv_NoEmpleJefe,
                           Pclob_Foto,
                           /* Pv_FormaPagoBcoEmp,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Pv_Banco,     */
                           Lv_Salida,
                           Lv_Mensaje);

      IF Lv_Salida IS NOT NULL OR Lv_Mensaje IS NOT NULL THEN
        Lv_MensajeError := Lv_Mensaje;
        RAISE LE_ERROR;
      END IF;
    END IF;
    COMMIT;
    CLOSE C_EMPLEADO;

     IF 'S' = RHKG_SINCRONIZAR_EMPLEADO.F_GET_PARAM('NEW_SYNC') THEN

      RHKG_SINCRONIZAR_EMPLEADO.P_SINCRIONIZACION_EMPLEADO(Lv_NoEmple,
                                                           Pv_NoCia,
                                                           Lv_Status,
                                                           Lv_Code,
                                                           Lv_Msn);
      IF Lv_Status <> 'GENERATED' THEN
        Lv_MensajeError := 'Error Status: ' || Lv_Status;
        RAISE LE_ERROR;
      END IF;
    ELSE

      Lv_Ejecutar := javaruncommand('/opt/ibm-java-ppc64-71/jre/bin/java -Denviroment=' ||
                                    Lv_Entorno ||
                                    ' -jar /home/oracle/scripts/ssosync-1.1.jar ' ||
                                    Pv_NoCia || ' ' || Lv_NoEmple);
    END IF;

    Pv_Salida  := '200';
    Pv_Mensaje := 'Transaccion Realizada Correctamente';

    BEGIN
      IF Lb_IsNew = TRUE THEN
        NAF47_TNET.RHKG_CONSULTA.P_NOTIFICACION_EMPLOYEE(Lv_NoEmple,Pv_NoCia,'NEW');
      ELSE
        IF(Lr_ObtenerEmpleadoOld.OFICINA <> Lv_IdOficina OR Lr_ObtenerEmpleadoOld.ESTADO <> Pv_Estado OR Lr_ObtenerEmpleadoOld.TITULO <> Lv_Titulo OR 
          Lr_ObtenerEmpleadoOld.AREA <> Lv_IdArea OR Lr_ObtenerEmpleadoOld.DEPTO <> Lv_IdDepartamento OR Lr_ObtenerEmpleadoOld.ID_JEFE <> Lv_NoEmpleJefe) THEN
            NAF47_TNET.RHKG_CONSULTA.P_NOTIFICACION_EMPLOYEE(Lv_NoEmple,Pv_NoCia,'UPDATE');
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Oracle-WebService-TelcoU',
                                             'GEK_MIGRACION.P_MIGRACION_RH',
                                             'Error en P_MIGRACION_RH: ' || SQLERRM || ' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                             NVL(SYS_CONTEXT('USERENV','HOST'),USER),
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
    END;
    
  EXCEPTION
    WHEN LE_ERROR THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error: ' || Lv_MensajeError;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH',
                                           'GEK_MIGRACION.P_MIGRACION_RH',
                                           'LE_ERROR en P_MIGRACION_RH: ' ||
                                           ' - ' || Lv_MensajeError || ' ' ||
                                           SQLERRM || ' ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               USER),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH',
                                           'GEK_MIGRACION.P_MIGRACION_RH',
                                           'Error en P_MIGRACION_RH: ' ||
                                           SQLERRM || ' ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               USER),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
  END P_MIGRACION_RH;

  PROCEDURE RHP_INSERTA_ARPLME(Pv_NoCia               IN Varchar2,
                               Pv_NombrePila          IN Varchar2,
                               Pv_Cedula              IN Varchar2,
                               Pv_Mail                IN Varchar2,
                               Pv_Telefono            IN Varchar2,
                               Pv_Celular             IN Varchar2,
                               Pv_Celular2            IN Varchar2,
                               Pv_Celular3            IN Varchar2,
                               Pv_NombreSegundo       IN Varchar2,
                               Pv_ApePat              IN Varchar2,
                               Pv_ApeMat              IN Varchar2,
                               Pv_Direccion           IN Varchar2,
                               Pv_Oficina             IN Varchar2,
                               Pv_FechaIngreso        IN Varchar2,
                               Pv_FechaNacimiento     IN Varchar2,
                               Pv_Sexo                IN Varchar2,
                               Pv_Estado              IN Varchar2,
                               Pv_EstadoCivil         IN Varchar2,
                               Pv_IdProvincia         IN Varchar2,
                               Pv_IdCanton            IN Varchar2,
                               Pv_IdArea              IN Varchar2,
                               Pv_IdDepartamento      IN Varchar2,
                               Pv_Puesto              IN Varchar2,
                               Pv_Titulo              IN Varchar2,
                               Pv_TipoEmpleado        IN Varchar2,
                               Pv_CalleDireccion      IN Varchar2,
                               Pv_ProvinciaDireccion  IN Varchar2,
                               Pv_CantonDireccion     IN Varchar2,
                               Pn_Sueldo              IN Number,
                               Pv_PaisNacimiento      IN Varchar2,
                               Pv_ProvinciaNacimiento IN Varchar2,
                               Pv_CantonNacimiento    IN Varchar2,
                               Pn_AdelantoQuincenal   IN Number,
                               Pv_CuentaEmpresa       IN Varchar2,
                               Pv_FormaPago           IN Varchar2,
                               Pv_BancoEmpleado       IN Varchar2,
                               Pv_TipoCuenta          IN Varchar2,
                               Pv_NumeroCuenta        IN Varchar2,
                               Pv_CentroCosto         IN Varchar2,
                               Pv_NoCiaJefe           IN Varchar2,
                               Pv_IdJefe              IN Varchar2,
                               Pv_TipoIdentificacion  IN Varchar2,
                               Pclob_Foto             IN Clob,
                               /* Pv_FormaPagoBcoEmp  IN Varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Pv_Banco            IN Varchar2,*/
                               Pv_NoEmple OUT Varchar2,
                               Pv_Salida  OUT Varchar2,
                               Pv_Mensaje OUT Varchar2) IS

    CURSOR C_NO_EMPLE IS
      SELECT NO_EMPLE
        FROM ARPLME
       WHERE NO_CIA = Pv_NoCia
         AND CEDULA = Pv_Cedula;

    Lv_MensajeError Varchar2(500);
    LE_ERROR Exception;

  BEGIN

    INSERT INTO ARPLME
      (NO_CIA,
       NO_EMPLE,
       TIPO_EMP,
       NOMBRE,
       NOMBRE_PILA,
       NOMBRE_SEGUNDO,
       APE_PAT,
       APE_MAT,
       ESTADO,
       CEDULA,
       MAIL,
       TELEFONO,
       CELULAR,
       CELULAR2,
       CELULAR3,
       DIRECCION,
       OFICINA,
       F_INGRESO,
       F_NACIMI,
       SEXO,
       E_CIVIL,
       ID_PROVINCIA,
       ID_REGION_PATRONAL,
       AREA,
       DEPTO,
       PUESTO,
       TITULO,
       CALLE,
       ID_PROVINCIA_DIREC,
       ID_CIUDAD_DIREC,
       SAL_BAS,
       PAIS_NACIMIENTO,
       PROVIN_NACIMIENTO,
       CANTON_NACIMIENTO,
       PORC_ADELANTO,
       ID_CTA,
       FORMA_PAGO,
       ID_OTRO_BANCO,
       TIPO_CTA,
       NUM_CUENTA,
       CENTRO_COSTO,
       NO_CIA_JEFE,
       ID_JEFE,
       ESTADO_PROP,
       Tipo_Id_Tributario,
       Foto)

    VALUES
      (Pv_NoCia,
       (SELECT NVL(MAX(TO_NUMBER(NO_EMPLE)), 0) + 1
          FROM ARPLME
         WHERE NO_CIA = Pv_NoCia),
       Pv_TipoEmpleado,
       Pv_ApePat || ' ' || Pv_ApeMat || ' ' || Pv_NombrePila || ' ' ||
       Pv_NombreSegundo,
       Pv_NombrePila,
       Pv_NombreSegundo,
       Pv_ApePat,
       Pv_ApeMat,
       Pv_Estado,
       Pv_Cedula,
       Pv_Mail,
       Pv_Telefono,
       Pv_Celular,
       Pv_Celular2,
       Pv_Celular3,
       Pv_Direccion,
       Pv_Oficina,
       To_Date(Pv_FechaIngreso, 'dd/mm/yyyy'),
       To_Date(Pv_FechaNacimiento, 'dd/mm/yyyy'),
       Pv_Sexo,
       Pv_EstadoCivil,
       Pv_IdProvincia,
       Pv_IdCanton,
       Pv_IdArea,
       Pv_IdDepartamento,
       Pv_Puesto,
       Pv_Titulo,
       Pv_CalleDireccion,
       Pv_ProvinciaDireccion,
       Pv_CantonDireccion,
       Pn_Sueldo,
       Pv_PaisNacimiento,
       Pv_ProvinciaNacimiento,
       Pv_CantonNacimiento,
       Pn_AdelantoQuincenal,
       Pv_CuentaEmpresa,
       Pv_FormaPago,
       Pv_BancoEmpleado,
       Pv_TipoCuenta,
       Pv_NumeroCuenta,
       Pv_CentroCosto,
       Pv_NoCiaJefe,
       Pv_IdJefe,
       Pv_Estado,
       Pv_TipoIdentificacion,
       Pclob_Foto);

    IF C_NO_EMPLE%ISOPEN THEN
      CLOSE C_NO_EMPLE;
    END IF;
    OPEN C_NO_EMPLE;
    FETCH C_NO_EMPLE
      INTO Pv_NoEmple;
    IF C_NO_EMPLE%NOTFOUND THEN
      Lv_MensajeError := 'Empleado: ' || Pv_Cedula || ' Compania: ' ||
                         Pv_NoCia || ' no existe';
      Raise LE_ERROR;
    END IF;
    CLOSE C_NO_EMPLE;

  EXCEPTION
    WHEN LE_ERROR THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error';
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH',
                                           'GEK_MIGRACION.RHP_INSERTA_ARPLME',
                                           'LE_ERROR en RHP_INSERTA_ARPLME: ' ||
                                           ' - ' || Lv_MensajeError || ' ' ||
                                           SQLERRM || ' ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               USER),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error';
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH',
                                           'GEK_MIGRACION.RHP_INSERTA_ARPLME',
                                           'Error en RHP_INSERTA_ARPLME: ' ||
                                           SQLERRM || ' ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               USER),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END RHP_INSERTA_ARPLME;

  PROCEDURE RHP_ACTUALIZA_ARPLME(Pv_NoCia               IN Varchar2,
                                 Pv_NoEmple             IN Varchar2,
                                 Pv_NombrePila          IN Varchar2,
                                 Pv_Telefono            IN Varchar2,
                                 Pv_Celular             IN Varchar2,
                                 Pv_Celular2            IN Varchar2,
                                 Pv_Celular3            IN Varchar2,
                                 Pv_NombreSegundo       IN Varchar2,
                                 Pv_ApePat              IN Varchar2,
                                 Pv_ApeMat              IN Varchar2,
                                 Pv_Direccion           IN Varchar2,
                                 Pv_Oficina             IN Varchar2,
                                 Pv_FechaIngreso        IN Varchar2,
                                 Pv_FechaEgreso         IN Varchar2,
                                 Pv_Estado              IN Varchar2,
                                 Pv_EstadoCivil         IN Varchar2,
                                 Pv_IdProvincia         IN Varchar2,
                                 Pv_IdCanton            IN Varchar2,
                                 Pv_IdArea              IN Varchar2,
                                 Pv_IdDepartamento      IN Varchar2,
                                 Pv_Puesto              IN Varchar2,
                                 Pv_PuestoAnterior      IN Varchar2,
                                 Pv_Titulo              IN Varchar2,
                                 Pv_TipoEmpleado        IN Varchar2,
                                 Pv_CalleDireccion      IN Varchar2,
                                 Pv_ProvinciaDireccion  IN Varchar2,
                                 Pv_CantonDireccion     IN Varchar2,
                                 Pn_Sueldo              IN Number,
                                 Pv_PaisNacimiento      IN Varchar2,
                                 Pv_ProvinciaNacimiento IN Varchar2,
                                 Pv_CantonNacimiento    IN Varchar2,
                                 Pn_AdelantoQuincenal   IN Number,
                                 Pv_CuentaEmpresa       IN Varchar2,
                                 Pv_FormaPago           IN Varchar2,
                                 Pv_BancoEmpleado       IN Varchar2,
                                 Pv_TipoCuenta          IN Varchar2,
                                 Pv_NumeroCuenta        IN Varchar2,
                                 Pv_CentroCosto         IN Varchar2,
                                 Pv_NoCiaJefe           IN Varchar2,
                                 Pv_IdJefe              IN Varchar2,
                                 Pclob_Foto             IN Clob,
                                 /*Pv_FormaPagoBcoEmp  IN Varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Pv_Banco            IN Varchar2,*/
                                 Pv_Salida  OUT Varchar2,
                                 Pv_Mensaje OUT Varchar2) IS
    LB_RHREMP        BOOLEAN;
    LD_FECHA_INGRESO DATE;
    LD_FECHA_EGRESO  DATE;
    LV_ULT_ACCION    VARCHAR2(10);
  BEGIN

RHP_REGISTRA_HIST_DE_REINGRESO(Pv_NoCia,
                                   Pv_NoEmple,
                                   Pv_Estado,
                                   LB_RHREMP,
                                   Pv_Salida,
                                   Pv_Mensaje);

    LD_FECHA_INGRESO := To_Date(Pv_FechaIngreso, 'dd/mm/yyyy');
    LD_FECHA_EGRESO  := To_Date(Pv_FechaEgreso, 'dd/mm/yyyy');

    IF NVL(LB_RHREMP,FALSE) THEN
      LD_FECHA_INGRESO := SYSDATE;
      LD_FECHA_EGRESO  := NULL;
      LV_ULT_ACCION    := 'REMP';
    END IF;

    UPDATE ARPLME
       SET NOMBRE_PILA        = UPPER(Pv_NombrePila),
           TELEFONO           = Pv_Telefono,
           CELULAR            = Pv_Celular,
           CELULAR2           = Pv_Celular2,
           CELULAR3           = Pv_Celular3,
           NOMBRE_SEGUNDO     = UPPER(Pv_NombreSegundo),
           APE_PAT            = UPPER(Pv_ApePat),
           APE_MAT            = UPPER(Pv_ApeMat),
           DIRECCION          = Pv_Direccion,
           OFICINA            = Pv_Oficina,
           F_INGRESO          = To_Date(Pv_FechaIngreso, 'dd/mm/yyyy'),
           F_EGRESO           = To_Date(Pv_FechaEgreso, 'dd/mm/yyyy'),
           MOTIVO_SALIDA      = NULL,
           DETALLE_SALIDA     = NULL,
           ESTADO             = Pv_Estado,
           ESTADO_PROP        = Pv_Estado,
           E_CIVIL            = Pv_EstadoCivil,
           ID_PROVINCIA       = Pv_IdProvincia,
           ID_REGION_PATRONAL = Pv_IdCanton,
           AREA               = Pv_IdArea,
           DEPTO              = Pv_IdDepartamento,
           PUESTO             = Pv_Puesto,
           PUESTO_ANT         = Pv_PuestoAnterior,
           TITULO             = Pv_Titulo,
           TIPO_EMP           = Pv_TipoEmpleado,
           CALLE              = Pv_CalleDireccion,
           ID_PROVINCIA_DIREC = Pv_ProvinciaDireccion,
           ID_CIUDAD_DIREC    = Pv_CantonDireccion,
           SAL_BAS            = Pn_Sueldo,
           PAIS_NACIMIENTO    = Pv_PaisNacimiento,
           PROVIN_NACIMIENTO  = Pv_ProvinciaNacimiento,
           CANTON_NACIMIENTO  = Pv_CantonNacimiento,
           PORC_ADELANTO      = Pn_AdelantoQuincenal,
           ID_CTA             = Pv_CuentaEmpresa,
           FORMA_PAGO         = Pv_FormaPago,
           ID_OTRO_BANCO      = Pv_BancoEmpleado,
           TIPO_CTA           = Pv_TipoCuenta,
           NUM_CUENTA         = Pv_NumeroCuenta,
           CENTRO_COSTO       = Pv_CentroCosto,
           NO_CIA_JEFE        = Pv_NoCiaJefe,
           ID_JEFE            = Pv_IdJefe,
           FOTO               = Pclob_Foto
     WHERE NO_CIA = Pv_NoCia
       AND NO_EMPLE = Pv_NoEmple;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error';
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH',
                                           'GEK_MIGRACION.RHP_ACTUALIZA_ARPLME',
                                           'Error en RHP_ACTUALIZA_ARPLME: ' ||
                                           SQLERRM || ' ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               USER),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END RHP_ACTUALIZA_ARPLME;

  PROCEDURE P_ELIMINA_MIGRA_CG(Pd_Fecha        IN DATE,
                               Pv_NoAsiento    IN VARCHAR2,
                               Pv_CodDiario    IN VARCHAR2,
                               Pv_NoCia        IN VARCHAR2,
                               Pv_MensajeError IN OUT VARCHAR2) IS

    -- cursor que recupera asientos mayorizados asociados a registros que se requeiere eliminar
    -- @CostoQuery: 2216
    CURSOR C_VERIFICA_MAYORIZADOS(Cv_CodEmpresa NAF47_TNET.MIGRA_ARCGAE.NO_CIA%TYPE) IS
      SELECT A.NO_ASIENTO
        FROM NAF47_TNET.ARCGAEH A
       WHERE A.NO_CIA = Cv_CodEmpresa
         AND A.ESTADO = 'A'
         AND EXISTS
       (SELECT NULL
                FROM NAF47_TNET.MIGRA_ARCGAE M
               WHERE M.NUMERO_CTRL = A.NO_ASIENTO
                 AND M.NO_CIA = A.NO_CIA
                 AND M.FECHA = NVL(Pd_Fecha, M.FECHA)
                 AND M.NO_ASIENTO = NVL(Pv_NoAsiento, M.NO_ASIENTO)
                 AND M.COD_DIARIO = Pv_CodDiario);

    -- cursor que recupera asientos autorizados asociados a registros que se requeiere eliminar
    -- @CostoQuery: 604
    CURSOR C_VERIFICA_AUTORIZADOS(Cv_CodEmpresa NAF47_TNET.MIGRA_ARCGAE.NO_CIA%TYPE) IS
      SELECT A.NO_ASIENTO
        FROM NAF47_TNET.ARCGAE A
       WHERE A.NO_CIA = Cv_CodEmpresa
         AND A.AUTORIZADO = 'S'
         AND EXISTS
       (SELECT NULL
                FROM NAF47_TNET.MIGRA_ARCGAE M
               WHERE M.NUMERO_CTRL = A.NO_ASIENTO
                 AND M.NO_CIA = A.NO_CIA
                 AND M.FECHA = NVL(Pd_Fecha, M.FECHA)
                 AND M.NO_ASIENTO = NVL(Pv_NoAsiento, M.NO_ASIENTO)
                 AND M.COD_DIARIO = Pv_CodDiario);
    --
    -- cursor que recupera asientos generados asociados a registros para eliminarlos
    -- @CostoQuery: 221
    CURSOR C_CONTABILIZADOS(Cv_CodEmpresa NAF47_TNET.MIGRA_ARCGAE.NO_CIA%TYPE) IS
      SELECT A.NO_CIA, A.NO_ASIENTO
        FROM NAF47_TNET.ARCGAE A
       WHERE A.NO_CIA = Cv_CodEmpresa
         AND A.ESTADO = 'P'
         AND NVL(A.AUTORIZADO, 'N') = 'N'
         AND EXISTS
       (SELECT NULL
                FROM NAF47_TNET.MIGRA_ARCGAE M
               WHERE M.NUMERO_CTRL = A.NO_ASIENTO
                 AND M.NO_CIA = A.NO_CIA
                 AND M.FECHA = NVL(Pd_Fecha, M.FECHA)
                 AND M.NO_ASIENTO = NVL(Pv_NoAsiento, M.NO_ASIENTO)
                 AND M.COD_DIARIO = Pv_CodDiario);
    --
    Le_Error EXCEPTION;
    Lv_CodEmpresa NAF47_TNET.MIGRA_ARCGAE.NO_CIA%TYPE;
    --
  BEGIN
  
    Lv_CodEmpresa := Pv_NoCia;
  
    IF Pv_NoCia = '33' then
        Lv_CodEmpresa := '18';
    end if;
  
    -- Se valida que no existan asientos contables mayorizados asociados a registros de la fecha que se requiere eliminar
    FOR Li_Mayorizado IN C_VERIFICA_MAYORIZADOS(Lv_CodEmpresa) LOOP
      -- Se concatenan los asientos mayorizados encontrados
      IF Pv_MensajeError IS NULL THEN
        Pv_MensajeError := Li_Mayorizado.No_Asiento;
      ELSE
        Pv_MensajeError := Pv_MensajeError || ',' ||
                           Li_Mayorizado.No_Asiento;
      END IF;
    END LOOP;
    --
    -- Si existe un mayorizado no se procesa nada.
    IF Pv_MensajeError IS NOT NULL THEN
      Pv_MensajeError := '002| Los siguentes asientos contables asociados a registros migrados ya se encuentran mayorizados' ||
                         CHR(10) || Pv_MensajeError;
      RAISE Le_Error;
    END IF;
    --
    -- Se valida que no existan asientos contables autorizados asociados a registros de la fecha que se requiere eliminar
    FOR Li_Autorizado IN C_VERIFICA_AUTORIZADOS(Lv_CodEmpresa) LOOP
      -- Se concatenan los asientos mayorizados encontrados
      IF Pv_MensajeError IS NULL THEN
        Pv_MensajeError := Li_Autorizado.No_Asiento;
      ELSE
        Pv_MensajeError := Pv_MensajeError || ',' ||
                           Li_Autorizado.No_Asiento;
      END IF;
    END LOOP;
    --
    -- Si existe un autorizado no se procesa nada.
    IF Pv_MensajeError IS NOT NULL THEN
      Pv_MensajeError := '003| Los siguentes asientos contables asociados a registros migrados ya se encuentran autorizados' ||
                         CHR(10) || Pv_MensajeError;
      RAISE Le_Error;
    END IF;
    --
    -- Se elimian los asientos contabilizados
    FOR Li_Contab IN C_CONTABILIZADOS(Lv_CodEmpresa) LOOP
      -- se procede a eliminar detalle de asientos
      DELETE NAF47_TNET.ARCGAL
       WHERE NO_CIA = Li_Contab.No_Cia
         AND NO_ASIENTO = Li_Contab.No_Asiento;

      -- Se elimina cabecera de asiento
      DELETE NAF47_TNET.ARCGAE
       WHERE NO_CIA = Li_Contab.No_Cia
         AND NO_ASIENTO = Li_Contab.No_Asiento;

    END LOOP;
    --
    -- Se procede documento asociado
    DELETE NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO A
     WHERE A.NO_CIA = Pv_NoCia
       AND EXISTS
     (SELECT NULL
              FROM NAF47_TNET.MIGRA_ARCGAE M
             WHERE M.ID_MIGRACION = A.MIGRACION_ID
               AND M.NO_CIA = A.NO_CIA
               AND M.NO_ASIENTO = NVL(Pv_NoAsiento, M.NO_ASIENTO)
               AND M.FECHA = NVL(Pd_Fecha, M.FECHA)
               AND M.COD_DIARIO = Pv_CodDiario);
               
    -- Se procede a detalle eliminar migracion
    DELETE NAF47_TNET.MIGRA_ARCGAL A
     WHERE A.NO_CIA = Pv_NoCia
       AND EXISTS
     (SELECT NULL
              FROM NAF47_TNET.MIGRA_ARCGAE M
             WHERE M.ID_MIGRACION = A.MIGRACION_ID
               AND M.NO_CIA = A.NO_CIA
               AND M.NO_ASIENTO = NVL(Pv_NoAsiento, M.NO_ASIENTO)
               AND M.FECHA = NVL(Pd_Fecha, M.FECHA)
               AND M.COD_DIARIO = Pv_CodDiario);

    -- se procede a eliminar cabecera de migracion
    DELETE NAF47_TNET.MIGRA_ARCGAE M
     WHERE M.NO_ASIENTO = NVL(Pv_NoAsiento, M.NO_ASIENTO)
       AND M.FECHA = nvl(Pd_Fecha, M.FECHA)
       AND M.COD_DIARIO = Pv_CodDiario
       AND M.NO_CIA = Pv_NoCia;
    --
    
    IF Pv_NoCia = '33' THEN
      -- Se procede documento asociado
    DELETE NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO A
     WHERE A.NO_CIA = Lv_CodEmpresa
       AND EXISTS
     (SELECT NULL
              FROM NAF47_TNET.MIGRA_ARCGAE M
             WHERE M.ID_MIGRACION = A.MIGRACION_ID
               AND M.NO_CIA = A.NO_CIA
               AND M.NO_ASIENTO = NVL(Pv_NoAsiento, M.NO_ASIENTO)
               AND M.FECHA = NVL(Pd_Fecha, M.FECHA)
               AND M.COD_DIARIO = Pv_CodDiario);
               
    -- Se procede a detalle eliminar migracion
    DELETE NAF47_TNET.MIGRA_ARCGAL A
     WHERE A.NO_CIA = Lv_CodEmpresa
       AND EXISTS
     (SELECT NULL
              FROM NAF47_TNET.MIGRA_ARCGAE M
             WHERE M.ID_MIGRACION = A.MIGRACION_ID
               AND M.NO_CIA = A.NO_CIA
               AND M.NO_ASIENTO = NVL(Pv_NoAsiento, M.NO_ASIENTO)
               AND M.FECHA = NVL(Pd_Fecha, M.FECHA)
               AND M.COD_DIARIO = Pv_CodDiario);

    -- se procede a eliminar cabecera de migracion
    DELETE NAF47_TNET.MIGRA_ARCGAE M
     WHERE M.NO_ASIENTO = NVL(Pv_NoAsiento, M.NO_ASIENTO)
       AND M.FECHA = nvl(Pd_Fecha, M.FECHA)
       AND M.COD_DIARIO = Pv_CodDiario
       AND M.NO_CIA = Lv_CodEmpresa;
    --
    END IF;
    
    COMMIT;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS',
                                           'GEK_MIGRACION.P_ELIMINA_MIGRA_CG',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en GEK_MIGRACION.P_ELIMINA_MIGRA_CG: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS',
                                           'GEK_MIGRACION.P_ELIMINA_MIGRA_CG',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_ELIMINA_MIGRA_CG;

  PROCEDURE P_ELIMINA_MIGRA_CK(Pv_NoDocu       IN VARCHAR2,
                               Pv_NoCia        IN VARCHAR2,
                               Pv_MensajeError IN OUT VARCHAR2) IS

    -- cursor que recupera asientos mayorizados asociados a registros que se requeiere eliminar
    -- @CostoQuery: 3
    CURSOR C_VERIFICA_PROCESADOS IS
      SELECT NVL(A.PROCESADO, 'N') PROCESADO, A.NUMERO_CTRL
        FROM NAF47_TNET.MIGRA_ARCKMM A
       WHERE A.NO_CIA = Pv_NoCia
         AND A.NO_DOCU = Pv_NoDocu;
    --
    Lr_MigraArckmm C_VERIFICA_PROCESADOS%ROWTYPE;
    Le_Error EXCEPTION;
    --
  BEGIN
    -- Se valida que no existan asientos contables mayorizados asociados a registros de la fecha que se requiere eliminar
    IF C_VERIFICA_PROCESADOS%ISOPEN THEN
      CLOSE C_VERIFICA_PROCESADOS;
    END IF;
    --
    OPEN C_VERIFICA_PROCESADOS;
    FETCH C_VERIFICA_PROCESADOS
      INTO Lr_MigraArckmm;
    IF C_VERIFICA_PROCESADOS%NOTFOUND THEN
      Lr_MigraArckmm := NULL;
    END IF;
    CLOSE C_VERIFICA_PROCESADOS;
    --
    IF Lr_MigraArckmm.Procesado IS NOT NULL THEN
      --Se valida procesado
      IF Lr_MigraArckmm.Procesado = 'S' THEN
        IF Lr_MigraArckmm.Numero_Ctrl IS NOT NULL THEN
          IF SUBSTR(Lr_MigraArckmm.Numero_Ctrl,
                    (LENGTH(Lr_MigraArckmm.Numero_Ctrl) - 2),
                    2) = '01' THEN
            Pv_MensajeError := '001| Transaccion fue migrada a Modulo NAF-CONTABILIDAD, no puede ser Eliminada.';
            RAISE Le_Error;
          ELSE
            Pv_MensajeError := '001| Transaccion fue migrada a Modulo NAF-BANCOS, no puede ser Eliminada.';
            RAISE Le_Error;
          END IF;
        ELSE
          Pv_MensajeError := 'Transaccion en estado Procesado sin transaccion NAF asignada.';
          RAISE Le_Error;
        END IF;
        --
      END IF;
      --
      -- No tuvo errores, se procede a eliminar
      DELETE NAF47_TNET.MIGRA_ARCKML A
       WHERE A.NO_CIA = Pv_NoCia
         AND A.NO_DOCU = Pv_NoDocu;
      --
      -- se procede a eliminar cabecera de migracion
      DELETE NAF47_TNET.MIGRA_ARCKMM M
       WHERE M.NO_DOCU = Pv_NoDocu
         AND M.NO_CIA = Pv_NoCia;
      --
      if Pv_NoCia = '33' then
        -- No tuvo errores, se procede a eliminar
          DELETE NAF47_TNET.MIGRA_ARCKML A
           WHERE A.NO_CIA = '18'
             AND A.NO_DOCU = Pv_NoDocu;
          --
          -- se procede a eliminar cabecera de migracion
          DELETE NAF47_TNET.MIGRA_ARCKMM M
           WHERE M.NO_DOCU = Pv_NoDocu
             AND M.NO_CIA = '18';
          --
      end if;
      COMMIT;
      --
    END IF;

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS',
                                           'GEK_MIGRACION.P_ELIMINA_MIGRA_CK',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en GEK_MIGRACION.P_ELIMINA_MIGRA_CK: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS',
                                           'GEK_MIGRACION.P_ELIMINA_MIGRA_CK',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_ELIMINA_MIGRA_CK;

  FUNCTION F_VALIDA_ELIMINAR_MIGRA(Pv_IdMigracion   IN VARCHAR2,
                                   Pv_TipoMigracion IN VARCHAR2,
                                   Pv_NoCia         IN VARCHAR2)
    RETURN BOOLEAN IS

    -- cursor que recupera asientos contables generados por documento migrado
    CURSOR C_DATOS_ASIENTO IS
      SELECT A.NO_CIA, A.NO_ASIENTO
        FROM NAF47_TNET.ARCGAE A
       WHERE EXISTS (SELECT NULL
                FROM NAF47_TNET.MIGRA_ARCGAE M
               WHERE M.NUMERO_CTRL = A.NO_ASIENTO
                 AND M.NO_CIA = A.NO_CIA
                 AND M.ID_MIGRACION = Pv_IdMigracion
                 AND M.NO_CIA = Pv_NoCia)
      UNION
      SELECT A.NO_CIA, A.NO_ASIENTO
        FROM NAF47_TNET.ARCGAEH A
       WHERE EXISTS (SELECT NULL
                FROM NAF47_TNET.MIGRA_ARCGAE M
               WHERE M.NUMERO_CTRL = A.NO_ASIENTO
                 AND M.NO_CIA = A.NO_CIA
                 AND M.ID_MIGRACION = Pv_IdMigracion
                 AND M.NO_CIA = Pv_NoCia);
    --
    -- cursor que recupera documentos bancos generado por documento migrado
    CURSOR C_DATOS_DOC_BANCOS IS
      SELECT A.NO_CIA, A.NO_DOCU, A.ESTADO
        FROM NAF47_TNET.ARCKMM A
       WHERE A.ESTADO != 'P'
         AND EXISTS (SELECT NULL
                FROM NAF47_TNET.MIGRA_ARCKMM B
               WHERE B.NO_DOCU = A.NUMERO_CTRL
                 AND B.NO_CIA = A.NO_CIA
                 AND B.ID_MIGRACION = Pv_IdMigracion
                 AND B.NO_CIA = Pv_NoCia);
    --
    Lr_DatosAsiento   C_DATOS_ASIENTO%ROWTYPE;
    Lr_DatosDocBancos C_DATOS_DOC_BANCOS%ROWTYPE;
    Lb_EliminaMigra   BOOLEAN := FALSE;
    --
  BEGIN

    IF Pv_TipoMigracion = 'CG' THEN
      -- Se valida que no existan asientos contables generados a contabilidad
      IF C_DATOS_ASIENTO%ISOPEN THEN
        CLOSE C_DATOS_ASIENTO;
      END IF;
      --
      OPEN C_DATOS_ASIENTO;
      FETCH C_DATOS_ASIENTO
        INTO Lr_DatosAsiento;
      IF C_DATOS_ASIENTO%NOTFOUND THEN
        Lr_DatosAsiento := NULL;
      END IF;
      CLOSE C_DATOS_ASIENTO;

      IF Lr_DatosAsiento.No_Asiento IS NULL THEN
        Lb_EliminaMigra := TRUE;
      END IF;

    ELSIF Pv_TipoMigracion = 'CK' THEN

      -- se valida documentos bancos generados por documento migrado
      IF C_DATOS_DOC_BANCOS%ISOPEN THEN
        CLOSE C_DATOS_DOC_BANCOS;
      END IF;
      --
      OPEN C_DATOS_DOC_BANCOS;
      FETCH C_DATOS_DOC_BANCOS
        INTO Lr_DatosDocBancos;
      IF C_DATOS_DOC_BANCOS%NOTFOUND THEN
        Lr_DatosDocBancos := NULL;
      END IF;
      CLOSE C_DATOS_DOC_BANCOS;

      IF Lr_DatosDocBancos.No_Docu IS NULL THEN
        Lb_EliminaMigra := TRUE;
      END IF;

    END IF;

    -- Se retorna valores
    RETURN Lb_EliminaMigra;
    --
  END F_VALIDA_ELIMINAR_MIGRA;

  PROCEDURE P_ELIMINA_DOCUMENTO_MIGRADO(Pv_IdMigracion   IN VARCHAR2,
                                        Pv_TipoMigracion IN VARCHAR2,
                                        Pv_NoCia         IN VARCHAR2,
                                        Pv_MensajeError  IN OUT VARCHAR2) IS

    -- cursor que recupera asientos contables generados por documento migrado
    CURSOR C_DATOS_ASIENTO IS
      SELECT A.NO_CIA, A.NO_ASIENTO
        FROM NAF47_TNET.ARCGAE A
       WHERE EXISTS (SELECT NULL
                FROM NAF47_TNET.MIGRA_ARCGAE M
               WHERE M.NUMERO_CTRL = A.NO_ASIENTO
                 AND M.NO_CIA = A.NO_CIA
                 AND M.ID_MIGRACION = Pv_IdMigracion
                 AND M.NO_CIA = Pv_NoCia)
      UNION
      SELECT A.NO_CIA, A.NO_ASIENTO
        FROM NAF47_TNET.ARCGAEH A
       WHERE EXISTS (SELECT NULL
                FROM NAF47_TNET.MIGRA_ARCGAE M
               WHERE M.NUMERO_CTRL = A.NO_ASIENTO
                 AND M.NO_CIA = A.NO_CIA
                 AND M.ID_MIGRACION = Pv_IdMigracion
                 AND M.NO_CIA = Pv_NoCia);
    --
    -- cursor que recupera documento bancos generado por documento migrado
    CURSOR C_DATOS_DOC_BANCOS IS
      SELECT A.NO_CIA, A.NO_DOCU, A.ESTADO
        FROM NAF47_TNET.ARCKMM A
       WHERE EXISTS (SELECT NULL
                FROM NAF47_TNET.MIGRA_ARCKMM B
               WHERE B.NO_DOCU = A.NUMERO_CTRL
                 AND B.NO_CIA = A.NO_CIA
                 AND B.ID_MIGRACION = Pv_IdMigracion
                 AND B.NO_CIA = Pv_NoCia);

    --
    Lr_DatosAsiento   C_DATOS_ASIENTO%ROWTYPE;
    Lr_DatosDocBancos C_DATOS_DOC_BANCOS%ROWTYPE;
    Le_Error EXCEPTION;
    --
  BEGIN
    IF Pv_TipoMigracion = 'CG' THEN
      -- se verifica asiento a eliminar
      IF C_DATOS_ASIENTO%ISOPEN THEN
        CLOSE C_DATOS_ASIENTO;
      END IF;
      --
      OPEN C_DATOS_ASIENTO;
      FETCH C_DATOS_ASIENTO
        INTO Lr_DatosAsiento;
      IF C_DATOS_ASIENTO%NOTFOUND THEN
        Lr_DatosAsiento := NULL;
      END IF;
      CLOSE C_DATOS_ASIENTO;

      IF Lr_DatosAsiento.No_Asiento IS NOT NULL THEN
        Pv_MensajeError := 'Documento migrado se encuentra contabilizado.';
        RAISE Le_Error;
      END IF;

      -- se procede a eliminar cabecera de migracion
      UPDATE NAF47_TNET.MIGRA_ARCGAE M
         SET M.TRANSFERIDO = 'X'
       WHERE M.ID_MIGRACION = Pv_IdMigracion
         AND M.NO_CIA = Pv_NoCia;
      --
    ELSIF Pv_TipoMigracion = 'CK' THEN
      -- Se verifica si documento migrado se encuentra procesado
      IF C_DATOS_DOC_BANCOS%ISOPEN THEN
        CLOSE C_DATOS_DOC_BANCOS;
      END IF;
      --
      OPEN C_DATOS_DOC_BANCOS;
      FETCH C_DATOS_DOC_BANCOS
        INTO Lr_DatosDocBancos;
      IF C_DATOS_DOC_BANCOS%NOTFOUND THEN
        Lr_DatosDocBancos := NULL;
      END IF;
      CLOSE C_DATOS_DOC_BANCOS;

      IF Lr_DatosDocBancos.No_Docu IS NOT NULL THEN
        IF Lr_DatosDocBancos.Estado != 'P' THEN
          Pv_MensajeError := 'Documento migrado se encuentra Procesado en modulo NAF:BANCOS.';
          RAISE Le_Error;
        END IF;
        --
        -- Se procede a eliminar detalle documento generado desde documento migrado
        DELETE NAF47_TNET.ARCKML
         WHERE NO_DOCU = Lr_DatosDocBancos.No_Docu
           AND NO_CIA = Lr_DatosDocBancos.No_Cia;

        -- Se procede a eliminar documento generado desde documento migrado
        DELETE NAF47_TNET.ARCKMM
         WHERE NO_DOCU = Lr_DatosDocBancos.No_Docu
           AND NO_CIA = Lr_DatosDocBancos.No_Cia;
      END IF;

      -- se procede a eliminar cabecera de migracion
      UPDATE NAF47_TNET.MIGRA_ARCKMM M
         SET M.PROCESADO = 'X'
       WHERE M.ID_MIGRACION = Pv_IdMigracion
         AND M.NO_CIA = Pv_NoCia;

    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_ELIMINA_DOCUMENTO_MIGRADO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en GEK_MIGRACION.P_ELIMINA_MIGRA_CG: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_ELIMINA_DOCUMENTO_MIGRADO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_ELIMINA_DOCUMENTO_MIGRADO;

  PROCEDURE P_PROCESA_MIGRA_DOC_ASOCIADO(Pr_MigraDocAsociado IN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE,
                                         Pv_TipoProceso      IN VARCHAR2,
                                         Pv_MensajeError     IN OUT VARCHAR2) IS
  
    --
    Le_Error EXCEPTION;
    --
  BEGIN
  
    IF Pv_TipoProceso = 'I' THEN
      -- inserta registro
      INSERT INTO NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO
        (DOCUMENTO_ORIGEN_ID,
         TIPO_DOC_MIGRACION,
         MIGRACION_ID,
         TIPO_MIGRACION,
         NO_CIA,
         FORMA_PAGO_ID,
         TIPO_DOCUMENTO_ID,
         ESTADO,
         USR_CREACION,
         FE_CREACION)
      VALUES
        (Pr_MigraDocAsociado.documento_origen_id,
         Pr_MigraDocAsociado.tipo_doc_migracion,
         Pr_MigraDocAsociado.migracion_id,
         Pr_MigraDocAsociado.tipo_migracion,
         Pr_MigraDocAsociado.no_cia,
         Pr_MigraDocAsociado.forma_pago_id,
         Pr_MigraDocAsociado.tipo_documento_id,
         Pr_MigraDocAsociado.estado,
         Pr_MigraDocAsociado.usr_creacion,
         SYSDATE);
    
      -- Elimina Registro
    ELSIF Pv_TipoProceso = 'E' THEN
    
      UPDATE NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO
         SET ESTADO      = 'E',
             USR_ULT_MOD = Pr_MigraDocAsociado.Usr_Ult_Mod,
             FE_ULT_MOD  = SYSDATE
       WHERE DOCUMENTO_ORIGEN_ID = Pr_MigraDocAsociado.Documento_Origen_Id
         AND TIPO_DOC_MIGRACION = Pr_MigraDocAsociado.Tipo_Doc_Migracion
         AND MIGRACION_ID = Pr_MigraDocAsociado.Migracion_Id
         AND TIPO_MIGRACION = Pr_MigraDocAsociado.Tipo_Migracion
         AND NO_CIA = Pr_MigraDocAsociado.No_Cia;
    
    END IF;
  
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en GEK_MIGRACION.P_INSERTA_MIGRA_DOC_ASOCIADO: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_PROCESA_MIGRA_DOC_ASOCIADO;
  
  PROCEDURE P_PROCESA_MIGRA_DOC_ASOC_MAS(Pr_MigraDocAsociado IN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE,
                                         Pv_TipoProceso      IN VARCHAR2,
                                         Pv_MensajeError     IN OUT VARCHAR2,
                                         Pv_EsProcesoMasivo  IN BOOLEAN DEFAULT FALSE,
                                         Pr_MigraDocAsociadoMas IN lstDocumentosAsociadosType default null) IS

    --
    Le_Error EXCEPTION;
    --
  BEGIN

    IF Pv_TipoProceso = 'I' THEN
       -- inserta registro
      IF Pv_EsProcesoMasivo THEN
        FORALL idx_ IN Pr_MigraDocAsociadoMas.FIRST..Pr_MigraDocAsociadoMas.LAST
          INSERT INTO NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO
            (DOCUMENTO_ORIGEN_ID,
             TIPO_DOC_MIGRACION,
             MIGRACION_ID,
             TIPO_MIGRACION,
             NO_CIA,
             FORMA_PAGO_ID,
             TIPO_DOCUMENTO_ID,
             ESTADO,
             USR_CREACION,
             FE_CREACION)
          VALUES
            (Pr_MigraDocAsociadoMas(idx_).DOCUMENTO_ORIGEN_ID,
             Pr_MigraDocAsociadoMas(idx_).tipo_doc_migracion,
             Pr_MigraDocAsociadoMas(idx_).migracion_id,
             Pr_MigraDocAsociadoMas(idx_).tipo_migracion,
             Pr_MigraDocAsociadoMas(idx_).no_cia,
             Pr_MigraDocAsociadoMas(idx_).forma_pago_id,
             Pr_MigraDocAsociadoMas(idx_).tipo_documento_id,
             Pr_MigraDocAsociadoMas(idx_).estado,
             Pr_MigraDocAsociadoMas(idx_).USR_CREACION,
             SYSDATE);
             --Pr_MigraDocAsociadoMas(idx_).
      ELSE
        -- inserta registro
        INSERT INTO NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO
          (DOCUMENTO_ORIGEN_ID,
           TIPO_DOC_MIGRACION,
           MIGRACION_ID,
           TIPO_MIGRACION,
           NO_CIA,
           FORMA_PAGO_ID,
           TIPO_DOCUMENTO_ID,
           ESTADO,
           USR_CREACION,
           FE_CREACION)
        VALUES
          (Pr_MigraDocAsociado.documento_origen_id,
           Pr_MigraDocAsociado.tipo_doc_migracion,
           Pr_MigraDocAsociado.migracion_id,
           Pr_MigraDocAsociado.tipo_migracion,
           Pr_MigraDocAsociado.no_cia,
           Pr_MigraDocAsociado.forma_pago_id,
           Pr_MigraDocAsociado.tipo_documento_id,
           Pr_MigraDocAsociado.estado,
           Pr_MigraDocAsociado.usr_creacion,
           SYSDATE);
      END IF;


      -- Elimina Registro
    ELSIF Pv_TipoProceso = 'E' THEN

      UPDATE NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO
         SET ESTADO      = 'E',
             USR_ULT_MOD = Pr_MigraDocAsociado.Usr_Ult_Mod,
             FE_ULT_MOD  = SYSDATE
       WHERE DOCUMENTO_ORIGEN_ID = Pr_MigraDocAsociado.Documento_Origen_Id
         AND TIPO_DOC_MIGRACION = Pr_MigraDocAsociado.Tipo_Doc_Migracion
         AND MIGRACION_ID = Pr_MigraDocAsociado.Migracion_Id
         AND TIPO_MIGRACION = Pr_MigraDocAsociado.Tipo_Migracion
         AND NO_CIA = Pr_MigraDocAsociado.No_Cia;

    END IF;

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en GEK_MIGRACION.P_INSERTA_MIGRA_DOC_ASOCIADO: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_PROCESA_MIGRA_DOC_ASOC_MAS;
  
  PROCEDURE P_INSERTA_ARCCMD(Pr_Arccmd  IN ARCCMD%ROWTYPE,
                             Pv_Salida  OUT VARCHAR2,
                             Pv_Mensaje OUT VARCHAR2) IS
  BEGIN

    INSERT INTO ARCCMD
      (No_cia,
       Centro,
       Tipo_Doc,
       Periodo,
       Ruta,
       No_Docu,
       Grupo,
       No_Cliente,
       Fecha,
       No_Agente,
       Cobrador,
       Subtotal,
       Estado,
       Origen,
       Ano,
       Mes,
       Semana,
       No_Fisico,
       Serie_Fisico,
       Fecha_Documento,
       Gravado,
       Numero_Ctrl,
       Tot_Imp,
       Tot_Imp_Especial,
       Cod_Diario,
       Moneda,
       Tipo_Cambio,
       Tot_Ret_Especial,
       Detalle,
       Sub_Cliente,
       Usuario,
       Tstamp,
       Division_Comercial,
       Estado_Sri,
       M_Original,
       Saldo,
       Total_Ref,
       Exento,
       Total_Db,
       Total_Cr,
       Tot_Ret)
    VALUES
      (Pr_Arccmd.No_Cia,
       Pr_Arccmd.Centro,
       Pr_Arccmd.Tipo_Doc,
       Pr_Arccmd.Periodo,
       Pr_Arccmd.Ruta,
       Pr_Arccmd.No_Docu,
       Pr_Arccmd.Grupo,
       Pr_Arccmd.No_Cliente,
       Pr_Arccmd.Fecha,
       Pr_Arccmd.No_Agente,
       Pr_Arccmd.Cobrador,
       Pr_Arccmd.Subtotal,
       Pr_Arccmd.Estado,
       Pr_Arccmd.Origen,
       Pr_Arccmd.Ano,
       Pr_Arccmd.Mes,
       Pr_Arccmd.Semana,
       Pr_Arccmd.No_Fisico,
       Pr_Arccmd.Serie_Fisico,
       Pr_Arccmd.Fecha_Documento,
       Pr_Arccmd.Gravado,
       Pr_Arccmd.Numero_Ctrl,
       Pr_Arccmd.Tot_Imp,
       Pr_Arccmd.Tot_Imp_Especial,
       Pr_Arccmd.Cod_Diario,
       Pr_Arccmd.Moneda,
       Pr_Arccmd.Tipo_Cambio,
       Pr_Arccmd.Tot_Ret_Especial,
       Pr_Arccmd.Detalle,
       Pr_Arccmd.Sub_Cliente,
       Pr_Arccmd.Usuario,
       Pr_Arccmd.Tstamp,
       Pr_Arccmd.Division_Comercial,
       Pr_Arccmd.Estado_Sri,
       0,
       0,
       0,
       0,
       0,
       0,
       0);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error en GEK_MIGRACION.P_INSERTA_ARCCMD: ' || SQLERRM || ' ' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_ARCCMD',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_ARCCMD;

  PROCEDURE P_INSERTA_ARCCFPAGOS(Pr_ARCCFPAGOS IN ARCCFPAGOS%ROWTYPE,
                                 Pv_Salida     OUT VARCHAR2,
                                 Pv_Mensaje    OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCCFPAGOS
      (Id_Forma_Pago,
       No_Cia,
       No_Docu,
       Linea,
       Valor,
       Autorizacion,
       Cod_Bco_Cia,
       Campo_Deposito,
       No_Docu_Deposito,
       Ref_Fecha,
       Ref_Cod_Banco,
       Cod_t_c,
       Ref_Cuenta)
    VALUES
      (Pr_ARCCFPAGOS.Id_Forma_Pago,
       Pr_ARCCFPAGOS.No_Cia,
       Pr_ARCCFPAGOS.No_Docu,
       Pr_ARCCFPAGOS.Linea,
       Pr_ARCCFPAGOS.Valor,
       Pr_ARCCFPAGOS.Autorizacion,
       Pr_ARCCFPAGOS.Cod_Bco_Cia,
       Pr_ARCCFPAGOS.Campo_Deposito,
       Pr_ARCCFPAGOS.No_Docu_Deposito,
       Pr_ARCCFPAGOS.Ref_Fecha,
       Pr_ARCCFPAGOS.Ref_Cod_Banco,
       Pr_ARCCFPAGOS.Cod_t_c,
       Pr_ARCCFPAGOS.Ref_Cuenta);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error en GEK_MIGRACION.P_INSERTA_ARCCFPAGOS: ' ||
                    SQLERRM || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_ARCCFPAGOS',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_ARCCFPAGOS;

  PROCEDURE P_INSERTA_ARCCRD(Pr_ARCCRD  IN ARCCRD%ROWTYPE,
                             Pv_Salida  OUT VARCHAR2,
                             Pv_Mensaje OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCCRD
      (Tipo_Refe,
       No_Refe,
       Monto,
       No_Cia,
       Tipo_Doc,
       No_Docu,
       Fecha_Vence,
       Ind_Procesado,
       Fec_Aplic,
       Ano,
       Mes,
       Monto_Refe,
       Moneda_Refe)
    VALUES
      (Pr_ARCCRD.Tipo_Refe,
       Pr_ARCCRD.No_Refe,
       Pr_ARCCRD.Monto,
       Pr_ARCCRD.No_Cia,
       Pr_ARCCRD.Tipo_Doc,
       Pr_ARCCRD.No_Docu,
       Pr_ARCCRD.Fecha_Vence,
       Pr_ARCCRD.Ind_Procesado,
       Pr_ARCCRD.Fec_Aplic,
       Pr_ARCCRD.Ano,
       Pr_ARCCRD.Mes,
       Pr_ARCCRD.Monto_Refe,
       Pr_ARCCRD.Moneda_Refe);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error en GEK_MIGRACION.P_INSERTA_ARCCRD: ' || SQLERRM || ' ' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_ARCCRD',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_ARCCRD;

  PROCEDURE P_INSERTA_ARCCTI(Pr_ARCCTI  IN ARCCTI%ROWTYPE,
                             Pv_Salida  OUT VARCHAR2,
                             Pv_Mensaje OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCCTI
      (Clave,
       Monto,
       Base,
       No_Serie,
       No_Fisico,
       No_Autorizacion,
       Fecha_Emision,
       Fecha_Vigencia,
       No_Cia,
       Ind_Imp_Ret,
       Grupo,
       No_Cliente,
       Tipo_Doc,
       No_Docu,
       No_refe,
       Porcentaje,
       Sri_Imp_Renta,
       Usuario_Registra,
       Tstamp)
    VALUES
      (Pr_ARCCTI.Clave,
       Pr_ARCCTI.Monto,
       Pr_ARCCTI.Base,
       Pr_ARCCTI.No_Serie,
       Pr_ARCCTI.No_Fisico,
       Pr_ARCCTI.No_Autorizacion,
       Pr_ARCCTI.Fecha_Emision,
       Pr_ARCCTI.Fecha_Vigencia,
       Pr_ARCCTI.No_Cia,
       'R',
       Pr_ARCCTI.Grupo,
       Pr_ARCCTI.No_Cliente,
       Pr_ARCCTI.Tipo_Doc,
       Pr_ARCCTI.No_Docu,
       Pr_ARCCTI.No_Refe,
       Pr_ARCCTI.Porcentaje,
       Pr_ARCCTI.Sri_Imp_Renta,
       Pr_ARCCTI.Usuario_Registra,
       Pr_ARCCTI.Tstamp);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error en GEK_MIGRACION.P_INSERTA_ARCCTI: ' || SQLERRM || ' ' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_ARCCTI',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_ARCCTI;

  PROCEDURE P_INSERTA_ARCCDC(Pr_ARCCDC  IN ARCCDC%ROWTYPE,
                             Pv_Salida  OUT VARCHAR2,
                             Pv_Mensaje OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCCDC
      (Codigo,
       Tipo,
       Monto,
       Monto_Dc,
       No_Cia,
       Centro,
       Tipo_Doc,
       Periodo,
       Ruta,
       No_Docu,
       Grupo,
       No_Cliente,
       Monto_Dol,
       Tipo_Cambio,
       Ind_Con,
       Centro_Costo)
    VALUES
      (Pr_ARCCDC.Codigo,
       Pr_ARCCDC.Tipo,
       Pr_ARCCDC.Monto,
       Pr_ARCCDC.Monto,
       Pr_ARCCDC.No_Cia,
       Pr_ARCCDC.Centro,
       Pr_ARCCDC.Tipo_Doc,
       Pr_ARCCDC.Periodo,
       Pr_ARCCDC.Ruta,
       Pr_ARCCDC.No_Docu,
       Pr_ARCCDC.Grupo,
       Pr_ARCCDC.No_Cliente,
       Pr_ARCCDC.Monto_Dol,
       Pr_ARCCDC.Tipo_Cambio,
       Pr_ARCCDC.Ind_Con,
       Pr_ARCCDC.Centro_Costo);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error en GEK_MIGRACION.P_INSERTA_ARCCDC: ' || SQLERRM || ' ' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_ARCCDC',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_ARCCDC;

  PROCEDURE P_ACTUALIZA_ARCCMD(Pr_ARCCMD     IN ARCCMD%ROWTYPE,
                               Pv_Formulario IN VARCHAR2,
                               Pv_Salida     OUT VARCHAR2,
                               Pv_Mensaje    OUT VARCHAR2) IS
  BEGIN
    UPDATE ARCCMD
       SET Exento     = Pr_ARCCMD.Exento,
           m_Original = Pr_ARCCMD.m_Original,
           Tot_Ret    = Pr_ARCCMD.Tot_Ret,
           Saldo      = Pr_ARCCMD.Saldo,
           Total_Ref  = Pr_ARCCMD.Total_Ref,
           Total_Cr   = Pr_ARCCMD.Total_Cr,
           Total_Db   = Pr_ARCCMD.Total_Db
     WHERE No_Cia = Pr_ARCCMD.No_Cia
       and Centro = Pr_ARCCMD.Centro
       AND No_DOCU = Pr_ARCCMD.NO_DOCU;

    UPDATE CONTROL_FORMU
       SET SIGUIENTE = SIGUIENTE + 1
     WHERE NO_CIA = Pr_ARCCMD.No_Cia
       AND FORMULARIO = Pv_Formulario
       AND MODULO = 'CC'
       AND NVL(ACTIVO, 'N') = 'S';

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error en GEK_MIGRACION.P_ACTUALIZA_ARCCMD: ' ||
                    SQLERRM || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_ACTUALIZA_ARCCMD',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_ACTUALIZA_ARCCMD;

  PROCEDURE P_MIGRACION_CXC(Pv_NoCia                  IN Varchar2,
                            Pv_Centro                 IN Varchar2,
                            Pv_TipoDoc                IN Varchar2,
                            Pv_Fecha                  IN Varchar2,
                            Pv_Grupo                  IN Varchar2,
                            Pv_TipoIdentificacion     IN Varchar2,
                            Pv_NoIdentificacion       IN Varchar2,
                            Pv_DetalleCobro           IN Varchar2,
                            Pv_NoCobrador             IN Varchar2,
                            Pv_UsuarioCreacion        IN Varchar2,
                            Pv_RefFecha               IN Varchar2,
                            Pclob_ListFormaPago       IN Varchar2,
                            Pclob_ListReferencia      IN Varchar2,
                            Pclob_ListRetencion       IN Varchar2,
                            Pclob_ListDetalleContable IN Varchar2,
                            Pn_SaldoFactura           OUT VARCHAR2,
                            Pv_Salida                 OUT VARCHAR2,
                            Pv_Mensaje                OUT VARCHAR2 /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Pn_SaldoFactura           OUT Number*/) IS

    CURSOR C_PERIODO IS
      SELECT *
        FROM ARINCD
       WHERE NO_CIA = Pv_NoCia
         AND CENTRO = Pv_Centro;

    CURSOR C_SUBCLIENTE(Cv_NoCliente Varchar2) IS
      SELECT *
        FROM ARCCLOCALES_CLIENTES S
       WHERE S.NO_CIA = Pv_NoCia
         AND S.GRUPO = Pv_Grupo
         AND S.NO_CLIENTE = Cv_NoCliente;

    CURSOR C_AUTOMATICO IS
      SELECT FORMULARIO
        FROM ARCC_RECIBOS_COBROS
       WHERE NO_CIA = Pv_NoCia
         AND CENTRO = Pv_Centro
         AND CODIGO_COBRADOR = Pv_NoCobrador
         AND ESTADO = 'A'
         AND NVL(IND_RECIBO, 'X') = 'A';

    CURSOR C_FORMU(Cv_Formulario VARCHAR2) IS
      SELECT SIGUIENTE, SERIE
        FROM CONTROL_FORMU
       WHERE NO_CIA = Pv_NoCia
         AND FORMULARIO = Cv_Formulario
         AND MODULO = 'CC'
         AND NVL(ACTIVO, 'N') = 'S';

    CURSOR C_RETE IS
      SELECT FORMULARIO_CTRL
        FROM ARCCTD
       WHERE NO_CIA = Pv_NoCia
         AND TIPO = Pv_TipoDoc
         AND NVL(IND_TARJETA_CREDITO, 'N') = 'N';

    CURSOR C_FORMU_TIPO_DOC(Cv_Formulario VARCHAR2) IS
      SELECT SIGUIENTE
        FROM CONTROL_FORMU
       WHERE NO_CIA = Pv_NoCia
         AND FORMULARIO = Cv_Formulario
         AND MODULO = 'CC'
         AND NVL(ACTIVO, 'N') = 'S';

    CURSOR C_TIPO IS
      SELECT *
        FROM ARCCTD
       WHERE NO_CIA = PV_NOCIA
         AND TIPO = PV_TIPODOC
         AND AFECTA_SALDO = 'S'
         AND IND_ANULACION = 'N'
         AND NVL(IND_COBRO, 'N') = 'S'
         AND NVL(IND_TARJETA_CREDITO, 'N') = 'N';

    CURSOR C_CLIENTES IS
      SELECT NO_CLIENTE
        FROM ARCCMC
       WHERE NO_CIA = Pv_NoCia
         AND CEDULA = Pv_NoIdentificacion
         AND TIPO_ID_TRIBUTARIO = Pv_TipoIdentificacion;

    CURSOR C_DATOS_REFE(Cv_TipoRefe     Varchar2,
                        Cv_NoFisicoRefe Varchar2,
                        Cv_SerieFisico  Varchar2,
                        Cv_Grupo        Varchar2,
                        Cv_NoCliente    Varchar2,
                        Cv_SubCliente   Varchar2) IS
      SELECT A.SALDO,
             A.MONEDA,
             A.FECHA,
             A.FECHA_VENCE,
             A.NO_DOCU,
             A.SERIE_FISICO,
             A.ORIGEN,
             NVL(A.SUBTOTAL, 0) SUBTOTAL,
             NVL(B.VALOR_TRANSPORTE, 0) VALOR_TRANSPORTE
        FROM ARCCMD A, ARFAFE B
       WHERE A.NO_CIA = Pv_NoCia
         AND A.TIPO_DOC = Cv_TipoRefe
         AND A.NO_FISICO = Cv_NoFisicoRefe
         AND A.SERIE_FISICO = Cv_SerieFisico
         AND A.GRUPO = Cv_Grupo
         AND A.NO_CLIENTE = Cv_NoCliente
         AND A.SUB_CLIENTE = Cv_SubCliente
         AND A.ESTADO != 'P'
         AND NVL(A.SALDO, 0) > 0
         AND A.NO_CIA = B.NO_CIA(+)
         AND A.NO_DOCU = B.NO_FACTU(+);

    CURSOR C_NO_DOCU_REFE(Cv_TipoDocu Varchar2, Cv_NoDocu Varchar2) IS
      SELECT NO_FISICO
        FROM ARCCMD
       WHERE NO_CIA = Pv_NoCia
         AND NO_DOCU = Cv_NoDocu
         AND CENTRO = Pv_Centro
         AND TIPO_DOC = Cv_TipoDocu;

    CURSOR C_MONTO_RET(Cv_NoCliente Varchar2,
                       Cv_NoDocu    Varchar2,
                       Cv_NoRefe    Varchar2) IS
      SELECT NVL(SUM(NVL(MONTO, 0)), 0)
        FROM ARCCTI
       WHERE NO_CIA = Pv_NoCia
         AND GRUPO = Pv_Grupo
         AND NO_CLIENTE = Cv_NoCliente
         AND NO_DOCU = Cv_NoDocu
         AND NO_REFE = Cv_NoRefe;

    CURSOR C_COBRADOR IS
      SELECT NOMBRE
        FROM ARINTB
       WHERE NO_CIA = Pv_NoCia
         AND CODIGO = Pv_NoCobrador
         AND TIPO_CODIGO = 'C'
         AND INACTIVO = 'N';

    CURSOR C_ARCGIMP(Cv_Clave Varchar2) IS
      SELECT PORCENTAJE, SRI_RETIMP_RENTA
        FROM ARCGIMP
       WHERE NO_CIA = Pv_NoCia
         AND IND_RETENCION = 'S'
         AND CLAVE = Cv_Clave
         AND AFECTA IN ('A', 'V')
       ORDER BY CLAVE;

    CURSOR C_SALDO(Cv_TipoRefe     Varchar2,
                   Cv_NoFisicoRefe Varchar2,
                   Cv_SerieFisico  Varchar2,
                   Cv_Grupo        Varchar2,
                   Cv_NoCliente    Varchar2,
                   Cv_SubCliente   Varchar2) IS
      SELECT A.SALDO
        FROM ARCCMD A, ARFAFE B
       WHERE A.NO_CIA = Pv_NoCia
         AND A.TIPO_DOC = Cv_TipoRefe
         AND A.NO_FISICO = Cv_NoFisicoRefe
         AND A.SERIE_FISICO = Cv_SerieFisico
         AND A.GRUPO = Cv_Grupo
         AND A.NO_CLIENTE = Cv_NoCliente
         AND A.SUB_CLIENTE = Cv_SubCliente
         AND A.ESTADO != 'P'
         AND A.NO_CIA = B.NO_CIA(+)
         AND A.NO_DOCU = B.NO_FACTU(+);

    CURSOR C_DEPOSITO(Cv_Autorizacion Varchar2, Cv_NoCta Varchar2) IS
      SELECT FECHA
        FROM ARCKMM
       WHERE NO_CIA = Pv_NoCia
         and NO_FISICO = Cv_Autorizacion
         AND NO_CTA = Cv_NoCta
         AND TIPO_DOC = 'DP';

    Lv_NoCliente ARCCMC.NO_CLIENTE%TYPE := NULL;

    L_ValorFormaPago   apex_json.t_values;
    L_ValorReferencia  apex_json.t_values;
    L_ValorRetencion   apex_json.t_values;
    L_ValorDetContable apex_json.t_values;

    Lclob_ListFormaPago   CLOB;
    Lclob_ListReferencia  CLOB;
    Lclob_ListRetencion   CLOB;
    Lclob_ListDetContable CLOB;

    Ln_ContadorFormaPago   Number := 0;
    Ln_ContadorReferencia  Number := 0;
    Ln_ContadorRetencion   Number := 0;
    Ln_ContadorDetContable Number := 0;

    Lr_ARCCFPAGOS           ARCCFPAGOS%ROWTYPE;
    Lr_ARCCMD               ARCCMD%ROWTYPE;
    Lr_Factura              ARCCMD%ROWTYPE;
    Lr_ARINCD               ARINCD%ROWTYPE;
    Lr_ARCCRD               ARCCRD%ROWTYPE;
    Lr_ARCCTI               ARCCTI%ROWTYPE;
    Lr_ARCCDC               ARCCDC%ROWTYPE;
    Lr_Dividendo            ARCCRD_DIVIDENDOS_MANUAL%ROWTYPE;
    Lr_ARCCLOCALES_CLIENTES ARCCLOCALES_CLIENTES%ROWTYPE;
    Lr_DatosRefe            C_DATOS_REFE%ROWTYPE;
    Lr_Arcgimp              C_ARCGIMP%ROWTYPE;
    Lv_NoFisicoRefe         ARCCMD.NO_FISICO%TYPE;
    Lv_SerieFisicoRefe      ARCCMD.SERIE_FISICO%TYPE;

    Lv_NoDocu ARCCMD.NO_DOCU%TYPE;

    Lv_formulario ARCC_RECIBOS_COBROS.FORMULARIO%TYPE;
    Ln_siguiente  Number;
    Ln_serie      ARCCMD.SERIE_FISICO%TYPE;

    Lv_formuTipoDoc ARCCTD.FORMULARIO%TYPE;
    Lr_TipoDoc      ARCCTD%ROWTYPE;
    Ln_siguTipoDoc  Number;

    Ln_SumFormaPago   Number := 0;
    Ln_LineaFPago     Number := 0;
    Ln_Dividendo      Number := 0;
    Ln_SaldoFactura   Number := 0;
    Lv_NombreCobrador ARINTB.Nombre%TYPE;

    Ln_SumReferencia Number := 0;

    Ln_SumDebito  Number := 0;
    Ln_SumCredito Number := 0;

    Lv_CodError     Varchar2(10);
    Lv_MensajeError Varchar2(500);

    Ln_Tot_Ret        Number := 0;
    Ln_TotalRetencion Number := 0;

    Ld_fecha date;
    Lc_reg1  C_DEPOSITO%rowtype;

    Le_Error Exception;
  BEGIN

    IF C_CLIENTES%ISOPEN THEN
      CLOSE C_CLIENTES;
    END IF;
    OPEN C_CLIENTES;

    FETCH C_CLIENTES
      INTO Lv_NoCliente;
    IF C_CLIENTES%NOTFOUND THEN
      Lv_MensajeError := ' No se encontr� Cliente en C_CLIENTES: ' ||
                         Pv_TipoIdentificacion;
      Raise Le_Error;
    END IF;
    CLOSE C_CLIENTES;

    Lr_ARCCMD.No_Cia   := Pv_NoCia;
    Lr_ARCCMD.Centro   := Pv_Centro;
    Lr_ARCCMD.Tipo_Doc := Pv_TipoDoc;

    IF C_PERIODO%ISOPEN THEN
      CLOSE C_PERIODO;
    END IF;

    OPEN C_PERIODO;
    FETCH C_PERIODO
      INTO Lr_ARINCD;
    IF C_PERIODO%NOTFOUND THEN
      Lv_MensajeError := ' No se encontr� Periodo en C_PERIODO';
      Raise Le_Error;
    END IF;
    CLOSE C_PERIODO;

    Lr_ARCCMD.Periodo    := Lr_ARINCD.Ano_Proce;
    Lr_ARCCMD.Ruta       := '0000';
    Lv_NoDocu            := TRANSA_ID.CC(Pv_NoCia);
    Lr_ARCCMD.No_Docu    := Lv_NoDocu;
    Lr_ARCCMD.Grupo      := Pv_Grupo;
    Lr_ARCCMD.No_Cliente := Lv_NoCliente;
    Lr_ARCCMD.Fecha      := Lr_ARINCD.Dia_Proceso_Cxc;

    IF C_SUBCLIENTE%ISOPEN THEN
      CLOSE C_SUBCLIENTE;
    END IF;
    OPEN C_SUBCLIENTE(Lv_NoCliente);
    FETCH C_SUBCLIENTE
      INTO Lr_ARCCLOCALES_CLIENTES;
    IF C_SUBCLIENTE%NOTFOUND THEN
      Lv_MensajeError := ' No se encontr� Subcliente en C_SUBCLIENTE';
      Raise Le_Error;
    END IF;
    CLOSE C_SUBCLIENTE;

    IF C_COBRADOR%ISOPEN THEN
      CLOSE C_COBRADOR;
    END IF;
    OPEN C_COBRADOR;
    FETCH C_COBRADOR
      INTO Lv_NombreCobrador;
    IF C_COBRADOR%NOTFOUND THEN
      Lv_MensajeError := ' No se encontr� Cobrador en COBRADOR';
      Raise Le_Error;
    END IF;
    CLOSE C_COBRADOR;

    Lr_ARCCMD.No_Agente := Lr_ARCCLOCALES_CLIENTES.Vendedor;
    Lr_ARCCMD.Cobrador  := Pv_NoCobrador;
    Lr_ARCCMD.Subtotal  := 0;
    Lr_ARCCMD.Estado    := 'P';
    Lr_ARCCMD.Origen    := 'CC';
    Lr_ARCCMD.Ano       := Lr_ARINCD.Ano_Proce_Cxc;
    Lr_ARCCMD.Mes       := Lr_ARINCD.Mes_Proce_Cxc;
    Lr_ARCCMD.Semana    := Lr_ARINCD.Semana_Proce_Cxc;

    IF C_AUTOMATICO%ISOPEN THEN
      CLOSE C_AUTOMATICO;
    END IF;

    OPEN C_AUTOMATICO;
    FETCH C_AUTOMATICO
      INTO Lv_formulario;
    IF C_AUTOMATICO%NOTFOUND THEN
      Lv_MensajeError := ' No se encontr� Formulario en C_AUTOMATICO';
      Raise Le_Error;
    END IF;

    CLOSE C_AUTOMATICO;

    IF C_FORMU%ISOPEN THEN
      CLOSE C_FORMU;
    END IF;

    OPEN C_FORMU(Lv_formulario);
    FETCH C_FORMU
      INTO Ln_siguiente, Ln_serie;
    IF C_FORMU%NOTFOUND THEN
      Lv_MensajeError := ' No se encontr� Secuencia en C_FORMU';
      Raise Le_Error;
    END IF;
    CLOSE C_FORMU;

    Lr_ARCCMD.No_Fisico        := Ln_siguiente;
    Lr_ARCCMD.Serie_Fisico     := Ln_serie;
    Lr_ARCCMD.Fecha_Documento  := Lr_ARINCD.Dia_Proceso_Cxc;
    Lr_ARCCMD.Gravado          := 0;
    Lr_ARCCMD.Tot_Imp          := 0;
    Lr_ARCCMD.Tot_Imp_Especial := 0;

    IF C_RETE%ISOPEN THEN
      CLOSE C_RETE;
    END IF;
    OPEN C_RETE;
    FETCH C_RETE
      INTO Lv_formuTipoDoc;
    IF C_RETE%NOTFOUND THEN
      Lv_MensajeError := ' No se encontr� Tipo Retencion en C_RETE';
      Raise Le_Error;
    END IF;
    CLOSE C_RETE;

    IF C_FORMU_TIPO_DOC%ISOPEN THEN
      CLOSE C_FORMU_TIPO_DOC;
    END IF;
    OPEN C_FORMU_TIPO_DOC(Lv_formuTipoDoc);
    FETCH C_FORMU_TIPO_DOC
      INTO Ln_siguTipoDoc;
    IF C_FORMU_TIPO_DOC%NOTFOUND THEN
      Lv_MensajeError := ' No se encontr� Tipo Documento en C_FORMU_TIPO_DOC';
      Raise Le_Error;
    END IF;
    CLOSE C_FORMU_TIPO_DOC;

    Lr_ARCCMD.Numero_Ctrl      := Ln_siguTipoDoc;
    Lr_ARCCMD.Tot_Imp          := 0;
    Lr_ARCCMD.Tot_Imp_Especial := 0;

    IF C_TIPO%ISOPEN THEN
      CLOSE C_TIPO;
    END IF;

    OPEN C_TIPO;
    FETCH C_TIPO
      INTO Lr_TipoDoc;
    IF C_TIPO%NOTFOUND THEN
      Lv_MensajeError := ' No se encontr� Tipo  en C_TIPO';
      Raise Le_Error;
    END IF;
    CLOSE C_TIPO;

    Lr_ARCCMD.Cod_Diario         := Lr_TipoDoc.Cod_Diario;
    Lr_ARCCMD.Moneda             := 'P';
    Lr_ARCCMD.Tipo_Cambio        := 1;
    Lr_ARCCMD.Tot_Ret_Especial   := 0;
    Lr_ARCCMD.Detalle            := Pv_DetalleCobro;
    Lr_ARCCMD.Sub_Cliente        := Lr_ARCCLOCALES_CLIENTES.No_Sub_Cliente;
    Lr_ARCCMD.Usuario            := Pv_UsuarioCreacion;
    Lr_ARCCMD.Tstamp             := Sysdate;
    Lr_ARCCMD.Division_Comercial := Lr_ARCCLOCALES_CLIENTES.Div_Comercial;
    Lr_ARCCMD.Estado_Sri         := 'P';

    P_INSERTA_ARCCMD(Lr_ARCCMD, Lv_CodError, Lv_MensajeError);

    IF Lv_CodError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
      Lv_MensajeError := 'Error en P_INSERTA_ARCCMD:' || Lv_MensajeError;
      Raise Le_Error;
    END IF;

    Lclob_ListFormaPago := Pclob_ListFormaPago;

    apex_json.parse(p_values => L_ValorFormaPago,
                    p_source => Lclob_ListFormaPago);

    Ln_ContadorFormaPago := apex_json.get_count(p_values => L_ValorFormaPago,
                                                p_path   => '.');

    FOR I in 1 .. Ln_ContadorFormaPago LOOP
      Lr_ARCCFPAGOS.Id_Forma_Pago := apex_json.get_varchar2(p_values => L_ValorFormaPago,
                                                            p_path   => '[%d].idFormaPago',
                                                            p0       => i);

      Lr_ARCCFPAGOS.Valor          := NVL(apex_json.get_varchar2(p_values => L_ValorFormaPago,
                                                                 p_path   => '[%d].valor',
                                                                 p0       => i),
                                          0);
      Ln_SumFormaPago              := Ln_SumFormaPago + Lr_ARCCFPAGOS.Valor;
      Lr_ARCCFPAGOS.Autorizacion   := apex_json.get_varchar2(p_values => L_ValorFormaPago,
                                                             p_path   => '[%d].autorizacion',
                                                             p0       => i);
      Lr_ARCCFPAGOS.Cod_Bco_Cia    := apex_json.get_varchar2(p_values => L_ValorFormaPago,
                                                             p_path   => '[%d].codBcoCia',
                                                             p0       => i);
      Lr_ARCCFPAGOS.Campo_Deposito := apex_json.get_varchar2(p_values => L_ValorFormaPago,
                                                             p_path   => '[%d].campoDeposito',
                                                             p0       => i);

      Lr_ARCCFPAGOS.No_Docu_Deposito := apex_json.get_varchar2(p_values => L_ValorFormaPago,
                                                               p_path   => '[%d].noDocuDeposito',
                                                               p0       => i);
      Lr_ARCCFPAGOS.Ref_Fecha        := TO_DATE(apex_json.get_varchar2(p_values => L_ValorFormaPago,
                                                                       p_path   => '[%d].refFecha',
                                                                       p0       => i),
                                                'DD-MM-YYYY');

      Lr_ARCCFPAGOS.Ref_Cod_Banco := apex_json.get_varchar2(p_values => L_ValorFormaPago,
                                                            p_path   => '[%d].refCodBanco',
                                                            p0       => i);

      Lr_ARCCFPAGOS.Cod_t_c    := apex_json.get_varchar2(p_values => L_ValorFormaPago,
                                                         p_path   => '[%d].codTC',
                                                         p0       => i);
      Lr_ARCCFPAGOS.Ref_Cuenta := apex_json.get_varchar2(p_values => L_ValorFormaPago,
                                                         p_path   => '[%d].refCuenta',
                                                         p0       => i);

      Ln_LineaFPago         := Ln_LineaFPago + 1;
      Lr_ARCCFPAGOS.No_Cia  := Pv_NoCia;
      Lr_ARCCFPAGOS.No_Docu := Lv_NoDocu;
      Lr_ARCCFPAGOS.Linea   := Ln_LineaFPago;

      OPEN C_DEPOSITO(Lr_ARCCFPAGOS.No_Docu_Deposito,
                      Lr_ARCCFPAGOS.Campo_Deposito);
      FETCH C_DEPOSITO
        INTO Lc_reg1;
      IF C_DEPOSITO%NOTFOUND THEN
        Ld_fecha := null;
      ELSE
        Ld_fecha := Lc_reg1.fecha;
      END IF;
      CLOSE c_deposito;

      IF ld_fecha IS NOT NULL THEN
        Lv_MensajeError := 'Deposito Nro. ' || Lr_ARCCFPAGOS.Autorizacion ||
                           ' ya se encuentra registrado para la cuenta ' ||
                           Lr_ARCCFPAGOS.Campo_Deposito || ' - Fecha ' ||
                           TO_CHAR(Ld_fecha, 'DD/MM/YYYY');
        Raise Le_Error;
      END IF;

      P_INSERTA_ARCCFPAGOS(Lr_ARCCFPAGOS, Lv_CodError, Lv_MensajeError);
      IF Lv_CodError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
        Lv_MensajeError := 'Error en P_INSERTA_ARCCFPAGOS:' ||
                           Lv_MensajeError;
        Raise Le_Error;
      END IF;

    END LOOP;

    Lclob_ListReferencia := Pclob_ListReferencia;

    apex_json.parse(p_values => L_ValorReferencia,
                    p_source => Lclob_ListReferencia);

    Ln_ContadorReferencia := apex_json.get_count(p_values => L_ValorReferencia,
                                                 p_path   => '.');

    FOR I in 1 .. Ln_ContadorReferencia LOOP
      Lr_ARCCRD.Tipo_Refe := apex_json.get_varchar2(p_values => L_ValorReferencia,
                                                    p_path   => '[%d].tipoRefe',
                                                    p0       => i);
      Lv_SerieFisicoRefe  := apex_json.get_varchar2(p_values => L_ValorReferencia,
                                                    p_path   => '[%d].noSerie',
                                                    p0       => i);
      Lv_NoFisicoRefe     := apex_json.get_varchar2(p_values => L_ValorReferencia,
                                                    p_path   => '[%d].noFisico',
                                                    p0       => i);
      Lr_ARCCRD.Monto     := NVL(apex_json.get_varchar2(p_values => L_ValorReferencia,
                                                        p_path   => '[%d].monto',
                                                        p0       => i),
                                 0);
      Ln_SumReferencia    := Ln_SumReferencia + Lr_ARCCRD.Monto;

      --
      Lr_ARCCRD.No_Cia   := Pv_NoCia;
      Lr_ARCCRD.Tipo_Doc := Pv_TipoDoc;
      Lr_ARCCRD.No_Docu  := Lv_NoDocu;

      IF C_DATOS_REFE%ISOPEN THEN
        CLOSE C_DATOS_REFE;
      END IF;
      OPEN C_DATOS_REFE(Lr_ARCCRD.Tipo_Refe,
                        Lv_NoFisicoRefe,
                        Lv_SerieFisicoRefe,
                        Pv_Grupo,
                        Lv_NoCliente,
                        Lr_ARCCMD.Sub_Cliente);
      FETCH C_DATOS_REFE
        INTO Lr_DatosRefe;
      IF C_DATOS_REFE%NOTFOUND THEN
        Lv_MensajeError := 'Documento con saldo no existe para el cliente: ' ||
                           Lv_NoCliente || ' en C_DATOS_REFE para: ' ||
                           Lr_ARCCRD.Tipo_Refe || ' ' || Lv_NoFisicoRefe || ' ' ||
                           Lv_SerieFisicoRefe || ' ' || Pv_Grupo || ' ' ||
                           Lv_NoCliente || ' ' || Lr_ARCCMD.Sub_Cliente;
        Raise Le_Error;
      END IF;

      CLOSE C_DATOS_REFE;
      Lr_ARCCRD.No_Refe       := Lr_DatosRefe.No_Docu;
      Lr_ARCCRD.Fecha_Vence   := Lr_DatosRefe.Fecha_Vence;
      Lr_ARCCRD.Ind_Procesado := 'S';
      Lr_ARCCRD.Fec_Aplic     := Lr_ARCCMD.Fecha;
      Lr_ARCCRD.Ano           := Lr_ARCCMD.Ano;
      Lr_ARCCRD.Mes           := Lr_ARCCMD.Mes;
      Lr_ARCCRD.Monto_Refe    := Lr_ARCCRD.Monto;
      Lr_ARCCRD.Moneda_Refe   := 'P';

      P_INSERTA_ARCCRD(Lr_ARCCRD, Lv_CodError, Lv_MensajeError);
      IF Lv_CodError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
        Lv_MensajeError := 'Error en P_INSERTA_ARCCRD: ' || Lv_MensajeError;
        Raise Le_Error;
      END IF;
      Lr_Dividendo.No_Cia     := Lr_ARCCRD.No_Cia;
      Lr_Dividendo.Tipo_Doc   := Lr_ARCCRD.Tipo_Doc;
      Lr_Dividendo.No_Docu    := Lr_ARCCRD.No_Docu;
      Lr_Dividendo.Tipo_Refe  := Lr_ARCCRD.Tipo_Refe;
      Lr_Dividendo.Monto_Refe := Lr_ARCCRD.Monto_Refe;
      Lr_Dividendo.No_Refe    := Lr_ARCCRD.No_Refe;
      Ln_Dividendo            := Ln_Dividendo + 1;
      Lr_Dividendo.Dividendo  := Ln_Dividendo;
      P_INSERTA_DIVIDENDO(Lr_Dividendo, Lv_CodError, Lv_MensajeError);
      IF Lv_CodError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
        Lv_MensajeError := 'Error en P_INSERTA_ARCCRD: ' || Lv_MensajeError;
        Raise Le_Error;
      END IF;

    END LOOP;

    Lclob_ListRetencion := Pclob_ListRetencion;

    apex_json.parse(p_values => L_ValorRetencion,
                    p_source => Lclob_ListRetencion);

    Ln_ContadorRetencion := apex_json.get_count(p_values => L_ValorRetencion,
                                                p_path   => '.');
    IF NVL(Ln_ContadorRetencion, 0) > 0 THEN

      FOR I in 1 .. Ln_ContadorRetencion LOOP
        Lr_ARCCTI.Clave   := apex_json.get_varchar2(p_values => L_ValorRetencion,
                                                    p_path   => '[%d].clave',
                                                    p0       => i);
        Lr_ARCCTI.Monto   := NVL(apex_json.get_varchar2(p_values => L_ValorRetencion,
                                                        p_path   => '[%d].monto',
                                                        p0       => i),
                                 0);
        Ln_TotalRetencion := Ln_TotalRetencion + Lr_ARCCTI.Monto;
        Lr_ARCCTI.Base    := NVL(apex_json.get_varchar2(p_values => L_ValorRetencion,
                                                        p_path   => '[%d].base',
                                                        p0       => i),
                                 0);

        Lr_ARCCTI.No_Serie := apex_json.get_varchar2(p_values => L_ValorRetencion,
                                                     p_path   => '[%d].noSerie',
                                                     p0       => i);

        Lr_ARCCTI.No_Fisico := apex_json.get_varchar2(p_values => L_ValorRetencion,
                                                      p_path   => '[%d].noFisico',
                                                      p0       => i);

        Lr_ARCCTI.No_Autorizacion := apex_json.get_varchar2(p_values => L_ValorRetencion,
                                                            p_path   => '[%d].noAutorizacion',
                                                            p0       => i);
        Lr_ARCCTI.Fecha_Emision   := TO_DATE(apex_json.get_varchar2(p_values => L_ValorRetencion,
                                                                    p_path   => '[%d].fechaEmision',
                                                                    p0       => i),
                                             'DD-MM-YYYY');
        Lr_ARCCTI.Fecha_Vigencia  := TO_DATE(apex_json.get_varchar2(p_values => L_ValorRetencion,
                                                                    p_path   => '[%d].fechaVigencia',
                                                                    p0       => i),
                                             'DD-MM-YYYY');

        IF Lr_ARCCTI.Clave IS NOT NULL THEN
          Lr_ARCCTI.No_Cia     := Pv_NoCia;
          Lr_ARCCTI.Grupo      := Pv_Grupo;
          Lr_ARCCTI.No_Cliente := Lv_NoCliente;
          Lr_ARCCTI.Tipo_Doc   := Pv_TipoDoc;
          Lr_ARCCTI.No_Docu    := Lv_NoDocu;
          Lr_ARCCTI.No_Refe    := Lr_ARCCRD.No_Refe;

          IF C_ARCGIMP%ISOPEN THEN
            CLOSE C_ARCGIMP;
          END IF;
          OPEN C_ARCGIMP(Lr_ARCCTI.Clave);
          FETCH C_ARCGIMP
            INTO Lr_Arcgimp;
          IF C_ARCGIMP%NOTFOUND THEN
            Lv_MensajeError := ' No se encontr� impuesto en C_ARCGIMP ';
            Raise Le_Error;
          END IF;
          CLOSE C_ARCGIMP;

          Lr_ARCCTI.Porcentaje       := Lr_Arcgimp.Porcentaje;
          Lr_ARCCTI.Sri_Imp_Renta    := Lr_Arcgimp.Sri_Retimp_Renta;
          Lr_ARCCTI.Usuario_Registra := Pv_UsuarioCreacion;
          Lr_ARCCTI.Tstamp           := Sysdate;

          P_INSERTA_ARCCTI(Lr_ARCCTI, Lv_CodError, Lv_MensajeError);
          IF Lv_CodError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
            Lv_MensajeError := 'Error en P_INSERTA_ARCCTI:' ||
                               Lv_MensajeError;
            Raise Le_Error;
          END IF;

          IF C_MONTO_RET%ISOPEN THEN
            CLOSE C_MONTO_RET;
          END IF;
          OPEN C_MONTO_RET(Lv_NoCliente, Lv_NoDocu, Lr_ARCCRD.No_Refe);
          FETCH C_MONTO_RET
            INTO Ln_Tot_Ret;
          IF C_MONTO_RET%NOTFOUND OR NVL(Ln_Tot_Ret, 0) = 0 THEN
            Lv_MensajeError := ' No se encontr� Total Ret para Cliente:' ||
                               Lv_NoCliente || ' Grupo: ' || Pv_Grupo ||
                               ' Cobro: ' || Lv_NoDocu || ' Fact. Refe: ' ||
                               Lr_ARCCRD.No_Refe || ' Empresa: ' ||
                               Pv_NoCia;
            Raise Le_Error;
          END IF;
          CLOSE C_MONTO_RET;

        END IF;
      END LOOP;

      IF Ln_TotalRetencion > 0 THEN
        Lr_ARCCFPAGOS               := NULL;
        Lr_ARCCFPAGOS.Id_Forma_Pago := 'RE';
        Lr_ARCCFPAGOS.Valor         := Ln_TotalRetencion;
        Lr_ARCCFPAGOS.No_Cia        := Pv_NoCia;
        Lr_ARCCFPAGOS.No_Docu       := Lv_NoDocu;
        Lr_ARCCFPAGOS.Linea         := Ln_LineaFPago + 1;

        P_INSERTA_ARCCFPAGOS(Lr_ARCCFPAGOS, Lv_CodError, Lv_MensajeError);
        IF Lv_CodError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
          Lv_MensajeError := 'Error en P_INSERTA_ARCCFPAGOS:' ||
                             Lv_MensajeError;
          Raise Le_Error;
        END IF;
      END IF;

    END IF;
    Lclob_ListDetContable := Pclob_ListDetalleContable;

    apex_json.parse(p_values => L_ValorDetContable,
                    p_source => Lclob_ListDetContable);

    Ln_ContadorDetContable := apex_json.get_count(p_values => L_ValorDetContable,
                                                  p_path   => '.');

    FOR I in 1 .. Ln_ContadorDetContable LOOP
      Lr_ARCCDC.Codigo := apex_json.get_varchar2(p_values => L_ValorDetContable,
                                                 p_path   => '[%d].codigo',
                                                 p0       => i);

      IF NOT CUENTA_CONTABLE.EXISTE(Pv_NoCia, Lr_ARCCDC.Codigo) THEN
        Lv_MensajeError := 'Cuenta no existe o no esta activa';
        Raise Le_Error;
      END IF;

      Lr_ARCCDC.Tipo  := apex_json.get_varchar2(p_values => L_ValorDetContable,
                                                p_path   => '[%d].tipo',
                                                p0       => i);
      Lr_ARCCDC.Monto := NVL(apex_json.get_varchar2(p_values => L_ValorDetContable,
                                                    p_path   => '[%d].monto',
                                                    p0       => i),
                             0);

      IF Lr_ARCCDC.Tipo = 'C' THEN
        Ln_SumCredito := Ln_SumCredito + Lr_ARCCDC.Monto;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                             'GEK_MIGRACION.P_MIGRACION_CC',
                                             'Lr_ARCCDC.Tipo: ' ||
                                             Lr_ARCCDC.Tipo ||
                                             ' Lr_ARCCDC.Monto: ' ||
                                             Lr_ARCCDC.Monto ||
                                             ' Ln_SumCredito: ' ||
                                             Ln_SumCredito,
                                             GEK_CONSULTA.F_RECUPERA_LOGIN,
                                             SYSDATE,
                                             GEK_CONSULTA.F_RECUPERA_IP);

      ELSE
        Ln_SumDebito := Ln_SumDebito + Lr_ARCCDC.Monto;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                             'GEK_MIGRACION.P_MIGRACION_CC',
                                             'Lr_ARCCDC.Tipo: ' ||
                                             Lr_ARCCDC.Tipo ||
                                             ' Lr_ARCCDC.Monto: ' ||
                                             Lr_ARCCDC.Monto ||
                                             ' Ln_SumDebito: ' ||
                                             Ln_SumDebito,
                                             GEK_CONSULTA.F_RECUPERA_LOGIN,
                                             SYSDATE,
                                             GEK_CONSULTA.F_RECUPERA_IP);
      END IF;

      Lr_ARCCDC.No_Cia       := Pv_NoCia;
      Lr_ARCCDC.Centro       := Pv_Centro;
      Lr_ARCCDC.Tipo_Doc     := Pv_TipoDoc;
      Lr_ARCCDC.Periodo      := Lr_ARCCMD.Periodo;
      Lr_ARCCDC.Ruta         := Lr_ARCCMD.Ruta;
      Lr_ARCCDC.No_Docu      := Lv_NoDocu;
      Lr_ARCCDC.Grupo        := Pv_Grupo;
      Lr_ARCCDC.No_Cliente   := Lv_NoCliente;
      Lr_ARCCDC.Monto_Dol    := Lr_ARCCDC.Monto;
      Lr_ARCCDC.Tipo_Cambio  := 1;
      Lr_ARCCDC.Ind_Con      := 'P';
      Lr_ARCCDC.Centro_Costo := '000000000';

      P_INSERTA_ARCCDC(Lr_ARCCDC, Lv_CodError, Lv_MensajeError);
      IF Lv_CodError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
        Lv_MensajeError := 'Error en P_INSERTA_ARCCDC:' || Lv_MensajeError;
        Raise Le_Error;
      END IF;

    END LOOP;

    IF Ln_SumCredito = Ln_SumDebito THEN
      Lr_ARCCMD.Total_Cr := Ln_SumCredito;
      Lr_ARCCMD.Total_Db := Ln_SumDebito;
    ELSE
      Lv_MensajeError := 'Debito: ' || Ln_SumDebito || ' y  Cr�dito: ' ||
                         Ln_SumCredito || ' diferentes.';
      Raise Le_Error;
    END IF;
    --Ln_TotalRetencion
    Lr_ARCCMD.Exento     := NVL(Ln_SumFormaPago, 0) +
                            NVL(Ln_TotalRetencion, 0);
    Lr_ARCCMD.m_Original := NVL(Ln_SumFormaPago, 0) +
                            NVL(Ln_TotalRetencion, 0);
    Lr_ARCCMD.Tot_Ret    := Ln_Tot_Ret;

    --Ln_SumFormaPago := 0;
    Ln_LineaFPago := 0;

    Lr_ARCCMD.Saldo     := NVL((Ln_SumReferencia - Ln_SumFormaPago), 0);
    Lr_ARCCMD.Total_Ref := NVL(Ln_SumReferencia, 0);

    P_ACTUALIZA_ARCCMD(Lr_ARCCMD,
                       Lv_formulario,
                       Lv_CodError,
                       Lv_MensajeError);
    IF Lv_CodError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
      Lv_MensajeError := 'Error en P_INSERTA_ARCCDC:' || Lv_MensajeError;
      Raise Le_Error;
    END IF;
    COMMIT;

    CCACTUALIZA(Pv_NoCia, Pv_TipoDoc, Lv_NoDocu, Lv_MensajeError);
    IF Lv_CodError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
      Lv_MensajeError := 'Error Docu No: ' || Pv_TipoDoc || '-' ||
                         Lv_NoDocu || ' en ccactualiza: ' ||
                         Lv_MensajeError;
      Raise Le_Error;
    ELSE
      COMMIT;
    END IF;

    CCPRORRATEA_FP_FACT(Pv_NoCia, Lv_NoDocu, Pv_TipoDoc, Lv_MensajeError);
    IF Lv_CodError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
      Lv_MensajeError := 'Error en CCPRORRATEA_FP_FACT:' || Lv_MensajeError;
      Raise Le_Error;
    ELSE
      COMMIT;
    END IF;

    OPEN C_SALDO(Lr_ARCCRD.Tipo_Refe,
                 Lv_NoFisicoRefe,
                 Lv_SerieFisicoRefe,
                 Pv_Grupo,
                 Lv_NoCliente,
                 Lr_ARCCMD.Sub_Cliente);
    FETCH C_SALDO
      INTO Ln_SaldoFactura;
    IF C_SALDO%NOTFOUND THEN
      Lv_MensajeError := 'Documento no Existe';
      Raise Le_Error;
    END IF;
    CLOSE C_SALDO;

    --    Lr_Factura.Saldo := NVL(Ln_SaldoFactura, 0) - NVL(Ln_SumFormaPago, 0);

    IF NVL(Ln_SaldoFactura, 0) < NVL(Ln_SumFormaPago, 0) THEN
      Pn_SaldoFactura := 0;
    ELSE
      Pn_SaldoFactura := NVL(Lr_Factura.Saldo, 0);
    END IF;

    Pv_Salida  := '200';
    Pv_Mensaje := 'Transaccion Exitosa';

  EXCEPTION
    WHEN Le_Error THEN
      Pn_SaldoFactura := 0;
      Pv_Mensaje      := Lv_MensajeError;
      Pv_Salida       := '403';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_MIGRACION_CC',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
      ROLLBACK;
    WHEN OTHERS THEN
      Pn_SaldoFactura := 0;
      Pv_Mensaje      := 'Error en GEK_MIGRACION.P_MIGRACION_CC: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      Pv_Salida       := '403';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_MIGRACION_CC',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
      ROLLBACK;
  END P_MIGRACION_CXC;

  PROCEDURE P_INSERTA_DIVIDENDO(Pr_Dividendo IN ARCCRD_DIVIDENDOS_MANUAL%ROWTYPE,
                                Pv_Salida    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCCRD_DIVIDENDOS_MANUAL
      (No_Cia,
       Tipo_Doc,
       No_Docu,
       Tipo_Refe,
       No_Refe,
       Monto_Refe,
       Dividendo,
       Tstamp)
    VALUES
      (Pr_Dividendo.No_cia,
       Pr_Dividendo.Tipo_Doc,
       Pr_Dividendo.No_Docu,
       Pr_Dividendo.Tipo_Refe,
       Pr_Dividendo.No_Refe,
       Pr_Dividendo.Monto_Refe,
       Pr_Dividendo.Dividendo,
       Sysdate);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error en GEK_MIGRACION.P_INSERTA_DIVIDENDO: ' ||
                    SQLERRM || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.P_INSERTA_DIVIDENDO',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_DIVIDENDO;
  PROCEDURE RHP_REGISTRA_HIST_DE_REINGRESO(Pv_NoCia   IN VARCHAR2,
                                           Pv_NoEmple IN VARCHAR2,
                                           Pv_Estado  IN VARCHAR2,
                                           PB_RHREMP  OUT BOOLEAN,
                                           Pv_Salida  OUT VARCHAR2,
                                           Pv_Mensaje OUT VARCHAR2) is

    CURSOR C_GET_ESTADO_ACT_EMP(CV_NOEMPLE VARCHAR2) IS
      SELECT A.ESTADO AS ESTADO_ACTUAL
        FROM NAF47_TNET.ARPLME A
       WHERE A.NO_EMPLE = CV_NOEMPLE;

    CURSOR C_GET_DATA_EMP(CV_NOEMPLE VARCHAR2, CV_CIA VARCHAR2) IS
      SELECT A.TIPO_EMP, A.F_EGRESO, A.MOTIVO_SALIDA
        FROM NAF47_TNET.ARPLME A
       WHERE NO_EMPLE = CV_NOEMPLE
         AND NO_CIA = CV_CIA
         AND ESTADO = 'I';

    LV_ESTADO_ACTUAL NAF47_TNET.ARPLME.ESTADO%TYPE;
    LV_TIPO_EMP      NAF47_TNET.ARPLME.TIPO_EMP%TYPE;
    LD_FECHA_EGRESO  NAF47_TNET.ARPLME.F_EGRESO%TYPE;
    LV_MOTIVO_SALIDA NAF47_TNET.ARPLME.MOTIVO_SALIDA%TYPE;

    LV_MENSAJE VARCHAR2(500);
    LE_ERROR EXCEPTION;

  BEGIN
    --CONSULTA EL ESTADO ACTUAL DEL EMPLEADO
    OPEN C_GET_ESTADO_ACT_EMP(Pv_NoEmple);
    FETCH C_GET_ESTADO_ACT_EMP
      INTO LV_ESTADO_ACTUAL;
    CLOSE C_GET_ESTADO_ACT_EMP;

    IF LV_ESTADO_ACTUAL IS NULL OR LV_ESTADO_ACTUAL = '' THEN
      LV_MENSAJE := 'No fue posible obtener el estado actual del empleado.';
      RAISE LE_ERROR;
    END IF;

    --COMPARA EL NUEVO ESTADO CON EL ESTADO ACTUAL DEL TRABAJADOR PARA IDENTIFICAR SI ES REINGRESO
    IF LV_ESTADO_ACTUAL = 'I' AND Pv_Estado = 'A' THEN
      --CONSULTA INFORMACION DEL EMPLEADO EN ESTADO INACTIVO
      OPEN C_GET_DATA_EMP(Pv_NoEmple, Pv_NoCia);
      FETCH C_GET_DATA_EMP
        INTO LV_TIPO_EMP, LD_FECHA_EGRESO, LV_MOTIVO_SALIDA;
      CLOSE C_GET_DATA_EMP;

      --SE REGISTRA EL REINGRESO
      INSERT INTO NAF47_TNET.PL_HIS_INGRESOS_EMPLEADO
        (NO_CIA,
         NO_EMPLE,
         F_INGRESO,
         F_EGRESO,
         TIPO_EMP,
         MO_SALIDA,
         ST_DATO,
         OBSERVACION)
      VALUES
        (Pv_NoCia,
         Pv_NoEmple,
         SYSDATE,
         LD_FECHA_EGRESO,
         LV_TIPO_EMP,
         LV_MOTIVO_SALIDA,
         NULL,
         NULL);

      PB_RHREMP := TRUE;
    END IF;
  EXCEPTION
    WHEN LE_ERROR THEN
      Pv_Salida  := '403';
      Pv_Mensaje := LV_MENSAJE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.RHP_REGISTRA_HIST_DE_REINGRESO',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_Salida  := '403';
      Pv_Mensaje := 'Error en GEK_MIGRACION.RHP_REGISTRA_HIST_DE_REINGRESO: ' ||
                    SQLERRM || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'GEK_MIGRACION.RHP_REGISTRA_HIST_DE_REINGRESO',
                                           Pv_Mensaje,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END;

end GEK_MIGRACION;
/