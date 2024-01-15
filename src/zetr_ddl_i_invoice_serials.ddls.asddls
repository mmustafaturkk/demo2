@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eInvoice Serials'
define view entity zetr_ddl_i_invoice_serials
  as select from zetr_t_eiser
  association to parent zetr_ddl_i_invoice_parameters as _eInvoiceParameters on $projection.CompanyCode = _eInvoiceParameters.CompanyCode
{
  key bukrs as CompanyCode,
  key serpr as SerialPrefix,
      descr as Description,
      nxtsp as NextSerial,
      maisp as MainSerial,
      numrn as NumberRangeNumber,
      insrt as SerialType,
      _eInvoiceParameters
}
