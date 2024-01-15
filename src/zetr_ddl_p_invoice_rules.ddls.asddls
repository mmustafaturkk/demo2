@EndUserText.label: 'eInvoice Rules'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_invoice_rules
  as projection on zetr_ddl_i_invoice_rules
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
      ProfileIDInput,
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
      ProfileID,
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
      _eInvoiceParameters : redirected to parent zetr_ddl_p_invoice_parameters
}
