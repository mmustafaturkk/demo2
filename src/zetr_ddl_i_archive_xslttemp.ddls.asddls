@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eArchive XSLT Templates'
define view entity zetr_ddl_i_archive_xslttemp
  as select from zetr_t_eaxslt
  association to parent zetr_ddl_i_archive_parameters as _eArchiveParameters on $projection.CompanyCode = _eArchiveParameters.CompanyCode
{
  key bukrs as CompanyCode,
  key xsltt as XSLTTemplate,
      deflt as DefaultTemplate,
      _eArchiveParameters   
}
