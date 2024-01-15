@EndUserText.label: 'Invoice Response Selection'
define abstract entity zetr_ddl_i_reject_selection
  //  with parameters parameter_name : parameter_type
{
  @Consumption.valueHelpDefinition: [ { entity: { name: 'zetr_ddl_vh_reject_types', element: 'RejectType' }}]
  @Consumption.filter     : {  selectionType: #SINGLE, multipleSelections: false }
  RejectType : zetr_e_reject_types;
  RejectNote : zetr_e_notes;
}
