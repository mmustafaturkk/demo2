@EndUserText.label: 'Incoming Invoices'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_incoming_invoices
  provider contract transactional_query
  as projection on zetr_ddl_i_incoming_invoices
{
  key     DocumentUUID,
          @ObjectModel.text.element: ['CompanyTitle']
          CompanyCode,
          CompanyTitle,
          EnvelopeUUID,
          InvoiceUUID,
          InvoiceID,
          IntegratorUUID,
          QueryID,
          @ObjectModel.text.element: ['TaxpayerTitle']
          TaxID,
          Aliass,
          TaxpayerTitle,
          DocumentDate,
          ReceiveDate,
          @Semantics.amount.currencyCode: 'Currency'
          Amount,
          @Semantics.amount.currencyCode: 'Currency'
          TaxAmount,
          @Semantics.currencyCode: true
          Currency,
          ExchangeRate,
          ProfileID,
          InvoiceType,
          Printed,
          Processed,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ETR_INCINV_LIST_VIREL'
  virtual ReferenceDocumentType   : zetr_e_awtyp,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ETR_INCINV_LIST_VIREL'
  virtual ReferenceDocumentNumber : belnr_d,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ETR_INCINV_LIST_VIREL'
  virtual ReferenceDocumentYear   : gjahr,
          Archived,
          LastNote,
          @ObjectModel.text.element: ['LastNoteCreatedByName']
          LastNoteCreatedBy,
          LastNoteCreatedByName,
          @ObjectModel.text.element: ['ResponseStatusText']
          ResponseStatus,
          ResponseStatusText,
          ApplicationResponse,
          @ObjectModel.text.element: ['TRAStatusText']
          TRAStatusCode,
          TRAStatusText,
          StatusDetail,
//          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ETR_INCINV_LIST_VIREL'
//          @Semantics.largeObject: { mimeType      : 'MimeType',
//                                    fileName      : 'Filename',
//                                    contentDispositionPreference: #INLINE }
//  virtual PDFContent              : zetr_e_dcont,
//          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ETR_INCINV_LIST_VIREL'
//          @Semantics.mimeType: true
//  virtual MimeType                : zetr_e_mimet,
//          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ETR_INCINV_LIST_VIREL'
//  virtual Filename                : zetr_e_filename,
//          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ETR_INCINV_LIST_VIREL'
//  virtual OverallStatus           : zetr_e_staex,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ETR_INCINV_LIST_VIREL'
  virtual PDFContentUrl           : abap.string(0),
//          StatusCriticality,

          _invoiceLogs     : redirected to composition child zetr_ddl_p_incoming_invlogs,
          _invoiceContents : redirected to composition child zetr_ddl_p_incoming_invcont
}
