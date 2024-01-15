@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TRA Tax Exemptions'
define root view entity ZETR_DDL_I_TAX_TYPES
  as select from    zetr_t_taxcd                                                   as Main
    left outer join zetr_t_taxcx                                                   as Text on  Text.spras = $session.system_language
                                                                                           and Text.taxty = Main.taxty
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_TAXCT' ) as Type on  Type.value_low = Main.taxct
                                                                                           and Type.language  = $session.system_language
  //composition of target_data_source_name as _association_name
{
  key Main.taxty as TaxType,
      Main.taxct as TaxCategory,
      Type.text  as TaxCategoryText,
      Text.stext as ShortDescription,
      Text.ltext as LongDescription
      //    _association_name // Make association public
}
