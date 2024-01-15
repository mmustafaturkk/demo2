@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eDelivery Serials'
define view entity zetr_ddl_i_delivery_serials
  as select from zetr_t_edser
  association to parent zetr_ddl_i_delivery_parameters as _eDeliveryParameters on $projection.CompanyCode = _eDeliveryParameters.CompanyCode
{
  key bukrs as CompanyCode,
  key serpr as SerialPrefix,
      descr as Description,
      nxtsp as NextSerial,
      maisp as MainSerial,
      numrn as NumberRangeNumber,
      _eDeliveryParameters
}
