REPORT zbcr_reltrs_list.

INCLUDE zbcx_reltrs_list_md IF FOUND.
INCLUDE zbcx_reltrs_list_vw IF FOUND.
INCLUDE zbcx_reltrs_list_ctr.

INITIALIZATION.

  DATA(lc_cntr) = NEW c_cntr( ).

START-OF-SELECTION.

  lc_cntr->select_data( ).
  lc_cntr->show_report( ).
