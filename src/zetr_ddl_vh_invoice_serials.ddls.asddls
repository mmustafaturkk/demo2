//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Serials VH'
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'SerialPrefix',
                usageType.sizeCategory: #S,
                usageType.dataClass: #ORGANIZATIONAL,
                usageType.serviceQuality: #A,
                supportedCapabilities: [#VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY],
                modelingPattern: #VALUE_HELP_PROVIDER }

@Search.searchable: true
@Consumption.ranked: true
@Metadata.ignorePropagatedAnnotations: true
define view entity zetr_ddl_vh_invoice_serials
  as select from zetr_t_eiser as Serials
{
  key Serials.bukrs as CompanyCode,
      @Search.defaultSearchElement: true
  key Serials.serpr as SerialPrefix,
      Serials.descr as Description,
      Serials.maisp as MainSerial,
      Serials.insrt as SerialType
}

union all

select from zetr_t_easer as Serials
{
  key Serials.bukrs as CompanyCode,
  key Serials.serpr as SerialPrefix,
      Serials.descr as Description,
      Serials.maisp as MainSerial,
      'EARSIV'      as SerialType
}
