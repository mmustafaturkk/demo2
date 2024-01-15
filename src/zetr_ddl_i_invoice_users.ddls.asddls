@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eInvoice Registered Users'
define root view entity zetr_ddl_i_invoice_users
  as select from    zetr_t_inv_ruser                                               as Users
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_TXPTY' ) as TaxpayerType on  TaxpayerType.language  = $session.system_language
                                                                                                   and TaxpayerType.value_low = Users.txpty
{
  key Users.taxid       as TaxID,
  key Users.recno       as RecordNo,
      Users.aliass      as Aliass,
      Users.title       as Title,
      Users.regdt       as RegisterDate,
      Users.regtm       as RegisterTime, 
      Users.defal       as DefaultAlias,
      Users.txpty       as TaxpayerType,
      TaxpayerType.text as TaxpayerTypeText
}
