REPORT zbcr_int_message_log.

INCLUDE zbcx_int_message_log_top.
INCLUDE zbcx_int_message_log_ss.
INCLUDE zbcx_int_message_log_cl.

INITIALIZATION.
  DATA(lo_rep) = NEW lcl_report( ).

START-OF-SELECTION.
  lo_rep->select_data( ).

END-OF-SELECTION.
  lo_rep->show_report( ).
