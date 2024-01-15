CLASS zcl_etr_incinv_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .

  PROTECTED SECTION.
    METHODS:
      select_incinv_list
        IMPORTING
          io_request  TYPE REF TO if_rap_query_request
          io_response TYPE REF TO if_rap_query_response
        RAISING
          cx_rap_query_prov_not_impl
          cx_rap_query_provider,
      select_incinv_content
        IMPORTING
          io_request  TYPE REF TO if_rap_query_request
          io_response TYPE REF TO if_rap_query_response
        RAISING
          cx_rap_query_prov_not_impl
          cx_rap_query_provider,
      select_incinv_log
        IMPORTING
          io_request  TYPE REF TO if_rap_query_request
          io_response TYPE REF TO if_rap_query_response
        RAISING
          cx_rap_query_prov_not_impl
          cx_rap_query_provider.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ETR_INCINV_QUERY IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA(lv_entity_id) = io_request->get_entity_id( ).
    DATA(lv_data_requested) = io_request->is_data_requested( ).
    CASE lv_entity_id.
      WHEN 'ZETR_DDL_I_INCINV_LIST'.
        select_incinv_list( io_request  = io_request
                            io_response = io_response ).
      WHEN 'ZETR_DDL_I_INCINV_CONTENT'.
        select_incinv_content( io_request  = io_request
                               io_response = io_response ).
      WHEN 'ZETR_DDL_I_INCINV_LOGS'.
        select_incinv_log( io_request  = io_request
                           io_response = io_response ).
    ENDCASE.
  ENDMETHOD.


  METHOD select_incinv_content.
    DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_i_incinv_content.
    DATA(lo_paging) = io_request->get_paging( ).
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.
    READ TABLE lt_filter INTO DATA(ls_filter_docui) WITH KEY name = 'DOCUMENTUUID'.
    CHECK sy-subrc = 0.
    READ TABLE lt_filter INTO DATA(ls_filter_conty) WITH KEY name = 'CONTENTTYPE'.

    DATA(lv_document_uuid) = ls_filter_docui-range[ 1 ]-low.
    SELECT SINGLE docui, invno, bukrs
      FROM zetr_t_icinv
      WHERE docui = @lv_document_uuid
      INTO @DATA(ls_document).
    TRY.
        DATA(lo_invoice_operations) = zcl_etr_invoice_operations=>factory( ls_document-bukrs ).

        IF 'PDF' IN ls_filter_conty-range.
          APPEND INITIAL LINE TO lt_output ASSIGNING FIELD-SYMBOL(<ls_output>).
          <ls_output>-ContentType = 'PDF'.
          <ls_output>-MimeType = 'application/pdf'.
          <ls_output>-Filename = ls_document-invno && '.PDF'.
          <ls_output>-DocumentUUID = ls_document-docui.
          IF ls_filter_conty-range IS NOT INITIAL.
            <ls_output>-DocumentContent = lo_invoice_operations->incoming_einvoice_download( iv_document_uid = ls_document-docui
                                                                                             iv_content_type = <ls_output>-ContentType
                                                                                             iv_create_log   = COND #( WHEN ls_filter_conty-range IS NOT INITIAL THEN abap_true ELSE abap_false ) ).
          ENDIF.
        ENDIF.

        IF 'HTML' IN ls_filter_conty-range.
          APPEND INITIAL LINE TO lt_output ASSIGNING <ls_output>.
          <ls_output>-ContentType = 'HTML'.
          <ls_output>-MimeType = 'text/html'.
          <ls_output>-Filename = ls_document-invno && '.HTML'.
          <ls_output>-DocumentUUID = ls_document-docui.
          IF ls_filter_conty-range IS NOT INITIAL.
            <ls_output>-DocumentContent = lo_invoice_operations->incoming_einvoice_download( iv_document_uid = ls_document-docui
                                                                                             iv_content_type = <ls_output>-ContentType
                                                                                             iv_create_log   = COND #( WHEN ls_filter_conty-range IS NOT INITIAL THEN abap_true ELSE abap_false ) ).
          ENDIF.
        ENDIF.

        IF 'UBL' IN ls_filter_conty-range.
          APPEND INITIAL LINE TO lt_output ASSIGNING <ls_output>.
          <ls_output>-ContentType = 'UBL'.
          <ls_output>-MimeType = 'text/xml'.
          <ls_output>-Filename = ls_document-invno && '.XML'.
          <ls_output>-DocumentUUID = ls_document-docui.
          IF ls_filter_conty-range IS NOT INITIAL.
            <ls_output>-DocumentContent = lo_invoice_operations->incoming_einvoice_download( iv_document_uid = ls_document-docui
                                                                                             iv_content_type = <ls_output>-ContentType
                                                                                             iv_create_log   = COND #( WHEN ls_filter_conty-range IS NOT INITIAL THEN abap_true ELSE abap_false ) ).
          ENDIF.
        ENDIF.
      CATCH zcx_etr_regulative_exception.
        "handle exception
    ENDTRY.

    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( lt_output ) ).
    ENDIF.
    io_response->set_data( lt_output ).
  ENDMETHOD.


  METHOD select_incinv_list.
    DATA(lo_paging) = io_request->get_paging( ).
    DATA(lv_top) = lo_paging->get_page_size( ).
    DATA(lv_skip) = lo_paging->get_offset( ).
    DATA(lt_sort) = io_request->get_sort_elements( ).
    DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_i_incinv_list.
    DATA(lv_orderby_string) = VALUE string( ).

    IF lt_sort IS NOT INITIAL.
      CLEAR lv_orderby_string.
      LOOP AT lt_sort INTO DATA(ls_sort).
        IF ls_sort-descending = abap_true.
          CONCATENATE lv_orderby_string ls_sort-element_name 'DESCENDING' INTO lv_orderby_string SEPARATED BY space.
        ELSE.
          CONCATENATE lv_orderby_string ls_sort-element_name 'ASCENDING' INTO lv_orderby_string SEPARATED BY space.
        ENDIF.
      ENDLOOP.
    ELSE.
      lv_orderby_string = 'DOCUMENTUUID'.
    ENDIF.

    DATA(lv_where_clause) =  io_request->get_filter( )->get_as_sql_string( ).
    IF lv_top < 0.
      lv_top = 1.
    ENDIF.

    SELECT *
      FROM zetr_ddl_i_incoming_invoices
      WHERE (lv_where_clause)
      ORDER BY (lv_orderby_string)
      INTO CORRESPONDING FIELDS OF TABLE @lt_output
      UP TO @lv_top ROWS
      OFFSET @lv_skip .
    IF sy-subrc = 0.
      SELECT head~CompanyCode, head~AccountingDocument, head~FiscalYear,
             head~DocumentReferenceID, head~ReferenceDocumentType, head~OriginalReferenceDocument,
             item~Customer, customer~businesspartner AS CustomerPartner, CustomerTaxNumber~bptaxnumber AS CustomerTaxNumber,
             item~Supplier, supplier~businesspartner AS SupplierPartner, supplierTaxNumber~bptaxnumber AS SupplierTaxNumber
        FROM i_journalentry AS head
        INNER JOIN i_journalentryitem AS item
          ON  item~CompanyCode = head~CompanyCode
          AND item~AccountingDocument = head~AccountingDocument
          AND item~FiscalYear = head~FiscalYear
        LEFT OUTER JOIN I_BusinessPartnerSupplier AS Supplier
          ON Supplier~Supplier = item~Supplier
        LEFT OUTER JOIN i_businesspartnertaxnumber AS SupplierTaxNumber
          ON SupplierTaxNumber~businesspartner = supplier~businesspartner
          AND ( SupplierTaxNumber~bptaxtype = 'TR2' OR SupplierTaxNumber~bptaxtype = 'TR3' )
        LEFT OUTER JOIN I_BusinessPartnerCustomer AS Customer
          ON Customer~Customer = item~Customer
        LEFT OUTER JOIN i_businesspartnertaxnumber AS CustomerTaxNumber
          ON CustomerTaxNumber~businesspartner = Customer~businesspartner
          AND ( CustomerTaxNumber~bptaxtype = 'TR2' OR CustomerTaxNumber~bptaxtype = 'TR3' )
        FOR ALL ENTRIES IN @lt_output
        WHERE head~DocumentReferenceID = @lt_output-InvoiceID
          AND head~IsReversal = ''
          AND head~IsReversed = ''
          AND item~ledger = '0L'
          AND item~financialaccounttype IN ('D','K')
        INTO TABLE @DATA(lt_accounting_documents).
      IF sy-subrc = 0.
        SORT lt_accounting_documents BY CompanyCode DocumentReferenceID SupplierTaxNumber CustomerTaxNumber.
        LOOP AT lt_output ASSIGNING FIELD-SYMBOL(<ls_output>).
          READ TABLE lt_accounting_documents
            INTO DATA(ls_accounting_document)
            WITH KEY CompanyCode = <ls_output>-CompanyCode
                     DocumentReferenceID = <ls_output>-InvoiceID
                     SupplierTaxNumber = <ls_output>-TaxID
            BINARY SEARCH.
          IF sy-subrc <> 0.
            READ TABLE lt_accounting_documents
              INTO ls_accounting_document
              WITH KEY CompanyCode = <ls_output>-CompanyCode
                       DocumentReferenceID = <ls_output>-InvoiceID
                       SupplierTaxNumber = ''
                       CustomerTaxNumber = <ls_output>-TaxID
              BINARY SEARCH.
          ENDIF.
          IF sy-subrc = 0.
            <ls_output>-ReferenceDocumentType = ls_accounting_document-ReferenceDocumentType(4).
            <ls_output>-ReferenceDocumentNumber = ls_accounting_document-OriginalReferenceDocument(10).
            <ls_output>-ReferenceDocumentYear = ls_accounting_document-FiscalYear.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( lt_output ) ).
    ENDIF.
    io_response->set_data( lt_output ).
  ENDMETHOD.


  METHOD select_incinv_log.
    DATA lt_output TYPE STANDARD TABLE OF zetr_ddl_i_incinv_logs.
    DATA(lo_paging) = io_request->get_paging( ).
    DATA(lv_top) = lo_paging->get_page_size( ).
    DATA(lv_skip) = lo_paging->get_offset( ).
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.
    READ TABLE lt_filter INTO DATA(ls_filter_docui) WITH KEY name = 'DOCUMENTUUID'.
    CHECK sy-subrc = 0.
    READ TABLE lt_filter INTO DATA(ls_filter_logui) WITH KEY name = 'LOGUUID'.
    SELECT *
      FROM zetr_ddl_i_document_logs
      WHERE DocumentUUID IN @ls_filter_docui-range
        AND LogUUID IN @ls_filter_logui-range
      ORDER BY loguuid
      INTO CORRESPONDING FIELDS OF TABLE @lt_output
      UP TO @lv_top ROWS
      OFFSET @lv_skip .
    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( lt_output ) ).
    ENDIF.
    io_response->set_data( lt_output ).
  ENDMETHOD.
ENDCLASS.
