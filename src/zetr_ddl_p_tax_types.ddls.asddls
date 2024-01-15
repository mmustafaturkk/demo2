@EndUserText.label: 'TRA Tax Types'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZETR_DDL_P_TAX_TYPES
  provider contract transactional_query
  as projection on ZETR_DDL_I_TAX_TYPES
{
  key TaxType,
      @ObjectModel.text.element: ['TaxCategoryText']
      TaxCategory,
      TaxCategoryText,
      ShortDescription,
      LongDescription
}
