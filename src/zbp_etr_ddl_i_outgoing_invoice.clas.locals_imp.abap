CLASS lhc_zetr_ddl_i_outgoing_invoic DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR outgoinginvoices RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR outgoinginvoices RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR outgoinginvoices RESULT result.
    METHODS archiveinvoices FOR MODIFY
      IMPORTING keys FOR ACTION outgoinginvoices~archiveinvoices RESULT result.

    METHODS downloadinvoices FOR MODIFY
      IMPORTING keys FOR ACTION outgoinginvoices~downloadinvoices RESULT result.

    METHODS sendinvoices FOR MODIFY
      IMPORTING keys FOR ACTION outgoinginvoices~sendinvoices RESULT result.

    METHODS setasrejected FOR MODIFY
      IMPORTING keys FOR ACTION outgoinginvoices~setasrejected RESULT result.

    METHODS statusupdate FOR MODIFY
      IMPORTING keys FOR ACTION outgoinginvoices~statusupdate RESULT result.


ENDCLASS.

CLASS lhc_zetr_ddl_i_outgoing_invoic IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zetr_ddl_i_outgoing_invoices IN LOCAL MODE
          ENTITY outgoinginvoices
            ALL FIELDS
            WITH CORRESPONDING #( keys )
        RESULT DATA(lt_invoices)
        FAILED failed.
    CHECK lt_invoices IS NOT INITIAL.
    result = VALUE #( FOR ls_invoice IN lt_invoices
                      ( %tky = ls_invoice-%tky
                        %action-sendinvoices = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-archiveinvoices = COND #( WHEN ls_invoice-statuscode = '' OR ls_invoice-statuscode = '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-downloadinvoices = COND #( WHEN ls_invoice-statuscode = '' OR ls_invoice-statuscode = '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-setasrejected = COND #( WHEN ls_invoice-statuscode = '' OR ls_invoice-statuscode = '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %action-statusupdate = COND #( WHEN ls_invoice-statuscode = '' OR ls_invoice-statuscode = '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %features-%update = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %features-%delete = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                   THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled  )
                        %field-profileid = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   WHEN ls_invoice-profileid = 'EARSIV'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-mandatory  )
                        %field-internetsale = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   WHEN ls_invoice-profileid = 'EARSIV'
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %field-invoicenote = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-invoicetype = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-taxtype = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-taxexemption = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-collectitems = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-serialprefix = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-xslttemplate = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                        %field-earchivetype = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   WHEN ls_invoice-profileid = 'EARSIV'
                                                     THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %field-aliass = COND #( WHEN ls_invoice-statuscode <> '' AND ls_invoice-statuscode <> '2'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   WHEN ls_invoice-profileid = 'EARSIV'
                                                     THEN if_abap_behv=>fc-f-read_only
                                                   ELSE if_abap_behv=>fc-f-unrestricted  )
                      ) ).
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD archiveinvoices.
  ENDMETHOD.

  METHOD downloadinvoices.
  ENDMETHOD.

  METHOD sendinvoices.
  ENDMETHOD.

  METHOD setasrejected.
  ENDMETHOD.

  METHOD statusupdate.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_outgoing_invoic DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_i_outgoing_invoic IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_deleted TYPE RANGE OF sysuuid_c22.
    IF delete-outgoinginvoices IS NOT INITIAL.
      SELECT *
        FROM zetr_t_oginv
        FOR ALL ENTRIES IN @delete-outgoinginvoices
        WHERE docui = @delete-outgoinginvoices-documentuuid
        INTO TABLE @DATA(lt_invoices).
      LOOP AT lt_invoices INTO DATA(ls_invoice).
        IF ls_invoice-stacd <> '' AND ls_invoice-stacd <> '2'.
          APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                              number   = '067'
                                              severity = if_abap_behv_message=>severity-error ) ) TO reported-outgoinginvoices.
        ELSE.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_invoice-docui ) TO lt_deleted.
        ENDIF.
      ENDLOOP.
      IF lt_deleted IS NOT INITIAL.
        DELETE FROM zetr_t_oginv
          WHERE docui IN @lt_deleted.
      ENDIF.
    ENDIF.
    IF update-outgoinginvoices IS NOT INITIAL.
      SELECT *
        FROM zetr_t_oginv
        FOR ALL ENTRIES IN @update-outgoinginvoices
        WHERE docui = @update-outgoinginvoices-documentuuid
        INTO TABLE @lt_invoices.
      SORT lt_invoices BY docui.

      DATA lt_logs TYPE zetr_tt_log_data.
      LOOP AT update-outgoinginvoices INTO DATA(ls_update).
        READ TABLE lt_invoices ASSIGNING FIELD-SYMBOL(<ls_invoice>) WITH KEY docui = ls_update-documentuuid BINARY SEARCH.
        CHECK sy-subrc = 0.
        IF ls_update-%control-aliass = if_abap_behv=>mk-on.
          <ls_invoice>-aliass = ls_update-aliass.
        ENDIF.
        IF ls_update-%control-profileid = if_abap_behv=>mk-on.
          <ls_invoice>-prfid = ls_update-profileid.
        ENDIF.
        IF ls_update-%control-invoicetype = if_abap_behv=>mk-on.
          <ls_invoice>-invty = ls_update-invoicetype.
        ENDIF.
        IF ls_update-%control-taxtype = if_abap_behv=>mk-on.
          <ls_invoice>-taxty = ls_update-taxtype.
        ENDIF.
        IF ls_update-%control-serialprefix = if_abap_behv=>mk-on.
          <ls_invoice>-serpr = ls_update-serialprefix.
        ENDIF.
        IF ls_update-%control-xslttemplate = if_abap_behv=>mk-on.
          <ls_invoice>-xsltt = ls_update-xslttemplate.
        ENDIF.
        IF ls_update-%control-taxexemption = if_abap_behv=>mk-on.
          <ls_invoice>-taxex = ls_update-taxexemption.
        ENDIF.
        IF ls_update-%control-printed = if_abap_behv=>mk-on.
          <ls_invoice>-prntd = ls_update-printed.
        ENDIF.
        IF ls_update-%control-collectitems = if_abap_behv=>mk-on.
          <ls_invoice>-itmcl = ls_update-collectitems.
        ENDIF.
        IF ls_update-%control-earchivetype = if_abap_behv=>mk-on.
          <ls_invoice>-eatyp = ls_update-earchivetype.
        ENDIF.
        IF ls_update-%control-internetsale = if_abap_behv=>mk-on.
          <ls_invoice>-intsl = ls_update-internetsale.
        ENDIF.
        IF ls_update-%control-invoicenote = if_abap_behv=>mk-on.
          <ls_invoice>-inote = ls_update-invoicenote.
        ENDIF.
        APPEND INITIAL LINE TO lt_logs ASSIGNING FIELD-SYMBOL(<ls_log>).
        <ls_log>-docui = ls_update-documentuuid.
        <ls_log>-logcd = zcl_etr_regulative_log=>mc_log_codes-updated.
        <ls_log>-uname = sy-uname.
        GET TIME STAMP FIELD DATA(lv_timestamp).
        CONVERT TIME STAMP lv_timestamp TIME ZONE space INTO DATE <ls_log>-datum TIME <ls_log>-uzeit.
      ENDLOOP.
      MODIFY zetr_t_oginv FROM TABLE @lt_invoices.
      zcl_etr_regulative_log=>create( lt_logs ).
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
