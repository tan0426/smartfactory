*&---------------------------------------------------------------------*
*& Include          ZDKTJ_WORKPLAN_ALV_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA : BEGIN OF GS_DATA,
          PLAN_CODE TYPE ZTJ_WORKPLAN-PLAN_CODE,
          MITEMCODE TYPE ZTJ_WORKPLAN-MITEMCODE,
          COMPONENT TYPE ZTJ_WORKPLAN-COMPONENT,
          ICNAME TYPE ZTJ_WORKPLAN-ICNAME,
         END OF GS_DATA,
         GT_DATA LIKE TABLE OF GS_DATA.
  DATA : GV_SNRO(3), GV_WP(5).
  DATA : GT_ZTJ_WORKPLAN LIKE TABLE OF ZTJ_WORKPLAN WITH HEADER LINE.
  DATA : LV_ANSWER.
  DATA : GT_ALV_LINE LIKE TABLE OF GS_WORKPL WITH HEADER LINE.

  PERFORM ALV_CURRENT_LINE. "ALV 선택 라인 가져오는 PERFROM.

  CLEAR : GT_ALV_LINE[].
  LOOP AT GT_INDEX INTO GS_INDEX.
    READ TABLE GT_WORKPL INTO GT_ALV_LINE INDEX GS_INDEX-INDEX.
    IF SY-SUBRC = 0.
      "CONFIRM 체크
      GT_ALV_LINE-PLAN_CONFIRM = 'X'.
      APPEND GT_ALV_LINE.
      CLEAR GT_ALV_LINE.
    ENDIF.
  ENDLOOP.

  CASE OK_CODE.
    WHEN 'DISP'.
        PERFORM GET_DATA.
    WHEN 'ADD'.
      DATA : LT_VALUE LIKE DYNPREAD OCCURS 0 WITH HEADER LINE.

      LT_VALUE-FIELDNAME = 'P_MCODE'.
      APPEND LT_VALUE.
      CLEAR LT_VALUE.

      CALL FUNCTION 'DYNP_VALUES_READ'
        EXPORTING
          dyname                               = SY-REPID
          dynumb                               = SY-DYNNR
*         TRANSLATE_TO_UPPER                   = ' '
*         REQUEST                              = ' '
*         PERFORM_CONVERSION_EXITS             = ' '
*         PERFORM_INPUT_CONVERSION             = ' '
*         DETERMINE_LOOP_INDEX                 = ' '
*         START_SEARCH_IN_CURRENT_SCREEN       = ' '
*         START_SEARCH_IN_MAIN_SCREEN          = ' '
*         START_SEARCH_IN_STACKED_SCREEN       = ' '
*         START_SEARCH_ON_SCR_STACKPOS         = ' '
*         SEARCH_OWN_SUBSCREENS_FIRST          = ' '
*         SEARCHPATH_OF_SUBSCREEN_AREAS        = ' '
        TABLES
          dynpfields                           = LT_VALUE[]
       EXCEPTIONS
         INVALID_ABAPWORKAREA                 = 1
         INVALID_DYNPROFIELD                  = 2
         INVALID_DYNPRONAME                   = 3
         INVALID_DYNPRONUMMER                 = 4
         INVALID_REQUEST                      = 5
         NO_FIELDDESCRIPTION                  = 6
         INVALID_PARAMETER                    = 7
         UNDEFIND_ERROR                       = 8
         DOUBLE_CONVERSION                    = 9
         STEPL_NOT_FOUND                      = 10
         OTHERS                               = 11
                .
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      IF P_MCODE IS NOT INITIAL.
        CLEAR GS_DATA.
        SELECT SINGLE BOMROUT~MITEMCODE ITEM~COMPONENT ITEMC~ICNAME
          INTO CORRESPONDING FIELDS OF GS_DATA
          FROM ZTJ_BOMROUTING AS BOMROUT
          JOIN ZTJ_ITEM AS ITEM
          ON BOMROUT~MITEMCODE = ITEM~ITEM_CODE
          JOIN ZTJ_ITEMC AS ITEMC
          ON ITEM~ITEM_GROUP = ITEMC~ICODE
          WHERE BOMROUT~MITEMCODE = P_MCODE.

        IF SY-SUBRC = 0.
          MOVE-CORRESPONDING GS_DATA TO GS_WORKPL.
          APPEND GS_WORKPL TO GT_WORKPL.
          IF SY-SUBRC = 0.
            MESSAGE '행 추가 됨' TYPE 'S'.
          ENDIF.
        ELSE.
          MESSAGE 'BOMROUTING이 없는 모품목' TYPE 'S' DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE '모품목을 입력하시오' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
    WHEN 'REFR'.
      PERFORM ALV_REFRESH.
    WHEN 'CONF'.
      CLEAR : GT_ZTJ_WORKPLAN,  GT_ZTJ_WORKPLAN[].
      SELECT *
        FROM ZTJ_WORKPLAN
        INTO CORRESPONDING FIELDS OF TABLE GT_ZTJ_WORKPLAN.

      CLEAR : GT_BOM, GT_BOM[].
      SELECT *
        FROM ZTJ_BOM
        INTO CORRESPONDING FIELDS OF TABLE GT_BOM.

      CLEAR : GT_TOTSTOCK, GT_TOTSTOCK[].
      SELECT *
        FROM ZTJ_TOTSTOCK
        INTO CORRESPONDING FIELDS OF TABLE GT_TOTSTOCK.

      LOOP AT GT_ALV_LINE.
        READ TABLE GT_ZTJ_WORKPLAN INTO GT_ZTJ_WORKPLAN WITH KEY PLAN_CODE = GT_ALV_LINE-PLAN_CODE.

        IF SY-SUBRC = 0.
          IF GT_ALV_LINE-PLAN_CONFIRM IS NOT INITIAL.
            GT_ZTJ_WORKPLAN-PLAN_CONFIRM = 'X'.
            APPEND GT_ZTJ_WORKPLAN.
            CLEAR GT_ZTJ_WORKPLAN.
            IF GT_ZTJ_WORKPLAN[] IS NOT INITIAL.
              MODIFY ZTJ_WORKPLAN FROM TABLE GT_ZTJ_WORKPLAN.
              COMMIT WORK.

              IF SY-SUBRC = 0.
                MESSAGE 'SUCCESS CONFIRM' TYPE 'S'.

                PERFORM AFTER_CONFIRM_STOCK.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

      ENDLOOP.
      PERFORM ALV_REFRESH.
    WHEN 'SAVE'.
      IF GT_WORKPL IS NOT INITIAL.
        LOOP AT GT_WORKPL INTO GS_WORKPL.
          "계획 코드가 있는 계획은 변경, 아니면 입력
          SELECT SINGLE *
            FROM ZTJ_WORKPLAN
            INTO CORRESPONDING FIELDS OF GT_ZTJ_WORKPLAN
            WHERE PLAN_CODE = GS_WORKPL-PLAN_CODE.
          IF SY-SUBRC = 0.
*            CLEAR GT_ZTJ_WORKPLAN.
            SELECT SINGLE *
              FROM ZTJ_WORKPLAN
              INTO CORRESPONDING FIELDS OF GT_ZTJ_WORKPLAN
              WHERE PLAN_DATE = GS_WORKPL-PLAN_DATE
              AND PLAN_QT = GS_WORKPL-PLAN_QT.
            IF SY-SUBRC = 0.
            ELSE.
              MOVE-CORRESPONDING GS_WORKPL TO GT_ZTJ_WORKPLAN.

              "변경 로그
              GT_ZTJ_WORKPLAN-AEDAT = SY-DATUM.
              GT_ZTJ_WORKPLAN-AEZET = SY-UZEIT.
              GT_ZTJ_WORKPLAN-AENAM = SY-UNAME.
              APPEND GT_ZTJ_WORKPLAN.

              "변경 되면 인터널 테이블에서 DB테이블로 입력
              IF GT_ZTJ_WORKPLAN[] IS NOT INITIAL.
                MODIFY ZTJ_WORKPLAN FROM GT_ZTJ_WORKPLAN.
                COMMIT WORK.
                IF SY-SUBRC = 0.
                  MESSAGE '변경 성공' TYPE 'S'.
                ENDIF.
                CLEAR : GT_ZTJ_WORKPLAN, GT_ZTJ_WORKPLAN[].
              ENDIF.
            ENDIF.
          ELSE.
            IF GS_WORKPL-PLAN_DATE IS NOT INITIAL
            AND GS_WORKPL-PLAN_QT IS NOT INITIAL.
              CLEAR GT_ZTJ_WORKPLAN.
              PERFORM GET_PLAN_CODE.
              GS_WORKPL-PLAN_CODE = GV_WP.
              MOVE-CORRESPONDING GS_WORKPL TO GT_ZTJ_WORKPLAN.

              "생성로그
              GT_ZTJ_WORKPLAN-ERDAT = SY-DATUM.
              GT_ZTJ_WORKPLAN-ERZET = SY-UZEIT.
              GT_ZTJ_WORKPLAN-ERNAM = SY-UNAME.
              APPEND GT_ZTJ_WORKPLAN.

              IF GT_ZTJ_WORKPLAN[] IS NOT INITIAL.
                MODIFY ZTJ_WORKPLAN FROM GT_ZTJ_WORKPLAN.
                COMMIT WORK.

                IF SY-SUBRC = 0.
                  MESSAGE '생성 완료' TYPE 'S'.
*                   LEAVE LIST-PROCESSING.
                ENDIF.

              ELSE.
                MESSAGE '계획 날짜, 계획 수량이 입력되지 않음' TYPE 'S' DISPLAY LIKE 'E'.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ELSE.
        MESSAGE '값이 없음' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
      PERFORM ALV_REFRESH.
    WHEN 'DELE'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
         TITLEBAR                    = '삭제 경고'
*         DIAGNOSE_OBJECT             = ' '
          text_question               = '정말 삭제 하겠습니까?'
*         TEXT_BUTTON_1               = 'Ja'(001)
*         ICON_BUTTON_1               = ' '
*         TEXT_BUTTON_2               = 'Nein'(002)
*         ICON_BUTTON_2               = ' '
*         DEFAULT_BUTTON              = '1'
*         DISPLAY_CANCEL_BUTTON       = 'X'
*         USERDEFINED_F1_HELP         = ' '
*         START_COLUMN                = 25
*         START_ROW                   = 6
*         POPUP_TYPE                  =
*         IV_QUICKINFO_BUTTON_1       = ' '
*         IV_QUICKINFO_BUTTON_2       = ' '
       IMPORTING
         ANSWER                      = LV_ANSWER
*       TABLES
*         PARAMETER                   =
*       EXCEPTIONS
*         TEXT_NOT_FOUND              = 1
*         OTHERS                      = 2
                .
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      IF LV_ANSWER = '1'.
        LOOP AT GT_ALV_LINE.
*          IF GT_ALV_LINE-PLAN_CONFIRM = 'X'.
*            MESSAGE 'CONFIRM 되어 있어서 삭제 불가' TYPE 'S' DISPLAY LIKE 'E'.
*            EXIT.
*          ELSE.
            "삭제 처리
            DELETE FROM ZTJ_WORKPLAN WHERE PLAN_CODE = GT_ALV_LINE-PLAN_CODE.
            COMMIT WORK. "COMMIT WORK AND WAIT도 가능한듯.
            IF SY-SUBRC = 0.
              MESSAGE '삭제 완료' TYPE 'S'.
            ENDIF.
*          ENDIF.

        ENDLOOP.
      ENDIF.
      PERFORM ALV_REFRESH.
  ENDCASE.
  CLEAR OK_CODE.
ENDMODULE.
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
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_MITEMCODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_mitemcode INPUT.
  "서치 헬프 가져올 테이블 지정
  DATA : BEGIN OF LS_HELP,
          MITEMCODE TYPE ZTJ_ITEM-ITEM_CODE,
          COMPONENT TYPE ZTJ_ITEM-COMPONENT,
         END OF LS_HELP,
         LT_HELP LIKE TABLE OF LS_HELP.
  DATA : LS_RETURN LIKE DDSHRETVAL,
         LT_RETURN LIKE TABLE OF DDSHRETVAL.

  SELECT ITEM_CODE AS MITEMCODE, COMPONENT
    INTO CORRESPONDING FIELDS OF TABLE @LT_HELP
    FROM ZTJ_ITEM.

  SORT LT_HELP.

  "SEARCH HELP FUNCTION
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield               = 'MITEMCODE'
*     PVALKEY                = ' '
*     DYNPPROG               = ' '
*     DYNPNR                 = ' '
*     DYNPROFIELD            = ' '
*     STEPL                  = 0
     WINDOW_TITLE           = '모품목 코드'
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
*     FIELD_TAB              = LT_FIELD
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
      P_MCODE = LS_RETURN-FIELDVAL.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_PLAN_DATA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_plan_data INPUT.
  DATA : LV_RETURN_DATE LIKE WORKFLDS-GKDAY.

  CALL FUNCTION 'F4_DATE'
   EXPORTING
     DATE_FOR_FIRST_MONTH               = SY-DATUM
     DISPLAY                            = ' '
*     FACTORY_CALENDAR_ID                = ' '
*     GREGORIAN_CALENDAR_FLAG            = ' '
*     HOLIDAY_CALENDAR_ID                = ' '
*     PROGNAME_FOR_FIRST_MONTH           = ' '
*     DATE_POSITION                      = ' '
   IMPORTING
     SELECT_DATE                        = LV_RETURN_DATE
*     SELECT_WEEK                        =
*     SELECT_WEEK_BEGIN                  =
*     SELECT_WEEK_END                    =
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  "서치헬프 창에서 선택하면 값을 가져옴
  IF LV_RETURN_DATE IS NOT INITIAL.
    GS_WORKPL-PLAN_DATE = LV_RETURN_DATE.
  ENDIF.
ENDMODULE.
