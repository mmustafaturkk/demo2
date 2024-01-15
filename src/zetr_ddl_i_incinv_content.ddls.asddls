@EndUserText.label: 'Incoming Invoice Contents'
@ObjectModel.query.implementedBy:'ABAP:ZCL_ETR_INCINV_QUERY'
//@Search.searchable: true
//@UI:{
//headerInfo:{
//                typeNamePlural: 'Incoming Invoice Contents',
//                typeName: 'Incoming Invoice Contents',
//                title:{ type: #STANDARD, label: 'Incoming Invoice Contents', value: 'Filename' }
//           }
//}
define custom entity zetr_ddl_i_incinv_content
  // with parameters parameter_name : parameter_type
{
      @UI.facet         : [ { id:              'InvoiceContent',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Invoice Content',
                     position:        10 } ]
      @UI.hidden        : true
  key DocumentUUID      : sysuuid_c22;
      @UI               : { lineItem:       [ { position: 1 } ],
                            identification: [ { position: 1 } ] }
      //      @UI.hidden        : true
  key ContentType       : zetr_e_dctyp;
      @Semantics.largeObject: { mimeType      : 'MimeType',
                                fileName      : 'Filename',
                                contentDispositionPreference: #INLINE }
      @UI               : { lineItem:       [ { position: 3 } ],
                            identification: [{ position: 3 }] }
      DocumentContent   : abap.rawstring(0);
      @Semantics.mimeType: true
      @UI.hidden        : true
      MimeType          : zetr_e_mimet;
      @UI               : { identification: [{ position: 2 }] }
      Filename          : zetr_e_filename;
      _incomingInvoices : association to parent zetr_ddl_i_incinv_list on $projection.DocumentUUID = _incomingInvoices.DocumentUUID;
}
