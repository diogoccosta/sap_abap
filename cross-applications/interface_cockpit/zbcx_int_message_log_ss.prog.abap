*&---------------------------------------------------------------------*
*& NAME       : ZBCX_INT_MESSAGE_LOG_SS                                *
*& CREATED BY : ORI_CARVALHD (DIOGO CARVALHO)                          *
*& CREATED ON : 23.09.2018                                             *
*&---------------------------------------------------------------------*
*&----------------------CHANGE CONTROL LOG-----------------------------*
*& DATE       | AUTHOR       | DESCRIPTION                             *
*& 23.09.2018 | ORI_CARVALHD | Initial                                 *
*& DD.MM.YYYY | <username>   | <change description/ID>                 *
*&                                                                     *
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-s01.
SELECT-OPTIONS: s_extsys FOR so_system,
                s_msg    FOR so_msg,
                s_date   FOR so_date OBLIGATORY DEFAULT sy-datum.
SELECTION-SCREEN SKIP.
PARAMETERS: p_out TYPE char01 AS CHECKBOX DEFAULT 'X',
            p_inb TYPE char01 AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b1.
