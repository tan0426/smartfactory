*&---------------------------------------------------------------------*
*& Include          ZDKTJ_WORKPLAN_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA : BEGIN OF GS_DATA,
          COMPONENT TYPE ZTJ_WORKPLAN-COMPONENT,
          ICNAME TYPE ZTJ_WORKPLAN-ICNAME,
         END OF GS_DATA,
         GT_DATA LIKE TABLE OF GS_DATA.
  DATA : LS_MITEMCODE LIKE GS_WORKPL.
  DATA : GT_ZTJ_WORKPL LIKE TABLE OF ZTJ_WORKPLAN WITH HEADER LINE.
  DATA : LV_ANSWER.

  SAVE_OK = OK_CODE.
  CASE OK_CODE.
    WHEN 'PUSH'.
      IF GS_WORKPL-MITEMCODE IS NOT INITIAL.
        SELECT SINGLE ITEM~COMPONENT ITEMC~ICNAME
          INTO CORRESPONDING FIELDS OF GS_DATA
          FROM ZTJ_ITEM AS ITEM
          JOIN ZTJ_BOMROUTING AS ROUT
          ON ITEM~ITEM_CODE = ROUT~MITEMCODE
          JOIN ZTJ_ITEMC AS ITEMC
          ON ITEM~ITEM_GROUP = ITEMC~ICODE
          WHERE ITEM~ITEM_CODE = GS_WORKPL-MITEMCODE.

        IF SY-SUBRC = 0.
          MOVE-CORRESPONDING GS_DATA TO GS_WORKPL.
          APPEND GS_WORKPL TO GT_WORKPL.
          IF SY-SUBRC = 0.
            MESSAGE '추가 완료' TYPE 'S'.
            CLEAR GS_WORKPL.
          ENDIF.
        ELSE.
          MESSAGE 'BOM ROUTING이 없는 품목' TYPE 'S' DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE '모품목 코드가 입력되지 않음' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
    WHEN 'REFR'.
      CLEAR : GS_WORKPL, GT_WORKPL, LV_MITEMCODENM, GS_DATA, GT_DATA.
    WHEN 'DISP'.
      IF GS_WORKPL-MITEMCODE IS NOT INITIAL.
        CLEAR LS_MITEMCODE.
        SELECT SINGLE *
          INTO CORRESPONDING FIELDS OF LS_MITEMCODE
          FROM ZTJ_ITEM
          WHERE ITEM_CODE = GS_WORKPL-MITEMCODE.
        IF LS_MITEMCODE IS NOT INITIAL.
          SELECT *
            INTO CORRESPONDING FIELDS OF TABLE GT_WORKPL
            FROM ZTJ_WORKPLAN
            WHERE MITEMCODE = GS_WORKPL-MITEMCODE.
          IF SY-SUBRC = 0.
            MESSAGE '계획 출력 완료' TYPE 'S'.
          ELSE.
            MESSAGE '계획이 없는 라우팅' TYPE 'S' DISPLAY LIKE 'E'.
          ENDIF.
        ELSE.
          MESSAGE '품목 코드가 없거나 잘목 입력함' TYPE 'S' DISPLAY LIKE 'E'.
        ENDIF.
      ENDIF.
    WHEN 'CREA'.
      LOOP AT GT_WORKPL INTO GS_WORKPL.
        IF GS_WORKPL-COMPONENT IS NOT INITIAL
        AND GS_WORKPL-ICNAME IS NOT INITIAL
        AND GS_WORKPL-PLAN_DATE IS NOT INITIAL
        AND GS_WORKPL-PLAN_QT IS NOT INITIAL.
          SELECT SINGLE *
            INTO CORRESPONDING FIELDS OF GT_ZTJ_WORKPL
            FROM ZTJ_WORKPLAN
            WHERE MITEMCODE = GS_WORKPL-MITEMCODE
            AND PLAN_DATE = GS_WORKPL-PLAN_DATE.
          IF SY-SUBRC = 0.
            MOVE-CORRESPONDING GS_WORKPL TO GT_ZTJ_WORKPL.

            "변경 로그
            GT_ZTJ_WORKPL-AEDAT = SY-DATUM.
            GT_ZTJ_WORKPL-AEZET = SY-UZEIT.
            GT_ZTJ_WORKPL-AENAM = SY-UNAME.
            APPEND GT_ZTJ_WORKPL.
            CLEAR GT_ZTJ_WORKPL.
            "변경 되면 인터널 테이블에서 DB테이블로 입력
            IF GT_ZTJ_WORKPL[] IS NOT INITIAL.
              MODIFY ZTJ_WORKPLAN FROM TABLE GT_ZTJ_WORKPL.
              COMMIT WORK.

              IF SY-SUBRC = 0.
                MESSAGE '변경 성공' TYPE 'S'.
              ENDIF.
            ENDIF.
          ELSE.
            MOVE-CORRESPONDING GS_WORKPL TO GT_ZTJ_WORKPL.

            "생성 로그
            GT_ZTJ_WORKPL-ERDAT = SY-DATUM.
            GT_ZTJ_WORKPL-ERZET = SY-UZEIT.
            GT_ZTJ_WORKPL-ERNAM = SY-UNAME.
            APPEND GT_ZTJ_WORKPL.
            CLEAR GT_ZTJ_WORKPL.

            "저장 되면 인터널 테이블에서 DB테이블로 입력
            IF GT_ZTJ_WORKPL[] IS NOT INITIAL.
              MODIFY ZTJ_WORKPLAN FROM TABLE GT_ZTJ_WORKPL.
              COMMIT WORK.

              IF SY-SUBRC = 0.
                MESSAGE '저장 성공' TYPE 'S'.
              ENDIF.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDLOOP.
    WHEN 'DELE'.
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE GT_ZTJ_WORKPL
        FROM ZTJ_WORKPLAN
        WHERE MITEMCODE = GS_WORKPL-MITEMCODE.

      IF LINES( GT_ZTJ_WORKPL ) > 1.
        CLEAR LV_ANSWER.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
           TITLEBAR                    = '삭제 경고'
            text_question               = '정말 삭제 하겠습니까?'
         IMPORTING
           ANSWER                      = LV_ANSWER.

        LOOP AT GT_WORKPL INTO GS_WORKPL.

          IF GS_WORKPL-CHK IS NOT INITIAL.

            IF LV_ANSWER = '1'.
              "삭제 처리
              DELETE FROM ZTJ_WORKPLAN WHERE MITEMCODE = GS_WORKPL-MITEMCODE
                                       AND PLAN_DATE = GS_WORKPL-PLAN_DATE.
              COMMIT WORK. "COMMIT WORK AND WAIT도 가능한듯.
              IF SY-SUBRC = 0.
                MESSAGE '삭제 완료' TYPE 'S'.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.

      ELSEIF LINES( GT_ZTJ_WORKPL ) = 1.
        CLEAR LV_ANSWER.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
           TITLEBAR                    = '삭제 경고'
            text_question               = '정말 삭제 하겠습니까?'
         IMPORTING
           ANSWER                      = LV_ANSWER
                  .
        IF sy-subrc <> 0.
*   Implement suitable error handling here
        ENDIF.

        IF LV_ANSWER = '1'.
          "삭제 처리
          DELETE FROM ZTJ_WORKPLAN WHERE MITEMCODE = GS_WORKPL-MITEMCODE.
          COMMIT WORK. "COMMIT WORK AND WAIT도 가능한듯.
          IF SY-SUBRC = 0.
            MESSAGE '삭제 완료' TYPE 'S'.
          ENDIF.
        ENDIF.
      ENDIF.

    WHEN 'CONF'.
      LOOP AT GT_WORKPL INTO GS_WORKPL.
        SELECT SINGLE *
            INTO CORRESPONDING FIELDS OF GT_ZTJ_WORKPL
            FROM ZTJ_WORKPLAN
            WHERE MITEMCODE = GS_WORKPL-MITEMCODE
            AND PLAN_DATE = GS_WORKPL-PLAN_DATE.
        IF SY-SUBRC = 0.
          IF GS_WORKPL-CHK IS NOT INITIAL. "체크박스 클릭 되어 있으면
            "CONTIRM 체크
            GT_ZTJ_WORKPL-PLAN_CONFIRM = 'X'.
            APPEND GT_ZTJ_WORKPL.
            CLEAR GT_ZTJ_WORKPL.

            IF GT_ZTJ_WORKPL[] IS NOT INITIAL.
              MODIFY ZTJ_WORKPLAN FROM TABLE GT_ZTJ_WORKPL.
              COMMIT WORK.

              IF SY-SUBRC = 0.
                MESSAGE '변경 성공' TYPE 'S'.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
  ENDCASE.
  CLEAR : OK_CODE, GT_ZTJ_WORKPL, GT_ZTJ_WORKPL[].
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
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MOVE_SCREEN_TO_ABAP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE move_screen_to_abap INPUT.
  "테이블에 값을 넣고 엔터를 치면 안없어지게 함.
  IF TC100-LINES < TC100-CURRENT_LINE.
*    MODIFY GT_WORKPL FROM GS_WORKPL INDEX TC100-CURRENT_LINE.
    INSERT GS_WORKPL INTO GT_WORKPL INDEX TC100-CURRENT_LINE.
  ELSE.

  ENDIF.

  MODIFY GT_WORKPL FROM GS_WORKPL INDEX TC100-CURRENT_LINE.
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
      GS_WORKPL-MITEMCODE = LS_RETURN-FIELDVAL.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_FIELD_MITEMCODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_field_mitemcode INPUT.
  IF GS_WORKPL-MITEMCODE IS NOT INITIAL.
    CLEAR LV_MITEMCODENM.
    SELECT SINGLE COMPONENT
      INTO LV_MITEMCODENM
      FROM ZTJ_ITEM
      WHERE ITEM_CODE = GS_WORKPL-MITEMCODE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_PLAN_DATE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_plan_date INPUT.
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
