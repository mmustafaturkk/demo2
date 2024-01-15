CLASS zcl_etr_temp_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_etr_temp_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    TRY.
        DATA(lo_service) = zcl_etr_edelivery_ws=>factory( iv_company = '1000' ).
        lo_service->get_incoming_deliveries(
          EXPORTING
            iv_date_from = '20240101'
            iv_date_to   = '20240111'
          IMPORTING
            et_items     = DATA(lt_items)
            et_list      = DATA(lt_list)
        ).
*        CATCH zcx_etr_regulative_exception.

        out->write( 'Başarılı' ).
      CATCH cx_root INTO DATA(lx_root).
        out->write( lx_root->get_text( ) ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
