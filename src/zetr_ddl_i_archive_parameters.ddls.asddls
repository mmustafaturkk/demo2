@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eArchive Parameters'
define root view entity zetr_ddl_i_archive_parameters
  as select from    zetr_t_eapar                                                   as parameters
    left outer join zetr_t_cmpin                                                   as company    on company.bukrs = parameters.bukrs
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZETR_D_GENID' ) as GenerateID on  GenerateID.language  = $session.system_language
                                                                                                 and GenerateID.value_low = parameters.genid

  composition [1..*] of ZETR_DDL_I_ARCHIVE_CUSTOM   as _customParameters
  composition [1..*] of ZETR_DDL_I_ARCHIVE_SERIALS  as _invoiceSerials
  composition [1..*] of ZETR_DDL_I_ARCHIVE_XSLTTEMP as _xsltTemplates
  composition [1..*] of ZETR_DDL_I_ARCHIVE_RULES    as _invoiceRules
{
  key parameters.bukrs   as CompanyCode,
      company.title      as CompanyTitle,
      parameters.datab   as ValidFrom,
      parameters.datbi   as ValidTo,
      parameters.intid   as Integrator,
      parameters.wsend   as WSEndpoint,
      parameters.wsena   as WSEndpointAlt,
      parameters.wsusr   as WSUser,
      parameters.wspwd   as WSPassword,
      parameters.genid   as GenerateSerial,
      GenerateID.text    as GenerateSerialText,
      parameters.barcode as Barcode,
      _customParameters,
      _invoiceSerials,
      _xsltTemplates,
      _invoiceRules
}
