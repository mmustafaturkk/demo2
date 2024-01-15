@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eArchive Serials'
define view entity zetr_ddl_i_archive_serials
  as select from zetr_t_easer
  association to parent zetr_ddl_i_archive_parameters as _eArchiveParameters on $projection.CompanyCode = _eArchiveParameters.CompanyCode
{
  key bukrs as CompanyCode,
  key serpr as SerialPrefix,
      descr as Description,
      nxtsp as NextSerial,
      maisp as MainSerial,
      numrn as NumberRangeNumber,
      _eArchiveParameters
}
