@EndUserText.label: 'eDelivery Rules'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_delivery_rules
  as projection on zetr_ddl_i_delivery_rules
{
  key CompanyCode,
      @ObjectModel.text.element: ['RuleTypeText']
  key RuleType,
  key RuleItemNumber,
      RuleTypeText,
      RuleDescription,
      @ObjectModel.text.element: ['ReferenceDocumentTypeText']
      ReferenceDocumentType,
      ReferenceDocumentTypeText,
      ProfileIDInput,
      eDeliveryTypeInput,
      @ObjectModel.text.element: ['SalesOrganizationName']
      SalesOrganization,
      SalesOrganizationName,
      @ObjectModel.text.element: ['DistributionChannelName']
      DistributionChannel,
      DistributionChannelName,
      @ObjectModel.text.element: ['PlantName']
      Plant,
      PlantName,
      @ObjectModel.text.element: ['StorageLocationName']
      StorageLocation,
      StorageLocationName,
      @ObjectModel.text.element: ['ReceivingPlantName']
      ReceivingPlant,
      ReceivingPlantName,
      @ObjectModel.text.element: ['ReceivingStorageLocationName']
      ReceivingStorageLocation,
      ReceivingStorageLocationName,
      @ObjectModel.text.element: ['SpecialStockTypeName']
      SpecialStockType,
      SpecialStockTypeName,
      @ObjectModel.text.element: ['MovementTypeName']
      MovementType,
      MovementTypeName,
      @ObjectModel.text.element: ['DeliveryTypeName']
      DeliveryType,
      DeliveryTypeName,
      @ObjectModel.text.element: ['GoodsMovementTypeName']
      GoodsMovementType,
      GoodsMovementTypeName,
      @ObjectModel.text.element: ['AccountingDocumentTypeName']
      AccountingDocumentType,
      AccountingDocumentTypeName,
      @ObjectModel.text.element: ['PartnerNmae']
      Partner,
      PartnerNmae,
      ProfileID,
      eDeliveryType,
      Exclude,
      @ObjectModel.text.element: ['SerialPrefixText']
      SerialPrefix,
      SerialPrefixText,
      XSLTTemplate,
      Note, 
      /* Associations */
      _eDeliveryParameters : redirected to parent zetr_ddl_p_delivery_parameters
}
