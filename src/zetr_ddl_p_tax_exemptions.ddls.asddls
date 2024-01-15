@EndUserText.label: 'TRA Tax Exemptions'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_tax_exemptions
  provider contract transactional_query
  as projection on zetr_ddl_i_tax_exemptions
{
  key ExemptionCode,
      @ObjectModel.text.element: ['ExemptionTypeText']
      ExemptionType,
      ExemptionTypeText,
      Description
}
