class ZBCCL_PO_CALL_MESSAGE definition
  public
  abstract
  create public .

public section.

  data GV_KEY type CHAR100 .
  data GV_EXTSYS type ZBCDE_SYSTEM .
  data GV_MESSAGE type ZBCDE_MESSAGE .
  data GV_CL_MSG type SEOCLSNAME .
  data GV_MT_PRX type SEOCLSNAME .
  data GV_MESSAGE_ID type CHAR50 .
  data GO_MSG type ref to OBJECT .
  data GV_OK type ABAP_BOOL .
  data:
    IT_INTMSG_LOG type standard table of zbct_intmsg_log .
  data:
    wa_intmsg_log like line of it_intmsg_log .
  constants C_OUT type ZBCDE_DIRECTION value 'OUT' ##NO_TEXT.
  constants C_INB type ZBCDE_DIRECTION value 'INB' ##NO_TEXT.
  constants C_OUT_SENT_PO type ZBCDE_MSGSTATUS value 'O1' ##NO_TEXT.
  constants C_OUT_ERROR_PO type ZBCDE_MSGSTATUS value 'O2' ##NO_TEXT.
  constants C_OUT_SENT_EXTSYS type ZBCDE_MSGSTATUS value 'O3' ##NO_TEXT.
  constants C_OUT_ERROR_EXTSYS type ZBCDE_MSGSTATUS value 'O4' ##NO_TEXT.
  constants C_OUT_RESP_EXTSYS type ZBCDE_MSGSTATUS value 'O5' ##NO_TEXT.
  constants C_INB_RCV_S4 type ZBCDE_MSGSTATUS value 'I1' ##NO_TEXT.
  constants C_INB_ERROR_S4 type ZBCDE_MSGSTATUS value 'I2' ##NO_TEXT.
  constants C_INB_RESP_EXTSYS type ZBCDE_MSGSTATUS value 'I3' ##NO_TEXT.
  constants C_INB_ERROR_EXTSYS type ZBCDE_MSGSTATUS value 'I4' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !IV_EXTSYS type ZBCDE_SYSTEM
      !IV_MESSAGE type ZBCDE_MESSAGE
      !IV_KEY type CHAR100 .
  methods SET_KEY
    importing
      !IV_KEY type CHAR100 optional .
  methods SET_EXTSYS
    importing
      !IV_EXTSYS type ZBCDE_SYSTEM .
  methods SET_MESSAGE
    importing
      !IV_MESSAGE type ZBCDE_MESSAGE .
  methods SET_CLASS .
  methods GEN_MESSAGE_ID .
  methods GET_KEY
    returning
      value(RV_KEY) type CHAR100 .
  methods GET_EXTSYS
    returning
      value(RV_EXTSYS) type ZBCDE_SYSTEM .
  methods GET_MESSAGE
    returning
      value(RV_MESSAGE) type ZBCDE_MESSAGE .
  methods GET_MESSAGE_ID
    returning
      value(RV_MSG_ID) type CHAR50 .
  methods GET_DATA .
  methods CHECK_DATA
    returning
      value(RV_OK) type ABAP_BOOL .
  methods FILLOUT_REQUEST .
  methods SET_REQUEST .
  methods CALL_MESSAGE
    exporting
      value(EV_OK) type ABAP_BOOL .
  methods SET_LOG_OUT_MESSAGE_SENT_PO
    importing
      !IV_RESP type STRING optional
      !IV_FAULT_MSG type STRING optional .
  methods SET_LOG_OUT_MESSAGE_ERROR_PO
    importing
      !IV_RESP type STRING optional
      !IV_FAULT_MSG type STRING optional
      !IV_DIRECTION type ZBCDE_DIRECTION default 'OUT'
      !IV_MESSAGE_STATUS type ZBCDE_MSGSTATUS default 'O2' .
  methods SET_LOG_OUT_MESSAGE_SENT_ESY
    importing
      !IV_RESP type STRING optional
      !IV_FAULT_MSG type STRING optional .
  methods SET_LOG_OUT_MESSAGE_ERROR_ESY
    importing
      !IV_RESP type STRING optional
      !IV_FAULT_MSG type STRING optional .
  methods SET_LOG_OUT_MESSAGE_OK_ESY
    importing
      !IV_RESP type STRING optional
      !IV_FAULT_MSG type STRING optional
      !IV_DIRECTION type ZBCDE_DIRECTION default 'OUT'
      !IV_MESSAGE_STATUS type ZBCDE_MSGSTATUS default 'O5' .
  methods CALL_MESSAGE_INBOUND
    importing
      !IS_DATA type ANY
    exporting
      value(EV_OK) type ABAP_BOOL
      !ES_DATA type ANY .
protected section.
private section.
ENDCLASS.



CLASS ZBCCL_PO_CALL_MESSAGE IMPLEMENTATION.


  METHOD call_message.

* De maneira a manter um Monitor Compartilhado para os Sistemas Externos e
* visualizar as etapas de Envio ou Recebimento das mensagens, deve-se verificar
* o uso dos métodos de gravação de entrada de log, conforme lista abaixo:
*
* SAÍDA
* - Mensagem enviada ao SAP PO (com RC = 0)
*     Método: SET_LOG_OUT_MESSAGE_SENT_PO
*
* - Erro no envio da mensagem ao SAP PO (com RC <> 0 ou qualquer erro)
*     Método: SET_LOG_OUT_MESSAGE_ERROR_PO
*
* - Mensagem enviada ao Sistema Externo (RC = 0 e PO ACK ok)
*     Método: SET_LOG_OUT_MESSAGE_SENT_ESY
*
* - Erro no envio da mensagem ao Sistema Externo (RC = 0 e PO Fault Message)
*     Método: SET_LOG_OUT_MESSAGE_ERROR_ESY
*
* - Resposta recebida pelo Sistema Externo (RC = 0, PO ACK ok e RESPONSE ok)
*     Método: SET_LOG_OUT_MESSAGE_OK_ESY
*
* ENTRADA
* - Mensagem recebida pelo SAP S4
*     Método:
*
* - Erro no processamento da mensagem pelo S4
*     Método:
*
* - Resposta enviada ao Sistema Externo
*     Método:
*
* - Erro no envio da resposta ao Sistema Externo
*     Método:

  ENDMETHOD.


  METHOD CALL_MESSAGE_INBOUND.

* De maneira a manter um Monitor Compartilhado para os Sistemas Externos e
* visualizar as etapas de Envio ou Recebimento das mensagens, deve-se verificar
* o uso dos métodos de gravação de entrada de log, conforme lista abaixo:
*
* SAÍDA
* - Mensagem enviada ao SAP PO (com RC = 0)
*     Método: SET_LOG_OUT_MESSAGE_SENT_PO
*
* - Erro no envio da mensagem ao SAP PO (com RC <> 0 ou qualquer erro)
*     Método: SET_LOG_OUT_MESSAGE_ERROR_PO
*
* - Mensagem enviada ao Sistema Externo (RC = 0 e PO ACK ok)
*     Método: SET_LOG_OUT_MESSAGE_SENT_ESY
*
* - Erro no envio da mensagem ao Sistema Externo (RC = 0 e PO Fault Message)
*     Método: SET_LOG_OUT_MESSAGE_ERROR_ESY
*
* - Resposta recebida pelo Sistema Externo (RC = 0, PO ACK ok e RESPONSE ok)
*     Método: SET_LOG_OUT_MESSAGE_OK_ESY
*
* ENTRADA
* - Mensagem recebida pelo SAP S4
*     Método:
*
* - Erro no processamento da mensagem pelo S4
*     Método:
*
* - Resposta enviada ao Sistema Externo
*     Método:
*
* - Erro no envio da resposta ao Sistema Externo
*     Método:

  ENDMETHOD.


  method CHECK_DATA.
  endmethod.


  METHOD constructor.

    set_extsys( iv_extsys ).
    set_message( iv_message ).
    set_key( iv_key ).

    set_class( ).

    IF gv_cl_msg IS NOT INITIAL.
      CREATE OBJECT go_msg TYPE (gv_cl_msg).
    ENDIF.

    gen_message_id( ).

  ENDMETHOD.


  method FILLOUT_REQUEST.
  endmethod.


  METHOD gen_message_id.
    gv_message_id = get_extsys( ) && sy-sysid && sy-mandt && sy-uname && sy-datum && sy-uzeit.
  ENDMETHOD.


  method GET_DATA.
  endmethod.


  METHOD get_extsys.
    rv_extsys = gv_extsys.
  ENDMETHOD.


  METHOD get_key.
    rv_key = gv_key.
  ENDMETHOD.


  METHOD get_message.
    rv_message = gv_message.
  ENDMETHOD.


  METHOD get_message_id.
    rv_msg_id = gv_message_id.
  ENDMETHOD.


  METHOD set_class.
    SELECT SINGLE class_msg
       FROM zbct_extsys_msgs
       INTO @gv_cl_msg
       WHERE extsyst   EQ @gv_extsys AND
             message   EQ @gv_message.
  ENDMETHOD.


  METHOD set_extsys.
    gv_extsys = iv_extsys.
  ENDMETHOD.


  METHOD set_key.
    gv_key = iv_key.
  ENDMETHOD.


  METHOD SET_LOG_OUT_MESSAGE_ERROR_ESY.

    CLEAR wa_intmsg_log.

    wa_intmsg_log-id_msg        = get_message_id( ).
    wa_intmsg_log-extsystem     = get_extsys( ).
    wa_intmsg_log-action        = get_message( ).
    wa_intmsg_log-msgkey        = get_key( ).
    wa_intmsg_log-sysuser       = sy-uname.
    wa_intmsg_log-sysdat        = sy-datum.
    wa_intmsg_log-systim        = sy-uzeit.
    wa_intmsg_log-direction     = c_out.
    wa_intmsg_log-msgstatus     = c_out_error_extsys.
    wa_intmsg_log-id_msg_resp   = ''.
    wa_intmsg_log-response      = iv_resp.
    wa_intmsg_log-fault_message = iv_fault_msg.

    MODIFY zbct_intmsg_log FROM wa_intmsg_log.
    COMMIT WORK.

  ENDMETHOD.


  METHOD set_log_out_message_error_po.

    CLEAR wa_intmsg_log.

    wa_intmsg_log-id_msg        = get_message_id( ).
    wa_intmsg_log-extsystem     = get_extsys( ).
    wa_intmsg_log-action        = get_message( ).
    wa_intmsg_log-msgkey        = get_key( ).
    wa_intmsg_log-sysuser       = sy-uname.
    wa_intmsg_log-sysdat        = sy-datum.
    wa_intmsg_log-systim        = sy-uzeit.
    wa_intmsg_log-direction     = iv_direction.
    wa_intmsg_log-msgstatus     = iv_message_status.
    wa_intmsg_log-id_msg_resp   = ''.
    wa_intmsg_log-response      = iv_resp.
    wa_intmsg_log-fault_message = iv_fault_msg.

    MODIFY zbct_intmsg_log FROM wa_intmsg_log.
    COMMIT WORK.

  ENDMETHOD.


  METHOD set_log_out_message_ok_esy.

    CLEAR wa_intmsg_log.

    wa_intmsg_log-id_msg        = get_message_id( ).
    wa_intmsg_log-extsystem     = get_extsys( ).
    wa_intmsg_log-action        = get_message( ).
    wa_intmsg_log-msgkey        = get_key( ).
    wa_intmsg_log-sysuser       = sy-uname.
    wa_intmsg_log-sysdat        = sy-datum.
    wa_intmsg_log-systim        = sy-uzeit.
    wa_intmsg_log-direction     = iv_direction.
    wa_intmsg_log-msgstatus     = iv_message_status.
    wa_intmsg_log-id_msg_resp   = ''.
    wa_intmsg_log-response      = iv_resp.
    wa_intmsg_log-fault_message = iv_fault_msg.

    MODIFY zbct_intmsg_log FROM wa_intmsg_log.
    COMMIT WORK.

  ENDMETHOD.


  METHOD SET_LOG_OUT_MESSAGE_SENT_ESY.

    CLEAR wa_intmsg_log.

    wa_intmsg_log-id_msg        = get_message_id( ).
    wa_intmsg_log-extsystem     = get_extsys( ).
    wa_intmsg_log-action        = get_message( ).
    wa_intmsg_log-msgkey        = get_key( ).
    wa_intmsg_log-sysuser       = sy-uname.
    wa_intmsg_log-sysdat        = sy-datum.
    wa_intmsg_log-systim        = sy-uzeit.
    wa_intmsg_log-direction     = c_out.
    wa_intmsg_log-msgstatus     = c_out_sent_po.
    wa_intmsg_log-id_msg_resp   = ''.
    wa_intmsg_log-response      = iv_resp.
    wa_intmsg_log-fault_message = iv_fault_msg.

    MODIFY zbct_intmsg_log FROM wa_intmsg_log.
    COMMIT WORK.

  ENDMETHOD.


  METHOD set_log_out_message_sent_po.

    CLEAR wa_intmsg_log.

    wa_intmsg_log-id_msg        = get_message_id( ).
    wa_intmsg_log-extsystem     = get_extsys( ).
    wa_intmsg_log-action        = get_message( ).
    wa_intmsg_log-msgkey        = get_key( ).
    wa_intmsg_log-sysuser       = sy-uname.
    wa_intmsg_log-sysdat        = sy-datum.
    wa_intmsg_log-systim        = sy-uzeit.
    wa_intmsg_log-direction     = c_out.
    wa_intmsg_log-msgstatus     = c_out_error_po.
    wa_intmsg_log-id_msg_resp   = ''.
    wa_intmsg_log-response      = iv_resp.
    wa_intmsg_log-fault_message = iv_fault_msg.

    MODIFY zbct_intmsg_log FROM wa_intmsg_log.
    COMMIT WORK.

  ENDMETHOD.


  METHOD set_message.
    gv_message = iv_message.
  ENDMETHOD.


  METHOD set_request.

    get_data( ).

    gv_ok = check_data( ).

    CHECK gv_ok EQ abap_true.
    fillout_request( ).

  ENDMETHOD.
ENDCLASS.
