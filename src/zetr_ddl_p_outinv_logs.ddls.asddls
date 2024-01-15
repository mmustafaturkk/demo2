@EndUserText.label: 'Outgoing Invoice Logs'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_outinv_logs
  as projection on zetr_ddl_i_outinv_logs
{
  key LogUUID,
      DocumentUUID,
      @ObjectModel.text.element: ['UserFullName']
      CreatedBy,
      UserFullName,
      CreationDate,
      CreationTime,
      @ObjectModel.text.element: ['LogCodeDescription']
      LogCode,
      LogCodeDescription,
      LogNote,
      /* Associations */
      _outgoingInvoices : redirected to parent zetr_ddl_p_outgoing_invoices
}
