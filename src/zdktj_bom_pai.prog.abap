*&---------------------------------------------------------------------*
*& Include          ZDKTJ_BOM_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA : GS_DATA LIKE ZTJ_BOM,
         GT_DATA LIKE TABLE OF GS_DATA.
  DATA : LS_MITEMCODE LIKE GS_BOM.
  DATA : GT_ZTJ_BOM LIKE TABLE OF ZTJ_BOM WITH HEADER LINE.
  DATA : LV_ANSWER.

  SAVE_OK = OK_CODE.

  CASE OK_CODE.
    WHEN 'DISP'.
      IF GS_BOM-PLANTCODE IS NOT INITIAL
      AND GS_BOM-MITEMCODE IS NOT INITIAL. "창고코드, 모품목코드 입력 확인

        "MITEMCODE가 품목 테이블에 없으면 다시 입력하도록 함.
        CLEAR LS_MITEMCODE.
        SELECT SINGLE *
          INTO CORRESPONDING FIELDS OF LS_MITEMCODE
          FROM ZTJ_ITEM
          WHERE ITEM_CODE = GS_BOM-MITEMCODE.

        IF LS_MITEMCODE IS NOT INITIAL.
          "BOM이 있는지 없는지 확인
          SELECT *
            INTO CORRESPONDING FIELDS OF TABLE GT_BOM
            FROM ZTJ_BOM
            WHERE MITEMCODE = GS_BOM-MITEMCODE.

          IF GT_BOM IS NOT INITIAL.
            MESSAGE 'BOM출력 완료' TYPE 'S'.
          ELSE.
            MESSAGE 'BOM이 없는 품목' TYPE 'S' DISPLAY LIKE 'W'.
          ENDIF.

        ELSE.
          MESSAGE '품목 코드가 없거나 잘못 입력됨' TYPE 'S' DISPLAY LIKE 'E'.
        ENDIF.

      ENDIF.
    WHEN 'CREA'.
      LOOP AT GT_BOM INTO GS_BOM.
        IF GS_BOM-ITEMCODE IS NOT INITIAL
        AND GS_BOM-COMPONENT IS NOT INITIAL
        AND GS_BOM-UOM IS NOT INITIAL
        AND GS_BOM-QUANTITY IS NOT INITIAL. "값이 모두 입력되었는지 확인
          "BOM이 있으면 변경, 아니면 입력
          SELECT SINGLE *
            INTO CORRESPONDING FIELDS OF GT_ZTJ_BOM
            FROM ZTJ_BOM
            WHERE MITEMCODE = GS_BOM-MITEMCODE.
          IF SY-SUBRC = 0.
            MOVE-CORRESPONDING GS_BOM TO GT_ZTJ_BOM.

            "변경 로그
            GT_ZTJ_BOM-AEDAT = SY-DATUM.
            GT_ZTJ_BOM-AEZET = SY-UZEIT.
            GT_ZTJ_BOM-AENAM = SY-UNAME.
            APPEND GT_ZTJ_BOM.
            CLEAR GT_ZTJ_BOM.

            "변경 되면 인터널 테이블에서 DB테이블로 입력
            IF GT_ZTJ_BOM[] IS NOT INITIAL.
              MODIFY ZTJ_BOM FROM TABLE GT_ZTJ_BOM.
              COMMIT WORK.

              IF SY-SUBRC = 0.
                MESSAGE '변경 성공' TYPE 'S'.
              ENDIF.
            ENDIF.

          ELSE.
            MOVE-CORRESPONDING GS_BOM TO GT_ZTJ_BOM.

            "생성 로그
            GT_ZTJ_BOM-ERDAT = SY-DATUM.
            GT_ZTJ_BOM-ERZET = SY-UZEIT.
            GT_ZTJ_BOM-ERNAM = SY-UNAME.
            APPEND GT_ZTJ_BOM.
            CLEAR GT_ZTJ_BOM.

            "저장 되면 인터널 테이블에서 DB테이블로 입력
            IF GT_ZTJ_BOM[] IS NOT INITIAL.
              MODIFY ZTJ_BOM FROM TABLE GT_ZTJ_BOM.
              COMMIT WORK.

              IF SY-SUBRC = 0.
                MESSAGE '저장 성공' TYPE 'S'.
              ENDIF.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDLOOP.
    WHEN 'REFR'.
        CLEAR : GS_BOM, GT_BOM, LS_MITEMCODE, GT_ZTJ_BOM, GS_DATA.
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
        DELETE FROM ZTJ_BOM WHERE MITEMCODE = GS_BOM-MITEMCODE.
        COMMIT WORK. "COMMIT WORK AND WAIT도 가능한듯.
        IF SY-SUBRC = 0.
          MESSAGE '삭제 완료' TYPE 'S'.
        ENDIF.
      ENDIF.

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
    "COMPONENT 자동 생성
    IF GS_BOM-ITEMCODE IS NOT INITIAL.
     CLEAR GS_BOM-COMPONENT.
     SELECT SINGLE COMPONENT
       INTO GS_BOM-COMPONENT
       FROM ZTJ_ITEM
       WHERE ITEM_CODE = GS_BOM-ITEMCODE.
     "단위 값을 기본으로 EA 입력함
     GS_BOM-UOM = 'EA'.
    ENDIF.
    INSERT GS_BOM INTO GT_BOM INDEX TC100-CURRENT_LINE.
  ELSEIF GS_BOM-ITEMCODE = ''.
    CLEAR GS_BOM.
  ELSE.
    "변경값을 넣으면 계속 자동 생성
    IF GS_BOM-ITEMCODE IS NOT INITIAL.
     CLEAR GS_BOM-COMPONENT.
     SELECT SINGLE COMPONENT
       INTO GS_BOM-COMPONENT
       FROM ZTJ_ITEM
       WHERE ITEM_CODE = GS_BOM-ITEMCODE.
     "단위 값을 기본으로 EA 입력함
     GS_BOM-UOM = 'EA'.
    ENDIF.
  ENDIF.

  "변경값 유지
  MODIFY GT_BOM FROM GS_BOM INDEX TC100-CURRENT_LINE.
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

*  서치헬프 필드명 지정
  DATA : LT_FIELD LIKE TABLE OF DFIES WITH HEADER LINE.


CALL FUNCTION 'DDIF_FIELDINFO_GET'
  EXPORTING
    tabname              = 'ZTJ_ITEM'
   FIELDNAME            = 'ITEM_CODE'
*   LANGU                = SY-LANGU
   LFIELDNAME           = 'ITEM_CODE'
*   ALL_TYPES            = ' '
*   GROUP_NAMES          = ' '
*   UCLEN                =
*   DO_NOT_WRITE         = ' '
 IMPORTING
*   X030L_WA             =
*   DDOBJTYPE            =
   DFIES_WA             = LT_FIELD
*   LINES_DESCR          =
* TABLES
*   DFIES_TAB            =
*   FIXED_VALUES         =
* EXCEPTIONS
*   NOT_FOUND            = 1
*   INTERNAL_ERROR       = 2
*   OTHERS               = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

  LT_FIELD-FIELDNAME = 'MITEMCODE'.
  LT_FIELD-POSITION = 1.
  LT_FIELD-OFFSET = 0.
  LT_FIELD-SCRTEXT_M = '모품목 코드'.
  APPEND LT_FIELD.
  CLEAR LT_FIELD.

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
  EXPORTING
    tabname              = 'ZTJ_ITEM'
   FIELDNAME            = 'COMPONENT'
*   LANGU                = SY-LANGU
   LFIELDNAME           = 'COMPONENT'
*   ALL_TYPES            = ' '
*   GROUP_NAMES          = ' '
*   UCLEN                =
*   DO_NOT_WRITE         = ' '
 IMPORTING
*   X030L_WA             =
*   DDOBJTYPE            =
   DFIES_WA             = LT_FIELD
*   LINES_DESCR          =
* TABLES
*   DFIES_TAB            =
*   FIXED_VALUES         =
* EXCEPTIONS
*   NOT_FOUND            = 1
*   INTERNAL_ERROR       = 2
*   OTHERS               = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


  LT_FIELD-FIELDNAME = 'COMPONENT'.
  LT_FIELD-POSITION = 2.
  LT_FIELD-OFFSET = 8.
  LT_FIELD-SCRTEXT_M = '품명'.
  APPEND LT_FIELD.
  CLEAR LT_FIELD.

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
     FIELD_TAB              = LT_FIELD
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
      GS_BOM-MITEMCODE = LS_RETURN-FIELDVAL.
    ENDLOOP.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_PLANTCODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_plantcode INPUT.
  "서치 헬프 가져올 테이블 지정
  DATA : BEGIN OF LS_HELP2,
          RESID TYPE ZTJ_RESMAP-RESID,
          RESNAME TYPE ZTJ_RESMAP-RESNAME,
         END OF LS_HELP2,
         LT_HELP2 LIKE TABLE OF LS_HELP2.
  DATA : LS_RETURN2 LIKE DDSHRETVAL,
         LT_RETURN2 LIKE TABLE OF DDSHRETVAL.

  SELECT RESID, RESNAME
    INTO CORRESPONDING FIELDS OF TABLE @LT_HELP2
    FROM ZTJ_RESMAP.

  SORT LT_HELP2.

*  "서치헬프 필드명 지정
*  DATA : LT_FIELD2 LIKE TABLE OF DFIES WITH HEADER LINE.
*  LT_FIELD2-FIELDNAME = 'RESID'.
*  LT_FIELD2-INTLEN = 20.
*  LT_FIELD2-LENG = 20.
*  LT_FIELD2-OUTPUTLEN = 20.
*  LT_FIELD2-REPTEXT = '창고 코드'.
*  APPEND LT_FIELD2.
*  CLEAR LT_FIELD2.
*
*  LT_FIELD2-FIELDNAME = 'RESNAME'.
*  LT_FIELD2-INTLEN  = 30.
*  LT_FIELD2-LENG = 30.
*  LT_FIELD2-OUTPUTLEN = 30.
*  LT_FIELD2-REPTEXT = '창고 이름'.
*  APPEND LT_FIELD2.
*  CLEAR LT_FIELD2.

  "SEARCH HELP FUNCTION
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield               = 'RESID'
*     PVALKEY                = ' '
*     DYNPPROG               = ' '
*     DYNPNR                 = ' '
*     DYNPROFIELD            = ' '
*     STEPL                  = 0
     WINDOW_TITLE           = '창고 코드'
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
*     FIELD_TAB              = LT_FIELD2
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
      GS_BOM-PLANTCODE = LS_RETURN2-FIELDVAL.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_FIELD_MITEMCODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_field_mitemcode INPUT.
  IF GS_BOM-MITEMCODE IS NOT INITIAL.
    CLEAR LV_ITEMNAME.
    SELECT SINGLE COMPONENT
      INTO LV_ITEMNAME
      FROM ZTJ_ITEM
      WHERE ITEM_CODE = GS_BOM-MITEMCODE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_FIELD_PLANTCODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_field_plantcode INPUT.
  IF GS_BOM-PLANTCODE IS NOT INITIAL.
    CLEAR LV_PLANTNAME.
    SELECT SINGLE RESNAME
      INTO LV_PLANTNAME
      FROM ZTJ_RESMAP
      WHERE RESID = GS_BOM-PLANTCODE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_TABLECONTROL_FIELD  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_tablecontrol_field INPUT.
  "서치 헬프 가져올 테이블 지정
  DATA : BEGIN OF LS_HELP3,
          ITEM_CODE TYPE ZTJ_ITEM-ITEM_CODE,
          COMPONENT TYPE ZTJ_ITEM-COMPONENT,
         END OF LS_HELP3,
         LT_HELP3 LIKE TABLE OF LS_HELP3.
  DATA : LS_RETURN3 LIKE DDSHRETVAL,
         LT_RETURN3 LIKE TABLE OF DDSHRETVAL.

  SELECT ITEM_CODE, COMPONENT
    INTO CORRESPONDING FIELDS OF TABLE @LT_HELP3
    FROM ZTJ_ITEM.

  SORT LT_HELP3.

*  "서치헬프 필드명 지정
*  DATA : LT_FIELD3 LIKE TABLE OF DFIES WITH HEADER LINE.
*  LT_FIELD3-FIELDNAME = 'ITEM_CODE'.
*  LT_FIELD3-INTLEN = 20.
*  LT_FIELD3-LENG = 20.
*  LT_FIELD3-OUTPUTLEN = 20.
*  LT_FIELD3-REPTEXT = '품목 코드'.
*  APPEND LT_FIELD3.
*  CLEAR LT_FIELD3.
*
*  LT_FIELD3-FIELDNAME = 'COMPONENT'.
*  LT_FIELD3-INTLEN  = 30.
*  LT_FIELD3-LENG = 30.
*  LT_FIELD3-OUTPUTLEN = 30.
*  LT_FIELD3-REPTEXT = '품명'.
*  APPEND LT_FIELD3.
*  CLEAR LT_FIELD3.

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
     WINDOW_TITLE           = '품목 코드'
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
*     FIELD_TAB              = LT_FIELD3
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
      GS_BOM-ITEMCODE = LS_RETURN3-FIELDVAL.
    ENDLOOP.
  ENDIF.

ENDMODULE.
