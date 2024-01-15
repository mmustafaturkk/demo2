@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incoming Delivery Contents'
define view entity zetr_ddl_i_incoming_delcont
  as select from    zetr_t_arcd  as Archive
    left outer join zetr_t_icdlv as Delivery on Delivery.docui = Archive.docui
  association to parent zetr_ddl_i_incoming_delhead as _incomingDeliveries on $projection.DocumentUUID = _incomingDeliveries.DocumentUUID
{
  key Archive.docui                               as DocumentUUID,
  key Archive.conty                               as ContentType,
      Delivery.bukrs                              as CompanyCode,
      Archive.contn                               as Content,
      cast(
      case Archive.conty when 'PDF' then 'application/pdf'
                 when 'UBL' then 'text/xml'
                 when 'HTML' then 'text/html'
                 else '' end as zetr_e_mimet )    as MimeType,
      cast(
      case Archive.conty when 'PDF' then concat( Delivery.dlvno, '.pdf' )
                 when 'UBL' then concat( Delivery.dlvno, '.xml' )
                 when 'HTML' then concat( Delivery.dlvno, '.html' )
                 else '' end as zetr_e_filename ) as Filename,
      Archive.arcid                               as ArchiveUUID,
      _incomingDeliveries // Make association public
}
