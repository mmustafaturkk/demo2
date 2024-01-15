//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice XSLT VH'
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'XSLTTemplate',
                usageType.sizeCategory: #S,
                usageType.dataClass: #ORGANIZATIONAL,
                usageType.serviceQuality: #A,
                supportedCapabilities: [#VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY],
                modelingPattern: #VALUE_HELP_PROVIDER }

@Search.searchable: true
@Consumption.ranked: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZETR_DDL_VH_INVOICE_XSLT
  as select from zetr_t_eixslt as Templates
{
  key Templates.bukrs as CompanyCode,
      @Search.defaultSearchElement: true
  key Templates.xsltt as XSLTTemplate,
      Templates.deflt as DefaultTemplate,
      @UI.hidden: true
      'EFATURA'       as XSLTType
}

union all

select from zetr_t_eaxslt as Templates
{
  key Templates.bukrs as CompanyCode,
  key Templates.xsltt as XSLTTemplate,
      Templates.deflt as DefaultTemplate,
      'EARSIV'        as XSLTType
}
