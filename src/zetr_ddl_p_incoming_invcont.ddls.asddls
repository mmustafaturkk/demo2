@EndUserText.label: 'Incoming Invoice Contents'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_incoming_invcont
  as projection on zetr_ddl_i_incoming_invcont
{
  key     DocumentUUID,
  key     ContentType,
          CompanyCode,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ETR_INCINV_CONT_VIREL'
          @Semantics.largeObject: { mimeType      : 'MimeType',
                                    fileName      : 'Filename',
                                    contentDispositionPreference: #INLINE }
  virtual Content : zetr_e_dcont,
          @Semantics.mimeType: true
          MimeType,
          Filename,
          ArchiveUUID,
          /* Associations */
          _incomingInvoices : redirected to parent zetr_ddl_p_incoming_invoices
}
