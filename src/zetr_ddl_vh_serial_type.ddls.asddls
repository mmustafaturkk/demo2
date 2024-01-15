//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eInvoice Serial Type F4'
@ObjectModel: { dataCategory: #VALUE_HELP,
                resultSet.sizeCategory: #XS,
                representativeKey: 'SerialType',
                usageType.sizeCategory: #S,
                usageType.dataClass: #ORGANIZATIONAL,
                usageType.serviceQuality: #A,
                supportedCapabilities: [#VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY],
                modelingPattern: #VALUE_HELP_PROVIDER }

@Search.searchable: true
@Consumption.ranked: true
@Metadata.ignorePropagatedAnnotations: true
define view entity zetr_ddl_vh_serial_type
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_INSRT' )
{
      @ObjectModel.text.element: ['Description']
      @UI.textArrangement: #TEXT_FIRST
  key cast( value_low as zetr_e_insrt ) as SerialType,
      @Search.defaultSearchElement: true
      text                              as Description
}
