class ZBCCL_TAX_CALCULATION definition
  public
  final
  create public .

public section.

  class-data GV_EBELN type EBELN .
  class-data GV_BUKRS type BUKRS .
  class-data GV_ERROR type SYST-SUBRC .
  constants GC_COMPONENT type CHAR02 value 'BR' ##NO_TEXT.
  constants GC_BSTYP_BEST type BSTYP value 'F' ##NO_TEXT.
  constants GC_BSTYP_KONT type BSTYP value 'K' ##NO_TEXT.
  constants GC_POCALLER type J_1BCALLER value 'PO' ##NO_TEXT.
  class-data LW_EKKO type EKKO .
  class-data:
    LT_EKPO  type standard table of ekpo .
  class-data LW_EKPO type EKPO .
  class-data LW_T001 type T001 .
  class-data LW_TAXCOM type TAXCOM .
  class-data LW_KOMK type KOMK .
  class-data LW_KOMP type KOMP .
  class-data:
    LT_KOMV type standard table of KOMV .
  class-data:
    LT_KOMV_AUX type standard table of komv .
  class-data:
    LT_TAXCOM type standard table of taxcom .
  class-data:
    LT_TKOMV type standard table of KOMV .
  class-data:
    LT_TKOMVD type standard table of KOMVD .
  class-data:
    LT_KONV type standard table of konv .
  class-data MY_TAXCOM type J_1B_TAXCOM .

  class-methods CALCULATE_TAX_PURCHASE_ORDER
    importing
      !IV_EBELN type EBELN
    exporting
      value(EV_KOMV) like LT_KOMV
      value(EV_TAXCOM) like LT_TAXCOM .
protected section.
private section.

  class-methods SET_EBELN
    importing
      !IV_EBELN type EBELN .
  class-methods SET_BUKRS
    importing
      !IV_BUKRS type BUKRS .
  class-methods GET_EBELN
    returning
      value(RV_EBELN) type EBELN .
  class-methods GET_BUKRS
    returning
      value(RV_BUKRS) type BUKRS .
  class-methods GET_PO_DATA .
  class-methods GET_COMPANY_DATA
    importing
      !IV_BUKRS type BUKRS .
  class-methods SET_TAXCOM_PO_BY_ITEM
    importing
      !IV_EKPO type EKPO .
  class-methods SAVE_TAX_FIELDS .
  class-methods SET_TAX_CALLER .
  class-methods CHECK_BSA_COMPONENT
    importing
      !IV_BUKRS type BUKRS
    returning
      value(RV_SUBRC) type SYST-SUBRC .
  class-methods SET_KOMK_PO .
  class-methods SET_KOMP_PO_BY_ITEM
    importing
      !IV_EKPO type EKPO .
  class-methods SET_PRICE_PRINT_ITEM .
  class-methods SET_PO_DISCOUNTS
    importing
      !IV_EKPO type EKPO .
  class-methods FIND_TAX_SPREADSHEET .
  class-methods CALCULATE_TAX_ITEM .
  class-methods APPEND_KOMV .
  class-methods APPEND_TAXCOM .
ENDCLASS.



CLASS ZBCCL_TAX_CALCULATION IMPLEMENTATION.


  METHOD append_komv.
    APPEND LINES OF lt_komv_aux TO lt_komv.
  ENDMETHOD.


  METHOD append_taxcom.
    APPEND lw_taxcom TO lt_taxcom.
  ENDMETHOD.


  METHOD calculate_tax_item.
    CALL FUNCTION 'CALCULATE_TAX_ITEM'
      EXPORTING
        i_taxcom     = lw_taxcom
        display_only = abap_true
        dialog       = abap_false
      IMPORTING
        e_taxcom     = lw_taxcom
      TABLES
        t_xkomv      = lt_komv_aux
      EXCEPTIONS
        OTHERS       = 0.
  ENDMETHOD.


  METHOD calculate_tax_purchase_order.

    set_ebeln( iv_ebeln ).
    get_po_data( ).
    get_company_data( get_bukrs( ) ).
    gv_error = check_bsa_component( get_bukrs( ) ).
    set_komk_po( ).

    REFRESH: lt_komv, lt_taxcom.
    DESCRIBE TABLE lt_ekpo.
    DO sy-tfill TIMES.
      TRY.
          lw_ekpo = lt_ekpo[ sy-index ].
          set_taxcom_po_by_item( lw_ekpo ).
          save_tax_fields( ).
          set_tax_caller( ).
          set_komp_po_by_item( lw_ekpo ).
          set_price_print_item( ).
          set_po_discounts( lw_ekpo ).
          find_tax_spreadsheet( ).
          REFRESH lt_komv_aux.
          calculate_tax_item( ).
          append_komv( ).
          append_taxcom( ).

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    ENDDO.

    ev_komv   = lt_komv.
    ev_taxcom = lt_taxcom.

  ENDMETHOD.


  METHOD check_bsa_component.
    CALL FUNCTION 'J_1BSA_COMPONENT_ACTIVE'
      EXPORTING
        bukrs                = iv_bukrs
        component            = gc_component
      EXCEPTIONS
        component_not_active = 1
        OTHERS               = 2.
    rv_subrc = sy-subrc.
  ENDMETHOD.


  METHOD find_tax_spreadsheet.
    CALL FUNCTION 'FIND_TAX_SPREADSHEET'
      EXPORTING
        buchungskreis       = lw_t001-bukrs
     EXCEPTIONS
       not_found           = 1
       OTHERS              = 2.
  ENDMETHOD.


  METHOD get_bukrs.
    rv_bukrs = gv_bukrs.
  ENDMETHOD.


  METHOD get_company_data.
    SELECT SINGLE *
           FROM t001
           INTO lw_t001
           WHERE bukrs EQ iv_bukrs.
  ENDMETHOD.


  METHOD get_ebeln.
    rv_ebeln = gv_ebeln.
  ENDMETHOD.


  METHOD get_po_data.
    SELECT SINGLE *
           FROM ekko
           INTO @lw_ekko
           WHERE ebeln EQ @gv_ebeln.
    IF sy-subrc IS INITIAL.
      SELECT *
             FROM ekpo
             INTO TABLE @lt_ekpo
             WHERE ebeln EQ @gv_ebeln
             ORDER BY ebeln, ebelp.
      set_bukrs( lw_ekko-bukrs ).
    ENDIF.
  ENDMETHOD.


  METHOD save_tax_fields.
    CALL FUNCTION 'J_1B_SAVE_TAX_FIELDS'
      EXPORTING
        i_taxcom = my_taxcom.
  ENDMETHOD.


  METHOD set_bukrs.
    gv_bukrs = iv_bukrs.
  ENDMETHOD.


  METHOD set_ebeln.
    gv_ebeln = iv_ebeln.
  ENDMETHOD.


  METHOD set_komk_po.
    CLEAR lw_komk.
    lw_komk-mandt = lw_ekko-mandt.
    lw_komk-kalsm = lw_ekko-kalsm.
    IF lw_ekko-kalsm IS INITIAL.
      lw_komk-kalsm = 'RM0000'.
    ENDIF.
    lw_komk-kappl = 'M'.
    lw_komk-waerk = lw_ekko-waers.
    lw_komk-knumv = lw_ekko-knumv.
    lw_komk-lifnr = lw_ekko-lifnr.
  ENDMETHOD.


  METHOD set_komp_po_by_item.
    clear lw_komp.
    lw_komp-kposn = iv_ekpo-ebelp.
    lw_komp-matnr = iv_ekpo-matnr.
    lw_komp-werks = iv_ekpo-werks.
    lw_komp-matkl = iv_ekpo-matkl.
    lw_komp-infnr = iv_ekpo-infnr.
    lw_komp-evrtn = iv_ekpo-konnr.
    lw_komp-evrtp = iv_ekpo-ktpnr.
  ENDMETHOD.


  METHOD set_po_discounts.
    CALL FUNCTION 'J_1B_NF_PO_DISCOUNTS'
      EXPORTING
        i_kalsm = lw_ekko-kalsm
        i_ekpo  = iv_ekpo
        i_ekko  = lw_ekko
      tables
        i_konv  = lt_konv.
  ENDMETHOD.


  METHOD set_price_print_item.
    CALL FUNCTION 'RV_PRICE_PRINT_ITEM'
      EXPORTING
        comm_head_i = lw_komk
        comm_item_i = lw_komp
        language    = sy-langu
      TABLES
        tkomv       = lt_tkomv
        tkomvd      = lt_tkomvd.
  ENDMETHOD.


  METHOD set_taxcom_po_by_item.
    CLEAR lw_taxcom.
    lw_taxcom-bukrs = iv_ekpo-bukrs.
    lw_taxcom-budat = lw_ekko-bedat.
    lw_taxcom-waers = lw_ekko-waers.
    lw_taxcom-kposn = iv_ekpo-ebelp.
    lw_taxcom-mwskz = iv_ekpo-mwskz.
    lw_taxcom-txjcd = iv_ekpo-txjcd.
    lw_taxcom-shkzg = 'H'.
    lw_taxcom-xmwst = 'X'.
    IF lw_ekko-bstyp EQ gc_bstyp_best.
      lw_taxcom-wrbtr = iv_ekpo-netwr.
    ELSE.
      lw_taxcom-wrbtr = iv_ekpo-zwert.
    ENDIF.
    IF NOT lw_ekko-llief IS INITIAL.
      lw_taxcom-lifnr = lw_ekko-llief.
    ELSE.
      lw_taxcom-lifnr = lw_ekko-lifnr.
    ENDIF.
    lw_taxcom-land1 = lw_ekko-lands.
    lw_taxcom-ekorg = lw_ekko-ekorg.
    lw_taxcom-hwaer = lw_t001-waers.
    lw_taxcom-llief = lw_ekko-llief.
    lw_taxcom-bldat = lw_ekko-bedat.
    lw_taxcom-matnr = iv_ekpo-ematn.
    lw_taxcom-werks = iv_ekpo-werks.
    lw_taxcom-bwtar = iv_ekpo-bwtar.
    lw_taxcom-matkl = iv_ekpo-matkl.
    lw_taxcom-meins = iv_ekpo-meins.
    IF lw_ekko-bstyp EQ gc_bstyp_best.
      lw_taxcom-mglme = iv_ekpo-menge.
    ELSE.
      IF lw_ekko-bstyp EQ gc_bstyp_kont AND
         iv_ekpo-abmng GT 0.
        lw_taxcom-mglme = iv_ekpo-abmng.
      ELSE.
        lw_taxcom-mglme = iv_ekpo-ktmng.
      ENDIF.
    ENDIF.
    IF lw_taxcom-mglme EQ 0.
      lw_taxcom-mglme = 1000.
    ENDIF.
    lw_taxcom-mtart = iv_ekpo-mtart.

    DATA: my_lfa1  TYPE lfa1,
          my_t001w TYPE t001w.

    CLEAR my_taxcom.
    IF NOT lw_ekko-llief IS INITIAL.
      CALL FUNCTION 'WY_LFA1_SINGLE_READ'
        EXPORTING
          pi_lifnr = lw_ekko-llief
        IMPORTING
          po_lfa1  = my_lfa1
        EXCEPTIONS
          OTHERS   = 0.
    ELSE.
      SELECT SINGLE *
             FROM lfa1
             INTO my_lfa1
             WHERE lifnr EQ lw_ekko-lifnr.
    ENDIF.

    IF NOT iv_ekpo-werks IS INITIAL.
      CALL FUNCTION 'AIP01_PLANT_DETERMINE'
        EXPORTING
          i_werks  = iv_ekpo-werks
        IMPORTING
          es_t001w = my_t001w
        EXCEPTIONS
          OTHERS   = 6.
    ENDIF.

    my_taxcom-txreg_sf = my_lfa1-txjcd.
    my_taxcom-txreg_st = iv_ekpo-txjcd.
    my_taxcom-taxbs    = my_lfa1-taxbs.
    my_taxcom-ipisp    = my_lfa1-ipisp.
    my_taxcom-brsch    = my_lfa1-brsch.
    my_taxcom-mtuse    = iv_ekpo-j_1bmatuse.
    my_taxcom-mtorg    = iv_ekpo-j_1bmatorg.
    my_taxcom-ownpr    = iv_ekpo-j_1bownpro.
    my_taxcom-steuc    = iv_ekpo-j_1bnbm.
    my_taxcom-matkl    = iv_ekpo-matkl.
    my_taxcom-vrkme    = iv_ekpo-meins.
    my_taxcom-mgame    = iv_ekpo-menge.
    my_taxcom-loc_pr   = my_lfa1-txjcd.


    CALL FUNCTION 'MM_DELIVERY_ADDRESS_TXJCD_GET'
      EXPORTING
        im_ebeln       = iv_ekpo-ebeln
        im_ebelp       = iv_ekpo-ebelp
        im_t001w_adrnr = my_t001w-adrnr
        im_n_lgort     = iv_ekpo-lgort
        im_o_lgort     = iv_ekpo-lgort
        im_adrn2       = iv_ekpo-adrn2
        im_werks       = iv_ekpo-werks
      IMPORTING
        ex_txjcd       = my_taxcom-loc_se.

    IF NOT iv_ekpo-werks IS INITIAL.
      my_taxcom-loc_sr = my_t001w-txjcd.
    ELSE.
      my_taxcom-loc_sr = iv_ekpo-txjcd.
    ENDIF.

  ENDMETHOD.


  METHOD set_tax_caller.
    CALL FUNCTION 'J_1B_SET_TAX_CALLER'
      EXPORTING
        i_caller = gc_pocaller.
  ENDMETHOD.
ENDCLASS.
