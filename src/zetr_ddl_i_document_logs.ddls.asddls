@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Document Logs'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_i_document_logs
  as select from    zetr_t_logs                                                    as Log
    left outer join I_BusinessUserBasic                                            as User    on User.UserID = Log.uname
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_LOGCD' ) as LogCode on  LogCode.language  = $session.system_language
                                                                                              and LogCode.value_low = Log.logcd

{
  key Log.logui           as LogUUID,
      Log.docui           as DocumentUUID,
      Log.uname           as CreatedBy,
      User.PersonFullName as UserFullName,
      Log.datum           as CreationDate,
      Log.uzeit           as CreationTime,
      Log.logcd           as LogCode,
      LogCode.text        as LogCodeDescription,
      Log.lnote           as LogNote
}
