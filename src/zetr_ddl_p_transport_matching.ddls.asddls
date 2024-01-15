@EndUserText.label: 'Transport Code Matching'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_transport_matching
  provider contract transactional_query 
  as projection on zetr_ddl_i_transport_matching
{
      @ObjectModel.text.element: ['ShippingTypeText']
  key ShippingType,
      ShippingTypeText,
      @ObjectModel.text.element: ['TransportTypeText']
      TransportType,
      TransportTypeText
}
