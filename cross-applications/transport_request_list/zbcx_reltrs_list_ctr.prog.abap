*&---------------------------------------------------------------------*
*& Include          ZBCX_RELTRS_LIST_CTR
*&---------------------------------------------------------------------*
CLASS c_cntr DEFINITION.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_date,
        sign   TYPE char01,
        option TYPE char02,
        low    TYPE e070-as4date,
        high   TYPE e070-as4date,
      END OF ty_date.

    TYPES:
      BEGIN OF ty_trtot,
        trkorr     TYPE e070-trkorr,
        client     TYPE e070c-client,
        as4text    TYPE e07t-as4text,
        trfunction TYPE e070-trfunction,
        trstatus   TYPE e070-trstatus,
        tarsystem  TYPE e070-tarsystem,
        as4user    TYPE e070-as4user,
        as4date    TYPE e070-as4date,
        as4time    TYPE e070-as4time,
      END OF ty_trtot.

    TYPES:
      BEGIN OF ty_output,
        trkorr   TYPE e070-trkorr,
        client   TYPE e070c-client,
        as4text  TYPE e07t-as4text,
        function TYPE string,
        status   TYPE string,
        devsys   TYPE ctslg_system-systemid,
        as4user  TYPE e070-as4user,
        as4date  TYPE e070-as4date,
        as4time  TYPE e070-as4time,
        qassys   TYPE ctslg_system-systemid,
        impdate1 TYPE e070-as4date,
        imptime1 TYPE e070-as4time,
        prdsys   TYPE ctslg_system-systemid,
        impdate2 TYPE e070-as4date,
        imptime2 TYPE e070-as4time,
        color    TYPE lvc_t_scol,
      END OF ty_output.

    CLASS-DATA:
      wa_date       TYPE ty_date,
      wr_trfunc     TYPE RANGE OF e070-trfunction,
      wa_trfunc     LIKE LINE OF wr_trfunc,
      wr_trstat     TYPE RANGE OF e070-trstatus,
      wa_trstat     LIKE LINE OF wr_trstat,
      wt_trtot      TYPE STANDARD TABLE OF ty_trtot,
      wt_output     TYPE STANDARD TABLE OF ty_output,
      wa_output     LIKE LINE OF wt_output,
      ws_cofile     TYPE ctslg_cofile,
      wt_systems    TYPE STANDARD TABLE OF ctslg_system,
      wt_steps      TYPE STANDARD TABLE OF ctslg_step,
      wt_actions    TYPE STANDARD TABLE OF ctslg_action,

      wt_trfunction TYPE STANDARD TABLE OF dd07v,
      wt_trstatus   TYPE STANDARD TABLE OF dd07v,

      wc_months     TYPE int4                  VALUE '8',   "CHANGE!!! Value to calculate months before today on selection screen
      wc_devsys     TYPE ctslg_system-systemid VALUE 'DEV', "CHANGE!!! System ID for your Development SAP System
      wc_qassys     TYPE ctslg_system-systemid VALUE 'QAS', "CHANGE!!! System ID for your Quality SAP System
      wc_prdsys     TYPE ctslg_system-systemid VALUE 'PRD', "CHANGE!!! System ID for your Production SAP System

      wc_sign_i     TYPE char01            VALUE 'I',
      wc_opt_eq     TYPE char02            VALUE 'EQ',
      wc_opt_bt     TYPE char02            VALUE 'BT',
      wc_wrk        TYPE e070-trfunction   VALUE 'K',
      wc_cst        TYPE e070-trfunction   VALUE 'W',
      wc_cpy        TYPE e070-trfunction   VALUE 'T',
      wc_mdd        TYPE e070-trstatus     VALUE 'D',
      wc_mdl        TYPE e070-trstatus     VALUE 'L',
      wc_lbo        TYPE e070-trstatus     VALUE 'O',
      wc_lbr        TYPE e070-trstatus     VALUE 'R',
      wc_lbn        TYPE e070-trstatus     VALUE 'N',
      wc_stp_i      TYPE ctslg_step-stepid VALUE 'I',

      wc_trfunction TYPE dd07l-domname   VALUE 'TRFUNCTION',
      wc_trstatus   TYPE dd07l-domname   VALUE 'TRSTATUS',

      go_salv       TYPE REF TO cl_salv_table,
      go_func       TYPE REF TO cl_salv_functions_list,
      go_colm       TYPE REF TO cl_salv_columns_table,
      lo_column     TYPE REF TO cl_salv_column.

    METHODS:
      constructor,
      select_data,
      refresh_all,
      prepare_parameters,
      select_trs_total,
      prepare_trs_status,
      select_domain_values,
      trfunction_text IMPORTING i_value        TYPE e070-trfunction
                      RETURNING VALUE(r_value) TYPE string,
      trstatus_text   IMPORTING i_value        TYPE e070-trstatus
                      RETURNING VALUE(r_value) TYPE string,
      show_report,
      set_columns_detail.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS c_cntr IMPLEMENTATION.

  METHOD constructor.

*   Titles...
    t_b1  = 'Selection Parameters'.
    t_b11 = 'Request Type:'.
    t_b12 = 'Request Status:'.

*   Screen paramterers...
    %_s_trkorr_%_app_%-text = 'Transport Request ID'.
    %_s_user_%_app_%-text   = 'User'.
    %_s_date_%_app_%-text   = 'Date'.
    %_p_tpk_%_app_%-text    = 'K - Workbench'.
    %_p_tpw_%_app_%-text    = 'W - Customizing'.
    %_p_tpt_%_app_%-text    = 'T - Transport of Copies'.
    %_p_lb_%_app_%-text     = 'Released (O, R and N)'.
    %_p_md_%_app_%-text     = 'Modifiable (D and L)'.

*   Default values for Import Date...
    wa_date-sign   = wc_sign_i.
    wa_date-option = wc_opt_bt.
    wa_date-low    = cl_reca_date=>sub_months_from_date( id_months = wc_months id_date = sy-datum ).
    wa_date-high   = sy-datum.
    APPEND wa_date TO s_date.

  ENDMETHOD.

  METHOD select_data.

    me->refresh_all( ).
    me->prepare_parameters( ).

    me->select_trs_total( ).
    me->prepare_trs_status( ).


  ENDMETHOD.

  METHOD refresh_all.
    CLEAR:
    wa_date, wa_trfunc, wa_trstat, wa_output.

    REFRESH:
    wr_trfunc, wr_trstat, wt_trtot, wt_output.
  ENDMETHOD.

  METHOD prepare_parameters.

*   TR Function values...
    wa_trfunc-sign   = wc_sign_i.
    wa_trfunc-option = wc_opt_eq.
    IF p_tpk NOT IS INITIAL..
      wa_trfunc-low = wc_wrk.
      APPEND wa_trfunc TO wr_trfunc.
    ENDIF.
    IF p_tpw NOT IS INITIAL.
      wa_trfunc-low = wc_cst.
      APPEND wa_trfunc TO wr_trfunc.
    ENDIF.
    IF p_tpt NOT IS INITIAL.
      wa_trfunc-low = wc_cpy.
      APPEND wa_trfunc TO wr_trfunc.
    ENDIF.

*   TR Status values...
    wa_trstat-sign   = wc_sign_i.
    wa_trstat-option = wc_opt_eq.
    IF NOT p_lb IS INITIAL.
      wa_trstat-low = wc_lbo.
      APPEND wa_trstat TO wr_trstat.
      wa_trstat-low = wc_lbr.
      APPEND wa_trstat TO wr_trstat.
      wa_trstat-low = wc_lbn.
      APPEND wa_trstat TO wr_trstat.
    ENDIF.
    IF NOT p_md IS INITIAL.
      wa_trstat-low = wc_mdd.
      APPEND wa_trstat TO wr_trstat.
      wa_trstat-low = wc_mdl.
      APPEND wa_trstat TO wr_trstat.
    ENDIF.

  ENDMETHOD.

  METHOD select_trs_total.

    SELECT a~trkorr, c~client, b~as4text, a~trfunction, a~trstatus, a~tarsystem, a~as4user, a~as4date, a~as4time
          INTO TABLE @wt_trtot
          FROM e070 AS a
          INNER JOIN e07t AS b
          ON b~trkorr EQ a~trkorr AND
             b~langu  EQ @sy-langu
          INNER JOIN e070c AS c
          ON c~trkorr EQ a~trkorr
          WHERE a~trkorr     IN @s_trkorr  AND
                a~trfunction IN @wr_trfunc AND
                a~trstatus   IN @wr_trstat AND
                a~as4user    IN @s_user    AND
                a~as4date    IN @s_date    AND
                a~strkorr    EQ @space
          ORDER BY a~trstatus, a~as4date, a~as4time, a~trfunction.

  ENDMETHOD.

  METHOD prepare_trs_status.

    CHECK wt_trtot[] NOT IS INITIAL.

    me->select_domain_values( ).

    DATA wa_cellcolor TYPE lvc_s_scol.

    LOOP AT wt_trtot INTO DATA(wa_trtot).
      MOVE-CORRESPONDING wa_trtot TO wa_output.
      wa_output-devsys   = wc_devsys.
      wa_output-function = me->trfunction_text( wa_trtot-trfunction ).
      wa_output-status   = me->trstatus_text( wa_trtot-trstatus ).
      CASE wa_trtot-trstatus.
*       Released...
        WHEN wc_lbo OR wc_lbr OR wc_lbn.

          wa_cellcolor-color-col = '6'.
          wa_cellcolor-color-int = '0'.

          CALL FUNCTION 'TR_READ_GLOBAL_INFO_OF_REQUEST'
            EXPORTING
              iv_trkorr = wa_trtot-trkorr
            IMPORTING
              es_cofile = ws_cofile.
          IF sy-subrc IS INITIAL.
            wt_systems[] = ws_cofile-systems[].
            LOOP AT wt_systems INTO DATA(wa_systems) WHERE systemid NE wc_devsys.
              wt_steps[] = wa_systems-steps[].
              TRY.
                  DATA(wa_steps) = wt_steps[ stepid = wc_stp_i ].
                  wt_actions[] = wa_steps-actions[].
                  SORT wt_actions BY date DESCENDING time DESCENDING.

                  LOOP AT wt_actions INTO DATA(wa_actions).

                    IF wa_systems-systemid EQ wc_qassys.
                      wa_output-qassys   = wa_systems-systemid.
                      wa_output-impdate1 = wa_actions-date.
                      wa_output-imptime1 = wa_actions-time.
                      wa_cellcolor-color-col = '4'.
                    ENDIF.
                    IF wa_systems-systemid EQ wc_prdsys.
                      wa_output-prdsys   = wa_systems-systemid.
                      wa_output-impdate1 = wa_actions-date.
                      wa_output-imptime1 = wa_actions-time.
                      wa_cellcolor-color-col = '5'.
                    ENDIF.
                    wa_cellcolor-color-int = '0'.
                    APPEND wa_cellcolor TO wa_output-color.
                  ENDLOOP.

                CATCH cx_root.
                  APPEND wa_cellcolor TO wa_output-color.

              ENDTRY.
            ENDLOOP.
          ELSE.
            APPEND wa_cellcolor TO wa_output-color.
          ENDIF.

*       Modifiable...
        WHEN wc_mdd OR wc_mdl.
          wa_cellcolor-color-col = '0'.
          wa_cellcolor-color-int = '0'.
          APPEND wa_cellcolor TO wa_output-color.
      ENDCASE.
      APPEND wa_output TO wt_output.
      CLEAR wa_output.
    ENDLOOP.

    SORT wt_output BY status DESCENDING prdsys impdate2 imptime2 qassys impdate1 imptime1 devsys as4date as4time function.

  ENDMETHOD.

  METHOD select_domain_values.

*   Read TR Function domain values...
    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = wc_trfunction
        text           = abap_true
        langu          = sy-langu
      TABLES
        dd07v_tab      = wt_trfunction
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2.
IF sy-subrc NOT IS INITIAL.
"Deal with error
ENDIF.
*   Read TR Status domain values...
    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = wc_trstatus
        text           = abap_true
        langu          = sy-langu
      TABLES
        dd07v_tab      = wt_trstatus
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2.
IF sy-subrc NOT IS INITIAL.
"Deal with error
ENDIF.
    SORT: wt_trfunction BY domvalue_l,
          wt_trstatus   BY domvalue_l.

  ENDMETHOD.

  METHOD trfunction_text.

    TRY.
        r_value = wt_trfunction[ domvalue_l = i_value ]-ddtext.

      CATCH cx_root INTO DATA(lo_cx).
        message e398(00) with lo_cx->text( ).
    ENDTRY.

  ENDMETHOD.

  METHOD trstatus_text.

    TRY.
        r_value = wt_trstatus[ domvalue_l = i_value ]-ddtext.

      CATCH cx_root INTO DATA(lo_cx).
        message e398(00) with lo_cx->text( ).
    ENDTRY.

  ENDMETHOD.

  METHOD show_report.

    cl_salv_table=>factory( IMPORTING r_salv_table = go_salv
                            CHANGING  t_table      = wt_output ).

    go_func = go_salv->get_functions( ).
    go_func->set_all( abap_true ).

    go_colm = go_salv->get_columns( ).

    me->set_columns_detail( ).

    go_colm->set_color_column( 'COLOR' ).
    go_colm->set_optimize( abap_true ).

    go_salv->display( ).

  ENDMETHOD.

  METHOD set_columns_detail.

    TRY.
        lo_column = go_colm->get_column( 'TRKORR' ).
        lo_column->set_long_text( 'Transport Request' ).
        lo_column->set_medium_text( 'Request' ).
        lo_column->set_short_text( 'Request' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'CLIENT' ).
        lo_column->set_long_text( 'Client' ).
        lo_column->set_medium_text( 'Client' ).
        lo_column->set_short_text( 'Client' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'AS4TEXT' ).
        lo_column->set_long_text( 'Description' ).
        lo_column->set_medium_text( 'Description' ).
        lo_column->set_short_text( 'Descript' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'FUNCTION' ).
        lo_column->set_long_text( 'Type' ).
        lo_column->set_medium_text( 'Type' ).
        lo_column->set_short_text( 'Type' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'STATUS' ).
        lo_column->set_long_text( 'Status' ).
        lo_column->set_medium_text( 'Status' ).
        lo_column->set_short_text( 'Status' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'DEVSYS' ).
        lo_column->set_long_text( 'DEV' ).
        lo_column->set_medium_text( 'DEV' ).
        lo_column->set_short_text( 'DEV' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'AS4USER' ).
        lo_column->set_long_text( 'Owner' ).
        lo_column->set_medium_text( 'Owner' ).
        lo_column->set_short_text( 'Owner' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'AS4DATE' ).
        lo_column->set_long_text( 'DEV Date' ).
        lo_column->set_medium_text( 'DEV Date' ).
        lo_column->set_short_text( 'DEV Date' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'AS4TIME' ).
        lo_column->set_long_text( 'DEV Time' ).
        lo_column->set_medium_text( 'DEV Time' ).
        lo_column->set_short_text( 'DEV Time' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'QASSYS' ).
        lo_column->set_long_text( 'QAS' ).
        lo_column->set_medium_text( 'QAS' ).
        lo_column->set_short_text( 'QAS' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'IMPDATE1' ).
        lo_column->set_long_text( 'QAS Date' ).
        lo_column->set_medium_text( 'QAS Date' ).
        lo_column->set_short_text( 'QAS Date' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'IMPTIME1' ).
        lo_column->set_long_text( 'QAS Time' ).
        lo_column->set_medium_text( 'QAS Time' ).
        lo_column->set_short_text( 'QAS Time' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'PRDSYS' ).
        lo_column->set_long_text( 'PRD' ).
        lo_column->set_medium_text( 'PRD' ).
        lo_column->set_short_text( 'PRD' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'IMPDATE2' ).
        lo_column->set_long_text( 'PRD Date' ).
        lo_column->set_medium_text( 'PRD Date' ).
        lo_column->set_short_text( 'PRD Date' ).

      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = go_colm->get_column( 'IMPTIME2' ).
        lo_column->set_long_text( 'PRD Time' ).
        lo_column->set_medium_text( 'PRD Time' ).
        lo_column->set_short_text( 'PRD Time' ).

      CATCH cx_salv_not_found.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
