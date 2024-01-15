CLASS zcl_etr_delivery_operations DEFINITION
  PUBLIC
  CREATE PROTECTED .

  PUBLIC SECTION.
    TYPES:
      mty_incoming_list  TYPE STANDARD TABLE OF zetr_t_icdlv WITH DEFAULT KEY,
      mty_incoming_items TYPE STANDARD TABLE OF zetr_t_icdli WITH DEFAULT KEY.
    CLASS-METHODS factory
      IMPORTING
        !iv_company        TYPE bukrs
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_etr_delivery_operations
      RAISING
        zcx_etr_regulative_exception .

    METHODS update_edelivery_users
      IMPORTING
        iv_db_write    TYPE abap_boolean DEFAULT abap_true
      RETURNING
        VALUE(rt_list) TYPE zcl_etr_edelivery_ws=>mty_taxpayers_list
      RAISING
        zcx_etr_regulative_exception.

    METHODS get_incoming_deliveries
      IMPORTING
        !iv_date_from TYPE datum OPTIONAL
        !iv_date_to   TYPE datum OPTIONAL
      EXPORTING
        et_list       TYPE mty_incoming_list
        et_items      TYPE mty_incoming_items
      RAISING
        zcx_etr_regulative_exception .

  PROTECTED SECTION.
    DATA mv_company_code TYPE bukrs.

    METHODS save_incoming_deliveries
      IMPORTING
        !it_list  TYPE mty_incoming_list
        !it_items TYPE mty_incoming_items
      RAISING
        zcx_etr_regulative_exception .

  PRIVATE SECTION.
    METHODS set_initial_data
      IMPORTING
        !iv_company TYPE bukrs.

ENDCLASS.



CLASS zcl_etr_delivery_operations IMPLEMENTATION.

  METHOD factory.
    SELECT SINGLE refcl
      FROM zetr_t_refcl
      WHERE bukrs = @iv_company
        AND prncl = 'ZCL_ETR_DELIVERY_OPERATIONS'
        INTO @DATA(lv_reference_class).
    IF sy-subrc <> 0.
      lv_reference_class = 'ZCL_ETR_DELIVERY_OPERATIONS'.
    ENDIF.

    TRY .
        CREATE OBJECT ro_instance TYPE (lv_reference_class).
        ro_instance->set_initial_data( iv_company ).
      CATCH cx_sy_create_object_error INTO DATA(lx_create_object_error).
        DATA(lv_error_text) = lx_create_object_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE ID 'ZETR_COMMON' TYPE 'E' NUMBER '000'
            WITH lv_error_text(50) lv_error_text+50(50) lv_error_text+100(50) lv_error_text+150(50).
    ENDTRY.
  ENDMETHOD.

  METHOD set_initial_data.
    mv_company_code = iv_company.
  ENDMETHOD.

  METHOD update_edelivery_users.
    rt_list = zcl_etr_edelivery_ws=>factory( mv_company_code )->download_registered_taxpayers( ).
    IF rt_list IS NOT INITIAL.
      SELECT taxid, aliass
        FROM zetr_t_dlv_ruser
        WHERE defal = @abap_true
        INTO TABLE @DATA(lt_default_aliases).
      SORT lt_default_aliases BY taxid aliass.

      SORT rt_list BY taxid.
      DATA: lv_taxid     TYPE zetr_e_taxid,
            lv_record_no TYPE buzei.
      LOOP AT rt_list ASSIGNING FIELD-SYMBOL(<ls_taxpayer>).
        IF lv_taxid <> <ls_taxpayer>-taxid.
          lv_taxid = <ls_taxpayer>-taxid.
          CLEAR lv_record_no.
        ENDIF.
        lv_record_no += 1.
        <ls_taxpayer>-recno = lv_record_no.

        IF lt_default_aliases IS NOT INITIAL.
          READ TABLE lt_default_aliases
              WITH KEY taxid = <ls_taxpayer>-taxid
                       aliass = <ls_taxpayer>-aliass
              BINARY SEARCH
              TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
            <ls_taxpayer>-defal = abap_true.
          ENDIF.
        ENDIF.
      ENDLOOP.
      CHECK iv_db_write = abap_true.
      DELETE FROM zetr_t_dlv_ruser.
      COMMIT WORK AND WAIT.
      INSERT zetr_t_dlv_ruser FROM TABLE @rt_list.
      COMMIT WORK AND WAIT.
    ELSE.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e004(zetr_common).
    ENDIF.
  ENDMETHOD.

  METHOD get_incoming_deliveries.
    DATA(lo_edelivery_service) = zcl_etr_edelivery_ws=>factory( mv_company_code ).
    lo_edelivery_service->get_incoming_deliveries(
      EXPORTING
        iv_date_from = iv_date_from
        iv_date_to   = iv_date_to
      IMPORTING
        et_items     = et_items
        et_list      = et_list ).
    CHECK et_list IS NOT INITIAL.
    SELECT dlvui
      FROM zetr_t_icdlv
      FOR ALL ENTRIES IN @et_list
      WHERE dlvui = @et_list-dlvui
      INTO TABLE @DATA(lt_existing).
    IF sy-subrc = 0.
      LOOP AT lt_existing INTO DATA(ls_existing).
        DELETE et_list WHERE dlvui = ls_existing-dlvui.
      ENDLOOP.
    ENDIF.
    CHECK et_list IS NOT INITIAL.
    save_incoming_deliveries( it_list  = et_list
                              it_items = et_items ).
  ENDMETHOD.

  METHOD save_incoming_deliveries.
    INSERT zetr_t_icdlv FROM TABLE @it_list.
    INSERT zetr_t_icdli FROM TABLE @it_items.

    GET TIME STAMP FIELD DATA(lv_timestamp).
    CONVERT TIME STAMP lv_timestamp TIME ZONE space INTO DATE DATA(lv_erdat) TIME DATA(lv_erzet).
    zcl_etr_regulative_log=>create( it_logs = VALUE #( FOR ls_list IN it_list ( docui = ls_list-docui
                                                                                uname = sy-uname
                                                                                datum = lv_erdat
                                                                                uzeit = lv_erzet
                                                                                logcd = zcl_etr_regulative_log=>mc_log_codes-received ) ) ).

    zcl_etr_regulative_archive=>create( it_archives = VALUE #( FOR ls_list IN it_list ( docui = ls_list-docui
                                                                                        conty = zcl_etr_regulative_archive=>mc_content_types-pdf )
                                                                                      ( docui = ls_list-docui
                                                                                        conty = zcl_etr_regulative_archive=>mc_content_types-html )
                                                                                      ( docui = ls_list-docui
                                                                                        conty = zcl_etr_regulative_archive=>mc_content_types-ubl ) ) ).
    COMMIT WORK AND WAIT.
  ENDMETHOD.

ENDCLASS.
