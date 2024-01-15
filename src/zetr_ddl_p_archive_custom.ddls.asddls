@EndUserText.label: 'eArchive Custom Parameters'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_archive_custom
  as projection on zetr_ddl_i_archive_custom
{
  key CompanyCode,
  key CustomParameter,
      Value,
      /* Associations */
      _eArchiveParameters : redirected to parent zetr_ddl_p_archive_parameters
}
