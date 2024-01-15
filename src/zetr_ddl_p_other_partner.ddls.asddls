@EndUserText.label: 'Other partner information'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zetr_ddl_p_other_partner
  provider contract transactional_query
  as projection on zetr_ddl_i_other_partner
{
  key TaxID,
      @ObjectModel.text.element: ['PartnerTypeText']
      PartnerType,
      PartnerTypeText,
      Title,
      FirstName,
      LastName,
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
      Website
}
