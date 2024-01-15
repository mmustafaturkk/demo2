@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TRA Transport Codes'
define root view entity zetr_ddl_i_transport_codes
  as select from    zetr_t_trnsp as Main
    left outer join zetr_t_trnsx as Text on  Text.spras = $session.system_language
                                         and Text.trnsp = Main.trnsp
  //composition of target_data_source_name as _association_name
{
  key Main.trnsp as TransportCode,
      Text.bezei as Description
      //    _association_name // Make association public
}
