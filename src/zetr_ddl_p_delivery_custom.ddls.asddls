@EndUserText.label: 'eDelivery Custom Parameters'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_delivery_custom
  as projection on zetr_ddl_i_delivery_custom
{
  key CompanyCode,
  key CustomParameter,
      Value,
      /* Associations */
      _eDeliveryParameters : redirected to parent zetr_ddl_p_delivery_parameters 
}
