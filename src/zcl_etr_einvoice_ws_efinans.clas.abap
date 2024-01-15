CLASS zcl_etr_einvoice_ws_efinans DEFINITION
  PUBLIC
  INHERITING FROM zcl_etr_einvoice_ws
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
*        odenecektutar           TYPE string,
*        odenecektutardovizcinsi TYPE string,
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
    TYPES:
      BEGIN OF mty_fat1_ekbilgi,
        anahtar TYPE string,
        deger   TYPE string,
      END OF mty_fat1_ekbilgi .
    TYPES:
      mty_fat1_ekbilgi_t TYPE STANDARD TABLE OF mty_fat1_ekbilgi WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_ekler,
        dosya_adi    TYPE string,
        mime_type    TYPE string,
        icerik       TYPE string,
        belge_turu   TYPE string,
        belge_tarihi TYPE string,
      END OF mty_fat1_ekler .
    TYPES:
      mty_fat1_ekler_t TYPE STANDARD TABLE OF mty_fat1_ekler WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_iadeyekonu,
        fatura_no     TYPE string,
        fatura_tarihi TYPE string,
      END OF mty_fat1_iadeyekonu .
    TYPES:
      mty_fat1_iadeyekonu_t TYPE STANDARD TABLE OF mty_fat1_iadeyekonu WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_vergi,
        ad              TYPE string,
        kod             TYPE string,
        matrah          TYPE string,
        oran            TYPE string,
        vergi_tutari    TYPE string,
        muafiyet_sebebi TYPE string,
      END OF mty_fat1_vergi .
    TYPES:
      mty_fat1_vergi_t TYPE STANDARD TABLE OF mty_fat1_vergi WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_vergiler,
        toplam_vergi_tutari TYPE string,
        vergi               TYPE mty_fat1_vergi_t,
      END OF mty_fat1_vergiler .
    TYPES:
      mty_fat1_vergiler_t TYPE STANDARD TABLE OF mty_fat1_vergiler WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_alicisatici,
        musteri_no    TYPE string,
        vergi_no      TYPE string,
        vergi_dairesi TYPE string,
        unvan         TYPE string,
        ulke          TYPE string,
        sehir         TYPE string,
        ilce          TYPE string,
        cadde_sokak   TYPE string,
        kasaba_koy    TYPE string,
        bina_adi      TYPE string,
        bina_no       TYPE string,
        kapi_no       TYPE string,
        posta_kodu    TYPE string,
        tel           TYPE string,
        fax           TYPE string,
        web_sitesi    TYPE string,
        eposta        TYPE string,
        sube_kodu     TYPE string,
        sube_adi      TYPE string,
        tapdk_no      TYPE string,
        adi           TYPE string,
        soyadi        TYPE string,
        etiket        TYPE string,
      END OF mty_fat1_alicisatici .
    TYPES:
      BEGIN OF mty_fat1_siparis,
        siparis_no     TYPE string,
        siparis_tarihi TYPE string,
      END OF mty_fat1_siparis .
    TYPES:
      BEGIN OF mty_fat1_irsaliye,
        irsaliye_no     TYPE string,
        irsaliye_tarihi TYPE string,
      END OF mty_fat1_irsaliye .
    TYPES:
      mty_fat1_irsaliye_t TYPE STANDARD TABLE OF mty_fat1_irsaliye WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_malkabul,
        mal_kabul_no     TYPE string,
        mal_kabul_tarihi TYPE string,
      END OF mty_fat1_malkabul .
    TYPES:
      mty_fat1_malkabul_t TYPE STANDARD TABLE OF mty_fat1_malkabul WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_satir,
        sira_no                TYPE string,
        alici_urun_kodu        TYPE string,
        satici_urun_kodu       TYPE string,
        uretici_urun_kodu      TYPE string,
        marka_adi              TYPE string,
        model_adi              TYPE string,
        urun_adi               TYPE string,
        tanim                  TYPE string,
        birim_kodu             TYPE string,
        birim_fiyat            TYPE string,
        miktar                 TYPE string,
        mal_hizmet_miktari     TYPE string,
        iskonto_artirim_nedeni TYPE string,
        iskonto_orani          TYPE string,
        iskonto_tutari         TYPE string,
        vergiler               TYPE mty_fat1_vergiler,
      END OF mty_fat1_satir .
    TYPES:
      mty_fat1_satir_t TYPE STANDARD TABLE OF mty_fat1_satir WITH DEFAULT KEY .
    TYPES:
      BEGIN OF mty_fat1_belge,
        fatura_id                      TYPE string,
        fatura_no                      TYPE string,
        fatura_tarihi                  TYPE string,
        fatura_zamani                  TYPE string,
        fatura_tipi                    TYPE string,
        fatura_turu                    TYPE string,
        siparis_bilgisi                TYPE mty_fat1_siparis,
        irsaliye_bilgisi               TYPE mty_fat1_irsaliye_t,
        mal_kabul_bilgisi              TYPE mty_fat1_malkabul_t,
        son_odeme_tarihi               TYPE string,
        para_birimi                    TYPE string,
        alici                          TYPE mty_fat1_alicisatici,
        satici                         TYPE mty_fat1_alicisatici,
        fatura_satir                   TYPE mty_fat1_satir_t,
        toplam_mal_hizmet_miktari      TYPE string,
        toplam_iskonto_tutari          TYPE string,
        toplam_artirim_tutari          TYPE string,
        vergi_haric_toplam             TYPE string,
        vergi_dahil_tutar              TYPE string,
        yuvarlama_tutari               TYPE string,
        odenecek_tutar                 TYPE string,
        vergiler                       TYPE mty_fat1_vergiler_t,
        fatura_not                     TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
        iadeye_konu_olan_fatura_bilgil TYPE mty_fat1_iadeyekonu_t,
        ekler                          TYPE mty_fat1_ekler_t,
        ek_bilgiler                    TYPE mty_fat1_ekbilgi_t,
      END OF mty_fat1_belge .

    CONSTANTS mc_erpcode_parameter TYPE zetr_E_CUSPA VALUE 'ERPCODE' ##NO_TEXT.

    METHODS: download_registered_taxpayers REDEFINITION.
    METHODS: outgoing_invoice_download REDEFINITION.
    METHODS: get_incoming_invoices REDEFINITION.
    METHODS: incoming_invoice_download REDEFINITION.
    METHODS: incoming_invoice_get_status REDEFINITION.
    METHODS: incoming_invoice_response REDEFINITION.

  PROTECTED SECTION.
    METHODS get_incoming_invoices_int
      IMPORTING
        !iv_date_from      TYPE datum
        !iv_date_to        TYPE datum
      RETURNING
        VALUE(rt_invoices) TYPE mty_incoming_documents
      RAISING
        zcx_etr_regulative_exception.

    METHODS set_incoming_invoice_received
      IMPORTING
        !iv_document_uuid TYPE zetr_e_duich
      RAISING
        zcx_etr_regulative_exception .

    METHODS get_incoming_invoice_stat_int
      IMPORTING
        !iv_document_uuid TYPE zetr_e_duich
      RETURNING
        VALUE(rs_status)  TYPE mty_document_status
      RAISING
        zcx_etr_regulative_exception .

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_etr_einvoice_ws_efinans IMPLEMENTATION.

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
    '<?xml version = ''1.0'' encoding = ''UTF-8''?>'
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
          '<urun>EFATURA</urun>'
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

    CALL TRANSFORMATION zetr_inv_userlist_efn
      SOURCE XML lv_taxpayers_xml
      RESULT efaturakayitlikullaniciliste = ls_user_list.
    LOOP AT ls_user_list-efaturakayitlikullanici INTO ls_user.
      CLEAR ls_taxpayer.
      CASE ls_user-tip.
        WHEN 'Özel'.
          ls_taxpayer-txpty = 'OZEL'.
        WHEN OTHERS.
          ls_taxpayer-txpty = 'KAMU'.
      ENDCASE.
      IF ls_user-kayitzamani IS NOT INITIAL.
        ls_taxpayer-regdt = ls_user-kayitzamani(8).
        ls_taxpayer-regtm = ls_user-kayitzamani+8(6).
      ENDIF.
      ls_taxpayer-title = ls_user-unvan.
      ls_taxpayer-taxid = ls_user-vkntckn.
      IF ls_user-aktifetiket IS NOT INITIAL.
        LOOP AT ls_user-aktifetiket INTO ls_alias.
          ls_taxpayer-aliass = ls_alias-etiket.
          APPEND ls_taxpayer TO rt_list.
        ENDLOOP.
      ELSE.
        APPEND ls_taxpayer TO rt_list.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD outgoing_invoice_download.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lv_content      TYPE string,
          lv_zipped_file  TYPE xstring.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

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
       '<ser:gidenBelgeleriIndirEttn>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
              '<belgeEttnListesi>' is_document_numbers-duich '</belgeEttnListesi>'
              '<belgeTuru>FATURA</belgeTuru>'
              '<belgeFormati>' iv_content_type '</belgeFormati>'
        '</ser:gidenBelgeleriIndirEttn>'
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
          CONCATENATE lv_content ls_xml_line-value INTO lv_content.
      ENDCASE.
    ENDLOOP.

    IF lv_content IS NOT INITIAL.
      lv_zipped_file = xco_cp=>string( lv_content )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
      zcl_etr_regulative_common=>unzip_file_single(
        EXPORTING
          iv_zipped_file_xstr = lv_zipped_file
        IMPORTING
          ev_output_data_xstr = rv_invoice_data ).
    ENDIF.
  ENDMETHOD.

  METHOD get_incoming_invoices.
    IF iv_date_from IS INITIAL OR iv_date_to IS INITIAL.
      RAISE EXCEPTION TYPE zcx_etr_regulative_exception
        MESSAGE e096(zetr_common).
    ENDIF.
    DATA(lt_service_return) = get_incoming_invoices_int( iv_date_from = iv_date_from
                                                         iv_date_to = iv_date_to ).
    LOOP AT lt_service_return ASSIGNING FIELD-SYMBOL(<ls_service_return>).
      TRY.
          DATA(lv_uuid) = cl_system_uuid=>create_uuid_c22_static( ).
          APPEND INITIAL LINE TO rt_list ASSIGNING FIELD-SYMBOL(<ls_list>).
          <ls_list>-docui = lv_uuid.
        CATCH cx_uuid_error.
          CONTINUE.
      ENDTRY.
      <ls_list>-invui = <ls_service_return>-ettn.
      <ls_list>-invno = <ls_service_return>-belgeno.
      <ls_list>-invii = <ls_service_return>-belgesirano.
      <ls_list>-envui = <ls_service_return>-zarfid.
      <ls_list>-invno = <ls_service_return>-belgeno.
      <ls_list>-envui = <ls_service_return>-zarfid.
      <ls_list>-invii = <ls_service_return>-belgesirano.
      <ls_list>-invqi = <ls_service_return>-ettn.
      <ls_list>-bukrs = ms_company_parameters-bukrs.
      <ls_list>-taxid = <ls_service_return>-gonderenvkntckn.
      <ls_list>-bldat = <ls_service_return>-belgetarihi.

      DATA(ls_invoice_status) = get_incoming_invoice_stat_int( <ls_list>-invui ).
      <ls_list>-recdt = ls_invoice_status-alimtarihi(8).
      <ls_list>-staex = ls_invoice_status-yanitgonderimcevabidetayi.
      <ls_list>-radsc = ls_invoice_status-yanitgonderimcevabikodu.
      IF ls_invoice_status-kepdurum = '1'.
        <ls_list>-resst = 'K'.
      ELSEIF ls_invoice_status-gibiptaldurum = '1'.
        <ls_list>-resst = 'G'.
      ELSEIF ls_invoice_status-yanitdurumu = '-1'.
        <ls_list>-resst = 'X'.
      ELSE.
        <ls_list>-resst = ls_invoice_status-yanitdurumu.
      ENDIF.

      DATA(lv_zipped_file) = xco_cp=>string( <ls_service_return>-belgexmlzipped )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
      zcl_etr_regulative_common=>unzip_file_single(
        EXPORTING
          iv_zipped_file_xstr = lv_zipped_file
        IMPORTING
          ev_output_data_str = DATA(lv_document_xml) ).
      DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_document_xml ).
      LOOP AT lt_xml_table INTO DATA(ls_xml_line).
        CHECK ls_xml_line-node_type = 'CO_NT_VALUE'.
        CASE ls_xml_line-name.
          WHEN 'faturaTuru'.
            <ls_list>-prfid = zcl_etr_invoice_operations=>conversion_profile_id_input( ls_xml_line-value ).
          WHEN 'faturaTipi'.
            <ls_list>-invty = zcl_etr_invoice_operations=>conversion_invoice_type_input( ls_xml_line-value ).
          WHEN 'kur'.
            <ls_list>-kursf = ls_xml_line-value.
          WHEN 'paraBirimi'.
            <ls_list>-waers = ls_xml_line-value.
          WHEN 'odenecekTutar'.
            <ls_list>-wrbtr = ls_xml_line-value.
          WHEN 'vergiDahilTutar'.
            <ls_list>-fwste += ls_xml_line-value.
          WHEN 'vergiHaricToplam'.
            <ls_list>-fwste -= ls_xml_line-value.
        ENDCASE.
      ENDLOOP.

      set_incoming_invoice_received( <ls_list>-invui ).
    ENDLOOP.
  ENDMETHOD.

  METHOD get_incoming_invoices_int.
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
              '<belgeTuru>FATURA</belgeTuru>'
              '<belgeVersiyon>2.0</belgeVersiyon>'
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

  METHOD set_incoming_invoice_received.
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
             '<belgeTuru>FATURA</belgeTuru>'
             '<ettn>' iv_document_uuid '</ettn>'
             '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
          '</ser:belgelerAlindi>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    run_service( lv_request_xml ).
  ENDMETHOD.

  METHOD get_incoming_invoice_stat_int.
    DATA: lv_request_xml      TYPE string.
*          lv_response_xml     TYPE string,
*          lt_xml_table        TYPE TABLE OF smum_xmltb,
*          ls_xml_line         TYPE smum_xmltb,
*          ls_custom_parameter TYPE /itetr/inv_eicp.
*
*    FIELD-SYMBOLS: <lv_return_field> TYPE any.

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
              '<belgeTuru>FATURA</belgeTuru>'
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
      ASSIGN COMPONENT ls_xml_line-name OF STRUCTURE rs_status TO FIELD-SYMBOL(<lv_return_field>).
      IF sy-subrc = 0.
        <lv_return_field> = ls_xml_line-value.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD incoming_invoice_download.
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
              '<belgeTuru>FATURA</belgeTuru>'
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

  METHOD incoming_invoice_get_status.
    DATA: ls_invoice_status TYPE mty_document_status.
    ls_invoice_status = get_incoming_invoice_stat_int( is_document_numbers-duich ).

    rs_status-staex = ls_invoice_status-yanitgonderimcevabidetayi.
    rs_status-radsc = ls_invoice_status-yanitgonderimcevabikodu.
    IF ls_invoice_status-kepdurum = '1'.
      rs_status-resst = 'K'.
    ELSEIF ls_invoice_status-gibiptaldurum = '1'.
      rs_status-resst = 'G'.
    ELSEIF ls_invoice_status-yanitdurumu = '-1'.
      rs_status-resst = 'X'.
    ELSE.
      rs_status-resst = ls_invoice_status-yanitdurumu.
    ENDIF.
    rs_status-apres = SWITCH #( rs_status-resst WHEN '2' THEN 'KABUL' WHEN '1' THEN 'RED' ELSE '' ).
  ENDMETHOD.

  METHOD incoming_invoice_response.
    build_application_response(
      EXPORTING
        is_document_numbers     = is_document_numbers
        iv_application_response = iv_application_response
        iv_note                 = iv_note
      IMPORTING
        ev_response_xml  = DATA(lv_appres_xml)
        ev_response_hash = DATA(lv_appres_hash) ).

    DATA(lv_appres_base64) = xco_cp=>xstring(  lv_appres_xml )->as_string( xco_cp_binary=>text_encoding->base64 )->value.

    READ TABLE mt_custom_parameters INTO DATA(ls_custom_parameter) WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    DATA lv_request_xml TYPE string.
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
       '<ser:belgeGonderExt>'
           '<parametreler>'
              '<belgeHash>' lv_appres_hash '</belgeHash>'
              '<belgeNo>' is_document_numbers-duich '</belgeNo>'
              '<belgeVersiyon>2.1</belgeVersiyon>'
              '<belgeTuru>UYGULAMA_YANITI_UBL</belgeTuru>'
              '<mimeType>application/xml</mimeType>'
              '<veri>' lv_appres_base64 '</veri>'
              '<donusTipiVersiyon>2.0</donusTipiVersiyon>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '</parametreler>'
        '</ser:belgeGonderExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
**    mv_request_url = '/efatura/ws/connectorService'.
    DATA(lv_response_xml) = run_service( lv_request_xml ).

    DATA(lt_xml_table) = zcl_etr_regulative_common=>parse_xml( lv_response_xml ).
  ENDMETHOD.

ENDCLASS.
