CLASS zcl_etr_edelivery_ws DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES mty_taxpayers_list TYPE STANDARD TABLE OF zetr_t_dlv_ruser WITH DEFAULT KEY .
    TYPES BEGIN OF mty_service_header.
    TYPES name TYPE string.
    TYPES value TYPE string.
    TYPES END OF mty_service_header .

    TYPES mty_service_header_tab TYPE TABLE OF mty_service_header WITH DEFAULT KEY .
    TYPES mty_incoming_deliveries TYPE STANDARD TABLE OF zetr_t_icdlv WITH DEFAULT KEY.
    TYPES mty_incoming_delivery_items TYPE STANDARD TABLE OF zetr_t_icdli WITH DEFAULT KEY.

    TYPES BEGIN OF mty_incoming_delivery_status.
    TYPES stacd TYPE zetr_e_stacd.
    TYPES staex TYPE zetr_e_staex.
    TYPES resst TYPE zetr_e_resst.
    TYPES radsc TYPE zetr_e_radsc.
    TYPES rsend TYPE zetr_e_rsend.
    TYPES envui TYPE zetr_e_envui.
    TYPES dlvui TYPE zetr_e_duich.
    TYPES dlvno TYPE zetr_e_docno.
    TYPES dlvqi TYPE zetr_e_docqi.
    TYPES ruuid TYPE zetr_e_ruuid.
    TYPES itmrs TYPE zetr_e_itmrs.
    TYPES END OF mty_incoming_delivery_status.

    CONSTANTS mc_erpcode_parameter TYPE zetr_e_cuspa VALUE 'ERPCODE' ##NO_TEXT.
    CONSTANTS mc_itmstat_parameter TYPE zetr_e_cuspa VALUE 'ITRESUBL' ##NO_TEXT.
    CONSTANTS mc_testvkn_parameter TYPE zetr_e_cuspa VALUE 'TESTVKN' ##NO_TEXT.

    CLASS-METHODS factory
      IMPORTING
        !iv_company        TYPE bukrs
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_etr_edelivery_ws
      RAISING
        zcx_etr_regulative_exception .
    METHODS download_registered_taxpayers
      ABSTRACT
      RETURNING
        VALUE(rt_list) TYPE mty_taxpayers_list
      RAISING
        zcx_etr_regulative_exception .
    METHODS get_incoming_deliveries
      ABSTRACT
      IMPORTING
        !iv_date_from TYPE datum OPTIONAL
        !iv_date_to   TYPE datum OPTIONAL
      EXPORTING
        !et_items     TYPE mty_incoming_delivery_items
        !et_list      TYPE mty_incoming_deliveries
      RAISING
        zcx_etr_regulative_exception .
    METHODS incoming_delivery_download
      ABSTRACT
      IMPORTING
        !is_document_numbers   TYPE zetr_s_document_numbers
        !iv_content_type       TYPE zetr_e_dctyp
      RETURNING
        VALUE(rv_invoice_data) TYPE xstring
      RAISING
        zcx_etr_regulative_exception .

  PROTECTED SECTION.
    DATA:
      mv_company_taxid      TYPE zetr_e_taxid,
      ms_company_parameters TYPE zetr_t_edpar,
      mt_custom_parameters  TYPE STANDARD TABLE OF zetr_t_edcus
                            WITH NON-UNIQUE SORTED KEY by_cuspa COMPONENTS cuspa,
      mv_request_url        TYPE string.

    METHODS run_service
      IMPORTING
        !iv_request                  TYPE string
        !iv_use_alternative_endpoint TYPE abap_boolean OPTIONAL
        !iv_authenticate             TYPE abap_boolean OPTIONAL
        !it_request_header           TYPE mty_service_header_tab OPTIONAL
      RETURNING
        VALUE(rv_response)           TYPE string
      RAISING
        zcx_etr_regulative_exception.
    METHODS incoming_invoice_get_status
      ABSTRACT
      IMPORTING
        !is_document_numbers TYPE zetr_S_DOCUMENT_NUMBERS
      RETURNING
        VALUE(rs_status)     TYPE mty_incoming_delivery_status
      RAISING
        zcx_etr_regulative_exception .

  PRIVATE SECTION.
    METHODS get_service_parameters
      IMPORTING
        !is_company_parameters TYPE zetr_t_edpar .
ENDCLASS.



CLASS zcl_etr_edelivery_ws IMPLEMENTATION.

  METHOD factory.
    SELECT SINGLE *
      FROM zetr_t_edpar
      WHERE bukrs = @iv_company
      INTO @DATA(ls_company_parameters).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE ID 'ZETR_COMMON' TYPE 'E' NUMBER '001'.
    ENDIF.

    SELECT SINGLE refcl
      FROM zetr_t_refcl
      WHERE bukrs = @iv_company
        AND prncl = 'ZCL_ETR_EDELIVERY_WS'
      INTO @DATA(lv_reference_class).

    IF lv_reference_class IS INITIAL.
      CONCATENATE 'ZCL_ETR_EDELIVERY_WS_' ls_company_parameters-intid INTO lv_reference_class.
    ENDIF.

    TRY .
        CREATE OBJECT ro_instance TYPE (lv_reference_class).
        ro_instance->get_service_parameters( ls_company_parameters ).
      CATCH cx_sy_create_object_error INTO DATA(lx_create_object_error).
        DATA(lv_error_text) = lx_create_object_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE ID 'ZETR_COMMON' TYPE 'E' NUMBER '000'
            WITH lv_error_text(50) lv_error_text+50(50) lv_error_text+100(50) lv_error_text+150(50).
    ENDTRY.
  ENDMETHOD.

  METHOD get_service_parameters.
    ms_company_parameters = is_company_parameters.

    SELECT *
      FROM zetr_t_edcus
      WHERE bukrs = @ms_company_parameters-bukrs
      INTO TABLE @mt_custom_parameters.

    SELECT *
      FROM zetr_t_cmpcp
      WHERE bukrs = @ms_company_parameters-bukrs
      APPENDING TABLE @mt_custom_parameters.

    READ TABLE mt_custom_parameters INTO DATA(ls_custom_parameter) WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_testvkn_parameter.
    IF sy-subrc = 0.
      mv_company_taxid = ls_custom_parameter-value.
    ELSE.
      SELECT SINGLE value
        FROM zetr_t_cmppi
        WHERE bukrs = @ms_company_parameters-bukrs
          AND prtid = 'VKN'
        INTO @mv_company_taxid.
    ENDIF.
  ENDMETHOD.

  METHOD run_service.
    DATA: lv_length_text TYPE string,
          lv_message     TYPE bapi_msg.

    DATA(lv_request_length) = strlen( iv_request ).
    lv_length_text = lv_request_length.
    CONDENSE lv_length_text.

    IF iv_use_alternative_endpoint = abap_true.
      DATA(lv_endpoint) = CONV string( ms_company_parameters-wsena ).
    ELSE.
      lv_endpoint = ms_company_parameters-wsend.
    ENDIF.

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = lv_endpoint ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e004(zetr_common).
        ENDIF.

        IF iv_authenticate IS NOT INITIAL.
          lo_request->set_authorization_basic(
            EXPORTING
              i_username = CONV #( ms_company_parameters-wsusr )
              i_password = CONV #( ms_company_parameters-wspwd ) ).
        ENDIF.

        lo_request->set_header_field( i_name  = '~request_method'
                                      i_value = 'POST' ).

        IF mv_request_url IS NOT INITIAL.
          lo_request->set_header_field( i_name  = '~request_uri'
                                        i_value = mv_request_url ).
        ENDIF.

        lo_request->set_header_field( i_name  = 'Content-Length'
                                      i_value = lv_length_text ).

        IF it_request_header IS NOT INITIAL.
          LOOP AT it_request_header INTO DATA(ls_request_header).
            lo_request->set_header_field( i_name  = ls_request_header-name
                                          i_value = ls_request_header-value ).
          ENDLOOP.
        ELSE.
          lo_request->set_header_field( i_name  = 'Content-Type'
                                        i_value = 'text/xml; charset=utf-8' ).
        ENDIF.

        lo_request->set_text( i_text   = iv_request
                              i_offset = 0
                              i_length = -1 ).

        DATA(lo_response) = lo_http_client->execute( i_method  = if_web_http_client=>post ).
        rv_response = lo_response->get_text( ).
        IF rv_response IS INITIAL.
          DATA(ls_response) = lo_response->get_status( ).
          lv_message = ls_response-code.
          CONDENSE lv_message.
          CONCATENATE lv_message ls_response-reason INTO lv_message SEPARATED BY '-'.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e000(zetr_common) WITH lv_message(50)
                                           lv_message+50(50)
                                           lv_message+100(50)
                                           lv_message+150(50).
        ELSEIF rv_response CS 'faultstring'.
          DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( rv_response ).
          READ TABLE lt_xml_table INTO DATA(ls_xml_line) WITH KEY node_type = 'CO_NT_VALUE' name = 'faultstring'.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e000(zetr_common) WITH ls_xml_line-value(50)
                                           ls_xml_line-value+50(50)
                                           ls_xml_line-value+100(50)
                                           ls_xml_line-value+150(50).
        ENDIF.
      CATCH cx_http_dest_provider_error INTO DATA(lx_http_dest_provider_error).
        lv_message = lx_http_dest_provider_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e000(zetr_common) WITH lv_message(50)
                                         lv_message+50(50)
                                         lv_message+100(50)
                                         lv_message+150(50).
      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        lv_message = lx_web_http_client_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE e000(zetr_common) WITH lv_message(50)
                                         lv_message+50(50)
                                         lv_message+100(50)
                                         lv_message+150(50).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
