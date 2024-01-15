@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outgoing Invoices'
define root view entity zetr_ddl_i_outgoing_invoices
  as select from    zetr_t_oginv                                                   as Main
  //composition of target_data_source_name as _association_name
    left outer join I_BusinessPartner                                              as Partner      on Partner.BusinessPartner = Main.partner
  //    left outer join zetr_ddl_c_invoice_user_names                                  as RegisteredUsers on RegisteredUsers.TaxID = Main.taxid
    left outer join ZETR_DDL_I_TAX_TYPES                                           as TaxCode      on TaxCode.TaxType = Main.taxty
    left outer join zetr_ddl_i_tax_exemptions                                      as TaxExemption on TaxExemption.ExemptionCode = Main.taxex
    left outer join zetr_ddl_i_tra_status_codes                                    as TRAStatus    on TRAStatus.StatusCode = Main.radsc
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_STACD' ) as StatusCode   on  StatusCode.language  = $session.system_language
                                                                                                   and StatusCode.value_low = Main.stacd
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_RESST' ) as ResponseCode on  ResponseCode.language  = $session.system_language
                                                                                                   and ResponseCode.value_low = Main.resst
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_EATYP' ) as eArchiveType on  eArchiveType.language  = $session.system_language
                                                                                                   and eArchiveType.value_low = Main.eatyp
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_AWTYP' ) as DocumentType on  DocumentType.language  = $session.system_language
                                                                                                   and DocumentType.value_low = Main.awtyp
    left outer join I_BillingDocumentTypeText                                      as BillDocType  on  BillDocType.Language            = $session.system_language
                                                                                                   and BillDocType.BillingDocumentType = Main.docty
    left outer join I_AccountingDocumentTypeText                                   as AccDocType   on  AccDocType.Language               = $session.system_language
                                                                                                   and AccDocType.AccountingDocumentType = Main.docty
    left outer join I_BusinessUserBasic                                            as BusinessUser on Main.ernam = BusinessUser.UserID
  composition [1..*] of zetr_ddl_i_outinv_logs as _invoiceLogs
{
  key Main.docui                                      as DocumentUUID,
      Main.bukrs                                      as CompanyCode,
      Main.belnr                                      as DocumentNumber,
      Main.gjahr                                      as FiscalYear,
      Main.awtyp                                      as DocumentType,
      DocumentType.text                               as DocumentTypeText,
      Main.docty                                      as ReferenceDocumentType,
      case Main.awtyp
        when 'VBRK'
             then BillDocType.BillingDocumentTypeName
             else AccDocType.AccountingDocumentTypeName
      end                                             as ReferenceDocumentTypeText,
      Main.werks                                      as Plant,
      Main.gsber                                      as BusinessArea,
      Main.vkorg                                      as SalesOrganization,
      Main.vtweg                                      as DistributionChannel,
      Main.partner                                    as PartnerNumber,
      Partner.OrganizationBPName1                     as PartnerName,
      Main.taxid                                      as TaxID,
      //      RegisteredUsers.Title                    as RegisteredUserTitle,
      Main.aliass                                     as Aliass,
      Main.bldat                                      as DocumentDate,
      Main.wrbtr                                      as Amount,
      Main.fwste                                      as TaxAmount,
      Main.kursf                                      as ExchangeRate,
      Main.waers                                      as Currency,
      Main.prfid                                      as ProfileID,
      Main.invty                                      as InvoiceType,
      Main.taxty                                      as TaxType,
      TaxCode.ShortDescription                        as TaxTypeText,
      Main.serpr                                      as SerialPrefix,
      cast( case when Main.prfid = 'EARSIV' or
                      Main.prfid = 'IHRACAT' or
                      Main.prfid = 'YOLCU' then Main.prfid
                 else 'YURTICI' end as zetr_e_insrt ) as SerialType,
      Main.xsltt                                      as XSLTTemplate,
      cast( case when Main.prfid = 'EARSIV' then Main.prfid
                 else 'EFATURA' end as zetr_e_insrt ) as XSLTType,
      Main.taxex                                      as TaxExemption,
      TaxExemption.Description                        as TaxExemptionText,
      Main.texex                                      as ExemptionExists,
      Main.revch                                      as Reversed,
      Main.revdt                                      as ReverseDate,
      Main.prntd                                      as Printed,
      Main.sndus                                      as Sender,
      Main.snddt                                      as SendDate,
      Main.sndtm                                      as SendTime,
      Main.inids                                      as InvoiceIDSaved,
      Main.itmcl                                      as CollectItems,
      Main.stacd                                      as StatusCode,
      StatusCode.text                                 as StatusCodeText,
      case when Main.resst = '0' then 2
           when Main.resst = 'X' or Main.resst = '2' then 3
           when Main.resst = '1' or Main.resst = 'R' or Main.resst = 'K' or Main.resst = 'G' then 1
           when Main.stacd <> ' ' and Main.stacd <> '2' then 2
           else 0
      end                                             as StatusCriticality,
      Main.staex                                      as StatusDetail,
      Main.resst                                      as Response,
      ResponseCode.text                               as ResponseText,
      cast(
      concat_with_space( StatusCode.text,
                         concat_with_space( case
                                              when ResponseCode.text <> ''
                                                then concat('(',concat(ResponseCode.text,')'))
                                              else '' end,
                                            case
                                              when Main.staex <> ''
                                                then concat('(',concat(Main.staex,')'))
                                              else '' end,
                                            1 ),
                         1 ) as zetr_e_staex )        as OverallStatus,
      Main.radsc                                      as TRAStatusCode,
      TRAStatus.Description                           as TRAStatusCodeText,
      Main.rsend                                      as Resendable,
      Main.raded                                      as ActualExportDate,
      Main.cedrn                                      as CustomsDocumentNo,
      Main.radrn                                      as CustomsReferenceNo,
      Main.invii                                      as IntegratorDocumentID,
      Main.rprid                                      as ReportID,
      Main.envui                                      as EnvelopeUUID,
      Main.invui                                      as InvoiceUUID,
      Main.invno                                      as InvoiceID,
      Main.eatyp                                      as eArchiveType,
      eArchiveType.text                               as eArchiveTypeText,
      Main.intsl                                      as InternetSale,
      Main.inote                                      as InvoiceNote,
      Main.ernam                                      as CreatedBy,
      BusinessUser.PersonFullName                     as CreatedByName,
      Main.erdat                                      as CreateDate,
      Main.erzet                                      as CreateTime,
      'https://www.sap.com'                           as ContentURL,
      _invoiceLogs // Make association public
}
