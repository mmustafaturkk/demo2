@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eInvoice Parameters'
define root view entity zetr_ddl_i_invoice_parameters
  as select from    zetr_t_eipar                                                   as parameters
    left outer join zetr_t_cmpin                                                   as company    on company.bukrs = parameters.bukrs
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_GENID' ) as GenerateID on  GenerateID.language  = $session.system_language
                                                                                                 and GenerateID.value_low = parameters.genid

  composition [1..*] of zetr_ddl_i_invoice_custom   as _customParameters
  composition [1..*] of zetr_ddl_i_invoice_serials  as _invoiceSerials
  composition [1..*] of zetr_ddl_i_invoice_xslttemp as _xsltTemplates
  composition [1..*] of zetr_ddl_i_invoice_rules    as _invoiceRules
{
  key parameters.bukrs    as CompanyCode,
      company.title       as CompanyTitle,
      parameters.datab    as ValidFrom,
      parameters.datbi    as ValidTo,
      parameters.intid    as Integrator,
      parameters.prfid    as ProfileID,
      parameters.wsend    as WSEndpoint,
      parameters.wsena    as WSEndpointAlt,
      parameters.wsusr    as WSUser,
      parameters.wspwd    as WSPassword,
      parameters.genid    as GenerateSerial,
      GenerateID.text     as GenerateSerialText,
      parameters.tfagn    as TaxfreeAgent,
      parameters.barcode  as Barcode,
      parameters.pk_alias as PKAlias,
      parameters.gb_alias as GBAlias,
      _customParameters,
      _invoiceSerials,
      _xsltTemplates,
      _invoiceRules
}
