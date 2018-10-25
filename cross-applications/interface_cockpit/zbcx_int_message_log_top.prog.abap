*&---------------------------------------------------------------------*
*& NAME       : ZBCX_INT_MESSAGE_LOG_TOP                               *
*& CREATED BY : ORI_CARVALHD (DIOGO CARVALHO)                          *
*& CREATED ON : 23.09.2018                                             *
*&---------------------------------------------------------------------*
*&----------------------CHANGE CONTROL LOG-----------------------------*
*& DATE       | AUTHOR       | DESCRIPTION                             *
*& 23.09.2018 | ORI_CARVALHD | Initial                                 *
*& DD.MM.YYYY | <username>   | <change description/ID>                 *
*&                                                                     *
*&---------------------------------------------------------------------*
DATA: go_salv TYPE REF TO cl_salv_table,
      go_func TYPE REF TO cl_salv_functions_list,
      go_colm TYPE REF TO cl_salv_columns.

DATA: so_system TYPE zbct_intmsg_log-extsystem,
      so_msg    TYPE zbct_intmsg_log-action,
      so_date   TYPE datum.
