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

  GS_LAYOUT-STYLEFNAME = 'STYLE'.
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
    EXPORTING
      is_layout                     = GS_LAYOUT
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
  IF P_MCODE IS INITIAL.
    CLEAR : GT_WORKPL.
    SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_WORKPL
    FROM ZTJ_WORKPLAN.
  ELSE.
    SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_WORKPL
    FROM ZTJ_WORKPLAN
    WHERE MITEMCODE = P_MCODE.
  ENDIF.

  LOOP AT GT_WORKPL INTO GS_WORKPL.
    IF GS_WORKPL-PLAN_CONFIRM = 'X'.
      GS_STYLE-FIELDNAME = 'PLAN_DATE'.
      GS_STYLE-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.
      APPEND GS_STYLE TO GS_WORKPL-STYLE.
      CLEAR GS_STYLE.

      GS_STYLE-FIELDNAME = 'PLAN_QT'.
      GS_STYLE-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.
      APPEND GS_STYLE TO GS_WORKPL-STYLE.
      CLEAR GS_STYLE.
    ENDIF.
    MODIFY GT_WORKPL FROM GS_WORKPL.
    CLEAR GS_WORKPL.
  ENDLOOP.

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
*&---------------------------------------------------------------------*
*& Form ALV_CURRENT_LINE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM alv_current_line .
  CALL METHOD gc_grid->get_selected_rows
    IMPORTING
      et_index_rows = GT_INDEX
*      et_row_no     =
      .

  DESCRIBE TABLE GT_INDEX LINES GD_LINES. "한 라인만 선택하기 위해서 몇 라인을 선택했는지 저장
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ALV_REFRESH
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM alv_refresh .
  CLEAR : GT_WORKPL.
  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE GT_WORKPL
  FROM ZTJ_WORKPLAN.

  LOOP AT GT_WORKPL INTO GS_WORKPL.
    IF GS_WORKPL-PLAN_CONFIRM = 'X'.
      GS_STYLE-FIELDNAME = 'PLAN_DATE'.
      GS_STYLE-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.
      APPEND GS_STYLE TO GS_WORKPL-STYLE.
      CLEAR GS_STYLE.

      GS_STYLE-FIELDNAME = 'PLAN_QT'.
      GS_STYLE-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.
      APPEND GS_STYLE TO GS_WORKPL-STYLE.
      CLEAR GS_STYLE.
    ENDIF.
    MODIFY GT_WORKPL FROM GS_WORKPL.
    CLEAR GS_WORKPL.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form AFTER_CONFIRM_STOCK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM after_confirm_stock.
  DATA : GT_BOM2 LIKE TABLE OF GT_BOM WITH HEADER LINE,
         GT_BOM3 LIKE TABLE OF GT_BOM2 WITH HEADER LINE,
         GT_BOM4 LIKE TABLE OF GT_BOM3 WITH HEADER LINE.

  DATA : GV_QT_M TYPE ZTJ_TOTSTOCK-TOTALQT.
  DATA : GV_QT_P TYPE ZTJ_TOTSTOCK-TOTALQT.

  "해당 CONFIRM된 라인의 모품목 코드를 이용해서
  "BOM을 불러온다 GT_BOM : ZTJ_BOM데이터를 그대로 가져옴
  CLEAR : GT_BOM2, GT_BOM2[].
  SELECT *
    FROM ZTJ_BOM
    INTO CORRESPONDING FIELDS OF TABLE GT_BOM2
    WHERE MITEMCODE = GT_ALV_LINE-MITEMCODE.
*  READ TABLE GT_BOM INTO GT_BOM2 WITH KEY MITEMCODE = GT_ALV_LINE-MITEMCODE.
  "GT_BOM2 : 완제품의 하위 재료 리스트
    IF SY-SUBRC = 0.
      "완제품 재고를 추가한다.
      "계획 수량을 담는다.
      CLEAR GV_QT_P.
      GV_QT_P = GT_ALV_LINE-PLAN_QT.
      "GT_TOTSTOCK DB에서 계획된 모품목의 토탈 수량을 가져온다.
      CLEAR : GT_TOTSTOCK2, GT_TOTSTOCK2[].
      READ TABLE GT_TOTSTOCK INTO GT_TOTSTOCK2 WITH KEY ITEM_CODE = GT_ALV_LINE-MITEMCODE.
      "가져온 토탈수량과 계획수량을 더한다. 그 값으로 업데이트 한다.
      GT_TOTSTOCK2-TOTALQT = GT_ALV_LINE-PLAN_QT + GT_TOTSTOCK2-TOTALQT.
      MODIFY ZTJ_TOTSTOCK FROM GT_TOTSTOCK2.
      CLEAR : GT_TOTSTOCK2, GT_TOTSTOCK2[].

      "반제품과 원재료 목록을 한 줄 씩 읽는다.
      LOOP AT GT_BOM2.
        "해당 ITEMCODE가 ZTJ_BOM에 모품목 코드가 있는 제품인지 아닌지 확인한다.

        CLEAR : GT_BOM3, GT_BOM3[].
        SELECT *
          FROM ZTJ_BOM
          INTO CORRESPONDING FIELDS OF TABLE GT_BOM3
          WHERE MITEMCODE = GT_BOM2-ITEMCODE.
*        READ TABLE GT_BOM INTO GT_BOM3 WITH KEY MITEMCODE = GT_BOM2-ITEMCODE.
        "GT_BOM3 : 반제품의 하위 원재료 리스트

        IF SY-SUBRC = 0. "모품목 코드가 있는 제품이면 반제품
          "반제품도 재고에서 빼줘야 함
          CLEAR GV_QT_M.
          GV_QT_M = GT_BOM2-QUANTITY * GT_ALV_LINE-PLAN_QT.

          CLEAR : GT_TOTSTOCK2, GT_TOTSTOCK2[].
          READ TABLE GT_TOTSTOCK INTO GT_TOTSTOCK2 WITH KEY ITEM_CODE = GT_BOM2-ITEMCODE.
          "가져온 토탈 수량에서 계산된 원재료 수량을 빼준다. 그 값으로 업데이트 한다.
          IF GT_TOTSTOCK2-TOTALQT <= GV_QT_M.
            MESSAGE '재고가 없음' TYPE 'S' DISPLAY LIKE 'E'.
            EXIT.
          ELSE.
            GT_TOTSTOCK2-TOTALQT = GT_TOTSTOCK2-TOTALQT - GV_QT_M.
            MODIFY ZTJ_TOTSTOCK FROM GT_TOTSTOCK2.
            CLEAR : GT_TOTSTOCK2, GT_TOTSTOCK2[].
          ENDIF.

          LOOP AT GT_BOM3. "반제품의 하위 원재료 리스트를 한 줄 씩 읽는다.
            "바로 수량을 가져와 계획 수량과 곱해서 GV_QT_M에 담는다.
            "GV_QT_M은 토탈 수량에서 원재료 갯수를 빼줄 변수이다.
            CLEAR GV_QT_M.
            "사용될 원재료 수량을 계산한다.
            GV_QT_M = GT_BOM3-QUANTITY * GT_ALV_LINE-PLAN_QT.

            CLEAR : GT_TOTSTOCK2, GT_TOTSTOCK2[].
            READ TABLE GT_TOTSTOCK INTO GT_TOTSTOCK2 WITH KEY ITEM_CODE = GT_BOM3-ITEMCODE.
            "가져온 토탈 수량에서 계산된 원재료 수량을 빼준다. 그 값으로 업데이트 한다.
            IF GT_TOTSTOCK2-TOTALQT <= GV_QT_M.
              MESSAGE '재고가 없음' TYPE 'S' DISPLAY LIKE 'E'.
              EXIT.
            ELSE.
              GT_TOTSTOCK2-TOTALQT = GT_TOTSTOCK2-TOTALQT - GV_QT_M.
              MODIFY ZTJ_TOTSTOCK FROM GT_TOTSTOCK2.
              CLEAR : GT_TOTSTOCK2, GT_TOTSTOCK2[].
            ENDIF.

          ENDLOOP.
        ELSE. "모품목 코드가 없는 제품이면 원재료
          "바로 수량을 가져와 계획 수량과 곱해서 GV_QT_M에 담는다.
          "GV_QT_M은 토탈 수량에서 원재료 갯수를 빼줄 변수이다.
          CLEAR GV_QT_M.
          "사용될 원재료 수량을 계산한다.
          GV_QT_M = GT_BOM2-QUANTITY * GT_ALV_LINE-PLAN_QT.

          CLEAR : GT_TOTSTOCK2, GT_TOTSTOCK2[].
          READ TABLE GT_TOTSTOCK INTO GT_TOTSTOCK2 WITH KEY ITEM_CODE = GT_BOM2-ITEMCODE.
          "가져온 토탈 수량에서 계산된 원재료 수량을 빼준다. 그 값으로 업데이트 한다.
          IF GT_TOTSTOCK2-TOTALQT <= GV_QT_M.
            MESSAGE '재고가 없음' TYPE 'S' DISPLAY LIKE 'E'.
            EXIT.
          ELSE.
            GT_TOTSTOCK2-TOTALQT = GT_TOTSTOCK2-TOTALQT - GV_QT_M.
            MODIFY ZTJ_TOTSTOCK FROM GT_TOTSTOCK2.
            CLEAR : GT_TOTSTOCK2, GT_TOTSTOCK2[].
          ENDIF.

        ENDIF.
      ENDLOOP.
    ENDIF.
    CLEAR : GV_QT_P, GV_QT_M.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form AFTER_CONFIRM_STOCK2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM after_confirm_stock2 .
ENDFORM.
