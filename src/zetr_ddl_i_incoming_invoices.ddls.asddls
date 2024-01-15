@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incoming Invoices'
define root view entity zetr_ddl_i_incoming_invoices
  as select from    zetr_t_icinv                                                   as Main
    left outer join zetr_t_cmpin                                                   as Company      on Company.bukrs = Main.bukrs
    left outer join zetr_ddl_i_tra_status_codes                                    as TRAStatus    on TRAStatus.StatusCode = Main.radsc
    left outer join zetr_ddl_c_invoice_user_names                                  as Taxpayer     on Taxpayer.TaxID = Main.taxid
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_RESST' ) as ResponseCode on  ResponseCode.language  = $session.system_language
                                                                                                   and ResponseCode.value_low = Main.resst
    left outer join I_BusinessUserBasic                                            as NoteUser     on NoteUser.UserID = Main.luser
  composition [1..*] of zetr_ddl_i_incoming_invlogs as _invoiceLogs
  composition [1..*] of zetr_ddl_i_incoming_invcont as _invoiceContents

{
  key Main.docui              as DocumentUUID,
      Main.bukrs              as CompanyCode,
      Company.sortl           as CompanyTitle,
      Main.envui              as EnvelopeUUID,
      Main.invui              as InvoiceUUID,
      Main.invno              as InvoiceID,
      Main.invii              as IntegratorUUID,
      Main.invqi              as QueryID,
      Main.taxid              as TaxID,
      Main.aliass             as Aliass,
      Taxpayer.Title          as TaxpayerTitle,
      Main.bldat              as DocumentDate,
      Main.recdt              as ReceiveDate,
      Main.wrbtr              as Amount,
      Main.fwste              as TaxAmount,
      Main.waers              as Currency,
      Main.kursf              as ExchangeRate,
      Main.prfid              as ProfileID,
      Main.invty              as InvoiceType,
      Main.prntd              as Printed,
      Main.procs              as Processed,
      Main.archv              as Archived,
      Main.lnote              as LastNote,
      Main.luser              as LastNoteCreatedBy,
      NoteUser.PersonFullName as LastNoteCreatedByName,      
      Main.resst              as ResponseStatus,
      ResponseCode.text       as ResponseStatusText,
      Main.apres              as ApplicationResponse,
      Main.radsc              as TRAStatusCode,
      TRAStatus.Description   as TRAStatusText,
      Main.staex              as StatusDetail,
//      case
//      when Main.resst = '1' or Main.resst = 'R' or Main.resst = 'K' or Main.resst = 'G' then 1
//      when Main.resst = '0' then 2
//      when Main.procs = '' then 2
//      when Main.procs = 'X' or Main.archv = 'X' then 3
//      else 0
//      end                     as StatusCriticality,
      _invoiceLogs,
      _invoiceContents
}
