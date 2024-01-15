@EndUserText.label: 'TRA Transport Codes'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_transport_codes
  provider contract transactional_query
  as projection on zetr_ddl_i_transport_codes
{
  key TransportCode,
      Description
}
