@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eDelivery Rules'
define view entity zetr_ddl_i_delivery_rules
  as select from    zetr_t_edrules                                                 as Rules
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_AWTYP' ) as RefDocType               on  RefDocType.language  = $session.system_language
                                                                                                               and RefDocType.value_low = Rules.awtyp
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_RULET' ) as RuleType                 on  RuleType.language  = $session.system_language
                                                                                                               and RuleType.value_low = Rules.rulet
    left outer join I_SalesOrganizationText                                        as SalesOrg                 on  SalesOrg.Language          = $session.system_language
                                                                                                               and SalesOrg.SalesOrganization = Rules.vkorg
    left outer join I_DistributionChannelText                                      as DistChannel              on  DistChannel.Language            = $session.system_language
                                                                                                               and DistChannel.DistributionChannel = Rules.vtweg
    left outer join I_Plant                                                        as Plant                    on Plant.Plant = Rules.werks
    left outer join I_Plant                                                        as ReceivingPlant           on ReceivingPlant.Plant = Rules.umwrk
    left outer join I_StorageLocation                                              as StorageLocation          on  StorageLocation.Plant           = Rules.werks
                                                                                                               and StorageLocation.StorageLocation = Rules.lgort
    left outer join I_StorageLocation                                              as ReceivingStorageLocation on  ReceivingStorageLocation.Plant           = Rules.umwrk
                                                                                                               and ReceivingStorageLocation.StorageLocation = Rules.umlgo
    left outer join I_GoodsMovementTypeT                                           as MovementType             on  MovementType.Language          = $session.system_language
                                                                                                               and MovementType.GoodsMovementType = Rules.bwart
    left outer join I_InventorySpecialStockTypeT                                   as SpecialStockType         on  SpecialStockType.Language                  = $session.system_language
                                                                                                               and SpecialStockType.InventorySpecialStockType = Rules.sobkz
    left outer join I_DeliveryDocumentTypeText                                     as DelDocType               on  DelDocType.Language             = $session.system_language
                                                                                                               and DelDocType.DeliveryDocumentType = Rules.sddty
    left outer join I_AccountingDocumentTypeText                                   as GoodsType                on  GoodsType.Language               = $session.system_language
                                                                                                               and GoodsType.AccountingDocumentType = Rules.mmdty
    left outer join I_AccountingDocumentTypeText                                   as AccDocType               on  AccDocType.Language               = $session.system_language
                                                                                                               and AccDocType.AccountingDocumentType = Rules.fidty
    left outer join I_BusinessPartner                                              as Partner                  on Partner.BusinessPartner = Rules.partner
    left outer join zetr_ddl_i_delivery_serials                                    as Serials                  on  Serials.CompanyCode  = Rules.bukrs
                                                                                                               and Serials.SerialPrefix = Rules.serpr
  association to parent zetr_ddl_i_delivery_parameters as _eDeliveryParameters on $projection.CompanyCode = _eDeliveryParameters.CompanyCode

{
  key Rules.bukrs                                    as CompanyCode,
  key Rules.rulet                                    as RuleType,
  key Rules.rulen                                    as RuleItemNumber,
      RuleType.text                                  as RuleTypeText,
      Rules.descr                                    as RuleDescription,
      Rules.awtyp                                    as ReferenceDocumentType,
      RefDocType.text                                as ReferenceDocumentTypeText,
      Rules.pidin                                    as ProfileIDInput,
      Rules.dtyin                                    as eDeliveryTypeInput,
      Rules.vkorg                                    as SalesOrganization,
      SalesOrg.SalesOrganizationName                 as SalesOrganizationName,
      Rules.vtweg                                    as DistributionChannel,
      DistChannel.DistributionChannelName            as DistributionChannelName,
      Rules.werks                                    as Plant,
      Plant.PlantName                                as PlantName,
      Rules.lgort                                    as StorageLocation,
      StorageLocation.StorageLocationName            as StorageLocationName,
      Rules.umwrk                                    as ReceivingPlant,
      Plant.PlantName                                as ReceivingPlantName,
      Rules.umlgo                                    as ReceivingStorageLocation,
      StorageLocation.StorageLocationName            as ReceivingStorageLocationName,
      Rules.sobkz                                    as SpecialStockType,
      SpecialStockType.InventorySpecialStockTypeName as SpecialStockTypeName,
      Rules.bwart                                    as MovementType,
      MovementType.GoodsMovementTypeName             as MovementTypeName,
      Rules.sddty                                    as DeliveryType,
      DelDocType.DeliveryDocumentTypeName            as DeliveryTypeName,
      Rules.mmdty                                    as GoodsMovementType,
      GoodsType.AccountingDocumentTypeName           as GoodsMovementTypeName,
      Rules.fidty                                    as AccountingDocumentType,
      AccDocType.AccountingDocumentTypeName          as AccountingDocumentTypeName,
      Rules.partner                                  as Partner,
      Partner.OrganizationBPName1                    as PartnerNmae,
      Rules.pidou                                    as ProfileID,
      Rules.dtyou                                    as eDeliveryType,
      Rules.excld                                    as Exclude,
      Rules.serpr                                    as SerialPrefix,
      Serials.Description                            as SerialPrefixText,
      Rules.xsltt                                    as XSLTTemplate,
      Rules.note                                     as Note,
      _eDeliveryParameters // Make association public
}
