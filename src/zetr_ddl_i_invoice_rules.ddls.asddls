@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eInvoice Rules'
define view entity zetr_ddl_i_invoice_rules
  as select from    zetr_t_eirules                                                 as Rules
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_AWTYP' ) as RefDocType   on  RefDocType.language  = $session.system_language
                                                                                                   and RefDocType.value_low = Rules.awtyp
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_RULET' ) as RuleType     on  RuleType.language  = $session.system_language
                                                                                                   and RuleType.value_low = Rules.rulet
    left outer join I_SalesOrganizationText                                        as SalesOrg     on  SalesOrg.Language          = $session.system_language
                                                                                                   and SalesOrg.SalesOrganization = Rules.vkorg
    left outer join I_DistributionChannelText                                      as DistChannel  on  DistChannel.Language            = $session.system_language
                                                                                                   and DistChannel.DistributionChannel = Rules.vtweg
    left outer join I_Plant                                                        as Plant        on Plant.Plant = Rules.werks
    left outer join I_BillingDocumentTypeText                                      as BillDocType  on  BillDocType.Language            = $session.system_language
                                                                                                   and BillDocType.BillingDocumentType = Rules.sddty
    left outer join I_AccountingDocumentTypeText                                   as InvRecType   on  InvRecType.Language               = $session.system_language
                                                                                                   and InvRecType.AccountingDocumentType = Rules.mmdty
    left outer join I_AccountingDocumentTypeText                                   as AccDocType   on  AccDocType.Language               = $session.system_language
                                                                                                   and AccDocType.AccountingDocumentType = Rules.fidty
    left outer join I_BusinessPartner                                              as Partner      on Partner.BusinessPartner = Rules.partner
    left outer join zetr_ddl_i_tax_exemptions                                      as TaxExemption on TaxExemption.ExemptionCode = Rules.taxex
    left outer join zetr_ddl_i_invoice_serials                                     as Serials      on  Serials.CompanyCode  = Rules.bukrs
                                                                                                   and Serials.SerialPrefix = Rules.serpr
  association to parent zetr_ddl_i_invoice_parameters as _eInvoiceParameters on $projection.CompanyCode = _eInvoiceParameters.CompanyCode
{
  key Rules.bukrs                           as CompanyCode,
  key Rules.rulet                           as RuleType,
  key Rules.rulen                           as RuleItemNumber,
      RuleType.text                         as RuleTypeText,
      Rules.descr                           as RuleDescription,
      Rules.awtyp                           as ReferenceDocumentType,
      RefDocType.text                       as ReferenceDocumentTypeText,
      Rules.pidin                           as ProfileIDInput,
      Rules.ityin                           as InvoiceTypeInput,
      Rules.vkorg                           as SalesOrganization,
      SalesOrg.SalesOrganizationName        as SalesOrganizationName,
      Rules.vtweg                           as DistributionChannel,
      DistChannel.DistributionChannelName   as DistributionChannelName,
      Rules.werks                           as Plant,
      Plant.PlantName                       as PlantName,
      Rules.sddty                           as BillingDocumentType,
      BillDocType.BillingDocumentTypeName   as BillingDocumentTypeName,
      Rules.mmdty                           as InvoiceReceiptType,
      InvRecType.AccountingDocumentTypeName as InvoiceReceiptTypeName,
      Rules.fidty                           as AccountingDocumentType,
      AccDocType.AccountingDocumentTypeName as AccountingDocumentTypeName,
      Rules.partner                         as Partner,
      Partner.OrganizationBPName1           as PartnerNmae,
      Rules.vbeln                           as SalesDocument,
      Rules.pidou                           as ProfileID,
      Rules.ityou                           as InvoiceType,
      Rules.taxex                           as TaxExemption,
      TaxExemption.ExemptionTypeText        as ExemptionTypeText,
      Rules.excld                           as Exclude,
      Rules.serpr                           as SerialPrefix,
      Serials.Description                   as SerialPrefixText,
      Rules.xsltt                           as XSLTTemplate,
      Rules.note                            as Note,
      _eInvoiceParameters
}
