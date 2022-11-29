*&---------------------------------------------------------------------*
*& Include          ZDKTJ_SQL_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'STATUS100'.
 SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_screen OUTPUT.
  DATA : GT_ZTJ_WORKPL LIKE TABLE OF ZTJ_WORKPLAN WITH HEADER LINE.

  CREATE OBJECT gc_docking
    EXPORTING
*      parent                      =
      repid                       = SY-REPID
      dynnr                       = SY-DYNNR
      side                        = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_BOTTOM
      extension                   = 400
*      style                       =
*      lifetime                    = lifetime_default
*      caption                     =
*      metric                      = 0
*      ratio                       =
*      no_autodef_progid_dynnr     =
*      name                        =
.
  CREATE OBJECT gc_grid
    EXPORTING
*      i_shellstyle      = 0
*      i_lifetime        =
      i_parent          = GC_DOCKING

      .
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  GS_FCAT-FIELDNAME = 'COMPONENT'.
  GS_FCAT-COLTEXT = '모품목명'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'DESCRIPTION'.
  GS_FCAT-COLTEXT = '공정 설명'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'PLAN_DATE'.
  GS_FCAT-COLTEXT = '계획 날짜'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'PLAN_QT'.
  GS_FCAT-COLTEXT = '계획 수량'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  GS_FCAT-FIELDNAME = 'PLAN_CONFIRM'.
  GS_FCAT-COLTEXT = '계획 실행 여부'.
  APPEND GS_FCAT TO GT_FCAT.
  CLEAR GS_FCAT.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_ZTJ_WORKPL
    FROM ZTJ_WORKPLAN.

  CALL METHOD gc_grid->set_table_for_first_display
    CHANGING
      it_outtab                     = GT_ZTJ_WORKPL[]
      it_fieldcatalog               = GT_FCAT.

  CLEAR : GT_ZTJ_WORKPL, GT_ZTJ_WORKPL[], GT_FCAT.

ENDMODULE.
