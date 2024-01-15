@EndUserText.label: 'eInvoice Custom Parameters'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_invoice_custom
  as projection on zetr_ddl_i_invoice_custom
{
  key CompanyCode,
  key CustomParameter,
      Value,
      /* Associations */
      _eInvoiceParameters : redirected to parent zetr_ddl_p_invoice_parameters
}
