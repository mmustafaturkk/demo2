@EndUserText.label: 'Outgoing Invoices'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_outgoing_invoices
  provider contract transactional_query
  as projection on zetr_ddl_i_outgoing_invoices
{
  key DocumentUUID,
      CompanyCode,
      DocumentNumber,
      FiscalYear,
      @ObjectModel.text.element: ['DocumentTypeText']
      DocumentType,
      DocumentTypeText,
      @ObjectModel.text.element: ['ReferenceDocumentTypeText']
      ReferenceDocumentType,
      ReferenceDocumentTypeText,
      Plant,
      BusinessArea,
      SalesOrganization,
      DistributionChannel,
      @ObjectModel.text.element: ['PartnerName']
      PartnerNumber,
      PartnerName,
      //      @ObjectModel.text.element: ['RegisteredUserTitle']
      TaxID,
      //      RegisteredUserTitle,
      Aliass,
      DocumentDate,
      @Semantics.amount.currencyCode: 'Currency'
      Amount,
      @Semantics.amount.currencyCode: 'Currency'
      TaxAmount,
      ExchangeRate,
      @Semantics.currencyCode: true
      Currency,
      ProfileID,
      InvoiceType,
      @ObjectModel.text.element: ['TaxTypeText']
      TaxType,
      TaxTypeText,
      SerialPrefix,
      SerialType,
      XSLTTemplate,
      XSLTType,
      @ObjectModel.text.element: ['TaxExemptionText']
      TaxExemption,
      TaxExemptionText,
      ExemptionExists,
      Reversed,
      ReverseDate,
      Printed,
      Sender,
      SendDate,
      SendTime,
      InvoiceIDSaved,
      CollectItems,
      @ObjectModel.text.element: ['StatusCodeText']
      StatusCode,
      StatusCodeText,
      StatusCriticality,
      StatusDetail,
      OverallStatus,
      @ObjectModel.text.element: ['ResponseText']
      Response,
      ResponseText,
      @ObjectModel.text.element: ['TRAStatusCodeText']
      TRAStatusCode,
      TRAStatusCodeText,
      Resendable,
      ActualExportDate,
      CustomsDocumentNo,
      CustomsReferenceNo,
      IntegratorDocumentID,
      ReportID,
      EnvelopeUUID,
      InvoiceUUID,
      InvoiceID,
      @ObjectModel.text.element: ['eArchiveTypeText']
      eArchiveType,
      eArchiveTypeText,
      InternetSale,
      InvoiceNote,
      @ObjectModel.text.element: ['CreatedByName']
      CreatedBy,
      CreatedByName,
      CreateDate,
      CreateTime,
      ContentURL,

      _invoiceLogs : redirected to composition child zetr_ddl_p_outinv_logs
}
