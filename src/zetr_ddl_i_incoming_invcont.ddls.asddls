@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incoming Invoice Contents'
define view entity zetr_ddl_i_incoming_invcont
  as select from    zetr_t_arcd  as Archive
    left outer join zetr_t_icinv as Invoice on Invoice.docui = Archive.docui
  association to parent zetr_ddl_i_incoming_invoices as _incomingInvoices on $projection.DocumentUUID = _incomingInvoices.DocumentUUID
{
  key Archive.docui                               as DocumentUUID,
  key Archive.conty                               as ContentType,
      Invoice.bukrs                               as CompanyCode,
      Archive.contn                               as Content,
      cast(
      case Archive.conty when 'PDF' then 'application/pdf'
                 when 'UBL' then 'text/xml'
                 when 'HTML' then 'text/html'
                 else '' end as zetr_e_mimet )    as MimeType,
      cast(
      case Archive.conty when 'PDF' then concat( Invoice.invno, '.pdf' )
                 when 'UBL' then concat( Invoice.invno, '.xml' )
                 when 'HTML' then concat( Invoice.invno, '.html' )
                 else '' end as zetr_e_filename ) as Filename,
      Archive.arcid                               as ArchiveUUID,
      _incomingInvoices // Make association public
}
