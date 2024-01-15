@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eDelivery XSLT Templates'
define view entity zetr_ddl_i_delivery_xslttemp
  as select from zetr_t_edxslt
  association to parent zetr_ddl_i_delivery_parameters as _eDeliveryParameters on $projection.CompanyCode = _eDeliveryParameters.CompanyCode
{
  key bukrs as CompanyCode,
  key xsltt as XSLTTemplate,
      deflt as DefaultTemplate,
      _eDeliveryParameters // Make association public
}
