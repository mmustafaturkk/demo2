CLASS zcl_etr_regulative_common DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .
  PUBLIC SECTION.
    TYPES: BEGIN OF mty_xml_node,
             node_type  TYPE string,
             prefix     TYPE string,
             name       TYPE string,
             nsuri      TYPE string,
             value_type TYPE string,
             value      TYPE string,
           END OF mty_xml_node,
           mty_xml_nodes TYPE TABLE OF mty_xml_node WITH EMPTY KEY,
           mty_hash      TYPE c LENGTH 32.
    CLASS-METHODS parse_xml
      IMPORTING
        iv_xml_string  TYPE string
      RETURNING
        VALUE(rt_data) TYPE mty_xml_nodes.
    CLASS-METHODS get_node_type
      IMPORTING
        node_type_int           TYPE i
      RETURNING
        VALUE(node_type_string) TYPE string.
    CLASS-METHODS get_value_type
      IMPORTING
        value_type_int           TYPE i
      RETURNING
        VALUE(value_type_string) TYPE string.
    CLASS-METHODS unzip_file_single
      IMPORTING
        !iv_zipped_file_str  TYPE string OPTIONAL
        !iv_zipped_file_xstr TYPE xstring OPTIONAL
      EXPORTING
        ev_output_data_str   TYPE string
        ev_output_data_xstr  TYPE xstring.
    CLASS-METHODS calculate_hash_for_raw
      IMPORTING
        !iv_raw_data              TYPE xstring
      RETURNING
        VALUE(rv_calculated_hash) TYPE string.
    CLASS-METHODS get_api_url
      RETURNING
        VALUE(rv_url) TYPE string.
    CLASS-METHODS get_ui_url
      RETURNING
        VALUE(rv_url) TYPE string.
ENDCLASS.



CLASS zcl_etr_regulative_common IMPLEMENTATION.

  METHOD parse_xml.
    DATA(lv_xml_raw) = cl_abap_conv_codepage=>create_out( )->convert(
            replace( val = iv_xml_string sub = |\n| with = `` occ = 0  ) ).
    DATA(lo_reader) = cl_sxml_string_reader=>create( lv_xml_raw ).
    TRY.
        DO.
          lo_reader->next_node( ).
          IF lo_reader->node_type = if_sxml_node=>co_nt_final.
            EXIT.
          ENDIF.
          APPEND VALUE #(
            node_type  = get_node_type( lo_reader->node_type )
            prefix     = lo_reader->prefix
            name       = lo_reader->name
            nsuri      = lo_reader->nsuri
            value_type = get_value_type( lo_reader->value_type )
            value      = lo_reader->value ) TO rt_data.
          IF lo_reader->node_type = if_sxml_node=>co_nt_element_open.
            DO.
              lo_reader->next_attribute( ).
              IF lo_reader->node_type <> if_sxml_node=>co_nt_attribute.
                EXIT.
              ENDIF.
              APPEND VALUE #(
                node_type  = `attribute`
                prefix     = lo_reader->prefix
                name       = lo_reader->name
                nsuri      = lo_reader->nsuri
                value      = lo_reader->value ) TO rt_data.
            ENDDO.
          ENDIF.
        ENDDO.
      CATCH cx_sxml_parse_error INTO DATA(parse_error).
    ENDTRY.
  ENDMETHOD.

  METHOD get_node_type.
    CASE node_type_int.
      WHEN if_sxml_node=>co_nt_initial.
        node_type_string = `CO_NT_INITIAL`.
*      WHEN if_sxml_node=>co_nt_comment.
*        node_type_string = `CO_NT_COMMENT`.
      WHEN if_sxml_node=>co_nt_element_open.
        node_type_string = `CO_NT_ELEMENT_OPEN`.
      WHEN if_sxml_node=>co_nt_element_close.
        node_type_string = `CO_NT_ELEMENT_CLOSE`.
      WHEN if_sxml_node=>co_nt_value.
        node_type_string = `CO_NT_VALUE`.
      WHEN if_sxml_node=>co_nt_attribute.
        node_type_string = `CO_NT_ATTRIBUTE`.
*      WHEN if_sxml_node=>co_nt_pi.
*        node_type_string = `CO_NT_FINAL`.
      WHEN OTHERS.
        node_type_string = `Error`.
    ENDCASE.
  ENDMETHOD.

  METHOD get_value_type.
    CASE value_type_int.
      WHEN 0.
        value_type_string = `Initial`.
      WHEN if_sxml_value=>co_vt_none .
        value_type_string = `CO_VT_NONE`.
      WHEN if_sxml_value=>co_vt_text.
        value_type_string = `CO_VT_TEXT`.
      WHEN if_sxml_value=>co_vt_raw.
        value_type_string = `CO_VT_RAW`.
      WHEN if_sxml_value=>co_vt_any.
        value_type_string = `CO_VT_ANY`.
      WHEN OTHERS.
        value_type_string = `Error`.
    ENDCASE.
  ENDMETHOD.

  METHOD unzip_file_single.
    DATA: lo_zip           TYPE REF TO cl_abap_zip,
          lv_input_xstring TYPE xstring,
          ls_file          TYPE cl_abap_zip=>t_file,
          lv_file_name     TYPE string.

    IF iv_zipped_file_xstr IS NOT INITIAL.
      lv_input_xstring = iv_zipped_file_xstr.
    ELSE.
      lv_input_xstring = cl_abap_conv_codepage=>create_out( )->convert( source = iv_zipped_file_str ).
    ENDIF.
    CREATE OBJECT lo_zip.
    lo_zip->load(
      EXPORTING
        zip             = lv_input_xstring
      EXCEPTIONS
        zip_parse_error = 1
        OTHERS          = 2 ).
    CHECK sy-subrc IS INITIAL.

    READ TABLE lo_zip->files INTO ls_file INDEX 1.
    CHECK sy-subrc IS INITIAL.

    lv_file_name = ls_file-name.
    lo_zip->get(
      EXPORTING
        name                    = lv_file_name
      IMPORTING
        content                 = ev_output_data_xstr
      EXCEPTIONS
        zip_index_error         = 1
        zip_decompression_error = 2
        OTHERS                  = 3 ).
    IF ev_output_data_str IS REQUESTED.
      ev_output_data_str = cl_abap_conv_codepage=>create_in( )->convert( source = ev_output_data_xstr ).
    ENDIF.
  ENDMETHOD.

  METHOD calculate_hash_for_raw.
    TRY.
        cl_abap_message_digest=>calculate_hash_for_raw(
          EXPORTING
            if_algorithm     = 'MD5'
            if_data          = iv_raw_data
            if_length        = xstrlen( iv_raw_data )
          IMPORTING
            ef_hashstring    = rv_calculated_hash ).
      CATCH cx_abap_message_digest.
    ENDTRY.
  ENDMETHOD.

  METHOD get_api_url.
    rv_url = xco_cp=>current->tenant( )->get_url( xco_cp_tenant=>url_type->api )->get_host( ).
  ENDMETHOD.

  METHOD get_ui_url.
    rv_url = xco_cp=>current->tenant( )->get_url( xco_cp_tenant=>url_type->ui )->get_host( ).
  ENDMETHOD.

ENDCLASS.
