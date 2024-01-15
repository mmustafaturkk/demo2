@EndUserText.label: 'Incoming Invoice Logs'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_incoming_invlogs
  as projection on zetr_ddl_i_incoming_invlogs
{
  key LogUUID,
      DocumentUUID,
      @ObjectModel.text.element: ['UserFullName']
      CreatedBy,
      UserFullName,
      @ObjectModel.sort.enabled: true
      CreationDate,
      @ObjectModel.sort.enabled: true
      CreationTime,
      @ObjectModel.text.element: ['LogCodeDescription']
      LogCode,
      LogCodeDescription,
      LogNote,
      /* Associations */
      _incomingInvoices : redirected to parent zetr_ddl_p_incoming_invoices
}
