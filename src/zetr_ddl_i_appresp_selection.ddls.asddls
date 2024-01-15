@EndUserText.label: 'Invoice Response Selection'
define abstract entity zetr_ddl_i_appresp_selection
  //  with parameters parameter_name : parameter_type
{
  @Consumption.valueHelpDefinition: [ { entity: { name: 'zetr_ddl_vh_app_response', element: 'ApplicationResponse' }}]
  @Consumption.filter : {  selectionType: #SINGLE, multipleSelections: false }
  ApplicationResponse : zetr_e_apres;
  ResponseNote        : zetr_e_notes;
}
