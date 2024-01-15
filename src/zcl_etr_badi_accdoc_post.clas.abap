CLASS zcl_etr_badi_accdoc_post DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES /pra/if_acct_doc_post_simulate .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ETR_BADI_ACCDOC_POST IMPLEMENTATION.


  METHOD /pra/if_acct_doc_post_simulate~acct_doc_line_validate.
    DATA(lv_subrc) = 0.
  ENDMETHOD.


  METHOD /pra/if_acct_doc_post_simulate~determine_egroup.
    DATA(lv_subrc) = 0.
  ENDMETHOD.


  METHOD /pra/if_acct_doc_post_simulate~determine_tpf.
    DATA(lv_subrc) = 0.
  ENDMETHOD.


  METHOD /pra/if_acct_doc_post_simulate~map_acct_doc_line_to_fi.
    DATA(lv_subrc) = 0.
  ENDMETHOD.


  METHOD /pra/if_acct_doc_post_simulate~process_detail.
    DATA(lv_subrc) = 0.
  ENDMETHOD.
ENDCLASS.
