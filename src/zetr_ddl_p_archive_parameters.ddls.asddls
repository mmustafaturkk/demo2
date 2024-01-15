@EndUserText.label: 'eArchive Parameters'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_archive_parameters
  provider contract transactional_query
  as projection on zetr_ddl_i_archive_parameters
{
      @ObjectModel.text.element: ['CompanyTitle']
  key CompanyCode,
      CompanyTitle,
      ValidFrom,
      ValidTo,
      Integrator,
      WSEndpoint,
      WSEndpointAlt,
      WSUser,
      WSPassword,
      @ObjectModel.text.element: ['GenerateSerialText']
      GenerateSerial,
      GenerateSerialText,
      Barcode,
      /* Associations */
      _customParameters : redirected to composition child zetr_ddl_p_archive_custom,
      _invoiceSerials   : redirected to composition child zetr_ddl_p_archive_serials,
      _xsltTemplates    : redirected to composition child zetr_ddl_p_archive_xslttemp,
      _invoiceRules     : redirected to composition child zetr_ddl_p_archive_rules
}
