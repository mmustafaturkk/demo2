@EndUserText.label: 'eArchive Rules'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_archive_rules
  as projection on zetr_ddl_i_archive_rules
{
  key CompanyCode,
      @ObjectModel.text.element: ['RuleTypeText']
  key RuleType,
  key RuleItemNumber,
      RuleTypeText,
      RuleDescription,
      @ObjectModel.text.element: ['ReferenceDocumentTypeText']
      ReferenceDocumentType,
      ReferenceDocumentTypeText,
      InvoiceTypeInput,
      @ObjectModel.text.element: ['SalesOrganizationName']
      SalesOrganization,
      SalesOrganizationName,
      @ObjectModel.text.element: ['DistributionChannelName']
      DistributionChannel,
      DistributionChannelName,
      @ObjectModel.text.element: ['PlantName']
      Plant,
      PlantName,
      @ObjectModel.text.element: ['BillingDocumentTypeName']
      BillingDocumentType,
      BillingDocumentTypeName,
      @ObjectModel.text.element: ['InvoiceReceiptTypeName']
      InvoiceReceiptType,
      InvoiceReceiptTypeName,
      @ObjectModel.text.element: ['AccountingDocumentTypeName']
      AccountingDocumentType,
      AccountingDocumentTypeName,
      @ObjectModel.text.element: ['PartnerNmae']
      Partner,
      PartnerNmae,
      SalesDocument,
      InvoiceType,
      @ObjectModel.text.element: ['ExemptionTypeText']
      TaxExemption,
      ExemptionTypeText,
      Exclude,
      @ObjectModel.text.element: ['SerialPrefixText']
      SerialPrefix,
      SerialPrefixText,
      XSLTTemplate,
      Note,
      _eArchiveParameters : redirected to parent zetr_ddl_p_archive_parameters
}
