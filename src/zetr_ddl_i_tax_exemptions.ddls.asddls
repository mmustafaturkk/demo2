@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TRA Tax Exemptions'
define root view entity zetr_ddl_i_tax_exemptions
  as select from    zetr_t_taxex                                                   as Main
    left outer join zetr_t_taxed                                                   as Text on  Text.spras = $session.system_language
                                                                                           and Text.taxex = Main.taxex
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_TAXET' ) as Type on  Type.value_low = Main.taxet
                                                                                           and Type.language  = $session.system_language
  //composition of target_data_source_name as _association_name
{
  key Main.taxex as ExemptionCode,
      Main.taxet as ExemptionType,
      Type.text  as ExemptionTypeText,
      Text.bezei as Description
      //    _association_name // Make association public
}
