@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TRA Unit Codes'
define root view entity zetr_ddl_i_unit_codes
  as select from    zetr_t_units as Main
    left outer join zetr_t_unitx as Text on  Text.spras = $session.system_language
                                         and Text.unitc = Main.unitc
{
  key Main.unitc as UnitCode,
      Text.bezei as Description
}
