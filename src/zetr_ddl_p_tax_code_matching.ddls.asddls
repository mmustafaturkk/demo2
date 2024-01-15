@EndUserText.label: 'Tax Code Matching'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_tax_code_matching
  provider contract transactional_query
  as projection on zetr_ddl_i_tax_code_matching
{
  key TaxProcedure,
  key TaxCode,
      @ObjectModel.text.element: ['TaxTypeText']
      TaxType,
      TaxTypeText,
      TaxRate,
      @ObjectModel.text.element: ['TaxExemptionText']
      TaxExemption,
      TaxExemptionText,
      InvoiceType,
      @ObjectModel.text.element: ['ParentTaxTypeText']
      ParentTaxType,
      ParentTaxTypeText,
      ParentTaxRate
}
