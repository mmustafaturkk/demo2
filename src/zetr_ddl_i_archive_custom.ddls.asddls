@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eArchive Custom Parameters'
define view entity zetr_ddl_i_archive_custom
  as select from zetr_t_eacus
  association to parent zetr_ddl_i_archive_parameters as _eArchiveParameters on $projection.CompanyCode = _eArchiveParameters.CompanyCode
{
  key bukrs as CompanyCode,
  key cuspa as CustomParameter,
      value as Value,
      _eArchiveParameters
}
