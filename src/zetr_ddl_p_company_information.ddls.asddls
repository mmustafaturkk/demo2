@EndUserText.label: 'Company Information'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_company_information
  provider contract transactional_query
  as projection on zetr_ddl_i_company_information
{      
  key CompanyCode,
      Title,
      FirstName,
      LastName,
      SearchTerm,
      TaxOffice,
      District,
      Street,
      BlockName,
      BuildingName,
      BuildingNo,
      RoomNumber,
      PostBox,
      Subdivision,
      CityName,
      PostCode,
      Region,
      Country,
      TelNumber,
      FaxNumber,
      EMail,
      Website,
      _companyIdentification : redirected to composition child zetr_ddl_p_company_identify,
      _companyParameters     : redirected to composition child zetr_ddl_p_company_parameters
}
