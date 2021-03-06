CLASS lcl_report DEFINITION.

  PUBLIC SECTION.
    DATA: it_output TYPE STANDARD TABLE OF zbct_intmsg_log.
    CONSTANTS: c_out TYPE zbcde_direction VALUE 'OUT',
               c_inb TYPE zbcde_direction VALUE 'INB'.

    METHODS select_data.
    METHODS show_report.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_report IMPLEMENTATION.

  METHOD select_data.
    SELECT *
           FROM zbct_intmsg_log
           INTO TABLE it_output
           WHERE extsystem IN s_extsys AND
                 action    IN s_msg    AND
                 sysdat    IN s_date.
    IF sy-subrc IS INITIAL.
      IF p_out IS INITIAL.
        DELETE it_output WHERE direction EQ c_out.
      ENDIF.
      IF p_inb IS INITIAL.
        DELETE it_output WHERE direction EQ c_inb.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD show_report.
    IF it_output[] IS INITIAL. RETURN. ENDIF
    cl_salv_table=>factory( IMPORTING r_salv_table = go_salv
                            CHANGING  t_table      = it_output ).

    go_func = go_salv->get_functions( ).
    go_func->set_all( abap_true ).

    go_colm = go_salv->get_columns( ).
    go_colm->set_optimize( abap_true ).

    go_salv->display( ).

  ENDMETHOD.

ENDCLASS.
