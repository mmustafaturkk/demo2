@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Accounting Documents'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zetr_ddl_i_accounting_document
  as select from    I_JournalEntry             as bkpf
    inner join      I_JournalEntryItem         as bseg              on  bkpf.CompanyCode        = bseg.CompanyCode
                                                                    and bkpf.AccountingDocument = bseg.AccountingDocument
                                                                    and bkpf.FiscalYear         = bseg.FiscalYear
    left outer join I_BusinessPartnerSupplier  as Supplier          on Supplier.Supplier = bseg.Supplier
    left outer join I_Businesspartnertaxnumber as SupplierTaxNumber on SupplierTaxNumber.BusinessPartner = Supplier.BusinessPartner
                                                                    and(
                                                                      SupplierTaxNumber.BPTaxType        = 'TR2'
                                                                      or SupplierTaxNumber.BPTaxType     = 'TR3'
                                                                    )
    left outer join I_BusinessPartnerCustomer  as Customer          on Customer.Customer = bseg.Customer
    left outer join I_Businesspartnertaxnumber as CustomerTaxNumber on CustomerTaxNumber.BusinessPartner = Customer.BusinessPartner
                                                                    and(
                                                                      CustomerTaxNumber.BPTaxType        = 'TR2'
                                                                      or CustomerTaxNumber.BPTaxType     = 'TR3'
                                                                    )
{
  key bkpf.CompanyCode,
  key bkpf.AccountingDocument,
  key bkpf.FiscalYear,
  key bseg.LedgerGLLineItem,
      bkpf.DocumentReferenceID,
      bkpf.ReferenceDocumentType,
      bkpf.OriginalReferenceDocument,
      bkpf.AccountingDocumentType,
      bseg.Customer,
      bseg.Supplier,
      case when bseg.Customer <> ''
           then Customer.BusinessPartner
           else Supplier.BusinessPartner
      end as BusinessPartner,
      case when bseg.Customer <> ''
           then CustomerTaxNumber.BPTaxNumber
           else SupplierTaxNumber.BPTaxNumber
      end as BPTaxNumber,
      bseg.DebitCreditCode
}
where
       bkpf.IsReversal           = ''
  and  bkpf.IsReversed           = ''
  and  bseg.Ledger               = '0L'
  and(
       bseg.FinancialAccountType = 'D'
    or bseg.FinancialAccountType = 'K'
  )
