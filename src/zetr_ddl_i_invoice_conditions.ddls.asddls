@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Conditions'
define root view entity zetr_ddl_i_invoice_conditions
  as select from    zetr_t_inv_cond                                                as Conditions
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_CNDTY' ) as ConditionCategory on  ConditionCategory.language  = $session.system_language
                                                                                                        and ConditionCategory.value_low = Conditions.cndty
    left outer join zetr_t_taxcx                                                   as TaxCode           on  TaxCode.spras = $session.system_language
                                                                                                        and TaxCode.taxty = Conditions.taxty
    left outer join I_ConditionTypeText                                            as ConditionType     on  ConditionType.Language             = $session.system_language
                                                                                                        and ConditionType.ConditionUsage       = 'A'
                                                                                                        and ConditionType.ConditionApplication = 'V'
                                                                                                        and ConditionType.ConditionType        = Conditions.kschl
  //composition of target_data_source_name as _association_name
{
  key Conditions.kschl                as ConditionType,
      ConditionType.ConditionTypeName as ConditionTypeText,
      Conditions.cndty                as ConditionCategory,
      ConditionCategory.text          as ConditionCategoryText,
      Conditions.taxty                as TaxType,
      TaxCode.stext                   as TaxTypeText
      //    _association_name // Make association public
}
