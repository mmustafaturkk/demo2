@EndUserText.label: 'TRA Unit Codes'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_unit_codes
  provider contract transactional_query
  as projection on zetr_ddl_i_unit_codes
{
  key UnitCode,
      Description
//      _unitCodeTexts
}
