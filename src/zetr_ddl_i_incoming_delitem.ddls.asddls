@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incoming Delivery Items'
define view entity zetr_ddl_i_incoming_delitem
  as select from zetr_t_icdli
  association to parent zetr_ddl_i_incoming_delhead as _incomingDeliveries on $projection.DocumentUUID = _incomingDeliveries.DocumentUUID
{
  key docui as DocumentUUID,
  key linno as ItemNo,
      mdesc as MaterialDescription,
      descr as Description,
      buyii as BuyerItemIdentification,
      selii as SellerItemIdentification,
      manii as ManufacturerItemIdentification,
      netpr as Price,
      waers as Currency,
      menge as Quantity,
      meins as UnitOfMeasure,
      recqt as ReceivedQuantity,
      napqt as UnacceptableQuantity,
      misqt as MissingQuantity,
      ovsqt as ExcessQuantity,
      rejpd as RejectedProductDescription,
      ldlvc as LateDeliveryCompliant,
      _incomingDeliveries // Make association public
}
