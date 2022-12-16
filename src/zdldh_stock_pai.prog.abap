*&---------------------------------------------------------------------*
*& Include          ZDLDH_STOCK_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  SAVE_OK = OK_CODE.    " PBO 까지 OK_CODE 가져가야하는 경우 SAVE_OK 사용 "
  GET TIME STAMP FIELD LV_RTIME.
  DATA : LV_DATA LIKE GT_STOCK.
  DATA : GV_RTIME LIKE ZTJ_STOCK-RTIME.

  DATA : BEGIN OF LS_TOT,
          MANDT LIKE ZTJ_TOTSTOCK-MANDT,
          WAREID LIKE ZTJ_TOTSTOCK-WAREID,
          ITEM_CODE LIKE ZTJ_TOTSTOCK-ITEM_CODE,
          COMPONENT LIKE ZTJ_TOTSTOCK-COMPONENT,
          TOTALQT LIKE ZTJ_TOTSTOCK-TOTALQT,
         END OF LS_TOT.
  DATA : LT_TOT LIKE TABLE OF LS_TOT.


  CASE SAVE_OK.
" 입고 버튼 클릭 "
    WHEN 'PUSH1'.
      IF LS_STOCK-ITEM_CODE IS NOT INITIAL AND LV_INPUT IS NOT INITIAL.
        SELECT SINGLE MAX( RTIME ) FROM ZTJ_STOCK INTO GV_RTIME WHERE ITEM_CODE = LS_STOCK-ITEM_CODE.
          IF SY-SUBRC = 0.

            SELECT SINGLE ST~ITEM_CODE, IT~COMPONENT, ST~RTIME, ST~INQT, ST~OUTQT, ST~TOTALQT
              FROM ZTJ_ITEM AS IT JOIN ZTJ_STOCK AS ST
                ON ST~ITEM_CODE = IT~ITEM_CODE AND ST~COMPONENT = IT~COMPONENT
              INTO CORRESPONDING FIELDS OF @GS_STOCK
              WHERE ST~RTIME = @GV_RTIME
                AND IT~ITEM_CODE = @LS_STOCK-ITEM_CODE
                AND ST~ITEM_CODE = IT~ITEM_CODE.

              CLEAR : LS_STOCK-OUTQT, GS_STOCK-OUTQT.
            MOVE GS_STOCK TO LS_STOCK.
            LS_STOCK-INQT = LV_INPUT.
            LS_STOCK-TOTALQT = LS_STOCK-TOTALQT + LS_STOCK-INQT.
            LS_STOCK-RTIME = LV_RTIME.
            MOVE LS_STOCK TO GS_STOCK.
            APPEND GS_STOCK TO GT_STOCK.
            MESSAGE ' 입고 성공! ' TYPE 'S'.
          ELSE.
            SELECT SINGLE * FROM ZTJ_STOCK INTO CORRESPONDING FIELDS OF GS_STOCK
              WHERE ITEM_CODE = LS_STOCK-ITEM_CODE.
            MOVE GS_STOCK TO LS_STOCK.
            LS_STOCK-INQT = LV_INPUT.
            LS_STOCK-TOTALQT = LS_STOCK-TOTALQT + LS_STOCK-INQT.
            LS_STOCK-RTIME = LV_RTIME.
            MOVE LS_STOCK TO GS_STOCK.
            APPEND GS_STOCK TO GT_STOCK.
            MESSAGE ' 입고 성공! ' TYPE 'S'.
          ENDIF.
      ENDIF.
      CLEAR : LV_INPUT, GV_RTIME.

" 출고 버튼 클릭 "
    WHEN 'PUSH2'.
      IF LS_STOCK-ITEM_CODE IS NOT INITIAL AND LV_INPUT IS NOT INITIAL.
        SELECT MAX( RTIME ) FROM ZTJ_STOCK INTO GV_RTIME WHERE ITEM_CODE = LS_STOCK-ITEM_CODE.
          IF SY-SUBRC = 0.
            SELECT SINGLE * FROM ZTJ_STOCK INTO GS_STOCK WHERE ITEM_CODE = LS_STOCK-ITEM_CODE AND RTIME = GV_RTIME.
              IF GS_STOCK-TOTALQT > LV_INPUT.
                IF SY-SUBRC = 0.
                  SELECT SINGLE * FROM ZTJ_STOCK INTO GS_STOCK WHERE ITEM_CODE = LS_STOCK-ITEM_CODE AND RTIME = GV_RTIME.
                    CLEAR : GS_STOCK-INQT, LS_STOCK-INQT.
                    MOVE GS_STOCK TO LS_STOCK.
                    LS_STOCK-OUTQT = LV_INPUT.
                    LS_STOCK-TOTALQT = GS_STOCK-TOTALQT - LS_STOCK-OUTQT.
                    LS_STOCK-RTIME = LV_RTIME.
                    MOVE LS_STOCK TO GS_STOCK.
                    APPEND GS_STOCK TO GT_STOCK.
                    MESSAGE ' 출고 성공 ! ' TYPE 'S'.
                ENDIF.
              ENDIF.
            ELSE.
              MESSAGE ' 재고가 출고량 보다 적습니다.' TYPE 'S' DISPLAY LIKE 'E'.
            ENDIF.
            ELSE.
              MESSAGE ' 입고가 필요합니다.' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
      CLEAR : LV_INPUT, GV_RTIME.
*--------------------------------------------------------------------------------------------------------------*
    WHEN 'DISP'.
      IF LS_STOCK-ITEM_CODE IS NOT INITIAL.
        SELECT * INTO CORRESPONDING FIELDS OF TABLE GT_STOCK FROM ZTJ_STOCK WHERE ITEM_CODE = LS_STOCK-ITEM_CODE.
      ELSE.
        SELECT * INTO CORRESPONDING FIELDS OF TABLE GT_STOCK FROM ZTJ_STOCK.
      ENDIF.
        MESSAGE ' 조회 완료 ! ' TYPE 'S'.


    WHEN 'SAVE'.            " 저장시 TOTALSTOCK 테이블에 TOTALQT 값 변경 미완성 "
      MODIFY ZTJ_STOCK FROM TABLE GT_STOCK.
      " TOTAL STOCK 테이블의 TOTALQT 값 변경 로직 "
      SELECT MAX( RTIME ) FROM ZTJ_STOCK INTO GV_RTIME WHERE ITEM_CODE = LS_STOCK-ITEM_CODE.
      SELECT ITEM_CODE COMPONENT TOTALQT FROM ZTJ_STOCK INTO CORRESPONDING FIELDS OF TABLE LT_TOT
        WHERE ITEM_CODE = LS_STOCK-ITEM_CODE AND RTIME = GV_RTIME.                                " 가장 마지막에 넣은 데이터 LT_TOT에 할당 "
        LOOP AT LT_TOT INTO LS_TOT.
          SELECT * FROM ZTJ_TOTSTOCK INTO CORRESPONDING FIELDS OF TABLE GT_TOT WHERE ITEM_CODE = LS_TOT-ITEM_CODE.
            MOVE LS_TOT TO GS_TOT.
        ENDLOOP.
        APPEND GS_TOT TO GT_TOT.
        MODIFY ZTJ_TOTSTOCK FROM TABLE GT_TOT .
        COMMIT WORK.


      MESSAGE ' 재고 이력 테이블에 저장 완료 ! ' TYPE 'S'.


    WHEN 'REFR'.
      SELECT * INTO CORRESPONDING FIELDS OF TABLE GT_STOCK FROM ZTJ_STOCK.
        SORT GT_STOCK BY ITEM_CODE ASCENDING RTIME ASCENDING.
      CLEAR : LS_STOCK, LV_INPUT, GS_STOCK.

  ENDCASE.
  CLEAR OK_CODE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  MOVE_SCREEN_TO_ABAP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE move_screen_to_abap INPUT.
  MODIFY GT_STOCK FROM GS_STOCK INDEX TC100-CURRENT_LINE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  F4_DATA_ITEM_CODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_data_item_code INPUT.
  DATA : BEGIN OF LS_HELP,
          ITEM_CODE TYPE ZTJ_ITEM-ITEM_CODE,
          COMPONENT TYPE ZTJ_ITEM-COMPONENT,
         END OF LS_HELP,
         LT_HELP LIKE TABLE OF LS_HELP.

   DATA : LS_RETURN LIKE DDSHRETVAL,
          LT_RETURN LIKE TABLE OF DDSHRETVAL.

   SELECT ITEM_CODE, COMPONENT INTO CORRESPONDING FIELDS OF TABLE @LT_HELP FROM ZTJ_ITEM.
     SORT LT_HELP.

      "SEARCH HELP FUNCTION
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield               = 'ITEM_CODE'
*     PVALKEY                = ' '
*     DYNPPROG               = ' '
*     DYNPNR                 = ' '
*     DYNPROFIELD            = ' '
*     STEPL                  = 0
*     WINDOW_TITLE           =
*     VALUE                  = ' '
     VALUE_ORG              = 'S'
*     MULTIPLE_CHOICE        = ' '
*     DISPLAY                = ' '
*     CALLBACK_PROGRAM       = ' '
*     CALLBACK_FORM          = ' '
*     CALLBACK_METHOD        =
*     MARK_TAB               =
*   IMPORTING
*     USER_RESET             =
    tables
      value_tab              = LT_HELP
*     FIELD_TAB              =
     RETURN_TAB             = LT_RETURN
*     DYNPFLD_MAPPING        =
   EXCEPTIONS
     PARAMETER_ERROR        = 1
     NO_VALUES_FOUND        = 2
     OTHERS                 = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  "서치헬프 창에서 선택하면 값을 가져옴
  IF LT_RETURN IS NOT INITIAL.
    LOOP AT LT_RETURN INTO LS_RETURN.
      LS_STOCK-ITEM_CODE = LS_RETURN-FIELDVAL.
    ENDLOOP.
  ENDIF.
  CLEAR : LS_HELP, LS_RETURN.

ENDMODULE.

*&---------------------------------------------------------------------*
*& Include          ZDLDH_STOCK_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command INPUT.
  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
  CLEAR OK_CODE.
ENDMODULE.
