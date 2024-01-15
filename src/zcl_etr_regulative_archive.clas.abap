CLASS zcl_etr_regulative_archive DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES mty_archives TYPE STANDARD TABLE OF zetr_s_document_archive WITH EMPTY KEY.

    CONSTANTS:
      BEGIN OF mc_content_types.
    CONSTANTS pdf  TYPE zetr_e_dctyp VALUE 'PDF' ##NO_TEXT.
    CONSTANTS ubl  TYPE zetr_e_dctyp VALUE 'UBL' ##NO_TEXT.
    CONSTANTS html TYPE zetr_e_dctyp VALUE 'HTML' ##NO_TEXT.
    CONSTANTS END OF mc_content_types .

    CLASS-METHODS create
      IMPORTING
        !it_archives TYPE mty_archives.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ETR_REGULATIVE_ARCHIVE IMPLEMENTATION.


  METHOD create.
    DATA: lt_archive  TYPE TABLE OF zetr_t_arcd,
          ls_archive  TYPE zetr_t_arcd,
          lt_archives TYPE mty_archives,
          ls_archives TYPE zetr_s_document_archive.
    lt_archives = it_archives.
    LOOP AT lt_archives INTO ls_archives.
      MOVE-CORRESPONDING ls_archives TO ls_archive.
      TRY.
          ls_archive-arcid = cl_system_uuid=>create_uuid_c22_static( ).
        CATCH cx_uuid_error.
          "handle exception
      ENDTRY.
      APPEND ls_archive TO lt_archive.
      CLEAR ls_archive.
    ENDLOOP.
    CHECK lt_archive IS NOT INITIAL.
    INSERT zetr_t_arcd FROM TABLE @lt_archive.
  ENDMETHOD.
ENDCLASS.
