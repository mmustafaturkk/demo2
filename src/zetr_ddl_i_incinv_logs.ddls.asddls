@EndUserText.label: 'Incoming Invoice Logs'
@ObjectModel.query.implementedBy:'ABAP:ZCL_ETR_INCINV_QUERY'
//@UI:{
//headerInfo:{
//                typeNamePlural: 'Invoice Logs',
//                typeName: 'Invoice Log',
//                title:{ type: #STANDARD, label: 'Invoice Logs', value: 'LogCodeDescription' }
//           }
//}
define custom entity zetr_ddl_i_incinv_logs
  // with parameters parameter_name : parameter_type
{
      @UI.facet          : [ { id:            'Logs',
                     purpose:       #STANDARD,
                     type:          #IDENTIFICATION_REFERENCE,
                     label:         'Logs',
                     position:      10 }  ]
      @UI.hidden         : true
  key LogUUID            : sysuuid_c22;
      @UI.hidden         : true
      DocumentUUID       : sysuuid_c22;
      @ObjectModel.text.element: ['UserFullName']
      @UI                : { lineItem: [ { position: 20 } ] }
      CreatedBy          : abp_creation_user;
      @UI.hidden         : true
      UserFullName       : zetr_e_title;
      @UI                : { lineItem: [ { position: 30 } ] }
      CreationDate       : abp_creation_date;
      @UI                : { lineItem: [ { position: 40 } ] }
      CreationTime       : abp_creation_time;
      @ObjectModel.text.element: ['LogCodeDescription']
      @UI                : { lineItem: [ { position: 50 } ] }
      LogCode            : zetr_e_logcd;
      @UI.hidden         : true
      LogCodeDescription : zetr_e_descr100;
      @UI                : { lineItem: [ { position: 60 } ] }
      LogNote            : zetr_e_notes;
      _incomingInvoices  : association to parent zetr_ddl_i_incinv_list on $projection.DocumentUUID = _incomingInvoices.DocumentUUID;
}
