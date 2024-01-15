//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TRA Tax Exemptions VH'
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'ConditionType',
                usageType.sizeCategory: #S,
                usageType.dataClass: #ORGANIZATIONAL,
                usageType.serviceQuality: #A,
                supportedCapabilities: [#VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY],
                modelingPattern: #VALUE_HELP_PROVIDER }

@Search.searchable: true
@Consumption.ranked: true
@Metadata.ignorePropagatedAnnotations: true
define view entity zetr_ddl_vh_condition_types
  as select from    I_ConditionType     as ConditionTypes
    left outer join I_ConditionTypeText as ConditionTypeText on  ConditionTypeText.Language      = $session.system_language
                                                             and ConditionTypeText.ConditionType = ConditionTypes.ConditionType
{
  key ConditionTypes.ConditionType,
      @Search.defaultSearchElement: true
      ConditionTypeText.ConditionTypeName
}
where
      ConditionTypes.ConditionUsage       = 'A'
  and ConditionTypes.ConditionApplication = 'V'
