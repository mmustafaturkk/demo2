CLASS zcl_etr_tra_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    CLASS-METHODS:
      generate_unit_codes,
      generate_transport_codes,
      generate_status_codes,
      generate_tax_codes,
      generate_tax_exemption_codes,
      generate_essential_partners.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ETR_TRA_DATA_GENERATOR IMPLEMENTATION.


  METHOD generate_essential_partners.
    DATA: lt_partners TYPE TABLE OF zetr_t_othp.

    lt_partners = VALUE #( ( taxid = '1460415308'
                             prtty = 'C'
                             title = 'Gümrük ve Ticaret Bakanlığı'
                             taxof = 'Ulus'
                             distr = 'Üniversiteler Mahallesi'
                             street = 'Dumlupınar Bulvarı'
                             bldno = '151'
                             subdv = 'Çankaya'
                             cityn = 'Ankara'
                             country = 'Türkiye'
                             email = 'ticaretbakanligi@hs01.kep.tr' ) ).

    DELETE FROM zetr_t_othp.
    COMMIT WORK AND WAIT.

    INSERT zetr_t_othp FROM TABLE @lt_partners.
    COMMIT WORK AND WAIT.
  ENDMETHOD.


  METHOD generate_status_codes.
    DATA: lt_codes TYPE TABLE OF zetr_t_rasta,
          lt_texts TYPE TABLE OF zetr_t_rastx.

    lt_codes = VALUE #( ( radsc = '1000'   rsend = ' '  rvrse = ' ' succs = ' ' )
                        ( radsc = '1100'   rsend = ' '  rvrse = ' ' succs = ' ' )
                        ( radsc = '1110'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1111'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1120'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1130'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1131'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1132'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1133'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1140'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1141'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1142'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1143'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1150'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1160'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1161'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1162'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1163'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1170'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1171'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1172'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1175'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1176'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1177'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1180'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1181'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1182'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1183'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1190'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1195'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1200'   rsend = ' '  rvrse = ' ' succs = ' ' )
                        ( radsc = '1210'   rsend = ' '  rvrse = 'X' succs = ' ' )
                        ( radsc = '1215'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1220'   rsend = ' '  rvrse = 'X' succs = ' ' )
                        ( radsc = '1230'   rsend = 'X'  rvrse = 'X' succs = ' ' )
                        ( radsc = '1300'   rsend = ' '  rvrse = ' ' succs = 'X' ) ).

    lt_texts = VALUE #( ( spras = 'T' radsc = '1000' bezei = 'Zarf kuyruğa eklendi' )
                        ( spras = 'T' radsc = '1100' bezei = 'Zarf işleniyor' )
                        ( spras = 'T' radsc = '1110' bezei = 'Zip dosyası değil' )
                        ( spras = 'T' radsc = '1111' bezei = 'Zarf ID uzunluğu geçersiz' )
                        ( spras = 'T' radsc = '1120' bezei = 'Zarf arşivden kopyalanamadı' )
                        ( spras = 'T' radsc = '1130' bezei = 'Zip açılamadı' )
                        ( spras = 'T' radsc = '1131' bezei = 'Zip bir dosya içermeli' )
                        ( spras = 'T' radsc = '1132' bezei = 'XML dosyası değil' )
                        ( spras = 'T' radsc = '1133' bezei = 'Zarf ID ve XML dosyasının adı aynı olmalı' )
                        ( spras = 'T' radsc = '1140' bezei = 'Döküman ayrıştırılamadı' )
                        ( spras = 'T' radsc = '1141' bezei = 'Zarf ID yok' )
                        ( spras = 'T' radsc = '1142' bezei = 'Zarf ID ve Zip dosyası adı aynı olmalı' )
                        ( spras = 'T' radsc = '1143' bezei = 'Geçersiz versiyon' )
                        ( spras = 'T' radsc = '1150' bezei = 'Schematron kontrol sonucu hatalı' )
                        ( spras = 'T' radsc = '1160' bezei = 'XML şema kontrolünden geçemedi' )
                        ( spras = 'T' radsc = '1161' bezei = 'İmza sahibi TCKN VKN alınamadı' )
                        ( spras = 'T' radsc = '1162' bezei = 'İmza kaydedilemedi' )
                        ( spras = 'T' radsc = '1163' bezei = 'Gönderilen zarf sistemde daha önce kayıtlı olan bir faturayı içermektedir' )
                        ( spras = 'T' radsc = '1170' bezei = 'Yetki kontrol edilemedi' )
                        ( spras = 'T' radsc = '1171' bezei = 'Gönderici birim yetkisi yok' )
                        ( spras = 'T' radsc = '1172' bezei = 'Posta kutusu yetkisi yok' )
                        ( spras = 'T' radsc = '1175' bezei = 'İmza yetkisi kontrol edilemedi' )
                        ( spras = 'T' radsc = '1176' bezei = 'İmza sahibi yetkisiz' )
                        ( spras = 'T' radsc = '1177' bezei = 'Geçersiz imza' )
                        ( spras = 'T' radsc = '1180' bezei = 'Adres kontrol edilemedi' )
                        ( spras = 'T' radsc = '1181' bezei = 'Adres bulunamadı' )
                        ( spras = 'T' radsc = '1182' bezei = 'Kullanıcı eklenemedi' )
                        ( spras = 'T' radsc = '1183' bezei = 'Kullanıcı silinemedi' )
                        ( spras = 'T' radsc = '1190' bezei = 'Sistem yanıtı hazırlanamadı' )
                        ( spras = 'T' radsc = '1195' bezei = 'Sistem hatası' )
                        ( spras = 'T' radsc = '1200' bezei = 'Zarf başarıyla işlendi' )
                        ( spras = 'T' radsc = '1210' bezei = 'Döküman bulunan adrese gönderilemedi' )
                        ( spras = 'T' radsc = '1215' bezei = 'Doküman gönderimi başarısız. Tekrar gönderme sonlandı' )
                        ( spras = 'T' radsc = '1220' bezei = 'Hedeften sistem yanıtı gelmedi' )
                        ( spras = 'T' radsc = '1230' bezei = 'Hedeften sistem yanıtı başarısız geldi' )
                        ( spras = 'T' radsc = '1300' bezei = 'Başarıyla tamamlandı' ) ).
    LOOP AT lt_texts INTO DATA(ls_text).
      CHECK ls_text-spras = 'T'.
      ls_text-spras = 'E'.
      APPEND ls_text TO lt_texts.
    ENDLOOP.

    DELETE FROM zetr_t_rasta.
    DELETE FROM zetr_t_rastx.
    COMMIT WORK AND WAIT.

    INSERT zetr_t_rasta FROM TABLE @lt_codes.
    INSERT zetr_t_rastx FROM TABLE @lt_texts.
    COMMIT WORK AND WAIT.
  ENDMETHOD.


  METHOD generate_tax_codes.
    DATA: lt_codes TYPE TABLE OF zetr_t_taxcd,
          lt_texts TYPE TABLE OF zetr_t_taxcx.

    lt_codes = VALUE #( ( taxty = '0003' taxct = 'DGR' )
                        ( taxty = '0011' taxct = 'DGR' )
                        ( taxty = '0015' taxct = 'KDV' )
                        ( taxty = '0021' taxct = 'DGR' )
                        ( taxty = '0061' taxct = 'DGR' )
                        ( taxty = '0071' taxct = 'OTV' )
                        ( taxty = '0073' taxct = 'OTV' )
                        ( taxty = '0074' taxct = 'OTV' )
                        ( taxty = '0075' taxct = 'OTV' )
                        ( taxty = '0076' taxct = 'OTV' )
                        ( taxty = '0077' taxct = 'OTV' )
                        ( taxty = '1047' taxct = 'DGR' )
                        ( taxty = '1048' taxct = 'DGR' )
                        ( taxty = '4071' taxct = 'DGR' )
                        ( taxty = '4080' taxct = 'DGR' )
                        ( taxty = '4081' taxct = 'DGR' )
                        ( taxty = '4171' taxct = 'DGR' )
                        ( taxty = '601'  taxct = 'TEV' )
                        ( taxty = '602'  taxct = 'TEV' )
                        ( taxty = '603'  taxct = 'TEV' )
                        ( taxty = '604'  taxct = 'TEV' )
                        ( taxty = '605'  taxct = 'TEV' )
                        ( taxty = '606'  taxct = 'TEV' )
                        ( taxty = '607'  taxct = 'TEV' )
                        ( taxty = '608'  taxct = 'TEV' )
                        ( taxty = '609'  taxct = 'TEV' )
                        ( taxty = '610'  taxct = 'TEV' )
                        ( taxty = '611'  taxct = 'TEV' )
                        ( taxty = '612'  taxct = 'TEV' )
                        ( taxty = '613'  taxct = 'TEV' )
                        ( taxty = '614'  taxct = 'TEV' )
                        ( taxty = '615'  taxct = 'TEV' )
                        ( taxty = '616'  taxct = 'TEV' )
                        ( taxty = '617'  taxct = 'TEV' )
                        ( taxty = '618'  taxct = 'TEV' )
                        ( taxty = '619'  taxct = 'TEV' )
                        ( taxty = '620'  taxct = 'TEV' )
                        ( taxty = '621'  taxct = 'TEV' )
                        ( taxty = '622'  taxct = 'TEV' )
                        ( taxty = '623'  taxct = 'TEV' )
                        ( taxty = '624'  taxct = 'TEV' )
                        ( taxty = '625'  taxct = 'TEV' )
                        ( taxty = '626'  taxct = 'TEV' )
                        ( taxty = '650'  taxct = 'TEV' )
                        ( taxty = '8001' taxct = 'DGR' )
                        ( taxty = '8002' taxct = 'DGR' )
                        ( taxty = '8004' taxct = 'DGR' )
                        ( taxty = '8005' taxct = 'DGR' )
                        ( taxty = '8006' taxct = 'DGR' )
                        ( taxty = '8007' taxct = 'DGR' )
                        ( taxty = '8008' taxct = 'DGR' )
                        ( taxty = '9021' taxct = 'DGR' )
                        ( taxty = '9040' taxct = 'DGR' )
                        ( taxty = '9077' taxct = 'OTV' )
                        ( taxty = '9944' taxct = 'DGR' ) ).

    lt_texts = VALUE #( ( taxty = '0003' spras = 'T' ltext = 'GELİR VERGİSİ STOPAJI' stext = 'GV STOPAJI' )
                        ( taxty = '0011' spras = 'T' ltext = 'KURUMLAR VERGİSİ STOPAJI' stext = 'KV STOPAJI' )
                        ( taxty = '0015' spras = 'T' ltext = 'GERÇEK USULDE KATMA DEĞER VERGİSİ' stext = 'KDV' )
                        ( taxty = '0021' spras = 'T' ltext = 'BANKA MUAMELELERİ VERGİSİ' stext = 'BMV' )
                        ( taxty = '0061' spras = 'T' ltext = 'KAYNAK KULLANIMI DESTEKLEME FONU KESİNTİSİ' stext = 'KKDF KESİNTİ' )
                        ( taxty = '0071' spras = 'T' ltext = 'PETROL VE DOĞALGAZ ÜRÜNLERİNE İLİŞKİN ÖZEL TÜKETİM VERGİSİ' stext = 'ÖTV 1.LİSTE' )
                        ( taxty = '0073' spras = 'T' ltext = 'KOLALI GAZOZ, ALKOLLÜ İÇEÇEKLER VE TÜTÜN MAMÜLLERİNE İLİŞKİN ÖZEL TÜKETİM VERGİSİ' stext = 'ÖTV 3.LİSTE' )
                        ( taxty = '0074' spras = 'T' ltext = 'DAYANIKLI TÜKETİM VE DİĞER MALLARA İLİŞKİN ÖZEL TÜKETİM VERGİSİ' stext = 'ÖTV 4.LİSTE' )
                        ( taxty = '0075' spras = 'T' ltext = 'ALKOLLÜ İÇEÇEKLERE İLİŞKİN ÖZEL TÜKETİM VERGİSİ' stext = 'ÖTV 3A LİSTE' )
                        ( taxty = '0076' spras = 'T' ltext = 'TÜTÜN MAMÜLLERİNE İLİŞKİN ÖZEL TÜKETİM VERGİSİ' stext = 'ÖTV 3B LİSTE' )
                        ( taxty = '0077' spras = 'T' ltext = 'KOLALI GAZOZLARA İLİŞKİN ÖZEL TÜKETİM VERGİSİ' stext = 'ÖTV 3C LİSTE' )
                        ( taxty = '1047' spras = 'T' ltext = 'DAMGA VERGİSİ' stext = 'DAMGA V' )
                        ( taxty = '1048' spras = 'T' ltext = '5035 SAYILI KANUNA GÖRE DAMGA VERGİSİ' stext = '5035 SK DAMGA V' )
                        ( taxty = '4071' spras = 'T' ltext = 'ELEKTRİK VE HAVAGAZI TÜKETİM VERGİSİ' stext = 'ELK.HAVAGAZ.TÜK.VER.' )
                        ( taxty = '4080' spras = 'T' ltext = 'ÖZEL İLETİŞİM VERGİSİ' stext = 'Ö.İLETİŞİM V' )
                        ( taxty = '4081' spras = 'T' ltext = '5035 SAYILI KANUNA GÖRE ÖZEL İLETİŞİM VERGİSİ' stext = '5035ÖZİLETV.' )
                        ( taxty = '4171' spras = 'T' ltext = 'PETROL VE DOĞALGAZ ÜRÜNLERİNE İLİŞKİN ÖTV TEVKİFATI' stext = 'PTR-DGZ ÖTV TEVKİFAT' )
                        ( taxty = '601'  spras = 'T' ltext = 'YAPIM İŞLERİ İLE BU İŞLERLE BİRLİKTE İFA EDİLEN MÜHENDİSLİK-MİMARLIK VE ETÜT-PROJE HİZMETLERİ' stext = 'GT 117-Bölüm (3.2.1) 4/10' )
                        ( taxty = '602'  spras = 'T' ltext = 'ETÜT, PLAN-PROJE, DANIŞMANLIK, DENETİM VE BENZERİ HİZMETLER' stext = 'GT 117-Bölüm (3.2.2) 9/10' )
                        ( taxty = '603'  spras = 'T' ltext = 'MAKİNE, TEÇHİZAT, DEMİRBAŞ VE TAŞITLARA AİT TADİL, BAKIM VE ONARIM HİZMETLERİ' stext = 'GT 117-Bölüm (3.2.3) 7/10' )
                        ( taxty = '604'  spras = 'T' ltext = 'YEMEK SERVİS HİZMETİ' stext = 'GT 117-Bölüm (3.2.4) 5/10' )
                        ( taxty = '605'  spras = 'T' ltext = 'ORGANİZASYON HİZMETİ' stext = 'GT 117-Bölüm (3.2.4) 5/10' )
                        ( taxty = '606'  spras = 'T' ltext = 'İŞGÜCÜ TEMİN HİZMETLERİ' stext = 'GT 117-Bölüm (3.2.5) 9/10' )
                        ( taxty = '607'  spras = 'T' ltext = 'ÖZEL GÜVENLİK HİZMETİ' stext = 'GT 117-Bölüm (3.2.5) 9/10' )
                        ( taxty = '608'  spras = 'T' ltext = 'YAPI DENETİM HİZMETLERİ' stext = 'GT 117-Bölüm (3.2.6) 9/10' )
                        ( taxty = '609'  spras = 'T' ltext = 'FASON OLARAK YAPTIRILAN TEKSTİL VE KONFEKSİYON İŞLERİ, ÇANTA VE AYAKKABI DİKİM İŞLERİ VE BU İŞLERE ARACILIK HİZMETLERİ' stext = 'GT 117-Bölüm (3.2.7) 7/10' )
                        ( taxty = '610'  spras = 'T' ltext = 'TURİSTİK MAĞAZALARA VERİLEN MÜŞTERİ BULMA / GÖTÜRME HİZMETLERİ' stext = 'GT 117-Bölüm (3.2.8) 9/10' )
                        ( taxty = '611'  spras = 'T' ltext = 'SPOR KULÜPLERİNİN YAYIN, REKLÂM VE İSİM HAKKI GELİRLERİNE KONU İŞLEMLERİ' stext = 'GT 117-Bölüm (3.2.9) 9/10' )
                        ( taxty = '612'  spras = 'T' ltext = 'TEMİZLİK HİZMETİ' stext = 'GT 117-Bölüm (3.2.10) 9/10' )
                        ( taxty = '613'  spras = 'T' ltext = 'ÇEVRE VE BAHÇE BAKIM HİZMETLERİ' stext = 'GT 117-Bölüm (3.2.10) 9/10' )
                        ( taxty = '614'  spras = 'T' ltext = 'SERVİS TAŞIMACILIĞI HİZMETİ' stext = 'GT 117-Bölüm (3.2.11) 5/10' )
                        ( taxty = '615'  spras = 'T' ltext = 'HER TÜRLÜ BASKI VE BASIM HİZMETLERİ' stext = 'GT 117-Bölüm (3.2.12) 7/10' )
                        ( taxty = '616'  spras = 'T' ltext = '5018 SAYILI KANUNA EKLİ CETVELLERDEKİ İDARE, KURUM VE KURUŞLARA YAPILAN DİĞER HİZMETLER' stext = 'GT 117-Bölüm (3.2.13) 5/10' )
                        ( taxty = '617'  spras = 'T' ltext = 'HURDA METALDEN ELDE EDİLEN KÜLÇE TESLİMLERİ' stext = 'GT 117-Bölüm (3.3.1) 7/10' )
                        ( taxty = '618'  spras = 'T' ltext = 'HURDA METALDEN ELDE EDİLENLER DIŞINDAKİ BAKIR, ÇİNKO VE ALÜMİNYUM KÜLÇE TESLİMLERİ' stext = 'GT 117-Bölüm (3.3.1) 7/10' )
                        ( taxty = '619'  spras = 'T' ltext = 'BAKIR, ÇİNKO VE ALÜMİNYUM ÜRÜNLERİNİN TESLİMİ' stext = 'GT 117-Bölüm (3.3.2) 5/10' )
                        ( taxty = '620'  spras = 'T' ltext = 'İSTİSNADAN VAZGEÇENLERİN HURDA VE ATIK TESLİMİ' stext = 'GT 117-Bölüm (3.3.3) 7/10' )
                        ( taxty = '621'  spras = 'T' ltext = 'METAL, PLASTİK, LASTİK, KAUÇUK, KÂĞIT VE CAM HURDA VE ATIKLARDAN ELDE EDİLEN HAMMADDE TESLİMİ' stext = 'GT 117-Bölüm (3.3.4) 9/10' )
                        ( taxty = '622'  spras = 'T' ltext = 'PAMUK, TİFTİK, YÜN VE YAPAĞI İLE HAM POST VE DERİ TESLİMLERİ' stext = 'GT 117-Bölüm (3.3.5) 9/10' )
                        ( taxty = '623'  spras = 'T' ltext = 'AĞAÇ VE ORMAN ÜRÜNLERİ TESLİMİ' stext = 'GT 117-Bölüm (3.3.6) 5/10' )
                        ( taxty = '624'  spras = 'T' ltext = 'YÜK TAŞIMACILIĞI HİZMETİ' )
                        ( taxty = '625'  spras = 'T' ltext = 'TİCARİ REKLAM HİZMETLERİ' )
                        ( taxty = '626'  spras = 'T' ltext = 'DİĞER TESLİMLER' )
                        ( taxty = '650'  spras = 'T' ltext = 'DİĞERLERİ' stext = 'DİĞERLERİ 2/10,5/10, 7/10,9/10' )
                        ( taxty = '8001' spras = 'T' ltext = 'BORSA TESCİL ÜCRETİ' stext = 'BORSA TES.ÜC.' )
                        ( taxty = '8002' spras = 'T' ltext = 'ENERJİ FONU' stext = 'ENERJİ FONU' )
                        ( taxty = '8004' spras = 'T' ltext = 'TRT PAYI' stext = 'TRT PAYI' )
                        ( taxty = '8005' spras = 'T' ltext = 'ELEKTRİK TÜKETİM VERGİSİ' stext = 'ELK.TÜK.VER.' )
                        ( taxty = '8006' spras = 'T' ltext = 'TELSİZ KULLANIM ÜCRETİ' stext = 'TK KULLANIM' )
                        ( taxty = '8007' spras = 'T' ltext = 'TELSİZ RUHSAT ÜCRETİ' stext = 'TK RUHSAT' )
                        ( taxty = '8008' spras = 'T' ltext = 'ÇEVRE TEMİZLİK VERGİSİ' stext = 'ÇEV. TEM .VER.' )
                        ( taxty = '9021' spras = 'T' ltext = '4961 BANKA SİGORTA MUAMELELERİ VERGİSİ' stext = '4961 BANKA SMV' )
                        ( taxty = '9040' spras = 'T' ltext = 'MERA FONU' stext = 'MERA FONU' )
                        ( taxty = '9077' spras = 'T' ltext = 'MOTORLU TAŞIT ARAÇLARINA İLİŞKİN ÖZEL TÜKETİM VERGİSİ (TESCİLE TABİ OLANLAR)' stext = 'ÖTV 2.LİSTE' )
                        ( taxty = '9944' spras = 'T' ltext = 'BELEDİYELERE ÖDENEN HAL RÜSUMU' stext = 'BEL.ÖD.HAL RÜSUM' ) ).
    LOOP AT lt_texts INTO DATA(ls_text).
      CHECK ls_text-spras = 'T'.
      ls_text-spras = 'E'.
      APPEND ls_text TO lt_texts.
    ENDLOOP.

    DELETE FROM zetr_t_taxcd.
    DELETE FROM zetr_t_taxcx.
    COMMIT WORK AND WAIT.

    INSERT zetr_t_taxcd FROM TABLE @lt_codes.
    INSERT zetr_t_taxcx FROM TABLE @lt_texts.
    COMMIT WORK AND WAIT.
  ENDMETHOD.


  METHOD generate_tax_exemption_codes.
    DATA: lt_codes TYPE TABLE OF zetr_t_taxex,
          lt_texts TYPE TABLE OF zetr_t_taxed.

    lt_codes = VALUE #( ( taxex = '101' taxet = 'V' )
                        ( taxex = '102' taxet = 'V' )
                        ( taxex = '103' taxet = 'V' )
                        ( taxex = '104' taxet = 'V' )
                        ( taxex = '105' taxet = 'V' )
                        ( taxex = '106' taxet = 'V' )
                        ( taxex = '107' taxet = 'V' )
                        ( taxex = '108' taxet = 'V' )
                        ( taxex = '151' taxet = 'V' )
                        ( taxex = '201' taxet = 'K' )
                        ( taxex = '202' taxet = 'K' )
                        ( taxex = '204' taxet = 'K' )
                        ( taxex = '205' taxet = 'K' )
                        ( taxex = '206' taxet = 'K' )
                        ( taxex = '207' taxet = 'K' )
                        ( taxex = '208' taxet = 'K' )
                        ( taxex = '209' taxet = 'K' )
                        ( taxex = '211' taxet = 'K' )
                        ( taxex = '212' taxet = 'K' )
                        ( taxex = '213' taxet = 'K' )
                        ( taxex = '214' taxet = 'K' )
                        ( taxex = '215' taxet = 'K' )
                        ( taxex = '216' taxet = 'K' )
                        ( taxex = '217' taxet = 'K' )
                        ( taxex = '218' taxet = 'K' )
                        ( taxex = '219' taxet = 'K' )
                        ( taxex = '220' taxet = 'K' )
                        ( taxex = '221' taxet = 'K' )
                        ( taxex = '223' taxet = 'K' )
                        ( taxex = '225' taxet = 'K' )
                        ( taxex = '226' taxet = 'K' )
                        ( taxex = '227' taxet = 'K' )
                        ( taxex = '228' taxet = 'K' )
                        ( taxex = '229' taxet = 'K' )
                        ( taxex = '230' taxet = 'K' )
                        ( taxex = '231' taxet = 'K' )
                        ( taxex = '232' taxet = 'K' )
                        ( taxex = '234' taxet = 'K' )
                        ( taxex = '235' taxet = 'K' )
                        ( taxex = '236' taxet = 'K' )
                        ( taxex = '237' taxet = 'K' )
                        ( taxex = '238' taxet = 'K' )
                        ( taxex = '239' taxet = 'K' )
                        ( taxex = '240' taxet = 'K' )
                        ( taxex = '241' taxet = 'K' )
                        ( taxex = '250' taxet = 'K' )
                        ( taxex = '301' taxet = 'T' )
                        ( taxex = '302' taxet = 'T' )
                        ( taxex = '303' taxet = 'T' )
                        ( taxex = '304' taxet = 'T' )
                        ( taxex = '305' taxet = 'T' )
                        ( taxex = '306' taxet = 'T' )
                        ( taxex = '307' taxet = 'T' )
                        ( taxex = '308' taxet = 'T' )
                        ( taxex = '309' taxet = 'T' )
                        ( taxex = '310' taxet = 'T' )
                        ( taxex = '311' taxet = 'T' )
                        ( taxex = '312' taxet = 'T' )
                        ( taxex = '313' taxet = 'K' )
                        ( taxex = '314' taxet = 'T' )
                        ( taxex = '315' taxet = 'T' )
                        ( taxex = '316' taxet = 'T' )
                        ( taxex = '317' taxet = 'T' )
                        ( taxex = '318' taxet = 'T' )
                        ( taxex = '319' taxet = 'T' )
                        ( taxex = '320' taxet = 'T' )
                        ( taxex = '321' taxet = 'T' )
                        ( taxex = '322' taxet = 'T' )
                        ( taxex = '323' taxet = 'T' )
                        ( taxex = '324' taxet = 'T' )
                        ( taxex = '325' taxet = 'T' )
                        ( taxex = '326' taxet = 'T' )
                        ( taxex = '327' taxet = 'T' )
                        ( taxex = '328' taxet = 'T' )
                        ( taxex = '350' taxet = 'T' )
                        ( taxex = '351' taxet = 'T' )
                        ( taxex = '701' taxet = 'I' )
                        ( taxex = '702' taxet = 'I' )
                        ( taxex = '703' taxet = 'I' )
                        ( taxex = '801' taxet = 'O' )
                        ( taxex = '802' taxet = 'O' )
                        ( taxex = '803' taxet = 'O' )
                        ( taxex = '804' taxet = 'O' )
                        ( taxex = '805' taxet = 'O' )
                        ( taxex = '806' taxet = 'O' )
                        ( taxex = '807' taxet = 'O' )
                        ( taxex = '808' taxet = 'O' )
                        ( taxex = '809' taxet = 'O' )
                        ( taxex = '810' taxet = 'O' )
                        ( taxex = '811' taxet = 'O' ) ).

    lt_texts = VALUE #( ( taxex = '101' spras = 'T' bezei = 'İhracat İstisnası' )
                        ( taxex = '102' spras = 'T' bezei = 'Diplomatik İstisna' )
                        ( taxex = '103' spras = 'T' bezei = 'Askeri Amaçlı İstisna' )
                        ( taxex = '104' spras = 'T' bezei = 'Petrol Arama Faaliyetlerinde Bulunanlara Yapılan Teslimler' )
                        ( taxex = '105' spras = 'T' bezei = 'Uluslararası Anlaşmadan Doğan İstisna' )
                        ( taxex = '106' spras = 'T' bezei = 'Diğer İstisnalar' )
                        ( taxex = '107' spras = 'T' bezei = '7/a Maddesi Kapsamında Yapılan Teslimler' )
                        ( taxex = '108' spras = 'T' bezei = 'Geçici 5. Madde Kapsamında Yapılan Teslimler' )
                        ( taxex = '151' spras = 'T' bezei = 'ÖTV - İstisna Olmayan Diğer' )
                        ( taxex = '201' spras = 'T' bezei = '17/1 Kültür ve Eğitim Amacı Taşıyan İşlemler' )
                        ( taxex = '202' spras = 'T' bezei = '17/2-a Sağlık, Çevre Ve Sosyal Yardım Amaçlı İşlemler' )
                        ( taxex = '204' spras = 'T' bezei = '17/2-c Yabancı Diplomatik Organ Ve Hayır Kurumlarının Yapacakları Bağışlarla İlgili Mal Ve Hizmet Alışları' )
                        ( taxex = '205' spras = 'T' bezei = '17/2-d Taşınmaz Kültür Varlıklarına İlişkin Teslimler ve Mimarlık Hizmetleri' )
                        ( taxex = '206' spras = 'T' bezei = '17/2-e Mesleki Kuruluşların İşlemleri' )
                        ( taxex = '207' spras = 'T' bezei = '17/3 Askeri Fabrika, Tersane ve Atölyelerin İşlemleri' )
                        ( taxex = '208' spras = 'T' bezei = '17/4-c Birleşme, Devir, Dönüşüm ve Bölünme İşlemleri' )
                        ( taxex = '209' spras = 'T' bezei = '17/4-e Banka ve Sigorta Muameleleri Vergisi Kapsamına Giren İşlemler' )
                        ( taxex = '211' spras = 'T' bezei = '17/4-h Zirai Amaçlı Su Teslimleri İle Köy Tüzel Kişiliklerince Yapılan İçme Suyu teslimleri' )
                        ( taxex = '212' spras = 'T' bezei = '17/4-ı Serbest Bölgelerde Verilen Hizmetler' )
                        ( taxex = '213' spras = 'T' bezei = '17/4-j Boru Hattı İle Yapılan Petrol Ve Gaz Taşımacılığı' )
                        ( taxex = '214' spras = 'T' bezei = '17/4-k Organize Sanayi Bölgelerindeki Arsa ve İşyeri Teslimleri İle Konut Yapı Kooperatiflerinin Üyelerine Konut Teslimleri' )
                        ( taxex = '215' spras = 'T' bezei = '17/4-l Varlık Yönetim Şirketlerinin İşlemleri' )
                        ( taxex = '216' spras = 'T' bezei = '17/4-m Tasarruf Mevduatı Sigorta Fonunun İşlemleri' )
                        ( taxex = '217' spras = 'T' bezei = '17/4-n Basın-Yayın ve Enformasyon Genel Müdürlüğüne Verilen Haber Hizmetleri' )
                        ( taxex = '218' spras = 'T' bezei = '17/4-o Gümrük Antrepoları, Geçici Depolama Yerleri, Gümrüklü Sahalar ve Vergisiz Satış Yapılan Mağazalarla İlgili Hizmetler' )
                        ( taxex = '219' spras = 'T' bezei = '17/4-p Hazine ve Arsa Ofisi Genel Müdürlüğünün işlemleri' )
                        ( taxex = '220' spras = 'T' bezei = '17/4-r İki Tam Yıl Süreyle Sahip Olunan Taşınmaz ve İştirak Hisseleri Satışları' )
                        ( taxex = '221' spras = 'T' bezei = 'Geçici 15 Konut Yapı Kooperatifleri, Belediyeler ve Sosyal Güvenlik Kuruluşlarına Verilen İnşaat Taahhüt Hizmeti' )
                        ( taxex = '223' spras = 'T' bezei = 'Geçici 20/1 Teknoloji Geliştirme Bölgelerinde Yapılan İşlemler' )
                        ( taxex = '225' spras = 'T' bezei = 'Geçici 23 Milli Eğitim Bakanlığına Yapılan Bilgisayar Bağışları İle İlgili Teslimler' )
                        ( taxex = '226' spras = 'T' bezei = '17/2-b Özel Okulları, Üniversite ve Yüksekokullar Tarafından Verilen Bedelsiz Eğitim Ve Öğretim Hizmetleri' )
                        ( taxex = '227' spras = 'T' bezei = '17/2-b Kanunların Gösterdiği Gerek Üzerine Bedelsiz Olarak Yapılan Teslim ve Hizmetler' )
                        ( taxex = '228' spras = 'T' bezei = '17/2-b Kanunun (17/1) Maddesinde Sayılan Kurum ve Kuruluşlara Bedelsiz Olarak Yapılan Teslimler' )
                        ( taxex = '229' spras = 'T' bezei = '17/2-b Gıda Bankacılığı Faaliyetinde Bulunan Dernek ve Vakıflara Bağışlanan Gıda, Temizlik, Giyecek ve Yakacak Maddeleri' )
                        ( taxex = '230' spras = 'T' bezei = '17/4-g Külçe Altın, Külçe Gümüş Ve Kiymetli Taşlarin Teslimi' )
                        ( taxex = '231' spras = 'T' bezei = '17/4-g Metal Plastik, Lastik, Kauçuk, Kağit, Cam Hurda Ve Atıkların Teslimi' )
                        ( taxex = '232' spras = 'T' bezei = '17/4-g Döviz, Para, Damga Pulu, Değerli Kağıtlar, Hisse Senedi ve Tahvil Teslimleri' )
                        ( taxex = '234' spras = 'T' bezei = '17/4-ş Konut Finansmanı Amacıyla Teminat Gösterilen ve İpotek Konulan Konutların Teslimi' )
                        ( taxex = '235' spras = 'T' bezei = '16/1-c Transit ve Gümrük Antrepo Rejimleri İle Geçici Depolama ve Serbest Bölge Hükümlerinin Uygulandığiı Malların Teslimi' )
                        ( taxex = '236' spras = 'T' bezei = '19/2 Usulüne Göre Yürürlüğe Girmiş Uluslararası Anlaşmalar Kapsamındaki İstisnalar (İade Hakkı Tanınmayan)' )
                        ( taxex = '237' spras = 'T' bezei = '17/4-t 5300 Sayılı Kanuna Göre Düzenlenen Ürün Senetlerinin İhtisas/Ticaret Borsaları Aracılığıyla İlk Teslimlerinden Sonraki Teslim' )
                        ( taxex = '238' spras = 'T' bezei = '17/4-u Varlıkların Varlık Kiralama Şirketlerine Devri İle Bu Varlıkların Varlık Kiralama Şirketlerince Kiralanması ve Devralınan Kuruma Devri' )
                        ( taxex = '239' spras = 'T' bezei = '17/4-y Taşınmazların Finansal Kiralama Şirketlerine Devri, Finansal Kiralama Şirketi Tarafından Devredene Kiralanması ve Devri' )
                        ( taxex = '240' spras = 'T' bezei = '17/4-z Patentli Veya Faydalı Model Belgeli Buluşa İlişkin Gayri Maddi Hakların Kiralanması, Devri ve Satışı' )
                        ( taxex = '241' spras = 'T' bezei = 'Türk Akım Gaz Boru Hattı Projesine İlişkin Anlaşmanın (9/b) Maddesinde Yer Alan Hizmetler' )
                        ( taxex = '250' spras = 'T' bezei = 'Diğerleri' )
                        ( taxex = '301' spras = 'T' bezei = '11/1-a Mal İhracatı' )
                        ( taxex = '302' spras = 'T' bezei = '11/1-a Hizmet İhracatı' )
                        ( taxex = '303' spras = 'T' bezei = '11/1-a Roaming Hizmetleri' )
                        ( taxex = '304' spras = 'T' bezei = '13/a Deniz Hava ve Demiryolu Taşıma Araçlarının Teslimi İle İnşa, Tadil, Bakım ve Onarımları' )
                        ( taxex = '305' spras = 'T' bezei = '13/b Deniz ve Hava Taşıma Araçları İçin Liman Ve Hava Meydanlarında Yapılan Hizmetler' )
                        ( taxex = '306' spras = 'T' bezei = '13/c Petrol Aramaları ve Petrol Boru Hatlarının İnşa ve Modernizasyonuna İlişkin Yapılan Teslim ve Hizmetler' )
                        ( taxex = '307' spras = 'T' bezei = '13/c Maden Arama, Altın, Gümüş, ve Platin Madenleri İçin İşletme, Zenginleştirme Ve Rafinaj Faaliyetlerine İlişkin Teslim Ve Hizmetler' )
                        ( taxex = '308' spras = 'T' bezei = '13/d Teşvikli Yatırım Mallarının Teslimi' )
                        ( taxex = '309' spras = 'T' bezei = '13/e Liman Ve Hava Meydanlarının İnşası, Yenilenmesi Ve Genişletilmesi' )
                        ( taxex = '310' spras = 'T' bezei = '13/f Ulusal Güvenlik Amaçlı Teslim ve Hizmetler' )
                        ( taxex = '311' spras = 'T' bezei = '14/1 Uluslararası Taşımacılık' )
                        ( taxex = '312' spras = 'T' bezei = '15/a Diplomatik Organ Ve Misyonlara Yapılan Teslim ve Hizmetler' )
                        ( taxex = '313' spras = 'T' bezei = '15/b Uluslararası Kuruluşlara Yapılan Teslim ve Hizmetler' )
                        ( taxex = '314' spras = 'T' bezei = '19/2 Usulüne Göre Yürürlüğe Girmiş Uluslar Arası Anlaşmalar Kapsamındaki İstisnalar' )
                        ( taxex = '315' spras = 'T' bezei = '14/3 İhraç Konusu Eşyayı Taşıyan Kamyon, Çekici ve Yarı Romorklara Yapılan Motorin Teslimleri' )
                        ( taxex = '316' spras = 'T' bezei = '11/1-a Serbest Bölgelerdeki Müşteriler İçin Yapılan Fason Hizmetler' )
                        ( taxex = '317' spras = 'T' bezei = '17/4-s Engellilerin Eğitimleri, Meslekleri ve Günlük Yaşamlarına İlişkin Araç-Gereç ve Bilgisayar Programları' )
                        ( taxex = '318' spras = 'T' bezei = 'Geçici 29 3996 Sayılı Kanuna Göre Yap-İşlet-Devret Modeli Çerçevesinde Gerçekleştirilecek Projeler, 3359 Sayılı Kanuna Göre Kiralama Karşılığı Yaptırılan Sağlık Tesislerine İlişkin Projeler' )
                        ( taxex = '319' spras = 'T' bezei = '13/g Başbakanlık Merkez Teşkilatına Yapılan Araç Teslimleri' )
                        ( taxex = '320' spras = 'T' bezei = 'Geçici 16 (6111 sayılı K.) İSMEP Kapsamında İstanbul İl Özel İdaresi''ne Bağlı Olarak Faaliyet Gösteren "İstanbul Proje Koordinasyon Birimi"ne Yapılacak Teslim ve Hizmetler' )
                        ( taxex = '321' spras = 'T' bezei = 'Geçici 26 Birleşmiş Milletler (BM) ile Kuzey Atlantik Antlaşması Teşkilatı (NATO) Temsilcilikleri ve Bu Teşkilatlara Bağlı Program, Fon ve Özel İhtisas Kuruluşları' )
                        ( taxex = '322' spras = 'T' bezei = '11/1-a Türkiye''de İkamet Etmeyenlere Özel Fatura ile Yapılan Teslimler (Bavul Ticareti)' )
                        ( taxex = '323' spras = 'T' bezei = '13/ğ 5300 Sayılı Kanuna Göre Düzenlenen Ürün Senetlerinin İhtisas/Ticaret Borsaları Aracılığıyla İlk Teslimi' )
                        ( taxex = '324' spras = 'T' bezei = '13/h Türkiye Kızılay Derneğine Yapılan Teslim ve Hizmetler ile Türkiye Kızılay Derneğinin Teslim ve Hizmetleri' )
                        ( taxex = '325' spras = 'T' bezei = '13/ı Yem Teslimleri' )
                        ( taxex = '326' spras = 'T' bezei = '13/ı Gıda, Tarım ve Hayvancılık Bakanlığı Tarafından Tescil Edilmiş Gübrelerin Teslimi' )
                        ( taxex = '327' spras = 'T' bezei = '13/ı Gıda, Tarım ve Hayvancılık Bakanlığı Tarafından Tescil Edilmiş Gübrelerin İçeriğinde Bulunan Hammaddelerin Gübre Üreticilerine teslimi' )
                        ( taxex = '328' spras = 'T' bezei = '13/i Konut veya İşyeri Teslimleri' )
                        ( taxex = '350' spras = 'T' bezei = 'Diğerleri' )
                        ( taxex = '351' spras = 'T' bezei = 'KDV - İstisna Olmayan Diğer' )
                        ( taxex = '701' spras = 'T' bezei = '3065 s. KDV Kanununun 11/1-c md. Kapsamındaki İhraç Kayıtlı Satış' )
                        ( taxex = '702' spras = 'T' bezei = 'DİİB ve Geçici Kabul Rejimi Kapsamındaki Satışlar' )
                        ( taxex = '703' spras = 'T' bezei = '4760 s. ÖTV Kanununun 8/2 Md. Kapsamındaki İhraç Kayıtlı Satış' )
                        ( taxex = '801' spras = 'T' bezei = 'Milli piyango, spor-toto ve benzeri Devletçe organize edilen organizasyonlar' )
                        ( taxex = '802' spras = 'T' bezei = 'At yarışları ve diğer müşterek bahis ve talih oyunları' )
                        ( taxex = '803' spras = 'T' bezei = 'Profesyonel sanatçıların yer aldığı gösteriler ve konserler ile profesyonel sporcuların katıldığı sportif faaliyetler, maçlar ve' )
                        ( taxex = '804' spras = 'T' bezei = 'Gümrük depolarında ve müzayede salonlarında yapılan satışlar' )
                        ( taxex = '805' spras = 'T' bezei = 'Altından mamül veya altın ihtiva eden ziynet eşyaları ile sikke altınların teslim ve ithali' )
                        ( taxex = '806' spras = 'T' bezei = 'Tütün mamülleri ve bazı alkollü içkiler' )
                        ( taxex = '807' spras = 'T' bezei = 'Gazete, dergi ve benzeri periyodik yayınlar' )
                        ( taxex = '808' spras = 'T' bezei = 'Külçe gümüş ve gümüşten mamül eşya teslimleri' )
                        ( taxex = '809' spras = 'T' bezei = 'Belediyeler tarafından yapılan şehiriçi yolcu taşımacılığında kullanılan biletlerin ve kartların bayiler tarafından satışı' )
                        ( taxex = '810' spras = 'T' bezei = 'Telefon kartı ve jeton satışları' )
                        ( taxex = '811' spras = 'T' bezei = 'Türkiye Şoförler ve Otomobilciler Federasyonu tarafından araç plakaları ile sürücü kurslarında kullanılan bir kısım evrakın bası' ) ).
    LOOP AT lt_texts INTO DATA(ls_text).
      CHECK ls_text-spras = 'T'.
      ls_text-spras = 'E'.
      APPEND ls_text TO lt_texts.
    ENDLOOP.

    DELETE FROM zetr_t_taxex.
    DELETE FROM zetr_t_taxed.
    COMMIT WORK AND WAIT.

    INSERT zetr_t_taxex FROM TABLE @lt_codes.
    INSERT zetr_t_taxed FROM TABLE @lt_texts.
    COMMIT WORK AND WAIT.
  ENDMETHOD.


  METHOD generate_transport_codes.
    DATA: lt_codes TYPE TABLE OF zetr_t_trnsp,
          lt_texts TYPE TABLE OF zetr_t_trnsx.

    lt_codes = VALUE #( ( trnsp = '1' )
                        ( trnsp = '2' )
                        ( trnsp = '3' )
                        ( trnsp = '4' )
                        ( trnsp = '5' )
                        ( trnsp = '6' )
                        ( trnsp = '7' )
                        ( trnsp = '8' ) ).

    lt_texts = VALUE #(
                        ( spras = 'T' trnsp = '1' bezei =  'Denizyolu' )
                        ( spras = 'T' trnsp = '2' bezei =  'Demiryolu' )
                        ( spras = 'T' trnsp = '3' bezei =  'Karayolu' )
                        ( spras = 'T' trnsp = '4' bezei =  'Havayolu' )
                        ( spras = 'T' trnsp = '5' bezei =  'Posta' )
                        ( spras = 'T' trnsp = '6' bezei =  'Çok araçlı' )
                        ( spras = 'T' trnsp = '7' bezei =  'Sabit taşıma tesisleri' )
                        ( spras = 'T' trnsp = '8' bezei =  'İç su taşımacılığı' ) ).
    LOOP AT lt_texts INTO DATA(ls_text).
      CHECK ls_text-spras = 'T'.
      ls_text-spras = 'E'.
      APPEND ls_text TO lt_texts.
    ENDLOOP.

    DELETE FROM zetr_t_trnsp.
    DELETE FROM zetr_t_trnsx.
    COMMIT WORK AND WAIT.

    INSERT zetr_t_trnsp FROM TABLE @lt_codes.
    INSERT zetr_t_trnsx FROM TABLE @lt_texts.
    COMMIT WORK AND WAIT.
  ENDMETHOD.


  METHOD generate_unit_codes.
    DATA: lt_codes TYPE TABLE OF zetr_t_units,
          lt_texts TYPE TABLE OF zetr_t_unitx,
          lt_match TYPE TABLE OF zetr_t_untmc.

    lt_codes = VALUE #( ( unitc = '3I' )
                        ( unitc = 'B32' )
                        ( unitc = 'BX' )
                        ( unitc = 'C62' )
                        ( unitc = 'CCT' )
                        ( unitc = 'CEN' )
                        ( unitc = 'CTM' )
                        ( unitc = 'D30' )
                        ( unitc = 'D32' )
                        ( unitc = 'D40' )
                        ( unitc = 'DMK' )
                        ( unitc = 'GFI' )
                        ( unitc = 'GRM' )
                        ( unitc = 'GT' )
                        ( unitc = 'GWH' )
                        ( unitc = 'KFO' )
                        ( unitc = 'KGM' )
                        ( unitc = 'KHY' )
                        ( unitc = 'KMA' )
                        ( unitc = 'KNI' )
                        ( unitc = 'KPH' )
                        ( unitc = 'KPO' )
                        ( unitc = 'KSD' )
                        ( unitc = 'KSH' )
                        ( unitc = 'KUR' )
                        ( unitc = 'KWH' )
                        ( unitc = 'KWT' )
                        ( unitc = 'LPA' )
                        ( unitc = 'LTR' )
                        ( unitc = 'MND' )
                        ( unitc = 'MTK' )
                        ( unitc = 'MTQ' )
                        ( unitc = 'MTR' )
                        ( unitc = 'MWH' )
                        ( unitc = 'NCL' )
                        ( unitc = 'PR' )
                        ( unitc = 'R9' )
                        ( unitc = 'SET' )
                        ( unitc = 'SM3' )
                        ( unitc = 'T3' ) ).

    lt_texts = VALUE #( ( spras = 'T' unitc = '3I ' bezei = 'KİLOGRAM-ADET' )
                        ( spras = 'T' unitc = 'B32' bezei = 'KG-METRE KARE' )
                        ( spras = 'T' unitc = 'BX ' bezei = 'KUTU' )
                        ( spras = 'T' unitc = 'C62' bezei = 'ADET(UNIT)' )
                        ( spras = 'T' unitc = 'CCT' bezei = 'TON BAŞINA TAŞIMA KAPASİTESİ' )
                        ( spras = 'T' unitc = 'CEN' bezei = 'YÜZ ADET' )
                        ( spras = 'T' unitc = 'CTM' bezei = 'KARAT' )
                        ( spras = 'T' unitc = 'D30' bezei = 'BRÜT KALORİ DEĞERİ' )
                        ( spras = 'T' unitc = 'D32' bezei = 'TERAWATT SAAT' )
                        ( spras = 'T' unitc = 'D40' bezei = 'BİN LİTRE' )
                        ( spras = 'T' unitc = 'DMK' bezei = 'DESİMETRE KARE' )
                        ( spras = 'T' unitc = 'GFI' bezei = 'FISSILE İZOTOP GRAMI' )
                        ( spras = 'T' unitc = 'GRM' bezei = 'GRAM' )
                        ( spras = 'T' unitc = 'GT ' bezei = 'GROSS TON' )
                        ( spras = 'T' unitc = 'GWH' bezei = 'GİGAWATT SAAT' )
                        ( spras = 'T' unitc = 'KFO' bezei = 'DİFOSFOR PENTAOKSİT KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KGM' bezei = 'KİLOGRAM' )
                        ( spras = 'T' unitc = 'KHY' bezei = 'HİDROJEN PEROKSİT KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KMA' bezei = 'METİL AMİNLERİN KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KNI' bezei = 'AZOTUN KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KPH' bezei = 'KİLOGRAM POTASYUM HİDROKSİT' )
                        ( spras = 'T' unitc = 'KPO' bezei = 'KİLOGRAM POTASYUM OKSİT' )
                        ( spras = 'T' unitc = 'KSD' bezei = '%90 KURU ÜRÜN KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KSH' bezei = 'SODYUM HİDROKSİT KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KUR' bezei = 'URANYUM KİLOGRAMI' )
                        ( spras = 'T' unitc = 'KWH' bezei = 'KİLOWATT SAAT' )
                        ( spras = 'T' unitc = 'KWT' bezei = 'KİLOWATT' )
                        ( spras = 'T' unitc = 'LPA' bezei = 'SAF ALKOL LİTRESİ' )
                        ( spras = 'T' unitc = 'LTR' bezei = 'LİTRE' )
                        ( spras = 'T' unitc = 'MND' bezei = 'KURUTULMUŞ NET AĞIRLIKLI KİLOGRAMI' )
                        ( spras = 'T' unitc = 'MTK' bezei = 'METRE KARE' )
                        ( spras = 'T' unitc = 'MTQ' bezei = 'METRE KÜP' )
                        ( spras = 'T' unitc = 'MTR' bezei = 'METRE' )
                        ( spras = 'T' unitc = 'MWH' bezei = 'MEGAWATT SAAT (1000 kW.h)' )
                        ( spras = 'T' unitc = 'NCL' bezei = 'HÜCRE ADEDİ' )
                        ( spras = 'T' unitc = 'PR ' bezei = 'ÇİFT' )
                        ( spras = 'T' unitc = 'R9 ' bezei = 'BİN METRE KÜP' )
                        ( spras = 'T' unitc = 'SET' bezei = 'SET' )
                        ( spras = 'T' unitc = 'SM3' bezei = 'STANDART METREKÜP' )
                        ( spras = 'T' unitc = 'T3 ' bezei = 'BİN ADET' ) ).
    LOOP AT lt_texts INTO DATA(ls_text).
      CHECK ls_text-spras = 'T'.
      ls_text-spras = 'E'.
      APPEND ls_text TO lt_texts.
    ENDLOOP.

    lt_match = VALUE #( ( meins = 'ST' unitc = 'C62' )
                        ( meins = 'G' unitc = 'GRM' )
                        ( meins = 'KG' unitc = 'KGM' )
                        ( meins = 'L' unitc = 'LTR' ) ).

    DELETE FROM zetr_t_units.
    DELETE FROM zetr_t_unitx.
    DELETE FROM zetr_t_untmc.
    COMMIT WORK AND WAIT.

    INSERT zetr_t_units FROM TABLE @lt_codes.
    INSERT zetr_t_unitx FROM TABLE @lt_texts.
    INSERT zetr_t_untmc FROM TABLE @lt_match.
    COMMIT WORK AND WAIT.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    generate_unit_codes( ).
    out->write( 'Unit codes generated' ).
    generate_transport_codes( ).
    out->write( 'Transport codes generated' ).
    generate_status_codes( ).
    out->write( 'Status codes generated' ).
    generate_tax_codes( ).
    out->write( 'Tax codes generated' ).
    generate_tax_exemption_codes( ).
    out->write( 'Tax Exemption codes generated' ).
    generate_essential_partners( ).
    out->write( 'Partners generated' ).
  ENDMETHOD.
ENDCLASS.
