@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eDelivery Custom Parameters'
define view entity zetr_ddl_i_delivery_custom
  as select from zetr_t_edcus
  association to parent zetr_ddl_i_delivery_parameters as _eDeliveryParameters on $projection.CompanyCode = _eDeliveryParameters.CompanyCode
{
  key bukrs as CompanyCode,
  key cuspa as CustomParameter,
      value as Value,
      _eDeliveryParameters // Make association public
}
