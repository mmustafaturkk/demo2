@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Company Identification'
define view entity zetr_ddl_i_company_identify
  as select from zetr_t_cmppi
  association to parent zetr_ddl_i_company_information as _companyInformation on $projection.CompanyCode = _companyInformation.CompanyCode
{
  key bukrs as CompanyCode,
  key prtid as PartyIdentification,
      value as Value,
      _companyInformation 
}
