CLASS zcl_etr_regulative_log DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS BEGIN OF mc_log_codes.
    CONSTANTS received TYPE zetr_e_logcd VALUE 'RECEIVED' ##NO_TEXT.
    CONSTANTS waiting TYPE zetr_e_logcd VALUE 'WAITING' ##NO_TEXT.
    CONSTANTS approved TYPE zetr_e_logcd VALUE 'APPROVED' ##NO_TEXT.
    CONSTANTS response TYPE zetr_e_logcd VALUE 'RESPONSE' ##NO_TEXT.
    CONSTANTS accepted TYPE zetr_e_logcd VALUE 'ACCEPTED' ##NO_TEXT.
    CONSTANTS rejected TYPE zetr_e_logcd VALUE 'REJECTED' ##NO_TEXT.
    CONSTANTS set_as_rejected TYPE zetr_e_logcd VALUE 'REJSET' ##NO_TEXT.
    CONSTANTS rejected_via_kep TYPE zetr_e_logcd VALUE 'REJKEP' ##NO_TEXT.
    CONSTANTS rejected_via_gib TYPE zetr_e_logcd VALUE 'REJGIB' ##NO_TEXT.
    CONSTANTS ready TYPE zetr_e_logcd VALUE 'READY' ##NO_TEXT.
    CONSTANTS processed TYPE zetr_e_logcd VALUE 'PROCESSED' ##NO_TEXT.
    CONSTANTS nonprocessed TYPE zetr_e_logcd VALUE 'NONPROCESS' ##NO_TEXT.
    CONSTANTS archived TYPE zetr_e_logcd VALUE 'ARCHIVED' ##NO_TEXT.
    CONSTANTS printed TYPE zetr_e_logcd VALUE 'PRINTED' ##NO_TEXT.
    CONSTANTS mail TYPE zetr_e_logcd VALUE 'MAIL' ##NO_TEXT.
    CONSTANTS reversed TYPE zetr_e_logcd VALUE 'REVERSED' ##NO_TEXT.
    CONSTANTS status TYPE zetr_e_logcd VALUE 'STATUS' ##NO_TEXT.
    CONSTANTS download TYPE zetr_e_logcd VALUE 'DOWNLOAD' ##NO_TEXT.
    CONSTANTS nonprinted TYPE zetr_e_logcd VALUE 'NONPRINTED' ##NO_TEXT.
    CONSTANTS sent TYPE zetr_e_logcd VALUE 'SENT' ##NO_TEXT.
    CONSTANTS created TYPE zetr_e_logcd VALUE 'CREATED' ##NO_TEXT.
    CONSTANTS updated TYPE zetr_e_logcd VALUE 'UPDATED' ##NO_TEXT.
    CONSTANTS deleted TYPE zetr_e_logcd VALUE 'DELETED' ##NO_TEXT.
    CONSTANTS note_added TYPE zetr_e_logcd VALUE 'NOTE' ##NO_TEXT.
    CONSTANTS sms TYPE zetr_e_logcd VALUE 'SMS' ##NO_TEXT.
    CONSTANTS saved TYPE zetr_e_logcd VALUE 'SAVED' ##NO_TEXT.
    CONSTANTS taxpayers_updated TYPE zetr_e_logcd VALUE 'TAXPAYERS' ##NO_TEXT.
    CONSTANTS END OF mc_log_codes.

    CLASS-METHODS create
      IMPORTING
        !it_logs TYPE zetr_tt_log_data.

    CLASS-METHODS create_single_log
      IMPORTING
        !iv_log_code    TYPE zetr_e_logcd
        !iv_log_text    TYPE zetr_e_notes OPTIONAL
        !iv_document_id TYPE sysuuid_c22 OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ETR_REGULATIVE_LOG IMPLEMENTATION.


  METHOD create.
    DATA: lt_log_db TYPE TABLE OF zetr_t_logs,
          ls_log_db TYPE zetr_t_logs,
          lt_logs   TYPE zetr_tt_log_data,
          ls_logs   TYPE zetr_s_log_data.
    lt_logs = it_logs.
    LOOP AT lt_logs INTO ls_logs.
      ls_log_db = CORRESPONDING #( ls_logs ).
      TRY.
          ls_log_db-logui = cl_system_uuid=>create_uuid_c22_static( ).
        CATCH cx_uuid_error.
          CONTINUE.
      ENDTRY.
      APPEND ls_log_db TO lt_log_db.
      CLEAR ls_log_db.
    ENDLOOP.
    CHECK lt_log_db IS NOT INITIAL.
    INSERT zetr_t_logs FROM TABLE @lt_log_db.
  ENDMETHOD.


  METHOD create_single_log.
    DATA: lt_log_db TYPE TABLE OF zetr_t_logs,
          ls_log_db TYPE zetr_t_logs.
    TRY.
        ls_log_db-logui = cl_system_uuid=>create_uuid_c22_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.
    ls_log_db-docui = iv_document_id.
    ls_log_db-uname = sy-uname.
    GET TIME STAMP FIELD DATA(lv_timestamp).
    CONVERT TIME STAMP lv_timestamp TIME ZONE space INTO DATE ls_log_db-datum TIME ls_log_db-uzeit.
    ls_log_db-logcd = iv_log_code.
    ls_log_db-lnote = iv_log_text.
    INSERT zetr_t_logs FROM @ls_log_db.
  ENDMETHOD.
ENDCLASS.
