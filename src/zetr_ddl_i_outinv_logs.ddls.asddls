@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outgoing Invoice Logs'
define view entity zetr_ddl_i_outinv_logs
  as select from    zetr_t_logs                                                    as Logs
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_LOGCD' ) as LogCode on  LogCode.language  = $session.system_language
                                                                                              and LogCode.value_low = Logs.logcd
    left outer join I_BusinessUserBasic                                            as User    on User.UserID = Logs.uname
  association to parent zetr_ddl_i_outgoing_invoices as _outgoingInvoices on $projection.DocumentUUID = _outgoingInvoices.DocumentUUID
{
  key Logs.logui          as LogUUID,
      Logs.docui          as DocumentUUID,
      Logs.uname          as CreatedBy,
      User.PersonFullName as UserFullName,
      Logs.datum          as CreationDate,
      Logs.uzeit          as CreationTime,
      Logs.logcd          as LogCode,
      LogCode.text        as LogCodeDescription,
      Logs.lnote          as LogNote,
      _outgoingInvoices // Make association public
}
