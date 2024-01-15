@EndUserText.label: 'eDelivery Parameters'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_delivery_parameters
  provider contract transactional_query
  as projection on zetr_ddl_i_delivery_parameters
{
      @ObjectModel.text.element: ['CompanyTitle']
  key CompanyCode,
      CompanyTitle,
      ValidFrom,
      ValidTo,
      Integrator,
      ProfileID,
      WSEndpoint,
      WSEndpointAlt,
      WSUser,
      WSPassword,
      @ObjectModel.text.element: ['GenerateSerialText']
      GenerateSerial,
      GenerateSerialText, 
      Barcode,
      PKAlias,
      GBAlias,
      /* Associations */
      _customParameters : redirected to composition child zetr_ddl_p_delivery_custom,
      _deliverySerials  : redirected to composition child zetr_ddl_p_delivery_serials,
      _xsltTemplates    : redirected to composition child zetr_ddl_p_delivery_xslttemp,
      _deliveryRules    : redirected to composition child zetr_ddl_p_delivery_rules
}
