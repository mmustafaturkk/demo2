@EndUserText.label: 'Download Incoming Invoices'
@ObjectModel.query.implementedBy:'ABAP:ZCL_ETR_DOWNLOAD_INCINV'
//@Search.searchable: true
@UI:{
headerInfo:{
                typeNamePlural: 'Download Incoming Invoices',
                typeName: 'Download Incoming Invoice',
                title:{ type: #STANDARD, label: 'Download Incoming Invoices', value: 'invno' }
           }
}
define root custom entity zetr_ddl_i_download_incinv
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
      invui  : zetr_e_duich;
      @UI    : { lineItem:       [ { position: 4 } ] }
      invno  : zetr_e_docno;
      @UI    : { lineItem:       [ { position: 5 } ] }
      prfid  : zetr_e_inprf;
      @UI    : { lineItem:       [ { position: 6 } ] }
      invty  : zetr_e_invty;
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
      @Semantics.amount.currencyCode : 'waers'
      @UI    : { lineItem:       [ { position: 13 } ] }
      fwste  : fwste_cs;
      @UI    : { lineItem:       [ { position: 14 } ] }
      waers  : waers;
      @UI    : { lineItem:       [ { position: 15 } ] }
      kursf  : zetr_e_kursf;
}
