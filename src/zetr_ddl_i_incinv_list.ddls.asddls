@EndUserText.label: 'Incoming Invoices'
@ObjectModel.query.implementedBy:'ABAP:ZCL_ETR_INCINV_QUERY'
//@Search.searchable: true
@UI:{
headerInfo:{
                typeNamePlural: 'Incoming Invoices',
                typeName: 'Incoming Invoice',
                title:{ type: #STANDARD, label: 'Incoming Invoices', value: 'InvoiceID' }
           }
}
define root custom entity zetr_ddl_i_incinv_list
  // with parameters parameter_name : parameter_type
{
      @UI                     : { hidden: true,
             lineItem         :       [ { type: #FOR_ACTION,
                                  dataAction: 'archiveInvoices',
                                  label: 'Archive' },
                                { type: #FOR_ACTION,
                                  dataAction: 'statusUpdate',
                                  label: 'Status Update' },
                                { type: #FOR_ACTION,
                                  dataAction: 'downloadInvoices',
                                  label: 'Download/Print' },
                                { type: #FOR_ACTION,
                                  dataAction: 'sendResponse',
                                  label: 'Send Response' }
                                 ] }
  key DocumentUUID            : sysuuid_c22;
      @ObjectModel.text.element: ['CompanyTitle']
      @UI                     : { lineItem:       [ { position: 10, importance: #HIGH } ],
             selectionField   : [ { position: 10 } ] }
      @Consumption.filter     : {  multipleSelections: true }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'zetr_ddl_vh_company_codes', element: 'CompanyCode' }}]
      CompanyCode             : bukrs;
      @UI.hidden              : true
      CompanyTitle            : zetr_e_title;
      @UI                     : { lineItem:       [ { position: 230 } ] }
      EnvelopeUUID            : zetr_e_envui;
      @UI.facet               : [ { id:              'Invoices',
                                    purpose  :         #STANDARD,
                                    type     :            #IDENTIFICATION_REFERENCE,
                                    label    :           'Incoming Invoices',
                                    position :        10 },
                                  { id:              'Contents',
                                    purpose:         #STANDARD,
                                    type:            #LINEITEM_REFERENCE,
                                    label:           'Invoice Contents',
                                    position:        20,
                                    targetElement:   '_invoiceContents' },
                                  { id:              'Logs',
                                    purpose:         #STANDARD,
                                    type:            #LINEITEM_REFERENCE,
                                    label:           'Invoice Logs',
                                    position:        30,
                                    targetElement:   '_invoiceLogs' } ]
      @UI                     : { lineItem:       [ { position: 20, importance: #HIGH } ],
                                  selectionField   : [ { position: 20 } ] }
      //      @Search.defaultSearchElement: true
      InvoiceUUID             : zetr_e_duich;
      @UI                     : { lineItem:       [ { position: 30 } ],
             selectionField   : [ { position: 30 } ] }
      InvoiceID               : zetr_e_docno;
      @UI                     : { lineItem:       [ { position: 240 } ] }
      IntegratorUUID          : zetr_e_docii;
      @UI.hidden              : true
      QueryID                 : zetr_e_docqi;
      @ObjectModel.text.element: ['TaxpayerTitle']
      @UI                     : { lineItem:       [ { position: 40 } ],
                                  identification   : [ { position: 40 } ],
                                  selectionField   : [ { position: 40 } ] }
      TaxID                   : zetr_e_taxid;
      @UI.hidden              : true
      Aliass                  : zetr_e_alias;
      @UI.hidden              : true
      TaxpayerTitle           : zetr_e_title;
      @UI                     : { lineItem:       [ { position: 50 } ],
                                  identification   : [ { position: 50 } ],
                                  selectionField   : [ { position: 50 } ] }
      DocumentDate            : bldat;
      @UI                     : { lineItem:       [ { position: 60 } ],
                                  identification   : [ { position: 60 } ],
                                  selectionField   : [ { position: 60 } ] }
      ReceiveDate             : zetr_e_recdt;
      @Semantics.amount.currencyCode : 'Currency'
      @UI                     : { lineItem:       [ { position: 70 } ] }
      Amount                  : wrbtr_cs;
      @Semantics.amount.currencyCode : 'Currency'
      @UI                     : { lineItem:       [ { position: 80 } ] }
      TaxAmount               : fwste_cs;
      @Semantics.currencyCode : true
      @UI.hidden              : true
      Currency                : waers;
      @UI                     : { lineItem:       [ { position: 100 } ] }
      ExchangeRate            : zetr_e_kursf;
      @UI                     : { lineItem:       [ { position: 110 } ],
                                  identification   : [ { position: 110 } ],
                                  selectionField   : [ { position: 110 } ] }
      @Consumption.filter     : {  multipleSelections: true }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'zetr_ddl_vh_invoice_profile', element: 'ProfileID' }}]
      ProfileID               : zetr_e_inprf;
      @UI                     : { lineItem:       [ { position: 120 } ],
                                  identification   : [ { position: 120 } ],
                                  selectionField   : [ { position: 120 } ] }
      @Consumption.filter     : {  multipleSelections: true }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'zetr_ddl_vh_invoice_type', element: 'InvoiceType' }}]
      InvoiceType             : zetr_e_invty;
      @UI                     : { lineItem:       [ { position: 130 } ],
                                  identification   : [ { position: 130 } ],
                                  selectionField   : [ { position: 130 } ] }
      @Consumption.filter     : {  multipleSelections: true }
      Printed                 : zetr_e_prnch;
      @UI                     : { lineItem:       [ { position: 140 } ],
                                  identification   : [ { position: 140 } ],
                                  selectionField   : [ { position: 140 } ] }
      @Consumption.filter     : {  multipleSelections: true, defaultValue: '' }
      Processed               : zetr_e_procs;
      @UI                     : { lineItem:       [ { position: 150 } ] }
      ReferenceDocumentType   : zetr_e_awtyp;
      @UI                     : { lineItem:       [ { position: 160 } ],
                                  identification   : [ { position: 160 } ] }
      ReferenceDocumentNumber : belnr_d;
      @UI                     : { lineItem:       [ { position: 170 } ] }
      ReferenceDocumentYear   : gjahr;
      @UI                     : { lineItem:       [ { position: 180 } ],
                                  selectionField   : [ { position: 180 } ] }
      Archived                : zetr_e_archv;
      @UI                     : { lineItem:       [ { position: 190 } ],
                                  identification   : [ { position: 190 } ],
                                  selectionField   : [ { position: 190 } ] }
      LastNote                : zetr_e_notes;
      @ObjectModel.text.element: ['ResponseStatusText']
      @UI                     : { lineItem:       [ { position: 200 } ],
                                  selectionField   : [ { position: 200 } ] }
      @Consumption.filter     : {  multipleSelections: true }
      ResponseStatus          : zetr_e_resst;
      @UI.hidden              : true
      ResponseStatusText      : zetr_e_descr100;
      @ObjectModel.text.element: ['TRAStatusText']
      @UI                     : { lineItem:       [ { position: 210 } ] }
      TRAStatusCode           : zetr_e_radsc;
      @UI.hidden              : true
      TRAStatusText           : zetr_e_descr100;
      @UI                     : { lineItem:       [ { position: 220 } ] }
      StatusDetail            : zetr_e_staex;

      _invoiceContents        : composition [0..*] of zetr_ddl_i_incinv_content;
      _invoiceLogs            : composition [0..*] of zetr_ddl_i_incinv_logs;

}
