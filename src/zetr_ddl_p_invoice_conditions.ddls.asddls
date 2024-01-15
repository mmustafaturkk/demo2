@EndUserText.label: 'Invoice Conditions'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_invoice_conditions
  provider contract transactional_query
  as projection on zetr_ddl_i_invoice_conditions
{
      @ObjectModel.text.element: ['ConditionTypeText']
  key ConditionType,
      ConditionTypeText,
      @ObjectModel.text.element: ['ConditionCategoryText']
      ConditionCategory,
      ConditionCategoryText,
      @ObjectModel.text.element: ['TaxTypeText']
      TaxType,
      TaxTypeText
}
