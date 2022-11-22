*&---------------------------------------------------------------------*
*& Include          ZDKTJ_BOMROUTING_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA : LV_MITEMCODE LIKE GS_BOMROUT-MITEMCODE.
  DATA : GT_ZTJ_BOMROUT LIKE TABLE OF ZTJ_BOMROUTING WITH HEADER LINE.
  DATA : LV_ANSWER.
  DATA : LV_JSONCODE(200).

  CASE OK_CODE.
    WHEN 'DISP'.
      IF GS_BOMROUT-MITEMCODE IS NOT INITIAL.
        "MITEMCODE가 BOM이 없으면 다시 입력하도록 함
        CLEAR LV_MITEMCODE.
        SELECT SINGLE MITEMCODE
          INTO LV_MITEMCODE
          FROM ZTJ_BOM
          WHERE MITEMCODE = GS_BOMROUT-MITEMCODE.

        IF LV_MITEMCODE IS NOT INITIAL.
          "BOM ROUTING이 있는지 확인
          SELECT *
            INTO CORRESPONDING FIELDS OF TABLE GT_BOMROUT
            FROM ZTJ_BOMROUTING
            WHERE MITEMCODE = GS_BOMROUT-MITEMCODE.

          IF GT_BOMROUT IS NOT INITIAL.
            MESSAGE 'BOM ROUTING 출력 완료' TYPE 'S'.
          ELSE.
            MESSAGE 'BOM ROUTING이 없는 품목' TYPE 'S' DISPLAY LIKE 'W'.
          ENDIF.

        ELSE.
          MESSAGE 'BOM이 없거나 잘못 입력됨' TYPE 'S' DISPLAY LIKE 'E'.
        ENDIF.

      ENDIF.

    WHEN 'CREA'.
      LOOP AT GT_BOMROUT INTO GS_BOMROUT.
        IF GS_BOMROUT-MITEMCODE IS NOT INITIAL.
          "MITEMCODE가 BOM이 없으면 다시 입력하도록 함
          CLEAR LV_MITEMCODE.
          SELECT SINGLE MITEMCODE
            INTO LV_MITEMCODE
            FROM ZTJ_BOM
            WHERE MITEMCODE = GS_BOMROUT-MITEMCODE.

          IF LV_MITEMCODE IS NOT INITIAL.
            IF GS_BOMROUT-ITEMCODE IS NOT INITIAL
            AND GS_BOMROUT-STEP_NO IS NOT INITIAL
            AND GS_BOMROUT-RES_ID IS NOT INITIAL
            AND GS_BOMROUT-NEXTSTEP IS NOT INITIAL
            AND GS_BOMROUT-INPUT_QT IS NOT INITIAL.
              SELECT SINGLE *
                INTO CORRESPONDING FIELDS OF GT_ZTJ_BOMROUT
                FROM ZTJ_BOMROUTING
                WHERE MITEMCODE = GS_BOMROUT-MITEMCODE.
              IF SY-SUBRC = 0.
                MOVE-CORRESPONDING GS_BOMROUT TO GT_ZTJ_BOMROUT.

                CONCATENATE '{"S":' GS_BOMROUT-STEP_NO ',' '"O":' GS_BOMROUT-OP_NO ','
                '"A":' GS_BOMROUT-ASS_CODE ',' '"R":' GS_BOMROUT-RES_ID ',' '"N":' GS_BOMROUT-NEXTSTEP '}'
                INTO LV_JSONCODE.

                "변경 로그
                GT_ZTJ_BOMROUT-AEDAT = SY-DATUM.
                GT_ZTJ_BOMROUT-AEZET = SY-UZEIT.
                GT_ZTJ_BOMROUT-AENAM = SY-UNAME.
                APPEND GT_ZTJ_BOMROUT.

                GT_ZTJ_BOMROUT-JSONCODE = LV_JSONCODE.
                APPEND GT_ZTJ_BOMROUT.
                CLEAR GT_ZTJ_BOMROUT.

                "변경 되면 인터널 테이블에서 DB테이블로 입력
                IF GT_ZTJ_BOMROUT[] IS NOT INITIAL.
                  MODIFY ZTJ_BOMROUTING FROM TABLE GT_ZTJ_BOMROUT.
                  COMMIT WORK.
                  IF SY-SUBRC = 0.
                    MESSAGE '변경 성공' TYPE 'S'.
                  ENDIF.
                ENDIF.
              ELSE.
                MOVE-CORRESPONDING GS_BOMROUT TO GT_ZTJ_BOMROUT.

                CONCATENATE '{"S":' GS_BOMROUT-STEP_NO ',' '"O":' GS_BOMROUT-OP_NO ','
                '"A":' GS_BOMROUT-ASS_CODE ',' '"R":' GS_BOMROUT-RES_ID ',' '"N":' GS_BOMROUT-NEXTSTEP '}'
                INTO LV_JSONCODE.

                "생성 로그
                GT_ZTJ_BOMROUT-ERDAT = SY-DATUM.
                GT_ZTJ_BOMROUT-ERZET = SY-UZEIT.
                GT_ZTJ_BOMROUT-ERNAM = SY-UNAME.
                APPEND GT_ZTJ_BOMROUT.
*                CLEAR GT_ZTJ_BOMROUT.

                GT_ZTJ_BOMROUT-JSONCODE = LV_JSONCODE.
                APPEND GT_ZTJ_BOMROUT.
                CLEAR GT_ZTJ_BOMROUT.

                "저장 되면 인터널 테이블에서 DB테이블로 입력
                IF GT_ZTJ_BOMROUT[] IS NOT INITIAL.
                  MODIFY ZTJ_BOMROUTING FROM TABLE GT_ZTJ_BOMROUT.
                  COMMIT WORK.

                  IF SY-SUBRC = 0.
                    MESSAGE '저장 성공' TYPE 'S'.
                  ENDIF.
                ENDIF.
              ENDIF.
            ELSE.
              MESSAGE '값이 모두 입력되야 함' TYPE 'S' DISPLAY LIKE 'E'.
            ENDIF.

          ELSE.
            MESSAGE 'BOM이 없거나 잘못 입력됨' TYPE 'S' DISPLAY LIKE 'E'.
          ENDIF.

        ENDIF.
      ENDLOOP.


    WHEN 'REFR'.
      CLEAR : GS_BOMROUT, GT_BOMROUT.
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
        "삭제 처리
        DELETE FROM ZTJ_BOMROUTING WHERE MITEMCODE = GS_BOMROUT-MITEMCODE.
        COMMIT WORK. "COMMIT WORK AND WAIT도 가능한듯.
        IF SY-SUBRC = 0.
          MESSAGE '삭제 완료' TYPE 'S'.
        ENDIF.
      ENDIF.
  ENDCASE.

  CLEAR :OK_CODE.
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

    "UOM 자동 생성
    IF GS_BOMROUT-ITEMCODE IS NOT INITIAL
    AND GS_BOMROUT-STEP_NO IS NOT INITIAL.
      CLEAR GS_BOMROUT-UOM.
      SELECT SINGLE UOM
        INTO GS_BOMROUT-UOM
        FROM ZTJ_BOM
        WHERE ITEMCODE = GS_BOMROUT-ITEMCODE.
    ENDIF.

    IF GS_BOMROUT-STEP_NO IS NOT INITIAL.
      CLEAR : GS_BOMROUT-OP_NO, GS_BOMROUT-ASS_CODE, GS_BOMROUT-DESCRIPTION.
      SELECT SINGLE OP_NO ASS_CODE DESCRIPTION
        INTO CORRESPONDING FIELDS OF GS_BOMROUT
        FROM ZTJ_PROCESS
        WHERE STEP_NO = GS_BOMROUT-STEP_NO.
    ENDIF.

    INSERT GS_BOMROUT INTO GT_BOMROUT INDEX TC100-CURRENT_LINE.
  ELSEIF GS_BOMROUT-ITEMCODE = ''.
    CLEAR GS_BOMROUT-UOM.
  ELSEIF GS_BOMROUT-STEP_NO = ''.
    CLEAR : GS_BOMROUT-OP_NO, GS_BOMROUT-ASS_CODE, GS_BOMROUT-DESCRIPTION.
  ELSE.

    "UOM 자동 생성
    IF GS_BOMROUT-ITEMCODE IS NOT INITIAL
    AND GS_BOMROUT-STEP_NO IS NOT INITIAL.
      CLEAR GS_BOMROUT-UOM.
      SELECT SINGLE UOM
        INTO GS_BOMROUT-UOM
        FROM ZTJ_BOM
        WHERE ITEMCODE = GS_BOMROUT-ITEMCODE.
    ENDIF.

    IF GS_BOMROUT-STEP_NO IS NOT INITIAL.
      CLEAR : GS_BOMROUT-OP_NO, GS_BOMROUT-ASS_CODE, GS_BOMROUT-DESCRIPTION.
      SELECT SINGLE OP_NO ASS_CODE DESCRIPTION
        INTO CORRESPONDING FIELDS OF GS_BOMROUT
        FROM ZTJ_PROCESS
        WHERE STEP_NO = GS_BOMROUT-STEP_NO.
    ENDIF.
  ENDIF.

  MODIFY GT_BOMROUT FROM GS_BOMROUT INDEX TC100-CURRENT_LINE.
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
      GS_BOMROUT-MITEMCODE = LS_RETURN-FIELDVAL.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_FIELD_MITEMCODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_field_mitemcode INPUT.
  IF GS_BOMROUT-MITEMCODE IS NOT INITIAL.
    CLEAR MITEMCODENM.
    SELECT SINGLE COMPONENT
      INTO MITEMCODENM
      FROM ZTJ_ITEM
      WHERE ITEM_CODE = GS_BOMROUT-MITEMCODE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_TABLECONTROL_ITEMCODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_tablecontrol_itemcode INPUT.
  DATA : BEGIN OF LS_HELP2,
          ITEMCODE TYPE ZTJ_BOM-ITEMCODE,
          COMPONENT TYPE ZTJ_BOM-COMPONENT,
         END OF LS_HELP2,
         LT_HELP2 LIKE TABLE OF LS_HELP2.
  DATA : LS_RETURN2 LIKE DDSHRETVAL,
         LT_RETURN2 LIKE TABLE OF DDSHRETVAL.

  "BOM을 참고하여 하위자재만 서치헬프를 띄운다.
  SELECT ITEMCODE, COMPONENT
    INTO CORRESPONDING FIELDS OF TABLE @LT_HELP2
    FROM ZTJ_BOM
    WHERE MITEMCODE = @GS_BOMROUT-MITEMCODE.

  SORT LT_HELP2.

  "SEARCH HELP FUNCTION
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield               = 'ITEMCODE'
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
      value_tab              = LT_HELP2
*     FIELD_TAB              =
     RETURN_TAB             = LT_RETURN2
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
  IF LT_RETURN2 IS NOT INITIAL.
    LOOP AT LT_RETURN2 INTO LS_RETURN2.
      GS_BOMROUT-ITEMCODE = LS_RETURN2-FIELDVAL.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_TABLECONTROL_STEP_NO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_tablecontrol_step_no INPUT.
  DATA : BEGIN OF LS_HELP3,
          STEP_NO TYPE ZTJ_PROCESS-STEP_NO,
          OP_NO TYPE ZTJ_PROCESS-OP_NO,
          ASS_CODE TYPE ZTJ_PROCESS-ASS_CODE,
          DESCRIPTION TYPE ZTJ_PROCESS-DESCRIPTION,
         END OF LS_HELP3,
         LT_HELP3 LIKE TABLE OF LS_HELP3.
  DATA : LS_RETURN3 LIKE DDSHRETVAL,
         LT_RETURN3 LIKE TABLE OF DDSHRETVAL.

  "ZTJ_PROCESS 내용물 띄움
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE @LT_HELP3
    FROM ZTJ_PROCESS.

  SORT LT_HELP3.

  "SEARCH HELP FUNCTION
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield               = 'STEP_NO'
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
      value_tab              = LT_HELP3
*     FIELD_TAB              =
     RETURN_TAB             = LT_RETURN3
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
  IF LT_RETURN3 IS NOT INITIAL.
    LOOP AT LT_RETURN3 INTO LS_RETURN3.
      GS_BOMROUT-STEP_NO = LS_RETURN3-FIELDVAL.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_TABLECONTROL_NEXTSTEP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_tablecontrol_nextstep INPUT.
  DATA : BEGIN OF LS_HELP4,
          STEP_NO TYPE ZTJ_PROCESS-STEP_NO,
          OP_NO TYPE ZTJ_PROCESS-OP_NO,
          ASS_CODE TYPE ZTJ_PROCESS-ASS_CODE,
          DESCRIPTION TYPE ZTJ_PROCESS-DESCRIPTION,
         END OF LS_HELP4,
         LT_HELP4 LIKE TABLE OF LS_HELP4.
  DATA : LS_RETURN4 LIKE DDSHRETVAL,
         LT_RETURN4 LIKE TABLE OF DDSHRETVAL.

  "ZTJ_PROCESS 내용물 띄움
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE @LT_HELP4
    FROM ZTJ_PROCESS.

  SORT LT_HELP4.

  "SEARCH HELP FUNCTION
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield               = 'STEP_NO'
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
      value_tab              = LT_HELP4
*     FIELD_TAB              =
     RETURN_TAB             = LT_RETURN4
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
  IF LT_RETURN4 IS NOT INITIAL.
    LOOP AT LT_RETURN4 INTO LS_RETURN4.
      GS_BOMROUT-NEXTSTEP = LS_RETURN4-FIELDVAL.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_TABLECONTROL_RES_ID  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_tablecontrol_res_id INPUT.
  DATA : BEGIN OF LS_HELP5,
          RES_ID TYPE ZTJ_RESOURCE-RES_ID,
          RES_NM TYPE ZTJ_RESOURCE-RES_NM,
         END OF LS_HELP5,
         LT_HELP5 LIKE TABLE OF LS_HELP5.
  DATA : LS_RETURN5 LIKE DDSHRETVAL,
         LT_RETURN5 LIKE TABLE OF DDSHRETVAL.

  "ZTJ_PROCESS 내용물 띄움
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE @LT_HELP5
    FROM ZTJ_RESOURCE.

  SORT LT_HELP5.

  "SEARCH HELP FUNCTION
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield               = 'RES_ID'
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
      value_tab              = LT_HELP5
*     FIELD_TAB              =
     RETURN_TAB             = LT_RETURN5
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
  IF LT_RETURN5 IS NOT INITIAL.
    LOOP AT LT_RETURN5 INTO LS_RETURN5.
      GS_BOMROUT-RES_ID = LS_RETURN5-FIELDVAL.
    ENDLOOP.
  ENDIF.
ENDMODULE.
