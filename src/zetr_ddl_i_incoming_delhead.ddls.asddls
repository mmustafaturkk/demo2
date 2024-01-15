@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incoming Deliveries'
define root view entity zetr_ddl_i_incoming_delhead
  as select from    zetr_t_icdlv                                                   as Main
    left outer join zetr_t_cmpin                                                   as Company       on Company.bukrs = Main.bukrs
    left outer join zetr_ddl_i_tra_status_codes                                    as TRAStatus     on TRAStatus.StatusCode = Main.radsc
    left outer join zetr_ddl_c_invoice_user_names                                  as Taxpayer      on Taxpayer.TaxID = Main.taxid
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_RESST' ) as ResponseCode  on  ResponseCode.language  = $session.system_language
                                                                                                    and ResponseCode.value_low = Main.resst
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_ITMRS' ) as ItemsResponse on  ItemsResponse.language  = $session.system_language
                                                                                                    and ItemsResponse.value_low = Main.itmrs
    left outer join I_BusinessUserBasic                                            as NoteUser      on NoteUser.UserID = Main.luser

  composition [1..*] of zetr_ddl_i_incoming_delitem as _deliveryItems
  composition [1..*] of zetr_ddl_i_incoming_delcont as _deliveryContents
  composition [1..*] of zetr_ddl_i_incoming_dellogs as _deliveryLogs
{
  key Main.docui            as DocumentUUID,
      Main.bukrs            as CompanyCode,
      Company.sortl         as CompanyTitle,
      Main.envui            as EnvelopeUUID,
      Main.dlvui            as DeliveryUUID,
      Main.dlvno            as DeliveryID,
      Main.dlvii            as IntegratorUUID,
      Main.dlvqi            as QueryID,
      Main.taxid            as TaxID,
      Main.aliass           as Aliass,
      Taxpayer.Title        as TaxpayerTitle,
      Main.bldat            as DocumentDate,
      Main.recdt            as ReceiveDate,
      Main.wrbtr            as Amount,
      Main.waers            as Currency,
      Main.prfid            as ProfileID,
      Main.dlvty            as DeliveryType,
      Main.prntd            as Printed,
      Main.procs            as Processed,
      Main.archv            as Archived,
      Main.lnote            as LatestNote,
      Main.luser            as LatestNoteCreatedBy,
      Main.resst            as ResponseStatus,
      ResponseCode.text     as ResponseStatusText,
      Main.radsc            as TRAStatusCode,
      TRAStatus.Description as TRAStatusText,
      Main.staex            as StatusDetail,
      Main.ruuid            as ResponseUUID,
      Main.itmrs            as ItemResponseStatus,
      ItemsResponse.text    as ItemResponseStatusText,
      _deliveryItems, // Make association public
      _deliveryContents, // Make association public
      _deliveryLogs // Make association public
}
