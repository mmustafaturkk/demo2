//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TRA Unit Exemptions VH'
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'UnitCode',
                resultSet.sizeCategory: #XS,
                usageType.sizeCategory: #S,
                usageType.dataClass: #ORGANIZATIONAL,
                usageType.serviceQuality: #A,
                supportedCapabilities: [#VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY],
                modelingPattern: #VALUE_HELP_PROVIDER }

@Search.searchable: true
@Consumption.ranked: true
@Metadata.ignorePropagatedAnnotations: true
define view entity zetr_ddl_vh_tra_unit_codes
  as select from    zetr_t_units as UnitCodes
    left outer join zetr_t_unitx as UnitCodeTexts on  UnitCodeTexts.spras = $session.system_language
                                                  and UnitCodeTexts.unitc = UnitCodes.unitc
{
  key UnitCodes.unitc     as UnitCode,
      @Search.defaultSearchElement: true
      UnitCodeTexts.bezei as Description
}
