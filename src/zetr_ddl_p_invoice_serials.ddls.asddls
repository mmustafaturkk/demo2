@EndUserText.label: 'eInvoice Serials'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_invoice_serials
  as projection on zetr_ddl_i_invoice_serials
{
  key CompanyCode,
  key SerialPrefix,
      Description,
      NextSerial,
      MainSerial,
      NumberRangeNumber,
      SerialType,
      /* Associations */
      _eInvoiceParameters : redirected to parent zetr_ddl_p_invoice_parameters
}
