@EndUserText.label: 'Download Incoming Deliveries'
@ObjectModel.query.implementedBy:'ABAP:ZCL_ETR_DOWNLOAD_INCDLV'
//@Search.searchable: true
@UI:{
headerInfo:{
                typeNamePlural: 'Download Incoming Deliveries',
                typeName: 'Download Incoming Delivery',
                title:{ type: #STANDARD, label: 'Download Incoming Deliveries', value: 'dlvno' }
           }
}
define root custom entity ZETR_DDL_I_DOWNLOAD_INCDLV
  // with parameters parameter_name : parameter_type
{
      @UI    : { lineItem:       [ { position: 1 } ] }
      //      @Search.defaultSearchElement: true
  key docui  : sysuuid_c22;
      @UI    : { lineItem:       [ { position: 2, importance: #HIGH } ],
                 selectionField: [ { position: 2 } ] }
      @Consumption.filter : {  multipleSelections: true }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'zetr_ddl_vh_company_codes', element: 'CompanyCode' }}]
      bukrs  : bukrs;
      @UI    : { lineItem:       [ { position: 3 } ] }
      dlvui  : zetr_e_duich;
      @UI    : { lineItem:       [ { position: 4 } ] }
      dlvno  : zetr_e_docno;
      @UI    : { lineItem:       [ { position: 5 } ] }
      prfid  : zetr_e_dlprf;
      @UI    : { lineItem:       [ { position: 6 } ] }
      dlvty  : zetr_e_dlvty;
      @UI    : { lineItem:       [ { position: 7 } ] }
      taxid  : zetr_e_taxid;
      @UI    : { lineItem:       [ { position: 8 } ] }
      aliass : zetr_e_alias;
      @UI    : { lineItem:       [ { position: 9 } ] }
      title  : zetr_e_title;
      @UI    : { lineItem:       [ { position: 10 } ] }
      bldat  : bldat;
      @UI    : { lineItem:       [ { position: 11 } ],
                 selectionField: [ { position: 11 } ] }
      @Consumption.filter : {  selectionType: #INTERVAL }
      recdt  : zetr_e_recdt;
      @Semantics.amount.currencyCode : 'waers'
      @UI    : { lineItem:       [ { position: 12 } ] }
      wrbtr  : wrbtr_cs;
      @UI    : { lineItem:       [ { position: 14 } ] }
      waers  : waers;
}
