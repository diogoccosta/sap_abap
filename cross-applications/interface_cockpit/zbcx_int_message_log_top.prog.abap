DATA: go_salv TYPE REF TO cl_salv_table,
      go_func TYPE REF TO cl_salv_functions_list,
      go_colm TYPE REF TO cl_salv_columns.

DATA: so_system TYPE zbct_intmsg_log-extsystem,
      so_msg    TYPE zbct_intmsg_log-action,
      so_date   TYPE datum.
