@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TRA Status Codes'
define root view entity zetr_ddl_i_tra_status_codes
  as select from    zetr_t_rasta as Main
    left outer join zetr_t_rastx as Text on  Text.spras = $session.system_language
                                         and Text.radsc = Main.radsc
  //composition of target_data_source_name as _association_name
{
  key Main.radsc as StatusCode,
      Main.rsend as Resendable,
      Main.rvrse as Reversable,
      Main.succs as Success,
      Text.bezei as Description
      //    _association_name // Make association public
}
