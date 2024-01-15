@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Other partner data'
define root view entity zetr_ddl_i_other_partner
  as select from    zetr_t_othp                                                    as Partners
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_PRTTY' ) as PartnerType on  PartnerType.language  = $session.system_language
                                                                                                  and PartnerType.value_low = Partners.prtty
  //composition of target_data_source_name as _association_name
{
  key Partners.taxid   as TaxID,
      Partners.prtty   as PartnerType,
      PartnerType.text as PartnerTypeText,
      Partners.title   as Title,
      Partners.namef   as FirstName,
      Partners.namel   as LastName,
      Partners.taxof   as TaxOffice,
      Partners.distr   as District,
      Partners.street  as Street,
      Partners.blckn   as BlockName,
      Partners.bldnm   as BuildingName,
      Partners.bldno   as BuildingNo,
      Partners.roomn   as RoomNumber,
      Partners.pobox   as PostBox,
      Partners.subdv   as Subdivision,
      Partners.cityn   as CityName,
      Partners.pstcd   as PostCode,
      Partners.region  as Region,
      Partners.country as Country,
      Partners.telnm   as TelNumber,
      Partners.faxnm   as FaxNumber,
      Partners.email   as EMail,
      Partners.website as Website
      //_association_name // Make association public
}
