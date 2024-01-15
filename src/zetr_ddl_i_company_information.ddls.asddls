@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Company Information'
define root view entity zetr_ddl_i_company_information
  as select from zetr_t_cmpin
  composition [1..*] of zetr_ddl_i_company_identify   as _companyIdentification
  composition [1..*] of zetr_ddl_i_company_parameters as _companyParameters
{
  key bukrs   as CompanyCode,
      title   as Title,
      namef   as FirstName,
      namel   as LastName,
      sortl   as SearchTerm,
      taxof   as TaxOffice,
      distr   as District,
      street  as Street,
      blckn   as BlockName,
      bldnm   as BuildingName,
      bldno   as BuildingNo,
      roomn   as RoomNumber,
      pobox   as PostBox,
      subdv   as Subdivision,
      cityn   as CityName,
      pstcd   as PostCode,
      region  as Region,
      country as Country,
      telnm   as TelNumber,
      faxnm   as FaxNumber,
      email   as EMail,
      website as Website,
      _companyIdentification,
      _companyParameters
}
