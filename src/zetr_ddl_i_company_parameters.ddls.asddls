@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Company Parameters'
define view entity zetr_ddl_i_company_parameters
  as select from zetr_t_cmpcp
  association to parent zetr_ddl_i_company_information as _companyInformation on $projection.CompanyCode = _companyInformation.CompanyCode
{
  key bukrs as CompanyCode,
  key cuspa as CustomParameter,
      value as Value,
      _companyInformation 
}
