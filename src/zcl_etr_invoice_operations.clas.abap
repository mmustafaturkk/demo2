CLASS zcl_etr_invoice_operations DEFINITION
  PUBLIC
  CREATE PROTECTED .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF mty_partner_register_data,
        businesspartner TYPE zetr_e_partner,
        bptaxnumber     TYPE c LENGTH 20,
        aliass          TYPE zetr_e_alias,
        registerdate    TYPE datum,
        title           TYPE zetr_e_title,
      END OF mty_partner_register_data,
      mty_incoming_list TYPE STANDARD TABLE OF zetr_t_icinv WITH DEFAULT KEY.

    CLASS-METHODS factory
      IMPORTING
        !iv_company        TYPE bukrs
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_etr_invoice_operations
      RAISING
        zcx_etr_regulative_exception .

    CLASS-METHODS conversion_profile_id_input
      IMPORTING
        !iv_input        TYPE string
      RETURNING
        VALUE(rv_output) TYPE string.

    CLASS-METHODS conversion_profile_id_output
      IMPORTING
        !iv_input        TYPE string
      RETURNING
        VALUE(rv_output) TYPE string.

    CLASS-METHODS conversion_invoice_type_input
      IMPORTING
        !iv_input        TYPE string
      RETURNING
        VALUE(rv_output) TYPE string.

    CLASS-METHODS conversion_invoice_type_output
      IMPORTING
        !iv_input        TYPE string
      RETURNING
        VALUE(rv_output) TYPE string.

    METHODS update_einvoice_users
      IMPORTING
        iv_db_write    TYPE abap_boolean DEFAULT abap_true
      RETURNING
        VALUE(rt_list) TYPE zcl_etr_einvoice_ws=>mty_taxpayers_list
      RAISING
        zcx_etr_regulative_exception.

    METHODS accounting_document_check
      IMPORTING
        !is_accountingdocheader TYPE zcl_etr_invoice_exits=>mty_accdoc_header
        !it_accountingdocitems  TYPE zcl_etr_invoice_exits=>mty_accdoc_items
      CHANGING
        !cs_validationmessage   TYPE symsg
      RAISING
        cx_ble_runtime_error .

    METHODS accounting_document_save
      IMPORTING
        !is_accountingdocheader   TYPE zcl_etr_invoice_exits=>mty_accdoc_header
        !it_accountingdocitems    TYPE zcl_etr_invoice_exits=>mty_accdoc_items
      CHANGING
        !cv_substitutiondone      TYPE abap_boolean
        !ct_accountingdocitemsout TYPE zcl_etr_invoice_exits=>mty_accdoc_items_out
      RAISING
        cx_ble_runtime_error .

    METHODS get_partner_register_data
      IMPORTING
        !iv_customer   TYPE zetr_e_partner OPTIONAL
        !iv_supplier   TYPE zetr_e_partner OPTIONAL
        !iv_partner    TYPE zetr_e_partner OPTIONAL
      RETURNING
        VALUE(rs_data) TYPE mty_partner_register_data.

    METHODS get_einvoice_rule
      IMPORTING
        !iv_rule_type         TYPE zetr_e_rulet
        !is_rule_input        TYPE zetr_s_invoice_rules_in
      RETURNING
        VALUE(rs_rule_output) TYPE zetr_s_invoice_rules_out.

    METHODS get_earchive_rule
      IMPORTING
        !iv_rule_type         TYPE zetr_e_rulet
        !is_rule_input        TYPE zetr_s_invoice_rules_in
      RETURNING
        VALUE(rs_rule_output) TYPE zetr_s_invoice_rules_out.

    METHODS outgoing_invoice_save
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE zetr_t_oginv
      RAISING
        zcx_etr_regulative_exception .

    METHODS get_incoming_invoices
      IMPORTING
        !iv_date_from  TYPE datum OPTIONAL
        !iv_date_to    TYPE datum OPTIONAL
      RETURNING
        VALUE(rt_list) TYPE mty_incoming_list
      RAISING
        zcx_etr_regulative_exception .

    METHODS save_incoming_invoices
      IMPORTING
        !it_list TYPE mty_incoming_list
      RAISING
        zcx_etr_regulative_exception .

    METHODS incoming_einvoice_download
      IMPORTING
        !iv_document_uid   TYPE sysuuid_c22
        !iv_content_type   TYPE zetr_e_dctyp
        !iv_create_log     TYPE abap_boolean DEFAULT 'X'
      RETURNING
        VALUE(rv_document) TYPE xstring
      RAISING
        zcx_etr_regulative_exception .

    METHODS incoming_einvoice_addnote
      IMPORTING
        !iv_document_uid TYPE sysuuid_c22
        !iv_note         TYPE zetr_e_notes
        !iv_user         TYPE sy-uname DEFAULT sy-uname
      RAISING
        zcx_etr_regulative_exception .

  PROTECTED SECTION.
    DATA mv_company_code TYPE bukrs.

    METHODS outgoing_invoice_save_vbrk
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE zetr_t_oginv
      RAISING
        zcx_etr_regulative_exception.

    METHODS outgoing_invoice_save_rmrp
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE zetr_t_oginv
      RAISING
        zcx_etr_regulative_exception.

    METHODS outgoing_invoice_save_bkpf
      IMPORTING
        !iv_awtyp          TYPE zetr_e_awtyp
        !iv_bukrs          TYPE bukrs
        !iv_belnr          TYPE belnr_d
        !iv_gjahr          TYPE gjahr
      RETURNING
        VALUE(rs_document) TYPE zetr_t_oginv
      RAISING
        zcx_etr_regulative_exception.

  PRIVATE SECTION.
    METHODS set_initial_data
      IMPORTING
        !iv_company TYPE bukrs.

ENDCLASS.



CLASS zcl_etr_invoice_operations IMPLEMENTATION.

  METHOD factory.
    SELECT SINGLE refcl
      FROM zetr_t_refcl
      WHERE bukrs = @iv_company
        AND prncl = 'ZCL_ETR_INVOICE_OPERATIONS'
        INTO @DATA(lv_reference_class).
    IF sy-subrc <> 0.
      lv_reference_class = 'ZCL_ETR_INVOICE_OPERATIONS'.
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

  METHOD update_einvoice_users.
    rt_list = zcl_etr_einvoice_ws=>factory( mv_company_code )->download_registered_taxpayers( ).
    IF rt_list IS NOT INITIAL.
      SELECT taxid, aliass
        FROM zetr_t_inv_ruser
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
      DELETE FROM zetr_t_inv_ruser.
      COMMIT WORK AND WAIT.
      INSERT zetr_t_inv_ruser FROM TABLE @rt_list.
      COMMIT WORK AND WAIT.
    ELSE.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e004(zetr_common).
    ENDIF.
  ENDMETHOD.

  METHOD accounting_document_check.
    CHECK is_accountingdocheader-referencedocumenttype(4) = 'BKPF'.
    SELECT SINGLE *
      FROM zetr_ddl_i_company_information
      WHERE companycode = @is_accountingdocheader-companycode
      INTO @DATA(ls_company_info).
    CHECK sy-subrc = 0.
    READ TABLE it_accountingdocitems
      INTO DATA(ls_accountingdocitem)
      WITH KEY financialaccounttype = 'D'.
    IF sy-subrc <> 0.
      READ TABLE it_accountingdocitems
        INTO ls_accountingdocitem
        WITH KEY financialaccounttype = 'K'.
    ENDIF.
    CHECK ls_accountingdocitem IS NOT INITIAL.
  ENDMETHOD.

  METHOD accounting_document_save.
    CHECK is_accountingdocheader-referencedocumenttype(4) = 'BKPF' AND
          is_accountingdocheader-isreversaldocument = abap_false AND
          is_accountingdocheader-reversedocument IS INITIAL.

    SELECT SINGLE *
      FROM zetr_ddl_i_company_information
      WHERE companycode = @is_accountingdocheader-companycode
      INTO @DATA(ls_company_info).
    CHECK sy-subrc = 0.

    TRY.
        DATA(ls_edocument) = VALUE zetr_t_oginv( docui = cl_system_uuid=>create_uuid_c22_static( )
                                                 bukrs = is_accountingdocheader-companycode
                                                 gjahr = is_accountingdocheader-fiscalyear
                                                 awtyp = is_accountingdocheader-referencedocumenttype
                                                 waers = is_accountingdocheader-transactioncurrency
                                                 kursf = is_accountingdocheader-exchangerate
                                                 bldat = is_accountingdocheader-documentdate
                                                 ernam = is_accountingdocheader-accountingdoccreatedbyuser
                                                 erdat = is_accountingdocheader-accountingdocumentcreationdate
                                                 erzet = is_accountingdocheader-creationtime ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    LOOP AT it_accountingdocitems INTO DATA(ls_accountingdocitem_partner) WHERE ( financialaccounttype = 'D' OR
                                                                                  financialaccounttype = 'K' )
                                                                            AND debitcreditcode = 'S'.
      IF ls_accountingdocitem_partner-amountintransactioncurrency IS INITIAL AND ls_accountingdocitem_partner-amountincompanycodecurrency IS NOT INITIAL.
        ls_accountingdocitem_partner-amountintransactioncurrency = ls_accountingdocitem_partner-amountincompanycodecurrency.
        ls_edocument-waers = is_accountingdocheader-companycodecurrency.
        ls_edocument-kursf = 1.
      ENDIF.
      ls_edocument-wrbtr += ls_accountingdocitem_partner-amountintransactioncurrency.

      ls_edocument-werks = ls_accountingdocitem_partner-plant.
      ls_edocument-gsber = ls_accountingdocitem_partner-businessarea.
    ENDLOOP.
    CHECK ls_accountingdocitem_partner IS NOT INITIAL.

    CASE ls_accountingdocitem_partner-debitcreditcode.
      WHEN 'S'.
        CASE ls_accountingdocitem_partner-financialaccounttype.
          WHEN 'D'.
            DATA(ls_partner_data) = get_partner_register_data( iv_customer = ls_accountingdocitem_partner-customer ).
          WHEN 'K'.
            ls_partner_data = get_partner_register_data( iv_supplier = ls_accountingdocitem_partner-supplier ).
        ENDCASE.
        ls_edocument-partner = ls_partner_data-businesspartner.
        ls_edocument-aliass = ls_partner_data-aliass.
        ls_edocument-taxid = ls_partner_data-bptaxnumber.
        DATA(ls_invoice_rules_input) = VALUE zetr_s_invoice_rules_in( awtyp = 'BKPF'
                                                                      werks = ls_edocument-werks
                                                                      fidty = is_accountingdocheader-accountingdocumenttype
                                                                      partner = ls_partner_data-businesspartner ).
        DATA(ls_invoice_rules_output) = get_einvoice_rule( iv_rule_type  = 'P'
                                                           is_rule_input = ls_invoice_rules_input ).
        IF ( ls_invoice_rules_output IS NOT INITIAL AND
             ls_invoice_rules_output-excld = abap_false AND
             ls_partner_data-registerdate IS NOT INITIAL AND
             ls_partner_data-registerdate <= is_accountingdocheader-documentdate ) OR
            ( ls_invoice_rules_output-pidou = 'IHRACAT' OR ls_invoice_rules_output-pidou = 'YOLCU' ).
          SELECT SINGLE datab, datbi, prfid
            FROM zetr_t_eipar
            WHERE bukrs = @mv_company_code
            INTO @DATA(ls_invoice_parameters).
        ELSE.
          CLEAR ls_invoice_rules_output.
          ls_invoice_rules_output = get_earchive_rule( iv_rule_type  = 'P'
                                                       is_rule_input = ls_invoice_rules_input ).
          CHECK ls_invoice_rules_output IS NOT INITIAL AND ls_invoice_rules_output-excld = abap_false.
          SELECT SINGLE datab, datbi, 'EARSIV' AS prfid
            FROM zetr_t_eapar
            WHERE bukrs = @mv_company_code
            INTO @ls_invoice_parameters.
        ENDIF.
        CHECK sy-subrc = 0 AND is_accountingdocheader-documentdate BETWEEN ls_invoice_parameters-datab AND ls_invoice_parameters-datbi.
        ls_edocument-prfid = COND #( WHEN ls_invoice_rules_output-pidou IS NOT INITIAL THEN ls_invoice_rules_output-pidou ELSE ls_invoice_parameters-prfid ).
        ls_edocument-invty = ls_invoice_rules_output-ityou.
        ls_edocument-taxex = ls_invoice_rules_output-taxex.

        SELECT SINGLE company~chartofaccounts, country~taxcalculationprocedure
          FROM i_companycode AS company
          INNER JOIN i_country AS country
            ON country~country = company~country
          WHERE company~companycode = @is_accountingdocheader-companycode
          INTO @DATA(ls_company_parameters).

        SELECT saknr, accty, taxty
          FROM zetr_t_fiacc
          FOR ALL ENTRIES IN @it_accountingdocitems
          WHERE ktopl = @ls_company_parameters-chartofaccounts
            AND saknr = @it_accountingdocitems-glaccount
            AND accty IN ('O','I')
          INTO TABLE @DATA(lt_account_parameters).
        SORT lt_account_parameters BY saknr.

        SELECT *
          FROM zetr_t_taxmc
          FOR ALL ENTRIES IN @it_accountingdocitems
          WHERE kalsm = @ls_company_parameters-taxcalculationprocedure
            AND mwskz = @it_accountingdocitems-taxcode
          INTO TABLE @DATA(lt_taxcode_parameters).
        SORT lt_taxcode_parameters BY mwskz.

        LOOP AT it_accountingdocitems INTO DATA(ls_accountingdocitem_tax).
          IF ls_accountingdocitem_tax-amountintransactioncurrency IS INITIAL AND ls_accountingdocitem_tax-amountincompanycodecurrency IS NOT INITIAL.
            ls_accountingdocitem_tax-amountintransactioncurrency = ls_accountingdocitem_tax-amountincompanycodecurrency.
          ENDIF.
          IF ls_accountingdocitem_tax-debitcreditcode = 'S'.
            ls_accountingdocitem_tax-amountintransactioncurrency = ls_accountingdocitem_tax-amountintransactioncurrency * -1.
          ENDIF.
          DATA(lv_hkont) = COND hkont( WHEN ls_accountingdocitem_tax-alternativeglaccount IS NOT INITIAL THEN ls_accountingdocitem_tax-alternativeglaccount ELSE ls_accountingdocitem_tax-glaccount ).
          READ TABLE lt_account_parameters INTO DATA(ls_account_parameter) WITH KEY saknr = lv_hkont BINARY SEARCH.
          CHECK sy-subrc = 0.
          ls_edocument-fwste += ls_accountingdocitem_tax-amountintransactioncurrency.

          CHECK ls_accountingdocitem_tax-taxcode IS NOT INITIAL.
          READ TABLE lt_taxcode_parameters INTO DATA(ls_taxcode_parameter) WITH KEY mwskz = ls_accountingdocitem_tax-taxcode BINARY SEARCH.
          IF sy-subrc = 0.
            IF ls_edocument-invty IS INITIAL.
              ls_edocument-invty = ls_taxcode_parameter-invty.
            ENDIF.
            ls_edocument-taxex = ls_taxcode_parameter-taxex.
          ENDIF.
        ENDLOOP.
        IF ls_edocument-fwste IS INITIAL.
          ls_edocument-texex = abap_true.
        ENDIF.

        ls_invoice_rules_input-pidin = ls_edocument-prfid.
        ls_invoice_rules_input-ityin = ls_edocument-invty.

        CASE ls_edocument-prfid.
          WHEN 'EARSIV'.
            CLEAR ls_invoice_rules_output.
            ls_invoice_rules_output = get_earchive_rule( iv_rule_type  = 'S'
                                                         is_rule_input = ls_invoice_rules_input ).
            ls_edocument-serpr = ls_invoice_rules_output-serpr.
            IF ls_edocument-serpr IS INITIAL.
              SELECT SINGLE serpr
                FROM zetr_t_easer
                WHERE bukrs = @is_accountingdocheader-companycode
                  AND maisp = @abap_true
                INTO @ls_edocument-serpr.
            ENDIF.

            CLEAR ls_invoice_rules_output.
            ls_invoice_rules_output = get_earchive_rule( iv_rule_type  = 'X'
                                                         is_rule_input = ls_invoice_rules_input ).
            ls_edocument-xsltt = ls_invoice_rules_output-xsltt.
            IF ls_edocument-xsltt IS INITIAL.
              SELECT SINGLE xsltt
                FROM zetr_t_eaxslt
                WHERE bukrs = @is_accountingdocheader-companycode
                  AND deflt = @abap_true
                INTO @ls_edocument-xsltt.
            ENDIF.
          WHEN OTHERS.
            CLEAR ls_invoice_rules_output.
            ls_invoice_rules_output = get_einvoice_rule( iv_rule_type  = 'S'
                                                         is_rule_input = ls_invoice_rules_input ).
            ls_edocument-serpr = ls_invoice_rules_output-serpr.
            IF ls_edocument-serpr IS INITIAL.
              DATA(lv_serial_type) = SWITCH zetr_e_insrt( ls_edocument-prfid WHEN 'IHRACAT' OR 'YOLCU' THEN ls_edocument-prfid ELSE 'YURTICI' ).
              SELECT SINGLE serpr
                FROM zetr_t_eiser
                WHERE bukrs = @is_accountingdocheader-companycode
                  AND insrt = @lv_serial_type
                  AND maisp = @abap_true
                INTO @ls_edocument-serpr.
            ENDIF.

            CLEAR ls_invoice_rules_output.
            ls_invoice_rules_output = get_einvoice_rule( iv_rule_type  = 'X'
                                                         is_rule_input = ls_invoice_rules_input ).
            ls_edocument-xsltt = ls_invoice_rules_output-xsltt.
            IF ls_edocument-xsltt IS INITIAL.
              SELECT SINGLE xsltt
                FROM zetr_t_eixslt
                WHERE bukrs = @is_accountingdocheader-companycode
                  AND deflt = @abap_true
                INTO @ls_edocument-xsltt.
            ENDIF.
        ENDCASE.

        READ TABLE ct_accountingdocitemsout ASSIGNING FIELD-SYMBOL(<ls_accountingitemout>) WITH KEY rowindex = ls_accountingdocitem_partner-rowindex.
        IF sy-subrc = 0.
          <ls_accountingitemout>-einvoiceuuid = ls_edocument-docui.
          cv_substitutiondone = abap_true.
        ENDIF.

        INSERT zetr_t_oginv FROM @ls_edocument.
      WHEN 'H'.

    ENDCASE.
  ENDMETHOD.

  METHOD get_partner_register_data.
    IF iv_customer IS NOT INITIAL.
      SELECT  customer~businesspartner, tax~bptaxnumber, register~aliass, register~regdt AS registerdate, register~title
        FROM i_businesspartnercustomer AS customer
        LEFT OUTER JOIN i_businesspartnertaxnumber AS tax
          ON tax~businesspartner = customer~businesspartner
          AND ( tax~bptaxtype = 'TR2' OR tax~bptaxtype = 'TR3' )
        LEFT OUTER JOIN zetr_t_inv_ruser AS register
          ON register~taxid = tax~bptaxnumber
        WHERE customer~customer = @iv_customer
        ORDER BY register~defal DESCENDING
        INTO @rs_data.
      ENDSELECT.
    ELSEIF iv_supplier IS NOT INITIAL.
      SELECT  supplier~businesspartner, tax~bptaxnumber, register~aliass, register~regdt AS registerdate, register~title
        FROM i_businesspartnersupplier AS supplier
        LEFT OUTER JOIN i_businesspartnertaxnumber AS tax
          ON tax~businesspartner = supplier~businesspartner
          AND ( tax~bptaxtype = 'TR2' OR tax~bptaxtype = 'TR3' )
        LEFT OUTER JOIN zetr_t_inv_ruser AS register
          ON register~taxid = tax~bptaxnumber
        WHERE supplier~supplier = @iv_supplier
        ORDER BY register~defal DESCENDING
        INTO @rs_data.
      ENDSELECT.
    ELSEIF iv_partner IS NOT INITIAL.
      SELECT  partner~businesspartner, tax~bptaxnumber, register~aliass, register~regdt AS registerdate, register~title
        FROM i_businesspartner AS partner
        LEFT OUTER JOIN i_businesspartnertaxnumber AS tax
          ON tax~businesspartner = partner~businesspartner
          AND ( tax~bptaxtype = 'TR2' OR tax~bptaxtype = 'TR3' )
        LEFT OUTER JOIN zetr_t_inv_ruser AS register
          ON register~taxid = tax~bptaxnumber
        WHERE partner~businesspartner = @iv_partner
        ORDER BY register~defal DESCENDING
        INTO @rs_data.
      ENDSELECT.
    ENDIF.
  ENDMETHOD.

  METHOD get_einvoice_rule.
    DATA: lt_awtyp   TYPE RANGE OF zetr_e_awtyp,
          lt_vkorg   TYPE RANGE OF zetr_e_vkorg,
          lt_vtweg   TYPE RANGE OF zetr_e_vtweg,
          lt_werks   TYPE RANGE OF werks_d,
          lt_invty   TYPE RANGE OF zetr_e_invty,
          lt_sddty   TYPE RANGE OF zetr_e_fkart,
          lt_mmdty   TYPE RANGE OF zetr_e_mmidt,
          lt_fidty   TYPE RANGE OF zetr_e_fidty,
          lt_partner TYPE RANGE OF zetr_e_partner,
          lt_prfid   TYPE RANGE OF zetr_e_inprf,
          lt_vbeln   TYPE RANGE OF sd_sls_document,
          ls_rule    TYPE zetr_t_eirules.

    lt_awtyp   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-awtyp   ) ).
    lt_vkorg   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vkorg   ) ).
    lt_vtweg   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vtweg   ) ).
    lt_werks   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-werks   ) ).
    lt_invty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-ityin   ) ).
    lt_sddty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-sddty   ) ).
    lt_mmdty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-mmdty   ) ).
    lt_fidty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-fidty   ) ).
    lt_partner = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-partner ) ).
    lt_prfid   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-pidin   ) ).
    lt_vbeln   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vbeln   ) ).

    SORT: lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_partner, lt_prfid, lt_vbeln.
    DELETE ADJACENT DUPLICATES FROM: lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_partner, lt_prfid, lt_vbeln.

    SELECT *
      FROM zetr_t_eirules
      WHERE bukrs EQ @mv_company_code
        AND rulet EQ @iv_rule_type
        AND awtyp IN @lt_awtyp
        AND vkorg IN @lt_vkorg
        AND vtweg IN @lt_vtweg
        AND werks IN @lt_werks
        AND ityin IN @lt_invty
        AND sddty IN @lt_sddty
        AND mmdty IN @lt_mmdty
        AND fidty IN @lt_fidty
        AND pidin IN @lt_prfid
        AND vbeln IN @lt_vbeln
        AND partner IN @lt_partner
      ORDER BY  awtyp   DESCENDING,
                vkorg   DESCENDING,
                vtweg   DESCENDING,
                werks   DESCENDING,
                ityin   DESCENDING,
                sddty   DESCENDING,
                mmdty   DESCENDING,
                fidty   DESCENDING,
                pidin   DESCENDING,
                vbeln   DESCENDING,
                partner DESCENDING
      INTO @ls_rule.
      IF ls_rule-awtyp IS NOT INITIAL.
        CHECK ls_rule-awtyp = is_rule_input-awtyp.
      ENDIF.
      IF ls_rule-vkorg IS NOT INITIAL.
        CHECK ls_rule-vkorg = is_rule_input-vkorg.
      ENDIF.
      IF ls_rule-vtweg IS NOT INITIAL.
        CHECK ls_rule-vtweg = is_rule_input-vtweg.
      ENDIF.
      IF ls_rule-werks IS NOT INITIAL.
        CHECK ls_rule-werks = is_rule_input-werks.
      ENDIF.
      IF ls_rule-pidin IS NOT INITIAL.
        CHECK ls_rule-pidin = is_rule_input-pidin.
      ENDIF.
      IF ls_rule-ityin IS NOT INITIAL.
        CHECK ls_rule-ityin = is_rule_input-ityin.
      ENDIF.
      IF ls_rule-sddty IS NOT INITIAL.
        CHECK ls_rule-sddty = is_rule_input-sddty.
      ENDIF.
      IF ls_rule-mmdty IS NOT INITIAL.
        CHECK ls_rule-mmdty = is_rule_input-mmdty.
      ENDIF.
      IF ls_rule-fidty IS NOT INITIAL.
        CHECK ls_rule-fidty = is_rule_input-fidty.
      ENDIF.
      IF ls_rule-vbeln IS NOT INITIAL.
        CHECK ls_rule-vbeln = is_rule_input-vbeln.
      ENDIF.
      IF ls_rule-partner IS NOT INITIAL.
        CHECK ls_rule-partner = is_rule_input-partner.
      ENDIF.
      MOVE-CORRESPONDING ls_rule TO rs_rule_output.
      EXIT.
    ENDSELECT.
  ENDMETHOD.

  METHOD get_earchive_rule.
    DATA: lt_awtyp   TYPE RANGE OF zetr_e_awtyp,
          lt_vkorg   TYPE RANGE OF zetr_e_vkorg,
          lt_vtweg   TYPE RANGE OF zetr_e_vtweg,
          lt_werks   TYPE RANGE OF werks_d,
          lt_invty   TYPE RANGE OF zetr_e_invty,
          lt_sddty   TYPE RANGE OF zetr_e_fkart,
          lt_mmdty   TYPE RANGE OF zetr_e_mmidt,
          lt_fidty   TYPE RANGE OF zetr_e_fidty,
          lt_partner TYPE RANGE OF zetr_e_partner,
          lt_prfid   TYPE RANGE OF zetr_e_inprf,
          lt_vbeln   TYPE RANGE OF sd_sls_document,
          ls_rule    TYPE zetr_t_earules.

    lt_awtyp   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-awtyp   ) ).
    lt_vkorg   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vkorg   ) ).
    lt_vtweg   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vtweg   ) ).
    lt_werks   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-werks   ) ).
    lt_invty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-ityin   ) ).
    lt_sddty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-sddty   ) ).
    lt_mmdty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-mmdty   ) ).
    lt_fidty   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-fidty   ) ).
    lt_partner = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-partner ) ).
    lt_prfid   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-pidin   ) ).
    lt_vbeln   = VALUE #( sign = 'I' option = 'EQ' ( low = ''  ) ( low = is_rule_input-vbeln   ) ).

    SORT: lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_partner, lt_prfid, lt_vbeln.
    DELETE ADJACENT DUPLICATES FROM: lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_partner, lt_prfid, lt_vbeln.

    SELECT *
      FROM zetr_t_earules
      WHERE bukrs EQ @mv_company_code
        AND rulet EQ @iv_rule_type
        AND awtyp IN @lt_awtyp
        AND vkorg IN @lt_vkorg
        AND vtweg IN @lt_vtweg
        AND werks IN @lt_werks
        AND ityin IN @lt_invty
        AND sddty IN @lt_sddty
        AND mmdty IN @lt_mmdty
        AND fidty IN @lt_fidty
        AND pidin IN @lt_prfid
        AND vbeln IN @lt_vbeln
        AND partner IN @lt_partner
      ORDER BY  awtyp   DESCENDING,
                vkorg   DESCENDING,
                vtweg   DESCENDING,
                werks   DESCENDING,
                ityin   DESCENDING,
                sddty   DESCENDING,
                mmdty   DESCENDING,
                fidty   DESCENDING,
                pidin   DESCENDING,
                vbeln   DESCENDING,
                partner DESCENDING
      INTO @ls_rule.
      IF ls_rule-awtyp IS NOT INITIAL.
        CHECK ls_rule-awtyp = is_rule_input-awtyp.
      ENDIF.
      IF ls_rule-vkorg IS NOT INITIAL.
        CHECK ls_rule-vkorg = is_rule_input-vkorg.
      ENDIF.
      IF ls_rule-vtweg IS NOT INITIAL.
        CHECK ls_rule-vtweg = is_rule_input-vtweg.
      ENDIF.
      IF ls_rule-werks IS NOT INITIAL.
        CHECK ls_rule-werks = is_rule_input-werks.
      ENDIF.
      IF ls_rule-pidin IS NOT INITIAL.
        CHECK ls_rule-pidin = is_rule_input-pidin.
      ENDIF.
      IF ls_rule-ityin IS NOT INITIAL.
        CHECK ls_rule-ityin = is_rule_input-ityin.
      ENDIF.
      IF ls_rule-sddty IS NOT INITIAL.
        CHECK ls_rule-sddty = is_rule_input-sddty.
      ENDIF.
      IF ls_rule-mmdty IS NOT INITIAL.
        CHECK ls_rule-mmdty = is_rule_input-mmdty.
      ENDIF.
      IF ls_rule-fidty IS NOT INITIAL.
        CHECK ls_rule-fidty = is_rule_input-fidty.
      ENDIF.
      IF ls_rule-vbeln IS NOT INITIAL.
        CHECK ls_rule-vbeln = is_rule_input-vbeln.
      ENDIF.
      IF ls_rule-partner IS NOT INITIAL.
        CHECK ls_rule-partner = is_rule_input-partner.
      ENDIF.
      MOVE-CORRESPONDING ls_rule TO rs_rule_output.
      EXIT.
    ENDSELECT.

    IF sy-subrc = 0 AND iv_rule_type = 'P' AND rs_rule_output-pidou IS INITIAL AND rs_rule_output-excld = abap_false.
      rs_rule_output-pidou = 'EARSIV'.
    ENDIF.
  ENDMETHOD.

  METHOD outgoing_invoice_save_bkpf.
    TYPES: BEGIN OF ty_taxpayer,
             aliass TYPE zetr_e_alias,
             regdt  TYPE budat,
             defal  TYPE abap_boolean,
             txpty  TYPE zetr_e_txpty,
           END OF ty_taxpayer,
           BEGIN OF ty_company,
             datab TYPE datum,
             datbi TYPE datum,
             genid TYPE zetr_e_genid,
             prfid TYPE zetr_e_inprf,
           END OF ty_company,
           BEGIN OF ty_tax_data,
             invty TYPE zetr_e_invty,
             taxex TYPE zetr_e_taxex,
             taxty TYPE zetr_e_taxty,
             taxrt TYPE zetr_e_taxrt,
           END OF ty_tax_data,
           BEGIN OF ty_bkpf,
             belnr TYPE belnr_d,
             gjahr TYPE gjahr,
             bldat TYPE bldat,
             erdat TYPE datum,
             erzet TYPE uzeit,
             waers TYPE waers,
             hwaer TYPE waers,
             kursf TYPE zetr_e_kursf,
             blart TYPE blart,
             usnam TYPE usnam,
           END OF ty_bkpf,
           BEGIN OF ty_bseg,
             buzei TYPE buzei,
             shkzg TYPE shkzg,
             hkont TYPE hkont,
             lokkt TYPE hkont,
             koart TYPE koart,
             kunnr TYPE lifnr,
             lifnr TYPE lifnr,
             wrbtr TYPE wrbtr_cs,
             dmbtr TYPE wrbtr_cs,
             mwskz TYPE mwskz,
             gsber TYPE gsber,
             werks TYPE werks_d,
           END OF ty_bseg.
    DATA: lt_bseg                TYPE STANDARD TABLE OF ty_bseg,
          ls_bseg_partner        TYPE ty_bseg,
          ls_bseg                TYPE ty_bseg,
          ls_bkpf                TYPE ty_bkpf,
          ls_tax_data            TYPE ty_tax_data,
          ls_company_data        TYPE ty_company,
          lt_taxpayer            TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer            TYPE ty_taxpayer,
          ls_document            TYPE zetr_t_oginv,
          ls_invoice_rule_input  TYPE zetr_s_invoice_rules_in,
          ls_invoice_rule_output TYPE zetr_s_invoice_rules_out,
          ls_bsec                TYPE i_journalentryitemonetimedata,
          lt_tax_acc             TYPE STANDARD TABLE OF zetr_t_fiacc,
          ls_bseg_tax            TYPE ty_bseg,
          lv_insrt               TYPE zetr_e_insrt.

    SELECT SINGLE accountingdocument AS belnr,
                  fiscalyear AS gjahr,
                  documentdate AS bldat,
                  accountingdocumentcreationdate AS erdat,
                  creationtime AS erzet,
                  transactioncurrency AS waers,
                  companycodecurrency AS hwaer,
                  absoluteexchangerate AS kursf,
                  accountingdocumenttype AS blart,
                  accountingdoccreatedbyuser AS usnam
      FROM i_journalentry
      WHERE companycode = @iv_bukrs
        AND accountingdocument = @iv_belnr
        AND fiscalyear = @iv_gjahr
        AND isreversal = ''
        AND isreversed = ''
      INTO @ls_bkpf.
    CHECK ls_bkpf IS NOT INITIAL.

    SELECT accountingdocumentitem AS buzei,
           debitcreditcode AS shkzg,
           glaccount AS hkont,
           alternativeglaccount AS lokkt,
           financialaccounttype AS koart,
           customer AS kunnr,
           supplier AS lifnr,
           amountintransactioncurrency AS wrbtr,
           amountincompanycodecurrency AS dmbtr,
           taxcode AS mwskz,
           profitcenter AS gsber,
           plant AS werks
      FROM i_journalentryitem
      WHERE companycode = @iv_bukrs
        AND accountingdocument = @iv_belnr
        AND fiscalyear = @iv_gjahr
        AND ledger = '0L'
      INTO TABLE @lt_bseg.

    ls_document-waers = ls_bkpf-waers.
    LOOP AT lt_bseg INTO ls_bseg_partner WHERE ( koart = 'K' OR koart = 'D' ) AND shkzg = 'S'.
      IF ls_bseg_partner-wrbtr IS INITIAL AND ls_bseg_partner-dmbtr IS NOT INITIAL.
        ls_bseg_partner-wrbtr = ls_bseg_partner-dmbtr.
        ls_document-waers = ls_bkpf-hwaer.
        ls_document-kursf = 1.
      ENDIF.
      ls_document-wrbtr += ls_bseg_partner-wrbtr.

      ls_document-werks = ls_bseg_partner-werks.
      ls_document-gsber = ls_bseg_partner-gsber.
    ENDLOOP.
    CHECK sy-subrc IS INITIAL.
    READ TABLE lt_bseg INTO ls_bseg WITH KEY koart = 'S'
                                             shkzg = 'H'.
    CHECK sy-subrc IS INITIAL.

    SELECT SINGLE taxid2
      FROM i_journalentryitemonetimedata
      WHERE companycode = @iv_bukrs
        AND accountingdocument = @iv_belnr
        AND fiscalyear = @iv_gjahr
      INTO @ls_document-taxid.

    IF ls_document-taxid IS INITIAL AND ls_bseg_partner-kunnr IS NOT INITIAL.
      DATA(ls_partner_data) = get_partner_register_data( iv_customer = ls_bseg_partner-kunnr ).
    ELSEIF ls_document-taxid IS INITIAL AND ls_bseg_partner-lifnr IS NOT INITIAL.
      ls_partner_data = get_partner_register_data( iv_supplier = ls_bseg_partner-lifnr ).
    ENDIF.

    ls_document-taxid = ls_partner_data-bptaxnumber.
    ls_document-partner = ls_partner_data-businesspartner.
    ls_document-bldat = ls_bkpf-bldat.
    ls_document-werks = ls_bseg-werks.

    ls_invoice_rule_input-awtyp = iv_awtyp.
    ls_invoice_rule_input-fidty = ls_bkpf-blart.
    ls_invoice_rule_input-partner = ls_document-partner.
    ls_invoice_rule_input-werks = ls_bseg-werks.

    SELECT SINGLE datab, datbi, genid, prfid
      FROM zetr_t_eipar
      WHERE bukrs = @iv_bukrs
      INTO @ls_company_data.
    IF sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.
      ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'P'
                                                  is_rule_input  = ls_invoice_rule_input ).
      IF ls_invoice_rule_output IS NOT INITIAL AND ls_invoice_rule_output-excld = abap_false.
        ls_document-prfid = ls_invoice_rule_output-pidou.
        ls_document-invty = ls_invoice_rule_output-ityou.
        ls_document-taxex = ls_invoice_rule_output-taxex.
      ENDIF.
    ENDIF.

    IF ls_document-taxid IS NOT INITIAL.
      " check if partner is registered
      SELECT aliass, regdt, defal, txpty
        FROM zetr_t_inv_ruser
        WHERE taxid = @ls_document-taxid
          AND regdt <= @ls_document-bldat
          INTO TABLE @lt_taxpayer.
      IF sy-subrc = 0.
        SORT lt_taxpayer BY defal.
        READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
        IF sy-subrc = 0.
          ls_document-aliass = ls_taxpayer-aliass.
        ELSE.
          SORT lt_taxpayer DESCENDING BY regdt.
          READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
          IF sy-subrc EQ 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ENDIF.
        ENDIF.

        IF ls_taxpayer-txpty EQ 'KAMU'.
          ls_document-prfid = 'KAMU'.
        ENDIF.

        IF ls_document-prfid IS INITIAL.
          IF ls_company_data-prfid IS INITIAL.
            ls_company_data-prfid = 'TEMEL'.
          ENDIF.
          ls_document-prfid = ls_company_data-prfid.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lt_taxpayer IS INITIAL AND ls_document-prfid NE 'IHRACAT' AND ls_document-prfid NE 'YOLCU'.
      SELECT SINGLE datab, datbi, genid
        FROM zetr_t_eapar
        WHERE bukrs = @iv_bukrs
        INTO @ls_company_data.
      CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.

      ls_document-prfid = 'EARSIV'.
      ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'P'
                                                  is_rule_input  = ls_invoice_rule_input ).
      IF ls_invoice_rule_output IS NOT INITIAL AND ls_invoice_rule_output-excld = abap_true.
        ls_document-invty = ls_invoice_rule_output-ityou.
        ls_document-taxex = ls_invoice_rule_output-taxex.
      ENDIF.
    ENDIF.

    CHECK ls_document-prfid IS NOT INITIAL.

    SELECT *
      FROM zetr_t_fiacc
      WHERE accty IN ('O','I')
      INTO TABLE @lt_tax_acc.
    SORT lt_tax_acc BY saknr.

    SELECT SINGLE company~chartofaccounts, country~taxcalculationprocedure
      FROM i_companycode AS company
      INNER JOIN i_country AS country
        ON country~country = company~country
      WHERE company~companycode = @iv_bukrs
      INTO @DATA(ls_company_parameters).

    DATA lv_hkont TYPE hkont .
    LOOP AT lt_bseg INTO ls_bseg_tax.
      CLEAR ls_tax_data.
      "-- Lokkt kontrolü STASKAN 24.12.2021
      lv_hkont = ls_bseg_tax-lokkt .
      IF  lv_hkont IS INITIAL .
        lv_hkont = ls_bseg_tax-hkont .
      ENDIF.

      SELECT SINGLE invty, taxex, taxty, taxrt
        FROM zetr_t_taxmc
        WHERE kalsm = @ls_company_parameters-taxcalculationprocedure
          AND mwskz = @ls_bseg_tax-mwskz
        INTO @ls_tax_data.
      IF sy-subrc EQ 0 AND ls_tax_data-taxrt EQ '0'.
        ls_document-texex = abap_true.
      ENDIF.

      READ TABLE lt_tax_acc WITH KEY saknr = lv_hkont BINARY SEARCH TRANSPORTING NO FIELDS.
      CHECK sy-subrc = 0.

      IF ls_bseg_tax-wrbtr IS INITIAL AND ls_bseg_tax-dmbtr IS NOT INITIAL.
        ls_bseg_tax-wrbtr = ls_bseg_tax-dmbtr.
      ENDIF.
      IF ls_bseg_tax-shkzg = 'S'.
        ls_bseg_tax-wrbtr = ls_bseg_tax-wrbtr * -1.
      ENDIF.
      ls_document-fwste += ls_bseg_tax-wrbtr.
      IF ls_bseg_tax-wrbtr IS INITIAL.
        ls_document-texex = abap_true.
      ENDIF.
      IF ls_document-invty IS INITIAL AND ls_bseg_tax-mwskz IS NOT INITIAL AND ls_tax_data IS NOT INITIAL.
        ls_document-invty = ls_tax_data-invty.
      ENDIF.
      IF ls_document-taxex IS INITIAL AND ls_bseg_tax-mwskz IS NOT INITIAL AND ls_tax_data IS NOT INITIAL.
        ls_document-taxex = ls_tax_data-taxex.
      ENDIF.
      IF ls_document-taxty IS INITIAL.
        ls_document-taxty = ls_tax_data-taxty. " AS 30.12.2021
      ENDIF.
    ENDLOOP.
    IF ls_document-fwste IS INITIAL.
      ls_document-texex = abap_true.
    ENDIF.
    IF ls_document-invty IS INITIAL AND ls_bseg_partner-mwskz IS NOT INITIAL.
      SELECT SINGLE invty, taxex
        FROM zetr_t_taxmc
        WHERE kalsm = @ls_company_parameters-taxcalculationprocedure
          AND mwskz = @ls_bseg_partner-mwskz
        INTO @ls_tax_data.
      IF sy-subrc = 0.
        ls_document-invty = ls_tax_data-invty.
        ls_document-taxex = ls_tax_data-taxex.
      ENDIF.
    ENDIF.

    TRY .
        ls_document-docui = cl_system_uuid=>create_uuid_c22_static( ).
        ls_document-invui = cl_system_uuid=>create_uuid_c36_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    ls_document-docty = ls_bkpf-blart.
    ls_document-awtyp = iv_awtyp(4).
    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-ernam = ls_bkpf-usnam.
    ls_document-erzet = ls_bkpf-erzet.
    ls_document-erdat = ls_bkpf-erdat.
    IF ls_document-kursf IS INITIAL.
      IF ls_bkpf-kursf IS NOT INITIAL.
        ls_document-kursf = ls_bkpf-kursf.
      ELSEIF ls_bkpf-waers = ls_bkpf-hwaer.
        ls_document-kursf = 1.
      ENDIF.
    ENDIF.

    CASE ls_document-prfid.
      WHEN 'EARSIV'.
        ls_invoice_rule_input-ityin = ls_document-invty.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_invoice_rule_output.
          ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'S'
                                                      is_rule_input  = ls_invoice_rule_input ).
          IF ls_invoice_rule_output IS NOT INITIAL.
            ls_document-serpr = ls_invoice_rule_output-serpr.
          ELSE.
            SELECT SINGLE serpr
              FROM zetr_t_easer
              WHERE bukrs = @iv_bukrs
                AND maisp = @abap_true
              INTO @ls_document-serpr.
          ENDIF.
        ENDIF.

        CLEAR ls_invoice_rule_output.
        ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'X'
                                              is_rule_input  = ls_invoice_rule_input ).
        IF ls_invoice_rule_output IS NOT INITIAL.
          ls_document-xsltt = ls_invoice_rule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM zetr_t_eaxslt
            WHERE bukrs = @iv_bukrs
              AND deflt = @abap_true
            INTO @ls_document-xsltt.
        ENDIF.
      WHEN OTHERS.
        ls_invoice_rule_input-ityin = ls_document-invty.
        ls_invoice_rule_input-pidin = ls_document-prfid.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_invoice_rule_output.
          ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'S'
                                                      is_rule_input  = ls_invoice_rule_input ).
          IF ls_invoice_rule_output IS NOT INITIAL.
            ls_document-serpr = ls_invoice_rule_output-serpr.
          ELSE.
            CASE ls_document-prfid.
              WHEN 'IHRACAT'.
                lv_insrt = 'E'.
              WHEN 'YOLCU'.
                lv_insrt = 'T'.
              WHEN OTHERS.
                lv_insrt = 'D'.
            ENDCASE.
            SELECT SINGLE serpr
              FROM zetr_t_eiser
              WHERE bukrs = @iv_bukrs
                AND maisp = @abap_true
                AND insrt = @lv_insrt
              INTO @ls_document-serpr.
          ENDIF.
        ENDIF.

        CLEAR ls_invoice_rule_output.
        ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'X'
                                                    is_rule_input  = ls_invoice_rule_input ).
        IF ls_invoice_rule_output IS NOT INITIAL.
          ls_document-xsltt = ls_invoice_rule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM zetr_t_eixslt
            WHERE bukrs = @iv_bukrs
              AND deflt = @abap_true
            INTO @ls_document-xsltt.
        ENDIF.
    ENDCASE.
    rs_document = ls_document.
  ENDMETHOD.

  METHOD outgoing_invoice_save_rmrp.
    TYPES: BEGIN OF ty_taxpayer,
             aliass TYPE zetr_e_alias,
             regdt  TYPE budat,
             defal  TYPE abap_boolean,
             txpty  TYPE zetr_e_txpty,
           END OF ty_taxpayer,
           BEGIN OF ty_company,
             datab TYPE datum,
             datbi TYPE datum,
             genid TYPE zetr_e_genid,
             prfid TYPE zetr_e_inprf,
           END OF ty_company,
           BEGIN OF ty_tax_data,
             invty TYPE zetr_e_invty,
             taxex TYPE zetr_e_taxex,
             taxty TYPE zetr_e_taxty,
           END OF ty_tax_data,
           BEGIN OF ty_rbkp,
             belnr TYPE belnr_d,
             gjahr TYPE gjahr,
             bldat TYPE bldat,
             lifnr TYPE lifnr,
             xrech TYPE xrech,
             stblg TYPE belnr_d,
             waers TYPE waers,
             cpudt TYPE datum,
             rmwwr TYPE rmwwr,
             wmwst TYPE wrbtr_cs,
             mwskz TYPE mwskz,
             kursf TYPE zetr_e_kursf,
             blart TYPE blart,
             usnam TYPE usnam,
           END OF ty_rbkp.
    DATA: ls_rbkp                TYPE ty_rbkp,
          ls_tax_data            TYPE ty_tax_data,
          ls_company_data        TYPE ty_company,
          lt_taxpayer            TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer            TYPE ty_taxpayer,
          ls_document            TYPE zetr_t_oginv,
          ls_invoice_rule_input  TYPE zetr_s_invoice_rules_in,
          ls_invoice_rule_output TYPE zetr_s_invoice_rules_out,
          lv_insrt               TYPE zetr_e_insrt.

    SELECT SINGLE invoice~supplierinvoice AS belnr,
                  invoice~fiscalyear AS gjahr,
                  invoice~documentdate AS bldat,
                  invoice~invoicingparty AS lifnr,
                  invoice~isinvoice AS xrech,
                  invoice~reversedocument AS stblg,
                  invoice~documentcurrency AS waers,
                  invoice~creationdate AS cpudt,
                  invoice~invoicegrossamount AS rmwwr,
                  tax~taxamount AS wmwst,
                  tax~taxcode AS mwskz,
                  invoice~exchangerate AS kursf,
                  invoice~accountingdocumenttype AS blart,
                  invoice~lastchangedbyuser AS usnam
      FROM i_supplierinvoiceapi01 AS invoice
      LEFT OUTER JOIN i_supplierinvoicetaxapi01 AS tax
        ON  tax~supplierinvoice = invoice~supplierinvoice
        AND tax~fiscalyear = invoice~fiscalyear
      WHERE invoice~supplierinvoice = @iv_belnr
        AND invoice~fiscalyear = @iv_gjahr
      INTO @ls_rbkp.

    CHECK ls_rbkp IS NOT INITIAL
      AND ls_rbkp-xrech = ''
      AND ls_rbkp-stblg = ''.

    DATA(ls_partner_data) = get_partner_register_data( iv_supplier = ls_rbkp-lifnr ).

    ls_document-bldat = ls_rbkp-bldat.

    ls_invoice_rule_input-awtyp = iv_awtyp.
    ls_invoice_rule_input-mmdty = ls_rbkp-blart.
    ls_invoice_rule_input-partner = ls_partner_data-businesspartner.

    SELECT SINGLE datab, datbi, genid, prfid
      FROM zetr_t_eipar
      WHERE bukrs = @iv_bukrs
      INTO @ls_company_data.
    IF sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.
      ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'P'
                                                  is_rule_input  = ls_invoice_rule_input ).
      IF ls_invoice_rule_output IS NOT INITIAL AND ls_invoice_rule_output-excld = abap_false.
        ls_document-prfid = ls_invoice_rule_output-pidou.
        ls_document-invty = ls_invoice_rule_output-ityou.
        ls_document-taxex = ls_invoice_rule_output-taxex.
      ENDIF.
    ENDIF.

    IF ls_document-taxid IS NOT INITIAL.
      " check if partner is registered
      SELECT aliass, regdt, defal, txpty
        FROM zetr_t_inv_ruser
        WHERE taxid = @ls_document-taxid
          AND regdt <= @ls_document-bldat
          INTO TABLE @lt_taxpayer.
      IF sy-subrc = 0.
        SORT lt_taxpayer BY defal.
        READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
        IF sy-subrc = 0.
          ls_document-aliass = ls_taxpayer-aliass.
        ELSE.
          SORT lt_taxpayer DESCENDING BY regdt.
          READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
          IF sy-subrc EQ 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ENDIF.
        ENDIF.

        IF ls_taxpayer-txpty EQ 'KAMU'.
          ls_document-prfid = 'KAMU'.
        ENDIF.

        IF ls_document-prfid IS INITIAL.
          IF ls_company_data-prfid IS INITIAL.
            ls_company_data-prfid = 'TEMEL'.
          ENDIF.
          ls_document-prfid = ls_company_data-prfid.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lt_taxpayer IS INITIAL AND ls_document-prfid NE 'IHRACAT' AND ls_document-prfid NE 'YOLCU'.
      SELECT SINGLE datab, datbi, genid
        FROM zetr_t_eapar
        WHERE bukrs = @iv_bukrs
        INTO @ls_company_data.
      CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.

      ls_document-prfid = 'EARSIV'.
      ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'P'
                                                  is_rule_input  = ls_invoice_rule_input ).
      IF ls_invoice_rule_output IS NOT INITIAL AND ls_invoice_rule_output-excld = abap_true.
        ls_document-invty = ls_invoice_rule_output-ityou.
        ls_document-taxex = ls_invoice_rule_output-taxex.
      ENDIF.
    ENDIF.

    CHECK ls_document-prfid IS NOT INITIAL.
    " determine invoice type
    IF ls_document-invty IS INITIAL OR ls_document-taxex IS INITIAL OR ls_document-taxty IS INITIAL.
      IF sy-subrc = 0 AND ls_rbkp-mwskz IS NOT INITIAL.
        SELECT SINGLE company~chartofaccounts, country~taxcalculationprocedure
          FROM i_companycode AS company
          INNER JOIN i_country AS country
            ON country~country = company~country
          WHERE company~companycode = @iv_bukrs
          INTO @DATA(ls_company_parameters).

        SELECT SINGLE invty, taxex, taxty
          FROM zetr_t_taxmc
          WHERE kalsm = @ls_company_parameters-taxcalculationprocedure
            AND mwskz = @ls_rbkp-mwskz
          INTO @ls_tax_data.
        IF sy-subrc = 0.
          IF ls_document-invty IS INITIAL.
            ls_document-invty = ls_tax_data-invty.
          ENDIF.
          IF ls_document-taxex IS INITIAL.
            ls_document-taxex = ls_tax_data-taxex.
          ENDIF.
          IF ls_document-taxty IS INITIAL.
            ls_document-taxty = ls_tax_data-taxty.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    TRY .
        ls_document-docui = cl_system_uuid=>create_uuid_c22_static( ).
        ls_document-invui = cl_system_uuid=>create_uuid_c36_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    ls_document-docty = ls_rbkp-blart.
    ls_document-awtyp = iv_awtyp(4).
    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-partner = ls_partner_data-businesspartner.
    ls_document-wrbtr = ls_rbkp-rmwwr.
    ls_document-fwste = ls_rbkp-wmwst.
    ls_document-kursf = ls_rbkp-kursf.
    ls_document-ernam = ls_rbkp-usnam.
    ls_document-erdat = ls_rbkp-cpudt.
    IF ls_document-fwste IS INITIAL.
      ls_document-texex = abap_true.
    ENDIF.
    ls_document-waers = ls_rbkp-waers.

    CASE ls_document-prfid.
      WHEN 'EARSIV'.
        ls_invoice_rule_input-ityin = ls_document-invty.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_invoice_rule_output.
          ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'S'
                                                      is_rule_input  = ls_invoice_rule_input ).
          IF ls_invoice_rule_output IS NOT INITIAL.
            ls_document-serpr = ls_invoice_rule_output-serpr.
          ELSE.
            SELECT SINGLE serpr
              FROM zetr_t_easer
              WHERE bukrs = @iv_bukrs
                AND maisp = @abap_true
              INTO @ls_document-serpr.
          ENDIF.
        ENDIF.

        CLEAR ls_invoice_rule_output.
        ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'X'
                                              is_rule_input  = ls_invoice_rule_input ).
        IF ls_invoice_rule_output IS NOT INITIAL.
          ls_document-xsltt = ls_invoice_rule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM zetr_t_eaxslt
            WHERE bukrs = @iv_bukrs
              AND deflt = @abap_true
            INTO @ls_document-xsltt.
        ENDIF.
      WHEN OTHERS.
        ls_invoice_rule_input-ityin = ls_document-invty.
        ls_invoice_rule_input-pidin = ls_document-prfid.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_invoice_rule_output.
          ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'S'
                                                      is_rule_input  = ls_invoice_rule_input ).
          IF ls_invoice_rule_output IS NOT INITIAL.
            ls_document-serpr = ls_invoice_rule_output-serpr.
          ELSE.
            CASE ls_document-prfid.
              WHEN 'IHRACAT'.
                lv_insrt = 'E'.
              WHEN 'YOLCU'.
                lv_insrt = 'T'.
              WHEN OTHERS.
                lv_insrt = 'D'.
            ENDCASE.
            SELECT SINGLE serpr
              FROM zetr_t_eiser
              WHERE bukrs = @iv_bukrs
                AND maisp = @abap_true
                AND insrt = @lv_insrt
              INTO @ls_document-serpr.
          ENDIF.
        ENDIF.

        CLEAR ls_invoice_rule_output.
        ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'X'
                                                    is_rule_input  = ls_invoice_rule_input ).
        IF ls_invoice_rule_output IS NOT INITIAL.
          ls_document-xsltt = ls_invoice_rule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM zetr_t_eixslt
            WHERE bukrs = @iv_bukrs
              AND deflt = @abap_true
            INTO @ls_document-xsltt.
        ENDIF.
    ENDCASE.
    rs_document = ls_document.
  ENDMETHOD.

  METHOD outgoing_invoice_save_vbrk.
    TYPES: BEGIN OF ty_taxpayer,
             aliass TYPE zetr_e_alias,
             regdt  TYPE budat,
             defal  TYPE abap_boolean,
             txpty  TYPE zetr_e_txpty,
           END OF ty_taxpayer,
           BEGIN OF ty_company,
             datab TYPE datum,
             datbi TYPE datum,
             genid TYPE zetr_e_genid,
             prfid TYPE zetr_e_inprf,
           END OF ty_company,
           BEGIN OF ty_tax_data,
             invty TYPE zetr_e_invty,
             taxex TYPE zetr_e_taxex,
             taxty TYPE zetr_e_taxty,
           END OF ty_tax_data,
           BEGIN OF ty_vbrk,
             vbeln TYPE belnr_d,
             fkdat TYPE datum,
             fkart TYPE zetr_e_fkart,
             vkorg TYPE zetr_e_vkorg,
             vtweg TYPE zetr_e_vtweg,
             rfbsk TYPE c LENGTH 1,
             ernam TYPE usnam,
             erdat TYPE datum,
             erzet TYPE uzeit,
             kurrf TYPE zetr_e_kursf,
             waerk TYPE waers,
           END OF ty_vbrk,
           BEGIN OF ty_vbrp,
             posnr TYPE sd_sls_document_item,
             gsber TYPE gsber,
             werks TYPE werks_d,
             fkimg TYPE menge_d,
             netwr TYPE p LENGTH 15 DECIMALS 2,
             mwsbp TYPE wrbtr_cs,
             mwskz TYPE mwskz,
           END OF ty_vbrp,
           BEGIN OF ty_vbpa,
             parvw TYPE c LENGTH 2,
             kunnr TYPE zetr_e_partner,
           END OF ty_vbpa.
    DATA: ls_tax_data            TYPE ty_tax_data,
          ls_company_data        TYPE ty_company,
          lt_taxpayer            TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer            TYPE ty_taxpayer,
          lt_vbpa                TYPE TABLE OF ty_vbpa,
          ls_vbpa                TYPE ty_vbpa,
          ls_vbrk                TYPE ty_vbrk,
          lt_vbrp                TYPE TABLE OF ty_vbrp,
          ls_vbrp                TYPE ty_vbrp,
          ls_document            TYPE zetr_t_oginv,
          ls_invoice_rule_input  TYPE zetr_s_invoice_rules_in,
          ls_invoice_rule_output TYPE zetr_s_invoice_rules_out,
          ls_muhattap            TYPE zetr_t_othp,
          lv_insrt               TYPE zetr_e_insrt,
          lv_parvw               TYPE c LENGTH 2.

    SELECT SINGLE *
      FROM zetr_t_oginv
      WHERE awtyp = @iv_awtyp
        AND belnr = @iv_belnr
      INTO @ls_document.
    IF sy-subrc = 0.
      SELECT SINGLE billingdocumentdate
        FROM i_billingdocument
        WHERE billingdocument = @iv_belnr
        INTO @ls_document-bldat.
      IF sy-subrc IS INITIAL.
        SELECT SUM( netamount ) AS wrbtr,
               SUM( taxamount ) AS fwste
          FROM i_billingdocumentitem
          WHERE billingdocument = @iv_belnr
          INTO (@ls_document-wrbtr, @ls_document-fwste).

        UPDATE zetr_t_oginv
          SET bldat = @ls_document-bldat,
              wrbtr = @ls_document-wrbtr,
              fwste = @ls_document-fwste
          WHERE docui = @ls_document-docui.
        COMMIT WORK.
      ENDIF.
    ENDIF.
    CHECK ls_document IS INITIAL.

    SELECT SINGLE billingdocument AS vbeln,
                  billingdocumentdate AS fkdat,
                  billingdocumenttype AS fkart,
                  salesorganization AS vkorg,
                  distributionchannel AS vtweg,
                  accountingtransferstatus AS rfbsk,
                  createdbyuser AS ernam,
                  creationdate AS erdat,
                  creationtime AS erzet,
                  accountingexchangerate AS kurrf,
                  transactioncurrency AS waerk
      FROM i_billingdocument
      WHERE billingdocument = @iv_belnr
        AND billingdocumentiscancelled = ''
        AND cancelledbillingdocument = ''
      INTO @ls_vbrk.
    CHECK ls_vbrk IS NOT INITIAL.

    SELECT billingdocumentitem AS posnr,
           businessarea AS gsber,
           plant AS werks,
           billingquantity AS fkimg,
           netamount AS netwr,
           taxamount AS mwsbp,
           taxcode AS mwskz
      FROM i_billingdocumentitem
      WHERE billingdocument = @iv_belnr
      INTO TABLE @lt_vbrp.

    SELECT partnerfunction AS parvw, customer AS kunnr
      FROM i_billingdocumentpartner
      WHERE billingdocument = @iv_belnr
      INTO TABLE @lt_vbpa.

    SORT lt_vbpa BY parvw.
    READ TABLE lt_vbpa INTO ls_vbpa WITH KEY parvw = 'RE' BINARY SEARCH.
    IF sy-subrc <> 0.
      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY parvw = 'AG' BINARY SEARCH.
    ENDIF.
    CHECK sy-subrc = 0.

    DATA(ls_partner_data) = get_partner_register_data( iv_customer = ls_vbpa-kunnr ).
    ls_document-taxid = ls_partner_data-bptaxnumber.
    ls_document-partner = ls_partner_data-businesspartner.


    READ TABLE lt_vbrp INTO ls_vbrp INDEX 1.
    CHECK sy-subrc = 0.

    ls_document-bldat = ls_vbrk-fkdat.

    ls_invoice_rule_input-awtyp = iv_awtyp.
    ls_invoice_rule_input-sddty = ls_vbrk-fkart.
    ls_invoice_rule_input-partner = ls_document-partner.
    ls_invoice_rule_input-vkorg = ls_vbrk-vkorg.
    ls_invoice_rule_input-vtweg = ls_vbrk-vtweg.
    ls_invoice_rule_input-werks = ls_vbrp-werks.
    ls_invoice_rule_input-vbeln = ls_vbrk-vbeln.

    SELECT SINGLE datab, datbi, genid, prfid
      FROM zetr_t_eipar
      WHERE bukrs = @iv_bukrs
      INTO @ls_company_data.
    IF sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.
      ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'P'
                                                  is_rule_input  = ls_invoice_rule_input ).
      IF ls_invoice_rule_output IS NOT INITIAL AND ls_invoice_rule_output-excld = abap_false.
        ls_document-prfid = ls_invoice_rule_output-pidou.
        ls_document-invty = ls_invoice_rule_output-ityou.
        ls_document-taxex = ls_invoice_rule_output-taxex.
      ENDIF.
    ENDIF.

    IF ls_document-prfid NE 'IHRACAT' AND
       ls_document-prfid NE 'YOLCU'.
      CHECK ls_vbrk-rfbsk CA 'CD'.
      IF ls_document-taxid IS NOT INITIAL.
        " check if partner is registered
        SELECT aliass, regdt, defal, txpty
          FROM zetr_t_inv_ruser
          WHERE taxid = @ls_document-taxid
            AND regdt <= @ls_document-bldat
            INTO TABLE @lt_taxpayer.
        IF sy-subrc = 0.
          SORT lt_taxpayer BY defal.
          READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
          IF sy-subrc = 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ELSE.
            SORT lt_taxpayer DESCENDING BY regdt.
            READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
            IF sy-subrc EQ 0.
              ls_document-aliass = ls_taxpayer-aliass.
            ENDIF.
          ENDIF.

          IF ls_taxpayer-txpty EQ 'KAMU'.
            ls_document-prfid = 'KAMU'.
          ENDIF.

          IF ls_document-prfid IS INITIAL.
            IF ls_company_data-prfid IS INITIAL.
              ls_company_data-prfid = 'TEMEL'.
            ENDIF.
            ls_document-prfid = ls_company_data-prfid.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lt_taxpayer IS INITIAL AND ls_document-prfid NE 'IHRACAT' AND ls_document-prfid NE 'YOLCU'.
      SELECT SINGLE datab, datbi, genid
        FROM zetr_t_eapar
        WHERE bukrs = @iv_bukrs
        INTO @ls_company_data.
      CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.

      ls_document-prfid = 'EARSIV'.
      ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'P'
                                                  is_rule_input  = ls_invoice_rule_input ).
      IF ls_invoice_rule_output IS NOT INITIAL AND ls_invoice_rule_output-excld = abap_true.
        ls_document-invty = ls_invoice_rule_output-ityou.
        ls_document-taxex = ls_invoice_rule_output-taxex.
      ENDIF.
    ENDIF.

    CHECK ls_document-prfid IS NOT INITIAL.

    IF ls_document-invty IS INITIAL OR ls_document-taxex IS INITIAL OR ls_document-taxty IS INITIAL.
      IF sy-subrc = 0 AND ls_vbrp-mwskz IS NOT INITIAL.
        SELECT SINGLE company~chartofaccounts, country~taxcalculationprocedure
          FROM i_companycode AS company
          INNER JOIN i_country AS country
            ON country~country = company~country
          WHERE company~companycode = @iv_bukrs
          INTO @DATA(ls_company_parameters).
        SELECT SINGLE invty, taxex, taxty
          FROM zetr_t_taxmc
          WHERE kalsm = @ls_company_parameters-taxcalculationprocedure
            AND mwskz = @ls_vbrp-mwskz
          INTO @ls_tax_data.
        IF sy-subrc = 0.
          IF ls_document-invty IS INITIAL.
            ls_document-invty = ls_tax_data-invty.
          ENDIF.
          IF ls_document-taxex IS INITIAL.
            ls_document-taxex = ls_tax_data-taxex.
          ENDIF.
          IF ls_document-taxty IS INITIAL.
            ls_document-taxty = ls_tax_data-taxty.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    TRY .
        ls_document-docui = cl_system_uuid=>create_uuid_c22_static( ).
        ls_document-invui = cl_system_uuid=>create_uuid_c36_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    ls_document-docty = ls_vbrk-fkart.
    ls_document-awtyp = iv_awtyp(4).
    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-erzet = ls_vbrk-erzet.
    ls_document-kursf = ls_vbrk-kurrf.
    ls_document-waers = ls_vbrk-waerk.
    ls_document-ernam = ls_vbrk-ernam.
    ls_document-vkorg = ls_vbrk-vkorg.
    ls_document-vtweg = ls_vbrk-vtweg.

    LOOP AT lt_vbrp INTO ls_vbrp.
      CHECK ls_vbrp-fkimg IS NOT INITIAL.
      ls_document-wrbtr += ls_vbrp-netwr.
      ls_document-fwste += ls_vbrp-mwsbp.
      ls_document-wrbtr += ls_vbrp-mwsbp.
      IF ls_vbrp-mwsbp IS INITIAL OR ls_vbrp-netwr IS INITIAL.
        ls_document-texex = abap_true.
      ENDIF.
      ls_document-werks = ls_vbrp-werks.
      ls_document-gsber = ls_vbrp-gsber.
    ENDLOOP.

    CASE ls_document-prfid.
      WHEN 'EARSIV'.
        ls_invoice_rule_input-ityin = ls_document-invty.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_invoice_rule_output.
          ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'S'
                                                      is_rule_input  = ls_invoice_rule_input ).
          IF ls_invoice_rule_output IS NOT INITIAL.
            ls_document-serpr = ls_invoice_rule_output-serpr.
          ELSE.
            SELECT SINGLE serpr
              FROM zetr_t_easer
              WHERE bukrs = @iv_bukrs
                AND maisp = @abap_true
              INTO @ls_document-serpr.
          ENDIF.
        ENDIF.

        CLEAR ls_invoice_rule_output.
        ls_invoice_rule_output = get_earchive_rule( iv_rule_type   = 'X'
                                              is_rule_input  = ls_invoice_rule_input ).
        IF ls_invoice_rule_output IS NOT INITIAL.
          ls_document-xsltt = ls_invoice_rule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM zetr_t_eaxslt
            WHERE bukrs = @iv_bukrs
              AND deflt = @abap_true
            INTO @ls_document-xsltt.
        ENDIF.
      WHEN OTHERS.
        ls_invoice_rule_input-ityin = ls_document-invty.
        ls_invoice_rule_input-pidin = ls_document-prfid.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_invoice_rule_output.
          ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'S'
                                                      is_rule_input  = ls_invoice_rule_input ).
          IF ls_invoice_rule_output IS NOT INITIAL.
            ls_document-serpr = ls_invoice_rule_output-serpr.
          ELSE.
            CASE ls_document-prfid.
              WHEN 'IHRACAT'.
                lv_insrt = 'E'.
              WHEN 'YOLCU'.
                lv_insrt = 'T'.
              WHEN OTHERS.
                lv_insrt = 'D'.
            ENDCASE.
            SELECT SINGLE serpr
              FROM zetr_t_eiser
              WHERE bukrs = @iv_bukrs
                AND maisp = @abap_true
                AND insrt = @lv_insrt
              INTO @ls_document-serpr.
          ENDIF.
        ENDIF.

        CLEAR ls_invoice_rule_output.
        ls_invoice_rule_output = get_einvoice_rule( iv_rule_type   = 'X'
                                                    is_rule_input  = ls_invoice_rule_input ).
        IF ls_invoice_rule_output IS NOT INITIAL.
          ls_document-xsltt = ls_invoice_rule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM zetr_t_eixslt
            WHERE bukrs = @iv_bukrs
              AND deflt = @abap_true
            INTO @ls_document-xsltt.
        ENDIF.
    ENDCASE.
* AS 07.01.2022
    IF ls_document-prfid EQ 'IHRACAT' .
      SELECT SINGLE *
        FROM zetr_t_othp
        WHERE prtty EQ 'C'
        INTO @ls_muhattap.

      SELECT aliass, regdt, defal
            FROM zetr_t_inv_ruser
            WHERE taxid = @ls_muhattap-taxid
              AND regdt <= @ls_document-bldat
            INTO TABLE @lt_taxpayer.
      IF sy-subrc = 0.
        SORT lt_taxpayer BY defal.
        READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
        IF sy-subrc = 0.
          ls_document-aliass = ls_taxpayer-aliass.
        ELSE.
          SORT lt_taxpayer DESCENDING BY regdt.
          READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
          IF sy-subrc EQ 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    rs_document = ls_document.
  ENDMETHOD.

  METHOD outgoing_invoice_save.
    SELECT COUNT(*)
      FROM zetr_t_oginv
      WHERE awtyp EQ @iv_awtyp
        AND bukrs EQ @iv_bukrs
        AND belnr EQ @iv_belnr
        AND gjahr EQ @iv_gjahr.
    CHECK sy-subrc NE 0.

    CASE iv_awtyp.
      WHEN 'VBRK'.
        rs_document = outgoing_invoice_save_vbrk( iv_awtyp = iv_awtyp
                                                  iv_bukrs = iv_bukrs
                                                  iv_belnr = iv_belnr
                                                  iv_gjahr = iv_gjahr ).
      WHEN 'RMRP'.
        rs_document = outgoing_invoice_save_rmrp( iv_awtyp = iv_awtyp
                                                  iv_bukrs = iv_bukrs
                                                  iv_belnr = iv_belnr
                                                  iv_gjahr = iv_gjahr ).
      WHEN 'BKPF' OR 'BKPFF' OR 'REACI'.
        rs_document = outgoing_invoice_save_bkpf( iv_awtyp = iv_awtyp
                                                  iv_bukrs = iv_bukrs
                                                  iv_belnr = iv_belnr
                                                  iv_gjahr = iv_gjahr ).
    ENDCASE.

    CHECK rs_document IS NOT INITIAL.
    INSERT zetr_t_oginv FROM @rs_document.
    zcl_etr_regulative_log=>create_single_log( iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-created
                                               iv_document_id = rs_document-docui ).
    COMMIT WORK AND WAIT.
  ENDMETHOD.

  METHOD get_incoming_invoices.
    DATA(lo_einvoice_service) = zcl_etr_einvoice_ws=>factory( mv_company_code ).
    rt_list = lo_einvoice_service->get_incoming_invoices( iv_date_from = iv_date_from
                                                          iv_date_to   = iv_date_to ).
    CHECK rt_list IS NOT INITIAL.
    SELECT invui
      FROM zetr_t_icinv
      FOR ALL ENTRIES IN @rt_list
      WHERE invui = @rt_list-invui
      INTO TABLE @DATA(lt_existing).
    IF sy-subrc = 0.
      LOOP AT lt_existing INTO DATA(ls_existing).
        DELETE rt_list WHERE invui = ls_existing-invui.
      ENDLOOP.
    ENDIF.
    CHECK rt_list IS NOT INITIAL.

    save_incoming_invoices( rt_list ).
  ENDMETHOD.

  METHOD save_incoming_invoices.
    INSERT zetr_t_icinv FROM TABLE @it_list.

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

  METHOD conversion_invoice_type_input.
    CASE iv_input.
      WHEN 'IHRACKAYITLI'.
        rv_output = 'IHRACKAYIT'.
      WHEN 'TEVKIFATIADE'.
        rv_output = 'TEVIADE'.
      WHEN 'ILAC_TIBBICIHAZ'.
        rv_output = 'ILAC_TIBBI'.
      WHEN 'KONAKLAMAVERGISI'.
        rv_output = 'KONAKLAMA'.
      WHEN OTHERS.
        rv_output = iv_input.
    ENDCASE.
  ENDMETHOD.

  METHOD conversion_invoice_type_output.
    CASE iv_input.
      WHEN 'IHRACKAYIT'.
        CONCATENATE iv_input 'LI' INTO rv_output.
      WHEN 'TEVIADE'.
        rv_output = 'TEVKIFATIADE'.
      WHEN 'ILAC_TIBBI'.
        rv_output = 'ILAC_TIBBICIHAZ'.
      WHEN 'KONAKLAMA'.
        rv_output = 'KONAKLAMAVERGISI'.
      WHEN OTHERS.
        rv_output = iv_input.
    ENDCASE.
  ENDMETHOD.

  METHOD conversion_profile_id_input.
    CASE iv_input.
      WHEN 'TEMELFATURA' OR 'TICARIFATURA' OR 'EARSIVFATURA' OR 'STDKODFATURA'.
        rv_output = iv_input.
        REPLACE 'FATURA' IN rv_output WITH ``.
      WHEN 'YOLCUBERABERFATURA'.
        rv_output = 'YOLCU'.
      WHEN OTHERS.
        rv_output = iv_input.
    ENDCASE.
  ENDMETHOD.

  METHOD conversion_profile_id_output.
    CASE iv_input.
      WHEN 'TEMEL' OR 'TICARI' OR 'EARSIV' OR 'STDKOD'.
        CONCATENATE iv_input 'FATURA' INTO rv_output.
      WHEN 'YOLCU'.
        rv_output = 'YOLCUBERABERFATURA'.
      WHEN OTHERS.
        rv_output = iv_input.
    ENDCASE.
  ENDMETHOD.

  METHOD incoming_einvoice_download.
    SELECT SINGLE docui, bukrs, archv, invii AS docii, invui AS duich, invno AS docno, envui
      FROM zetr_t_icinv
      WHERE docui = @iv_document_uid
      INTO @DATA(ls_document).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e005(zetr_common).
    ELSEIF ls_document-archv IS NOT INITIAL.
*      rv_document = /itetr/cl_regulative_archive=>get_single_docui( iv_docui = ls_document-docui
*                                                                    iv_conty = iv_content_type ).
    ELSE.
      DATA(lo_einvoice_service) = zcl_etr_einvoice_ws=>factory( iv_company = ls_document-bukrs ).
      rv_document = lo_einvoice_service->incoming_invoice_download( is_document_numbers = CORRESPONDING #( ls_document )
                                                                    iv_content_type = iv_content_type ).
      CHECK iv_create_log = abap_true.
      zcl_etr_regulative_log=>create_single_log(
        EXPORTING
          iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-download
          iv_document_id = ls_document-docui ).
    ENDIF.
  ENDMETHOD.

  METHOD incoming_einvoice_addnote.
    UPDATE zetr_t_icinv
      SET lnote = @iv_note,
          luser = @iv_user
      WHERE docui = @iv_document_uid.

    zcl_etr_regulative_log=>create_single_log( iv_log_code    = zcl_etr_regulative_log=>mc_log_codes-note_added
                                               iv_log_text    = iv_note
                                               iv_document_id = iv_document_uid ).
  ENDMETHOD.

ENDCLASS.
