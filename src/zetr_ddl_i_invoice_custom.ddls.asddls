@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eInvoice Custom Parameters'
define view entity zetr_ddl_i_invoice_custom
  as select from zetr_t_eicus
  association to parent zetr_ddl_i_invoice_parameters as _eInvoiceParameters on $projection.CompanyCode = _eInvoiceParameters.CompanyCode
{
  key bukrs as CompanyCode, 
  key cuspa as CustomParameter,
      value as Value,
      _eInvoiceParameters // Make association public
}
