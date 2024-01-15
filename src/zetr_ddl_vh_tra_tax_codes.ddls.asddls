//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TRA Tax Exemptions VH'
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'TaxCode',
                usageType.sizeCategory: #S,
                usageType.dataClass: #ORGANIZATIONAL,
                usageType.serviceQuality: #A,
                supportedCapabilities: [#VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY],
                modelingPattern: #VALUE_HELP_PROVIDER }

@Search.searchable: true
@Consumption.ranked: true
@Metadata.ignorePropagatedAnnotations: true
define view entity zetr_ddl_vh_tra_tax_codes
  as select from    zetr_t_taxcd as TaxCodes
    left outer join zetr_t_taxcx as TaxCodeTexts on  TaxCodeTexts.spras = $session.system_language
                                                 and TaxCodeTexts.taxty = TaxCodes.taxty
{
  key TaxCodes.taxty     as TaxCode,
      TaxCodeTexts.stext as ShortDescription,
      @Search.defaultSearchElement: true      
      TaxCodeTexts.ltext as LongDescription
}
