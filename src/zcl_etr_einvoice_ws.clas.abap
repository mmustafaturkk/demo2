CLASS zcl_etr_einvoice_ws DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      mty_taxpayers_list TYPE STANDARD TABLE OF zetr_t_inv_ruser WITH DEFAULT KEY,
      mty_incoming_list  TYPE STANDARD TABLE OF zetr_t_icinv WITH DEFAULT KEY,
      BEGIN OF mty_service_header,
        name  TYPE string,
        value TYPE string,
      END OF mty_service_header ,
      mty_service_header_tab TYPE TABLE OF mty_service_header WITH DEFAULT KEY,

      BEGIN OF mty_incoming_invoice_status,
        apres TYPE zetr_e_apres,
        resst TYPE zetr_e_resst,
        radsc TYPE zetr_e_radsc,
        staex TYPE zetr_e_staex,
      END     OF mty_incoming_invoice_status.

    CLASS-METHODS factory
      IMPORTING
        !iv_company        TYPE bukrs
*      value(IO_INVOICE) type ref to /ITETR/CL_OUTGOING_INVOICE optional
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_etr_einvoice_ws
      RAISING
        zcx_etr_regulative_exception .

    METHODS download_registered_taxpayers
      ABSTRACT
      RETURNING
        VALUE(rt_list) TYPE mty_taxpayers_list
      RAISING
        zcx_etr_regulative_exception .

    METHODS outgoing_invoice_download
      ABSTRACT
      IMPORTING
        !is_document_numbers   TYPE zetr_s_document_numbers
        !iv_content_type       TYPE zetr_e_dctyp
      RETURNING
        VALUE(rv_invoice_data) TYPE zetr_E_dCONT
      RAISING
        zcx_etr_regulative_exception .

    METHODS get_incoming_invoices
      ABSTRACT
      IMPORTING
        !iv_date_from  TYPE datum OPTIONAL
        !iv_date_to    TYPE datum OPTIONAL
      EXPORTING
        !ev_message    TYPE bapi_msg
      RETURNING
        VALUE(rt_list) TYPE mty_incoming_list
      RAISING
        zcx_etr_regulative_exception .

    METHODS incoming_invoice_download
      ABSTRACT
      IMPORTING
        !is_document_numbers   TYPE zetr_s_document_numbers
        !iv_content_type       TYPE zetr_e_dctyp
      RETURNING
        VALUE(rv_invoice_data) TYPE xstring
      RAISING
        zcx_etr_regulative_exception .

    METHODS incoming_invoice_get_status
      ABSTRACT
      IMPORTING
        !is_document_numbers TYPE zetr_S_DOCUMENT_NUMBERS
      RETURNING
        VALUE(rs_status)     TYPE mty_incoming_invoice_status
      RAISING
        zcx_etr_regulative_exception .

    METHODS incoming_invoice_response
      ABSTRACT
      IMPORTING
        !is_document_numbers     TYPE zetr_S_DOCUMENT_NUMBERS
        !iv_application_response TYPE zetr_e_apres
        !iv_note                 TYPE zetr_e_notes OPTIONAL
        !iv_receiver_alias       TYPE zetr_e_alias OPTIONAL
        !iv_receiver_taxid       TYPE zetr_e_taxid OPTIONAL
      RAISING
        zcx_etr_regulative_exception .

  PROTECTED SECTION.
    DATA:
      mv_company_taxid      TYPE zetr_e_taxid,
      ms_company_parameters TYPE zetr_t_eipar,
      mt_custom_parameters  TYPE STANDARD TABLE OF zetr_t_eicus
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

    METHODS build_application_response
      IMPORTING
        !is_document_numbers     TYPE zetr_S_DOCUMENT_NUMBERS
        !iv_application_response TYPE zetr_e_apres
        !iv_note                 TYPE zetr_e_notes OPTIONAL
      EXPORTING
        !ev_response_xml         TYPE xstring
        !ev_response_hash        TYPE string
        !es_response_structure   TYPE zif_etr_app_response_ubl21=>applicationresponsetype
      RAISING
        zcx_etr_regulative_exception.

  PRIVATE SECTION.
    METHODS get_service_parameters
      IMPORTING
        !is_company_parameters TYPE zetr_t_eipar .
ENDCLASS.



CLASS zcl_etr_einvoice_ws IMPLEMENTATION.

  METHOD factory.
    SELECT SINGLE *
      FROM zetr_t_eipar
      WHERE bukrs = @iv_company
      INTO @DATA(ls_company_parameters).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE ID 'ZETR_COMMON' TYPE 'E' NUMBER '001'.
    ENDIF.

    SELECT SINGLE refcl
      FROM zetr_t_refcl
      WHERE bukrs = @iv_company
        AND prncl = 'ZCL_ETR_EINVOICE_WS'
      INTO @DATA(lv_reference_class).

    IF lv_reference_class IS INITIAL.
      CONCATENATE 'ZCL_ETR_EINVOICE_WS_' ls_company_parameters-intid INTO lv_reference_class.
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
      FROM zetr_t_eicus
      WHERE bukrs = @ms_company_parameters-bukrs
      INTO TABLE @mt_custom_parameters.

    SELECT *
      FROM zetr_t_cmpcp
      WHERE bukrs = @ms_company_parameters-bukrs
      APPENDING TABLE @mt_custom_parameters.

    READ TABLE mt_custom_parameters INTO DATA(ls_custom_parameter) WITH TABLE KEY by_cuspa COMPONENTS cuspa = 'TESTVKN'.
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
          FIND REGEX 'faultstring:.*''.*''' IN rv_response SUBMATCHES lv_message.
          RAISE EXCEPTION TYPE zcx_etr_regulative_exception
            MESSAGE e000(zetr_common) WITH lv_message(50)
                                           lv_message+50(50)
                                           lv_message+100(50)
                                           lv_message+150(50).
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

  METHOD build_application_response.
    DATA(lv_invoice_xml) = me->incoming_invoice_download(
      EXPORTING
        is_document_numbers = is_document_numbers
        iv_content_type = 'UBL' ).
    DATA(lv_xml_string) = cl_abap_conv_codepage=>create_in( )->convert( lv_invoice_xml ).
    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_xml_string ).
    LOOP AT lt_xml_table INTO DATA(ls_xml_line).
      DATA(lv_index) = sy-tabix.
      CASE ls_xml_line-name.
        WHEN 'UBLVersionID'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          es_response_structure-ublversionid-content = ls_xml_line-value.
        WHEN 'CustomizationID'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          es_response_structure-customizationid-content = ls_xml_line-value.
        WHEN 'ProfileID'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          es_response_structure-profileid-content = ls_xml_line-value.
        WHEN 'ID'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE' AND es_response_structure-id-content IS INITIAL.
          es_response_structure-id-content = ls_xml_line-value.
        WHEN 'UUID'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          es_response_structure-uuid-content = ls_xml_line-value.
        WHEN 'IssueDate'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          es_response_structure-issuedate-content = ls_xml_line-value.
        WHEN 'IssueTime'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          es_response_structure-issuetime-content = ls_xml_line-value.
        WHEN 'AccountingCustomerParty'.
          CASE ls_xml_line-node_type.
            WHEN 'CO_NT_ELEMENT_OPEN'.
              DATA(lv_from) = lv_index + 1.
              LOOP AT lt_xml_table INTO DATA(ls_xml_line_temp) FROM lv_from.
                CASE ls_xml_line_temp-name.
                  WHEN 'AccountingCustomerParty'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_CLOSE'.
                    EXIT.
                  WHEN 'PartyIdentification'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      APPEND INITIAL LINE TO es_response_structure-senderparty-partyidentification ASSIGNING FIELD-SYMBOL(<ls_identification>).
                    ELSEIF <ls_identification> IS ASSIGNED.
                      UNASSIGN <ls_identification>.
                    ENDIF.
                  WHEN 'schemeID'.
                    CHECK <ls_identification> IS ASSIGNED.
                    <ls_identification>-schemeid = ls_xml_line_temp-value.
                  WHEN 'ID'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'
                      AND <ls_identification> IS ASSIGNED..
                    <ls_identification>-content = ls_xml_line_temp-value.
                  WHEN 'PartyName'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-senderparty-partyname TO FIELD-SYMBOL(<ls_partyname>).
                    ELSEIF <ls_partyname> IS ASSIGNED.
                      UNASSIGN <ls_partyname>.
                    ENDIF.
                  WHEN 'Country'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-senderparty-postaladdress-country TO FIELD-SYMBOL(<ls_country>).
                    ELSEIF <ls_country> IS ASSIGNED.
                      UNASSIGN <ls_country>.
                    ENDIF.
                  WHEN 'TaxScheme'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-senderparty-partytaxscheme-taxscheme-name TO FIELD-SYMBOL(<ls_taxscheme>).
                    ELSEIF <ls_taxscheme> IS ASSIGNED.
                      UNASSIGN <ls_taxscheme>.
                    ENDIF.
                  WHEN 'Name'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    IF <ls_partyname> IS ASSIGNED.
                      <ls_partyname> = ls_xml_line_temp-value.
                    ELSEIF <ls_country> IS ASSIGNED.
                      <ls_country> = ls_xml_line_temp-value.
                    ELSEIF <ls_taxscheme> IS ASSIGNED.
                      <ls_taxscheme> = ls_xml_line_temp-value.
                    ENDIF.
                  WHEN 'CitySubdivisionName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-senderparty-postaladdress-citysubdivisionname-content = ls_xml_line_temp-value.
                  WHEN 'CityName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-senderparty-postaladdress-cityname-content = ls_xml_line_temp-value.
                  WHEN 'CityName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-senderparty-postaladdress-cityname-content = ls_xml_line_temp-value.
                  WHEN 'FirstName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-senderparty-person-firstname-content = ls_xml_line_temp-value.
                  WHEN 'FamilyName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-senderparty-person-familyname-content = ls_xml_line_temp-value.
                ENDCASE.
              ENDLOOP.
          ENDCASE.
        WHEN 'AccountingSupplierParty'.
          CASE ls_xml_line-node_type.
            WHEN 'CO_NT_ELEMENT_OPEN'.
              lv_from = lv_index + 1.
              LOOP AT lt_xml_table INTO ls_xml_line_temp FROM lv_from.
                CASE ls_xml_line_temp-name.
                  WHEN 'AccountingSupplierParty'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_CLOSE'.
                    EXIT.
                  WHEN 'PartyIdentification'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      APPEND INITIAL LINE TO es_response_structure-receiverparty-partyidentification ASSIGNING <ls_identification>.
                    ELSEIF <ls_identification> IS ASSIGNED.
                      UNASSIGN <ls_identification>.
                    ENDIF.
                  WHEN 'schemeID'.
                    CHECK <ls_identification> IS ASSIGNED.
                    <ls_identification>-schemeid = ls_xml_line_temp-value.
                  WHEN 'ID'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'
                      AND <ls_identification> IS ASSIGNED..
                    <ls_identification>-content = ls_xml_line_temp-value.
                  WHEN 'PartyName'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-receiverparty-partyname TO <ls_partyname>.
                    ELSEIF <ls_partyname> IS ASSIGNED.
                      UNASSIGN <ls_partyname>.
                    ENDIF.
                  WHEN 'Country'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-receiverparty-postaladdress-country TO <ls_country>.
                    ELSEIF <ls_country> IS ASSIGNED.
                      UNASSIGN <ls_country>.
                    ENDIF.
                  WHEN 'TaxScheme'.
                    IF ls_xml_line_temp-node_type = 'CO_NT_ELEMENT_OPEN'.
                      ASSIGN COMPONENT 'CONTENT' OF STRUCTURE es_response_structure-receiverparty-partytaxscheme-taxscheme-name TO <ls_taxscheme>.
                    ELSEIF <ls_taxscheme> IS ASSIGNED.
                      UNASSIGN <ls_taxscheme>.
                    ENDIF.
                  WHEN 'Name'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    IF <ls_partyname> IS ASSIGNED.
                      <ls_partyname> = ls_xml_line_temp-value.
                    ELSEIF <ls_country> IS ASSIGNED.
                      <ls_country> = ls_xml_line_temp-value.
                    ELSEIF <ls_taxscheme> IS ASSIGNED.
                      <ls_taxscheme> = ls_xml_line_temp-value.
                    ENDIF.
                  WHEN 'CitySubdivisionName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-receiverparty-postaladdress-citysubdivisionname-content = ls_xml_line_temp-value.
                  WHEN 'CityName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-receiverparty-postaladdress-cityname-content = ls_xml_line_temp-value.
                  WHEN 'CityName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-receiverparty-postaladdress-cityname-content = ls_xml_line_temp-value.
                  WHEN 'FirstName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-receiverparty-person-firstname-content = ls_xml_line_temp-value.
                  WHEN 'FamilyName'.
                    CHECK ls_xml_line_temp-node_type = 'CO_NT_VALUE'.
                    es_response_structure-receiverparty-person-familyname-content = ls_xml_line_temp-value.
                ENDCASE.
              ENDLOOP.
          ENDCASE.
      ENDCASE.
    ENDLOOP.

    APPEND INITIAL LINE TO es_response_structure-signature ASSIGNING FIELD-SYMBOL(<ls_signature>).
    <ls_signature>-id-schemeid = 'VKN_TCKN'.
    <ls_signature>-id-content = mv_company_taxid.
    <ls_signature>-signatoryparty = CORRESPONDING #( es_response_structure-senderparty ).
    <ls_signature>-digitalsignatureattachment-externalreference-uri-content = 'Signature_DSB2022000000874'.

    APPEND INITIAL LINE TO es_response_structure-documentresponse ASSIGNING FIELD-SYMBOL(<ls_document_response>).
    APPEND INITIAL LINE TO es_response_structure-note ASSIGNING FIELD-SYMBOL(<ls_note>).
    <ls_note>-content = COND #( WHEN iv_note IS NOT INITIAL THEN iv_note ELSE iv_application_response ).
    APPEND INITIAL LINE TO <ls_document_response>-response-description ASSIGNING <ls_note>.
    <ls_note>-content = COND #( WHEN iv_note IS NOT INITIAL THEN iv_note ELSE iv_application_response ).
    <ls_document_response>-response-responsecode-content = iv_application_response.
    <ls_document_response>-response-referenceid-content = es_response_structure-uuid-content.
    <ls_document_response>-documentreference-issuedate = es_response_structure-issuedate.
    <ls_document_response>-documentreference-id = es_response_structure-uuid.
    <ls_document_response>-documentreference-documenttype-content = 'FATURA'.
    <ls_document_response>-documentreference-documenttypecode-content = 'FATURA'.

    APPEND INITIAL LINE TO <ls_document_response>-lineresponse ASSIGNING FIELD-SYMBOL(<ls_line_response>).
    APPEND INITIAL LINE TO <ls_line_response>-response ASSIGNING FIELD-SYMBOL(<ls_line_response2>).
    <ls_line_response2> = <ls_document_response>-response.
    <ls_line_response>-linereference-lineid-content = ''.

    TRY.
        CALL TRANSFORMATION zetr_ubl21_app_response
          SOURCE root = es_response_structure
          RESULT XML ev_response_xml.
        ev_response_hash = zcl_etr_regulative_common=>calculate_hash_for_raw( ev_response_xml ).
      CATCH cx_root INTO DATA(lx_root).
        DATA(lv_error) = lx_root->get_text( ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
