*&---------------------------------------------------------------------*
*& Include          ZDKTJ_WORKPLAN_ALV_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_object .

    CREATE OBJECT gc_docking
      EXPORTING
*        parent                      =
        repid                       = SY-REPID
        dynnr                       = SY-DYNNR
        side                        = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_BOTTOM
        extension                   = 390
*        style                       =
*        lifetime                    = lifetime_default
*        caption                     =
*        metric                      = 0
*        ratio                       =
*        no_autodef_progid_dynnr     =
*        name                        =
  .
    CREATE OBJECT gc_grid
      EXPORTING
*        i_shellstyle      = 0
*        i_lifetime        =
        i_parent          = GC_DOCKING

        .
    IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

*    GS_LAYOUT-STYLEFNAME = 'STYLE'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FIELD_CATALOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM field_catalog .
  GS_FCAT-FIELDNAME = 'PLAN_CODE'.
  GS_FCAT-COLTEXT = '생산 계획 코드'.
  GS_FCAT-KEY = 'X'.
*  GS_FCAT-JUST = 'C'. "C, R, L 정렬
  GS_FCAT-OUTPUTLEN = 10.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'MITEMCODE'.
  GS_FCAT-COLTEXT = '모품목 코드'.
  GS_FCAT-KEY = 'X'.
*  GS_FCAT-JUST = 'C'. "C, R, L 정렬
  GS_FCAT-OUTPUTLEN = 15.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'COMPONENT'.
  GS_FCAT-COLTEXT = '모품목명'.
  GS_FCAT-OUTPUTLEN = 20.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'ICNAME'.
  GS_FCAT-COLTEXT = '품목군'.
  GS_FCAT-OUTPUTLEN = 20.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'PLAN_DATE'.
  GS_FCAT-COLTEXT = '계획 날짜'.
  GS_FCAT-OUTPUTLEN = 15.
  GS_FCAT-EDIT = 'X'.
  GS_FCAT-REF_TABLE = 'ADCP'.
  GS_FCAT-REF_FIELD = 'DATE_FROM'.
  GS_FCAT-INTTYPE = 'D'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'PLAN_QT'.
  GS_FCAT-COLTEXT = '계획 수량'.
  GS_FCAT-EDIT = 'X'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'PLAN_CONFIRM'.
  GS_FCAT-COLTEXT = '계획 실행 여부'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  CALL METHOD gc_grid->register_edit_event
    EXPORTING
      i_event_id = CL_GUI_ALV_GRID=>MC_EVT_ENTER "엔터 = MC_EVT_ENTER, MODIFYED는 엔터이외에도..
*    EXCEPTIONS
*      error      = 1
*      others     = 2
          .

  CALL METHOD gc_grid->set_table_for_first_display
*    EXPORTING
*      is_layout                     = GS_LAYOUT
    CHANGING
      it_outtab                     = GT_WORKPL
      it_fieldcatalog               = GT_FCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_WORKPL
    FROM ZTJ_WORKPLAN.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh .
  DATA : LS_STABLE TYPE LVC_S_STBL.
  LS_STABLE-ROW = 'X'.
  LS_STABLE-COL = 'X'.

  CALL METHOD GC_GRID->refresh_table_display
      EXPORTING
        is_stable      = LS_STABLE
*        i_soft_refresh = 'X'
      EXCEPTIONS
        finished       = 1
        others         = 2
            .
    IF sy-subrc  <> 0.
*     Implement suitable error handling here
    ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PLAN_CODE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> RANGE_NR
*&      --> OBJECT
*&---------------------------------------------------------------------*
FORM get_plan_code.

  CALL FUNCTION 'NUMBER_GET_NEXT'
  EXPORTING
    nr_range_nr                   = '01'
    object                        = 'ZTJ_02'
*   QUANTITY                      = '1'
*   SUBOBJECT                     = ' '
*   TOYEAR                        = '0000'
*   IGNORE_BUFFER                 = ' '
 IMPORTING
   NUMBER                        = GV_SNRO
*   QUANTITY                      =
*   RETURNCODE                    =
* EXCEPTIONS
*   INTERVAL_NOT_FOUND            = 1
*   NUMBER_RANGE_NOT_INTERN       = 2
*   OBJECT_NOT_FOUND              = 3
*   QUANTITY_IS_0                 = 4
*   QUANTITY_IS_NOT_1             = 5
*   INTERVAL_OVERFLOW             = 6
*   BUFFER_OVERFLOW               = 7
*   OTHERS                        = 8
          .
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.

  CONCATENATE 'WP' GV_SNRO INTO GV_WP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  CHECK  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check INPUT.

  IF P_MCODE2 IS NOT INITIAL.
    MESSAGE 'HAHA' TYPE 'S'.
  ENDIF.

ENDMODULE.
