@EndUserText.label: 'Unsaved Invoices'
@ObjectModel.query.implementedBy:'ABAP:ZETR_CL_UNSAVED_INVOICES'
//@Search.searchable: true
@UI:{
headerInfo:{
                typeNamePlural: 'Unsaved Outgoing Invoices',
                typeName: 'Unsaved Outgoing Invoice',
                title:{ type: #STANDARD, label: 'Unsaved Outgoing Invoices', value: 'belnr' }
           }
}
define root custom entity zetr_ddl_i_unsaved_invoices
  // with parameters parameter_name : parameter_type
{
      @UI          : { lineItem:       [ { position: 1 } ] }
      //      @Search.defaultSearchElement: true
  key docui        : sysuuid_c22;
      @UI          : { lineItem:       [ { position: 2, importance: #HIGH } ],
                       selectionField: [ { position: 2 } ] }
      @Consumption.filter : {  multipleSelections: true }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CompanyCodeVH', element: 'CompanyCode' }}]
      bukrs        : bukrs;
      @UI          : { lineItem:       [ { position: 3, importance: #HIGH } ],
                       selectionField: [ { position: 3 } ] }
      belnr        : belnr_d;
      @UI          : { lineItem:       [ { position: 4 } ],
                       selectionField: [ { position: 4 } ] }
      gjahr        : gjahr;
      @UI          : { lineItem:       [ { position: 5 } ],
                       selectionField: [ { position: 5 } ] }
      @Consumption.filter : {  multipleSelections: true }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'zetr_ddl_vh_refdoc_type', element: 'RefDocType' }}]
      @ObjectModel.text.element: ['awtyp_text']
      awtyp        : zetr_e_awtyp;
      @UI.hidden   : true
      awtyp_text   : zetr_e_descr100;
      @UI          : { lineItem:       [ { position: 6 } ] }
      @ObjectModel.text.element: ['partner_name']
      partner      : zetr_e_partner;
      @UI.hidden   : true
      partner_name : zetr_e_title;
      @UI          : { lineItem:       [ { position: 7 } ] }
      taxid        : zetr_e_taxid;
      @UI          : { lineItem:       [ { position: 8 } ],
                       selectionField: [ { position: 8 } ] }
      bldat        : bldat;
      @UI          : { selectionField: [ { position: 9 } ] }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_BillingDocumentType', element: 'BillingDocumentType' }}]
      sddty        : zetr_e_fkart;
      @UI          : { selectionField: [ { position: 10 } ] }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_AccountingDocumentType', element: 'AccountingDocumentType' }}]
      mmdty        : zetr_e_mmidt;
      @UI          : { selectionField: [ { position: 11 } ] }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_AccountingDocumentType', element: 'AccountingDocumentType' }}]
      fidty        : zetr_e_fidty;
      @UI          : { lineItem:       [ { position: 12 } ] }
      @ObjectModel.text.element: ['docty_text']
      docty        : zetr_e_docty;
      @UI.hidden   : true
      docty_text   : zetr_e_descr;
      @Semantics.amount.currencyCode: 'waers'
      @UI          : { lineItem:       [ { position: 13 } ] }
      wrbtr        : wrbtr_cs;
      @Semantics.amount.currencyCode: 'waers'
      @UI          : { lineItem:       [ { position: 14 } ] }
      fwste        : fwste_cs;
      @UI          : { lineItem:       [ { position: 15 } ] }
      kursf        : zetr_e_kursf;
      @UI          : { lineItem:       [ { position: 16 } ] }
      waers        : waers;
      @UI          : { lineItem:       [ { position: 17 } ] }
      prfid        : zetr_e_inprf;
      @UI          : { lineItem:       [ { position: 18 } ] }
      invty        : zetr_e_invty;
      @UI          : { lineItem:       [ { position: 19 } ],
                       selectionField: [ { position: 19 } ] }
      ernam        : abp_creation_user;
      @UI          : { lineItem:       [ { position: 20 } ],
                       selectionField: [ { position: 20 } ] }
      erdat        : abp_creation_date;
      @UI          : { lineItem:       [ { position: 21 } ] }
      erzet        : abp_creation_time;
}
