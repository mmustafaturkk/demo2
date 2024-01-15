@EndUserText.label: 'eDelivery Registered Users'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_delivery_users
  provider contract transactional_query
  as projection on zetr_ddl_i_delivery_users
{
  key TaxID,
  key RecordNo,
      Aliass,
      Title,
      RegisterDate,
      RegisterTime,
      DefaultAlias,
      @ObjectModel.text.element: ['TaxpayerTypeText']
      TaxpayerType,
      TaxpayerTypeText
}
