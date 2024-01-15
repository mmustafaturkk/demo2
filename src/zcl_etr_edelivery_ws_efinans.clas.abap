CLASS zcl_etr_edelivery_ws_efinans DEFINITION
  PUBLIC
  INHERITING FROM zcl_etr_edelivery_ws
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF mty_document_status,
        aciklama                  TYPE string,
        alimtarihi                TYPE string,
        belgeno                   TYPE string,
        ettn                      TYPE string,
        yanitdetayi               TYPE string,
        yanitdurumu               TYPE string,
        yanitgonderimcevabidetayi TYPE string,
        yanitgonderimcevabikodu   TYPE string,
        yanitgonderimdurumu       TYPE string,
        yanitgonderimtarihi       TYPE string,
        sirano                    TYPE string,
        yereleaktarimdurumu       TYPE string,
        kepdurum                  TYPE string,
        gibiptaldurum             TYPE string,
        yanitettn                 TYPE string,
      END OF mty_document_status .
    TYPES:
      BEGIN OF mty_incoming_document,
        belgeno         TYPE string,
        belgesirano     TYPE string,
        belgetarihi     TYPE string,
        ettn            TYPE string,
        zarfid          TYPE string,
        gonderenetiket  TYPE string,
        gonderenvkntckn TYPE string,
        belgexmlzipped  TYPE string,
      END OF mty_incoming_document .
    TYPES:
      mty_incoming_documents TYPE STANDARD TABLE OF mty_incoming_document WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_user_alias,
        etiket                  TYPE String,
        etiketolusturulmazamani TYPE string,
      END OF mty_user_alias .
    TYPES:
      mty_user_alias_t TYPE STANDARD TABLE OF mty_user_alias WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_users,
        tip         TYPE string,
        kayitzamani TYPE string,
        unvan       TYPE string,
        vkntckn     TYPE string,
        hesaptipi   TYPE string,
        aktifetiket TYPE mty_user_alias_t,
      END OF mty_users .
    TYPES:
      mty_users_t TYPE STANDARD TABLE OF mty_users WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_user_list,
        efaturakayitlikullanici TYPE mty_users_t,
      END OF mty_user_list .

    METHODS: download_registered_taxpayers REDEFINITION.
    METHODS: get_incoming_deliveries REDEFINITION.
    METHODS: incoming_delivery_download REDEFINITION.
  PROTECTED SECTION.
    METHODS set_incoming_delivery_received
      IMPORTING
        !iv_document_uuid TYPE zetr_e_duich
      RAISING
        zcx_etr_regulative_exception .
    METHODS get_incoming_deliveries_int
      IMPORTING
        !iv_date_from      TYPE datum
        !iv_date_to        TYPE datum
      RETURNING
        VALUE(rt_invoices) TYPE mty_incoming_documents
      RAISING
        zcx_etr_regulative_exception.
    METHODS get_incoming_delivery_stat_int
      IMPORTING
        !iv_document_uuid TYPE zetr_e_duich
      RETURNING
        VALUE(rs_status)  TYPE mty_document_status
      RAISING
        zcx_etr_regulative_exception .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_etr_edelivery_ws_efinans IMPLEMENTATION.

  METHOD download_registered_taxpayers.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          ls_user_list      TYPE mty_user_list,
          ls_user           TYPE mty_users,
          ls_alias          TYPE mty_user_alias,
          lv_taxpayers_xml  TYPE string,
          ls_taxpayer       TYPE zetr_t_inv_ruser.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
            '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
            '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
      '<soapenv:Body>'
        '<ser:kayitliKullaniciListeleExtended>'
          '<urun>EIRSALIYE</urun>'
          '<gecmisEklensin></gecmisEklensin>'
        '</ser:kayitliKullaniciListeleExtended>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
    LOOP AT lt_xml_table INTO DATA(ls_xml_line).
      CASE ls_xml_line-name.
        WHEN 'return'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          CONCATENATE lv_base64_content ls_xml_line-value INTO lv_base64_content.
      ENDCASE.
    ENDLOOP.
    lv_zipped_file = xco_cp=>string( lv_base64_content )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
*    lv_zipped_file = cl_web_http_utility=>decode_base64( encoded = lv_base64_content ).
    zcl_etr_regulative_common=>unzip_file_single(
      EXPORTING
        iv_zipped_file_xstr = lv_zipped_file
      IMPORTING
        ev_output_data_str = lv_taxpayers_xml ).

    CLEAR lt_xml_table.
    lt_xml_table = zcl_etr_regulative_common=>parse_xml( iv_xml_string = lv_taxpayers_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
      CASE ls_xml_line-name.
        WHEN 'eIrsaliyeKayitliKullanici'.
          CLEAR ls_taxpayer.
        WHEN 'tip'.
          CASE ls_xml_line-value.
            WHEN 'Özel'.
              ls_taxpayer-txpty = 'OZEL'.
            WHEN OTHERS.
              ls_taxpayer-txpty = 'KAMU'.
          ENDCASE.
        WHEN 'kayitZamani'.
          ls_taxpayer-regdt = ls_xml_line-value(8).
          ls_taxpayer-regtm = ls_xml_line-value+8(6).
        WHEN 'unvan'.
          ls_taxpayer-title = ls_xml_line-value.
        WHEN 'vknTckn'.
          ls_taxpayer-taxid = ls_xml_line-value.
        WHEN 'etiket'.
          ls_taxpayer-aliass = ls_xml_line-value.
          APPEND ls_taxpayer TO rt_list.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_incoming_deliveries.
    IF iv_date_from IS INITIAL OR iv_date_to IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e096(zetr_common).
    ENDIF.
    DATA(lt_service_return) = get_incoming_deliveries_int( iv_date_from = iv_date_from
                                                           iv_date_to = iv_date_to ).
    LOOP AT lt_service_return ASSIGNING FIELD-SYMBOL(<ls_service_return>).
      TRY.
          DATA(lv_uuid) = cl_system_uuid=>create_uuid_c22_static( ).
          APPEND INITIAL LINE TO et_list ASSIGNING FIELD-SYMBOL(<ls_list>).
          <ls_list>-docui = lv_uuid.
        CATCH cx_uuid_error.
          CONTINUE.
      ENDTRY.
      <ls_list>-dlvui = <ls_service_return>-ettn.
      <ls_list>-dlvno = <ls_service_return>-belgeno.
      <ls_list>-dlvii = <ls_service_return>-belgesirano.
      <ls_list>-envui = <ls_service_return>-zarfid.
      <ls_list>-dlvno = <ls_service_return>-belgeno.
      <ls_list>-envui = <ls_service_return>-zarfid.
      <ls_list>-dlvii = <ls_service_return>-belgesirano.
      <ls_list>-dlvqi = <ls_service_return>-ettn.
      <ls_list>-bukrs = ms_company_parameters-bukrs.
      <ls_list>-taxid = <ls_service_return>-gonderenvkntckn.
      <ls_list>-bldat = <ls_service_return>-belgetarihi.

      DATA(ls_invoice_status) = get_incoming_delivery_stat_int( <ls_list>-dlvui ).
      <ls_list>-staex = ls_invoice_status-yanitgonderimcevabidetayi.
      <ls_list>-radsc = ls_invoice_status-yanitgonderimcevabikodu.
      <ls_list>-ruuid = ls_invoice_status-yanitettn.
      CASE ls_invoice_status-yanitdurumu.
        WHEN '0'.
          <ls_list>-resst = '0'.
        WHEN '-1'.
          <ls_list>-resst = 'X'.
        WHEN '1' OR '2'.
          <ls_list>-resst = '1'.
        WHEN OTHERS.
          CLEAR <ls_list>-resst.
      ENDCASE.

      DATA(lv_zipped_file) = xco_cp=>string( <ls_service_return>-belgexmlzipped )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
      zcl_etr_regulative_common=>unzip_file_single(
        EXPORTING
          iv_zipped_file_xstr = lv_zipped_file
        IMPORTING
          ev_output_data_str = DATA(lv_document_xml) ).
      DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_document_xml ).
      LOOP AT lt_xml_table INTO DATA(ls_xml_line).
        CASE ls_xml_line-name.
          WHEN 'irsaliyeSatir'.
            CHECK ls_xml_line-node_type = 'CO_NT_ELEMENT_OPEN'.
            DATA(lv_item_index) = sy-tabix + 1.
            APPEND INITIAL LINE TO et_items ASSIGNING FIELD-SYMBOL(<ls_item>).
            <ls_item>-docui = <ls_list>-docui.
            LOOP AT lt_xml_table INTO DATA(ls_xml_item) FROM lv_item_index.
              CASE ls_xml_item-name.
                WHEN 'irsaliyeSatir'.
                  CHECK ls_xml_line-node_type = 'CO_NT_ELEMENT_CLOSE'.
                  UNASSIGN <ls_item>.
                  EXIT.
                WHEN 'paraBirimi'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE'.
                  <ls_item>-waers = ls_xml_item-value.
                WHEN 'siraNo'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE' AND <ls_item>-linno IS INITIAL.
                  <ls_item>-linno = ls_xml_item-value.
                WHEN 'gonderilenMalAdedi'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE'.
                  <ls_item>-menge = ls_xml_item-value.
                WHEN 'birimKodu'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE' AND <ls_item>-meins IS INITIAL.
                  SELECT SINGLE meins
                    FROM zetr_t_untmc
                    WHERE unitc = @ls_xml_item-value
                    INTO @<ls_item>-meins.
                WHEN 'aciklama'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE' AND <ls_item>-descr IS INITIAL.
                  <ls_item>-descr = ls_xml_item-value.
                WHEN 'adi'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE' AND <ls_item>-mdesc IS INITIAL.
                  <ls_item>-mdesc = ls_xml_item-value.
                WHEN 'aliciUrunKodu'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE'.
                  <ls_item>-buyii = ls_xml_item-value.
                WHEN 'saticiUrunKodu'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE'.
                  <ls_item>-selii = ls_xml_item-value.
                WHEN 'ureticiUrunKodu'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE'.
                  <ls_item>-manii = ls_xml_item-value.
                WHEN 'birimFiyat'.
                  CHECK ls_xml_item-node_type = 'CO_NT_VALUE' AND <ls_item>-netpr IS INITIAL.
                  <ls_item>-netpr = ls_xml_item-value.
              ENDCASE.
            ENDLOOP.
          WHEN 'irsaliyeTuru'.
            CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
            <ls_list>-prfid = ls_xml_line-value(5).
          WHEN 'urunDegeri'.
            CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
            <ls_list>-wrbtr = ls_xml_line-value.
          WHEN 'irsaliyeTipi'.
            CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
            <ls_list>-dlvty = ls_xml_line-value.
          WHEN 'paraBirimi'.
            IF <ls_item> IS NOT ASSIGNED AND ls_xml_line-node_type = 'CO_NT_VALUE'.
              <ls_list>-waers = ls_xml_line-value.
            ENDIF.
        ENDCASE.
      ENDLOOP.

      set_incoming_delivery_received( <ls_list>-dlvui ).
    ENDLOOP.
  ENDMETHOD.

  METHOD set_incoming_delivery_received.
    DATA: lv_request_xml TYPE string.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
              '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
              '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
          '<ser:belgelerAlindi>'
             '<belgeTuru>IRSALIYE</belgeTuru>'
             '<ettn>' iv_document_uuid '</ettn>'
             '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
          '</ser:belgelerAlindi>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    run_service( lv_request_xml ).
  ENDMETHOD.

  METHOD get_incoming_deliveries_int.
    DATA: lv_request_xml TYPE string.
    READ TABLE mt_custom_parameters INTO DATA(ls_custom_parameter) WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
            '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
            '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:gelenBelgeleriAlExt>'
           '<parametreler>'
*              '<belgeFormati>UBL</belgeFormati>'
              '<belgeTuru>IRSALIYE</belgeTuru>'
              '<belgeVersiyon>1.0</belgeVersiyon>'
              '<donusTipiVersiyon>2.0</donusTipiVersiyon>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<gelisTarihiBaslangic>' iv_date_from '000000</gelisTarihiBaslangic>'
              '<gelisTarihiBitis>' iv_date_to '235959</gelisTarihiBitis>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '</parametreler>'
        '</ser:gelenBelgeleriAlExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    DATA(lv_response_xml) = run_service( lv_request_xml ).

    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
    LOOP AT lt_xml_table INTO DATA(ls_xml_line).
      CASE ls_xml_line-name.
        WHEN 'return'.
          CHECK ls_xml_line-node_type = 'CO_NT_ELEMENT_OPEN'.
          APPEND INITIAL LINE TO rt_invoices ASSIGNING FIELD-SYMBOL(<ls_list>).
        WHEN 'belgeXmlZipped'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          CONCATENATE <ls_list>-belgexmlzipped
                      ls_xml_line-value
                      INTO <ls_list>-belgexmlzipped.
        WHEN OTHERS.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          TRANSLATE ls_xml_line-name TO UPPER CASE.
          ASSIGN COMPONENT ls_xml_line-name OF STRUCTURE <ls_list> TO FIELD-SYMBOL(<lv_invoice_field>).
          IF sy-subrc = 0.
            <lv_invoice_field> = ls_xml_line-value.
          ENDIF.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_incoming_delivery_stat_int.
    DATA: lv_request_xml TYPE string.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    READ TABLE mt_custom_parameters INTO DATA(ls_custom_parameter) WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
            '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
            '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:gelenBelgeDurumSorgulaExt>'
           '<parametreler>'
              '<ettn>' iv_document_uuid '</ettn>'
              '<belgeTuru>IRSALIYE</belgeTuru>'
              '<donusTipiVersiyon>5.0</donusTipiVersiyon>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '</parametreler>'
        '</ser:gelenBelgeDurumSorgulaExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    DATA(lv_response_xml) = run_service( lv_request_xml ).

    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
    LOOP AT lt_xml_table INTO DATA(ls_xml_line).
      CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
      TRANSLATE ls_xml_line-name TO UPPER CASE.
      ASSIGN COMPONENT ls_xml_line-name OF STRUCTURE rs_status TO <lv_return_field>.
      IF sy-subrc = 0.
        <lv_return_field> = ls_xml_line-value.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD incoming_delivery_download.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lv_content      TYPE string.

    READ TABLE mt_custom_parameters
      INTO DATA(ls_custom_parameter)
      WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:gelenBelgeleriIndirExt>'
           '<parametreler>'
              '<ettn>' is_document_numbers-duich '</ettn>'
              '<belgeTuru>IRSALIYE</belgeTuru>'
              '<belgeFormati>' iv_content_type '</belgeFormati>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '</parametreler>'
        '</ser:gelenBelgeleriIndirExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
    LOOP AT lt_xml_table INTO DATA(ls_xml_line).
      CASE ls_xml_line-name.
        WHEN 'return'.
          CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
          CONCATENATE lv_content
              ls_xml_line-value
              INTO lv_content.
      ENDCASE.
    ENDLOOP.
    IF lv_content IS NOT INITIAL.
      DATA(lv_zipped_file) = xco_cp=>string( lv_content )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
      zcl_etr_regulative_common=>unzip_file_single(
        EXPORTING
          iv_zipped_file_xstr = lv_zipped_file
        IMPORTING
          ev_output_data_xstr = DATA(lv_invoice_content) ).
      rv_invoice_data = lv_invoice_content.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
