//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eInvoice Profile F4'
@ObjectModel: { dataCategory: #VALUE_HELP,
                resultSet.sizeCategory: #XS,
                representativeKey: 'ProfileID',
                usageType.sizeCategory: #S,
                usageType.dataClass: #ORGANIZATIONAL,
                usageType.serviceQuality: #A,
                supportedCapabilities: [#VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY],
                modelingPattern: #VALUE_HELP_PROVIDER }

@Search.searchable: true
@Consumption.ranked: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZETR_DDL_VH_DELIVERY_PROFILE
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_DLPRF' )
{
      @ObjectModel.text.element: ['Description']
      @UI.textArrangement: #TEXT_FIRST
  key cast( value_low as zetr_e_dlprf ) as ProfileID,
      @Search.defaultSearchElement: true
      text                              as Description
}
