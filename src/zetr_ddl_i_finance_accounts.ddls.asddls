@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Finance Accounts'
define root view entity zetr_ddl_i_finance_accounts
  as select from    zetr_t_fiacc                                                   as GLAccounts
  //composition of target_data_source_name as _association_name
    left outer join I_ChartOfAccountsText                                          as ChartOfAccountsText on  ChartOfAccountsText.Language        = $session.system_language
                                                                                                          and ChartOfAccountsText.ChartOfAccounts = GLAccounts.ktopl
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_ACCTY' ) as AccountType         on  AccountType.language  = $session.system_language
                                                                                                          and AccountType.value_low = GLAccounts.accty
    left outer join zetr_t_taxcx                                                   as TaxCode             on  TaxCode.spras = $session.system_language
                                                                                                          and TaxCode.taxty = GLAccounts.taxty
    left outer join I_GLAccountText                                                as GLAccountText       on  GLAccountText.Language        = $session.system_language
                                                                                                          and GLAccountText.ChartOfAccounts = GLAccounts.ktopl
                                                                                                          and GLAccountText.GLAccount       = GLAccounts.saknr
{
  key GLAccounts.ktopl                        as ChartOfAccounts,
  key GLAccounts.saknr                        as GLAccount,
      ChartOfAccountsText.ChartOfAccountsName as ChartOfAccountsText,
      GLAccountText.GLAccountName             as GLAccountText,
      GLAccounts.accty                        as AccountType,
      AccountType.text                        as AccountTypeText,
      GLAccounts.taxty                        as TaxType,
      TaxCode.stext                           as TaxTypeText
      //    _association_name // Make association public
}
