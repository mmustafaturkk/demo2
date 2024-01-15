CLASS zcl_etr_outgoing_invoice DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS factory
      IMPORTING
        !iv_document_uuid TYPE sysuuid_c22
        !iv_preview       TYPE abap_boolean
      RETURNING
        VALUE(ro_object)  TYPE REF TO zcl_etr_outgoing_invoice
      RAISING
        zcx_etr_regulative_exception .

  PROTECTED SECTION.
    DATA mo_invoice_operations TYPE REF TO zcl_etr_invoice_operations .
    DATA ms_document TYPE zetr_t_oginv .
    DATA mv_preview TYPE abap_boolean .
*    DATA ms_invoice_ubl TYPE edo_tr_invoice .
    DATA mv_invoice_hash TYPE c LENGTH 32 .
    DATA mv_invoice_ubl TYPE xstring .
    DATA mt_custom_parameters TYPE TABLE OF zetr_t_cmpcp .
    DATA mv_generate_invoice_id TYPE zetr_e_genid .
    DATA mv_company_taxid TYPE zetr_e_taxid .
    DATA mv_add_signature TYPE zetr_e_value .
    DATA mv_barcode TYPE zetr_e_barcode .

  PRIVATE SECTION.
    METHODS set_initial_data
      IMPORTING
        !is_document TYPE zetr_t_oginv
        !iv_preview  TYPE abap_boolean
      RAISING
        zcx_etr_regulative_exception .
ENDCLASS.



CLASS ZCL_ETR_OUTGOING_INVOICE IMPLEMENTATION.


  METHOD factory.
    SELECT SINGLE *
      FROM zetr_t_oginv
      WHERE docui = @iv_document_uuid
      INTO @DATA(ls_document).
    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e005(zetr_common).
    ENDIF.

    SELECT SINGLE refcl
      FROM zetr_t_refcl
      WHERE bukrs = @ls_document-bukrs
        AND prncl = 'ZCL_ETR_OUTGOING_INVOICE'
      INTO @DATA(lv_reference_class).

    IF lv_reference_class IS INITIAL.
      lv_reference_class = 'ZCL_ETR_OUTGOING_INVOICE'.
    ENDIF.

    TRY .
        CREATE OBJECT ro_object TYPE (lv_reference_class).
        ro_object->set_initial_data( is_document = ls_document
                                     iv_preview = iv_preview ).
      CATCH cx_sy_create_object_error INTO DATA(lx_create_object_error).
        DATA(lv_message) = CONV bapi_msg( lx_create_object_error->get_text( ) ).
        RAISE EXCEPTION TYPE zcx_etr_regulative_exception
          MESSAGE ID 'ZETR_COMMON' TYPE 'E' NUMBER '000'
            WITH lv_message(50) lv_message+50(50) lv_message+100(50) lv_message+150(*).
    ENDTRY.
  ENDMETHOD.


  METHOD set_initial_data.
    ms_document = is_document.
    mv_preview = iv_preview.
    mo_invoice_operations = zcl_etr_invoice_operations=>factory( ms_document-bukrs ).


    SELECT SINGLE value
      FROM zetr_t_cmppi
      WHERE bukrs = @ms_document-bukrs
        AND prtid = 'VKN'
      INTO @mv_company_taxid.
    CASE ms_document-prfid.
      WHEN 'EARSIV'.
        SELECT SINGLE genid, barcode
          FROM zetr_t_eapar
          WHERE bukrs = @ms_document-bukrs
          INTO @DATA(ls_earp).
        mv_generate_invoice_id = ls_earp-genid.
        mv_barcode = ls_earp-barcode.
        IF mv_company_taxid IS INITIAL.
          SELECT SINGLE value
            FROM zetr_t_eacus
            WHERE bukrs = @ms_document-bukrs
              AND cuspa = 'TEST_VKN'
            INTO @mv_company_taxid.
        ENDIF.

        SELECT SINGLE value
          FROM zetr_t_eacus
          WHERE bukrs = @ms_document-bukrs
            AND cuspa = 'ADDSIGN'
          INTO @mv_add_signature.
      WHEN OTHERS.
        SELECT SINGLE genid, barcode
          FROM zetr_t_eipar
          WHERE bukrs = @ms_document-bukrs
          INTO @DATA(ls_einp).
        mv_generate_invoice_id = ls_einp-genid. "hkizilkaya
        mv_barcode = ls_einp-barcode. "hkizilkaya
        IF mv_company_taxid IS INITIAL.
          SELECT SINGLE value
            FROM zetr_t_eicus
            WHERE bukrs = @ms_document-bukrs
              AND cuspa = 'TEST_VKN'
            INTO @mv_company_taxid.
        ENDIF.

        SELECT SINGLE value
          FROM zetr_t_eicus
          WHERE bukrs = @ms_document-bukrs
            AND cuspa = 'ADDSIGN'
          INTO @mv_add_signature.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
