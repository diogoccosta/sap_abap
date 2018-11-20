*&---------------------------------------------------------------------*
*& Include          ZBCX_RELTRS_LIST_VW
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE t_b1.
SELECT-OPTIONS: s_trkorr FOR e070-trkorr,
                s_user   FOR e070-as4user DEFAULT sy-uname,
                s_date   FOR e070-as4date.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b11 WITH FRAME TITLE t_b11.
PARAMETERS: p_tpk TYPE c AS CHECKBOX DEFAULT 'X',
            p_tpw TYPE c AS CHECKBOX,
            p_tpt TYPE c AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b11.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b12 WITH FRAME TITLE t_b12.
PARAMETERS: p_lb TYPE c AS CHECKBOX DEFAULT 'X',
            p_md TYPE c AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b12.

SELECTION-SCREEN END OF BLOCK b1.
