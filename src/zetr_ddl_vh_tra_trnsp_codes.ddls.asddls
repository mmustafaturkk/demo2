//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TRA Tax Exemptions VH'
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'TransportCode',
                resultSet.sizeCategory: #XS,
                usageType.sizeCategory: #S,
                usageType.dataClass: #ORGANIZATIONAL,
                usageType.serviceQuality: #A,
                supportedCapabilities: [#VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY],
                modelingPattern: #VALUE_HELP_PROVIDER }

@Search.searchable: true
@Consumption.ranked: true
@Metadata.ignorePropagatedAnnotations: true
define view entity zetr_ddl_vh_tra_trnsp_codes
  as select from    zetr_t_trnsp as TransportCodes
    left outer join zetr_t_trnsx as TransportCodeTexts on  TransportCodeTexts.spras = $session.system_language
                                                       and TransportCodeTexts.trnsp = TransportCodes.trnsp
{
      @ObjectModel.text.element: ['Description']
      @UI.textArrangement: #TEXT_FIRST
  key TransportCodes.trnsp     as TransportCode,
      @Search.defaultSearchElement: true
      TransportCodeTexts.bezei as Description
}
