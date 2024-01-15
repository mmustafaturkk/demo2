@EndUserText.label: 'Finance Accounts'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_finance_accounts
  provider contract transactional_query
  as projection on zetr_ddl_i_finance_accounts
{
      @ObjectModel.text.element: ['ChartOfAccountsText']
  key ChartOfAccounts,
      @ObjectModel.text.element: ['GLAccountText']
  key GLAccount,
      ChartOfAccountsText,
      GLAccountText,
      @ObjectModel.text.element: ['AccountTypeText']
      AccountType,
      AccountTypeText,
      @ObjectModel.text.element: ['TaxTypeText']
      TaxType,
      TaxTypeText
}
