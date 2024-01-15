@EndUserText.label: 'Company Parameters'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_company_parameters
  //  provider contract transactional_query
  as projection on zetr_ddl_i_company_parameters
{
  key CompanyCode,      
  key CustomParameter,
      Value,
      _companyInformation : redirected to parent zetr_ddl_p_company_information
}
