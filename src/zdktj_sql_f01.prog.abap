*&---------------------------------------------------------------------*
*& Include          ZDKTJ_SQL_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SQL_RUN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM sql_run .
DATA : GT_DATA LIKE TABLE OF ZTJ_BOM WITH HEADER LINE.
DATA : GT_DATA2 LIKE TABLE OF ZTJ_BOMROUTING WITH HEADER LINE.
DATA : GT_DATA3 LIKE TABLE OF ZTJ_WORKPLAN WITH HEADER LINE.

DATA : LV_MSG TYPE STRING.
DATA : LX_EXEC TYPE REF TO CX_ROOT.

SELECT PLANTCODE MITEMCODE ITEMCODE COMPONENT UOM QUANTITY
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA
  FROM ZTJ_BOM.

SELECT MITEMCODE STEP_NO OP_NO ASS_CODE ITEMCODE RES_ID NEXTSTEP DESCRIPTION UOM INPUT_QT JSONCODE
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA2
  FROM ZTJ_BOMROUTING.

SELECT MITEMCODE PLAN_DATE COMPONENT ICNAME PLAN_QT PLAN_CONFIRM
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA3
  FROM ZTJ_WORKPLAN.

EXEC SQL.
  CONNECT TO 'MSSQL1'
ENDEXEC.
IF SY-SUBRC <> 0.
  MESSAGE 'CONNECT FAIL' TYPE 'S' DISPLAY LIKE 'E'.
  EXIT.
ENDIF.

TRY .

EXEC SQL.
  DELETE FROM sapout.BOM_T
  DELETE FROM sapout.BOMROUTING_T
  DELETE FROM sapout.WORKPLAN_T
ENDEXEC.

LOOP AT GT_DATA.
  EXEC SQL.
    INSERT INTO sapout.BOM_T (PLANTCODE, MITEMCODE, ITEMCODE, COMPONENT, UOM, QUANTITY)
           VALUES (:GT_DATA-PLANTCODE, :GT_DATA-MITEMCODE, :GT_DATA-ITEMCODE, :GT_DATA-COMPONENT, :GT_DATA-UOM, :GT_DATA-QUANTITY)
  ENDEXEC.
ENDLOOP.

LOOP AT GT_DATA2.
  EXEC SQL.

    INSERT INTO sapout.BOMROUTING_T (MITEMCODE, STEP_NO, OP_NO, ASS_CODE, ITEMCODE, RES_ID, NEXTSTEP, DESCRIPTION, UOM, INPUT_QT, JSONCODE)
           VALUES (:GT_DATA2-MITEMCODE, :GT_DATA2-STEP_NO, :GT_DATA2-OP_NO, :GT_DATA2-ASS_CODE, :GT_DATA2-ITEMCODE, :GT_DATA2-RES_ID, :GT_DATA2-NEXTSTEP, :GT_DATA2-DESCRIPTION, :GT_DATA2-UOM, :GT_DATA2-INPUT_QT, :GT_DATA2-JSONCODE)

  ENDEXEC.
ENDLOOP.

LOOP AT GT_DATA3.
  EXEC SQL.

    INSERT INTO sapout.WORKPLAN_T (MITEMCODE, PLAN_DATE, COMPONENT, ICNAME, PLAN_QT, PLAN_CONFIRM)
           VALUES (:GT_DATA3-MITEMCODE, :GT_DATA3-PLAN_DATE, :GT_DATA3-COMPONENT, :GT_DATA3-ICNAME, :GT_DATA3-PLAN_QT, :GT_DATA3-PLAN_CONFIRM)
  ENDEXEC.
ENDLOOP.

CATCH CX_SY_NATIVE_SQL_ERROR INTO LX_EXEC.
  LV_MSG = LX_EXEC->GET_TEXT(  ).
  MESSAGE LV_MSG TYPE 'S' DISPLAY LIKE 'E'.
ENDTRY.

IF LV_MSG IS INITIAL.
  EXEC SQL.
    COMMIT
  ENDEXEC.
ELSE.
  EXEC SQL.
    ROLLBACK
  ENDEXEC.
ENDIF.

EXEC SQL.
  DISCONNECT 'MSSQL1'
ENDEXEC.
IF SY-SUBRC <> 0.
  MESSAGE 'CONNECT FAIL' TYPE 'S' DISPLAY LIKE 'E'.
  EXIT.
ENDIF.
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
  DATA : GT_ZTJ_WORKPL LIKE TABLE OF ZTJ_WORKPLAN WITH HEADER LINE.

    CREATE OBJECT gc_docking
      EXPORTING
*        parent                      =
        repid                       = SY-REPID
        dynnr                       = SY-DYNNR
        side                        = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_BOTTOM
        extension                   = 400
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

  CALL METHOD gc_grid->refresh_table_display
      EXPORTING
        is_stable      = LS_STABLE
*        i_soft_refresh =
*      EXCEPTIONS
*        finished       = 1
*        others         = 2
            .
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.
ENDFORM.
