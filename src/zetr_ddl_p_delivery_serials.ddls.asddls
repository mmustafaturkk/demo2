@EndUserText.label: 'eDelivery Serials'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_delivery_serials
  as projection on zetr_ddl_i_delivery_serials
{
  key CompanyCode,
  key SerialPrefix,
      Description,
      NextSerial,
      MainSerial,
      NumberRangeNumber,
      /* Associations */
      _eDeliveryParameters : redirected to parent zetr_ddl_p_delivery_parameters 
}
