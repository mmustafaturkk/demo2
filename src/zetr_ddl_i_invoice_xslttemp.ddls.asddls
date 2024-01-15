@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eInvoice XSLT Templates'
define view entity zetr_ddl_i_invoice_xslttemp
  as select from zetr_t_eixslt
  association to parent zetr_ddl_i_invoice_parameters as _eInvoiceParameters on $projection.CompanyCode = _eInvoiceParameters.CompanyCode
{
  key bukrs as CompanyCode,
  key xsltt as XSLTTemplate,
      deflt as DefaultTemplate,
      _eInvoiceParameters // Make association public
}
