@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Code Matching'
define root view entity zetr_ddl_i_tax_code_matching
  as select from    zetr_t_taxmc as Matching
    left outer join zetr_t_taxcx as TaxCode       on  TaxCode.spras = $session.system_language
                                                  and TaxCode.taxty = Matching.taxty
    left outer join zetr_t_taxcx as ParentTaxCode on  ParentTaxCode.spras = $session.system_language
                                                  and ParentTaxCode.taxty = Matching.txtyp
    left outer join zetr_t_taxed as TaxExemption  on  TaxExemption.spras = $session.system_language
                                                  and TaxExemption.taxex = Matching.taxex 
  //composition of target_data_source_name as _association_name
{
  key Matching.kalsm      as TaxProcedure,
  key Matching.mwskz      as TaxCode,
      Matching.taxty      as TaxType,
      TaxCode.stext       as TaxTypeText,
      Matching.taxrt      as TaxRate,
      Matching.taxex      as TaxExemption,
      TaxExemption.bezei  as TaxExemptionText,
      Matching.invty      as InvoiceType,
      Matching.txtyp      as ParentTaxType,
      ParentTaxCode.stext as ParentTaxTypeText,
      Matching.txrtp      as ParentTaxRate
      //    _association_name // Make association public
}
