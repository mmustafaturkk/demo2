@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transport Code Matching'
define root view entity zetr_ddl_i_transport_matching
  as select from    zetr_t_trnmc       as Matching
    left outer join zetr_t_trnsx       as Transport on  Transport.spras = $session.system_language
                                                    and Matching.trnsp  = Transport.trnsp
    left outer join I_ShippingTypeText as Shipping  on  Shipping.Language     = $session.system_language
                                                    and Shipping.ShippingType = Matching.vsart
  //composition of target_data_source_name as _association_name
{
  key Matching.vsart            as ShippingType,
      Shipping.ShippingTypeName as ShippingTypeText,
      Matching.trnsp            as TransportType,
      Transport.bezei           as TransportTypeText
      //    _association_name // Make association public
}
