@EndUserText.label: 'Company Identification'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_p_company_identify
  //  provider contract transactional_query
  as projection on zetr_ddl_i_company_identify
{
  key CompanyCode,  
  key PartyIdentification,
      Value,
      _companyInformation : redirected to parent zetr_ddl_p_company_information
}
