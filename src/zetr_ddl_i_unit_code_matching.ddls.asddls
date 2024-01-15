@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unit Code Matching'
define root view entity zetr_ddl_i_unit_code_matching
  as select from    zetr_t_untmc        as Matching
    left outer join I_UnitOfMeasureText as UnitOfMeasureText on  UnitOfMeasureText.Language      = $session.system_language
                                                             and UnitOfMeasureText.UnitOfMeasure = Matching.meins
    left outer join zetr_t_unitx        as UnitCode          on  UnitCode.spras = $session.system_language
                                                             and UnitCode.unitc = Matching.unitc
  //composition of target_data_source_name as _association_name
{
  key Matching.meins                      as UnitOfMeasure,
      UnitOfMeasureText.UnitOfMeasureName as UnitOfMeasureText,
      Matching.unitc                      as UnitCode,
      UnitCode.bezei                      as UnitCodeText
      //    _association_name // Make association public
}
