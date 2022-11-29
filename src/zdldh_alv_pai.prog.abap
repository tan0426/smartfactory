*&---------------------------------------------------------------------*
*& Include          ZDLDH_ALV_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZDLDH_ALV_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
    SAVE_OK = OK_CODE.

  CASE OK_CODE.
    WHEN 'PUSH1'.
      IF GS_CUST-ZCODE IS NOT INITIAL.
        CALL SCREEN 200.
      ENDIF.
    WHEN 'PUSH2'.
      IF GS_ITEM-ITEM_CODE IS NOT INITIAL.
        CALL SCREEN 300.
      ENDIF.
    WHEN 'PUSH3'.
      IF GS_RMAP-RESID IS NOT INITIAL.
        CALL SCREEN 400.
      ENDIF.
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
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
    CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0400 INPUT.
  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_CUST_ZCODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_cust_zcode INPUT.
"서치 헬프 가져올 테이블 지정
  DATA : BEGIN OF LS_HELP,
          ZCODE TYPE ZTJ_CUST-ZCODE,
          ZCNAME TYPE ZTJ_CUST-ZCNAME,
         END OF LS_HELP,
         LT_HELP LIKE TABLE OF LS_HELP.
  DATA : LS_RETURN LIKE DDSHRETVAL,
         LT_RETURN LIKE TABLE OF DDSHRETVAL.

  SELECT ZCODE, ZCNAME
    INTO CORRESPONDING FIELDS OF TABLE @LT_HELP
    FROM ZTJ_CUST.

  SORT LT_HELP.

  "SEARCH HELP FUNCTION
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      retfield               = 'ZCODE'
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
      GS_CUST-ZCODE = LS_RETURN-FIELDVAL.
    ENDLOOP.
  ENDIF.
  CLEAR : LS_HELP, LS_RETURN.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_ITEM_ITEM_CODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_item_item_code INPUT.
  DATA : BEGIN OF LS_HELP2,
          ITEM_CODE TYPE ZTJ_ITEM-ITEM_CODE,
          COMPONENT TYPE ZTJ_ITEM-COMPONENT,
          ITEM_GROUP TYPE ZTJ_ITEM-ITEM_GROUP,
         END OF LS_HELP2,
         LT_HELP2 LIKE TABLE OF LS_HELP2.

   DATA : LS_RETURN2 LIKE DDSHRETVAL,
          LT_RETURN2 LIKE TABLE OF DDSHRETVAL.

   SELECT ITEM_CODE, COMPONENT, ITEM_GROUP INTO CORRESPONDING FIELDS OF TABLE @LT_HELP2 FROM ZTJ_ITEM.
     SORT LT_HELP2.

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
      GS_ITEM-ITEM_CODE = LS_RETURN2-FIELDVAL.
    ENDLOOP.
  ENDIF.
  CLEAR : LS_HELP2, LS_RETURN2.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_RMAP_RESID  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_rmap_resid INPUT.
  DATA : BEGIN OF LS_HELP3,
          RESID TYPE ZTJ_RESMAP-RESID,
          RESNAME TYPE ZTJ_RESMAP-RESNAME,
          BTYPE TYPE ZTJ_RESMAP-BTYPE,
          BUFNO TYPE ZTJ_RESMAP-BUFNO,
          RSIDE TYPE ZTJ_RESMAP-RSIDE,
          RROW TYPE ZTJ_RESMAP-RROW,
          RCOL TYPE ZTJ_RESMAP-RCOL,
          RSHARE TYPE ZTJ_RESMAP-RSHARE,
         END OF LS_HELP3,
         LT_HELP3 LIKE TABLE OF LS_HELP3.

   DATA : LS_RETURN3 LIKE DDSHRETVAL,
          LT_RETURN3 LIKE TABLE OF DDSHRETVAL.

   SELECT RESID, RESNAME, BTYPE, BUFNO, RSIDE, RROW, RCOL, RSHARE INTO CORRESPONDING FIELDS OF TABLE @LT_HELP3 FROM ZTJ_RESMAP.
     SORT LT_HELP3.

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
      GS_RMAP-RESID = LS_RETURN3-FIELDVAL.
    ENDLOOP.
  ENDIF.
  CLEAR : LS_HELP3, LS_RETURN3.

ENDMODULE.
