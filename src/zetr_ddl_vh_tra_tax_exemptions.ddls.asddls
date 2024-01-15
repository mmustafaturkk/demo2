//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TRA Tax Exemptions VH'
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'TaxExemption',
                usageType.sizeCategory: #S,
                usageType.dataClass: #ORGANIZATIONAL,
                usageType.serviceQuality: #A,
                supportedCapabilities: [#VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY],
                modelingPattern: #VALUE_HELP_PROVIDER }

@Search.searchable: true
@Consumption.ranked: true
@Metadata.ignorePropagatedAnnotations: true
define view entity zetr_ddl_vh_tra_tax_exemptions
  as select from    zetr_t_taxex as TaxExemptions
    left outer join zetr_t_taxed as TaxExemptionTexts on  TaxExemptionTexts.spras = $session.system_language
                                                      and TaxExemptionTexts.taxex = TaxExemptions.taxex
{
  key TaxExemptions.taxex     as TaxExemption,
      @Search.defaultSearchElement: true
      TaxExemptionTexts.bezei as Description
}
