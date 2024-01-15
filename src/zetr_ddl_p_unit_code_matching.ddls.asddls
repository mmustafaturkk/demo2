@EndUserText.label: 'Unit Code Matching'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_unit_code_matching
  provider contract transactional_query
  as projection on zetr_ddl_i_unit_code_matching
{
      @ObjectModel.text.element: ['UnitOfMeasureText']
  key UnitOfMeasure,
      UnitOfMeasureText,
      @ObjectModel.text.element: ['UnitCodeText']
      UnitCode,
      UnitCodeText
}
