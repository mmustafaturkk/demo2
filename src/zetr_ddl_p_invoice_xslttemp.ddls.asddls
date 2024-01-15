@EndUserText.label: 'eInvoice XSLT Templates'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_invoice_xslttemp
  as projection on zetr_ddl_i_invoice_xslttemp
{
  key CompanyCode,
  key XSLTTemplate,
      DefaultTemplate,
      /* Associations */
      _eInvoiceParameters : redirected to parent zetr_ddl_p_invoice_parameters
}
