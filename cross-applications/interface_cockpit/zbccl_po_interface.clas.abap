class ZBCCL_PO_INTERFACE definition
  public
  final
  create public .

public section.

  class-methods SCHEDULE_JOB
    importing
      !IV_EXTSYST type ZBCDE_SYSTEM
      !IV_MESSAGE type ZBCDE_MESSAGE
      !IV_KEY type ANY .
protected section.
private section.

  class-methods CREATE_JOB_SECTION
    importing
      !IV_JOBNAME type BTCJOB
    returning
      value(RV_JOBCOUNT) type BTCJOBCNT .
  class-methods CLOSE_JOB_SECTION
    importing
      !IV_JOBNAME type BTCJOB
      !IV_JOBCOUNT type BTCJOBCNT .
  class-methods SUBMIT_INTERFACE_REPORT
    importing
      !IV_EXTSYST type ZBCDE_SYSTEM
      !IV_MESSAGE type ZBCDE_MESSAGE
      !IV_KEY type ANY
      !IV_JOBNAME type BTCJOB
      !IV_JOBCOUNT type BTCJOBCNT .
ENDCLASS.



CLASS ZBCCL_PO_INTERFACE IMPLEMENTATION.


  METHOD close_job_section.
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = iv_jobcount
        jobname              = iv_jobname
        strtimmed            = abap_true
      EXCEPTIONS
        cant_start_immediate = 01
        invalid_startdate    = 02
        jobname_missing      = 03
        job_close_failed     = 04
        job_nosteps          = 05
        job_notex            = 06
        lock_failed          = 07
        OTHERS               = 99.
    IF NOT sy-subrc IS INITIAL.

    ENDIF.
  ENDMETHOD.


  METHOD create_job_section.
    CALL FUNCTION 'JOB_OPEN'
      EXPORTING
        delanfrep        = space
        jobgroup         = space
        jobname          = iv_jobname
        sdlstrtdt        = sy-datum
        sdlstrttm        = sy-uzeit
      IMPORTING
        jobcount         = rv_jobcount
      EXCEPTIONS
        cant_create_job  = 01
        invalid_job_data = 02
        jobname_missing  = 03.

    IF NOT sy-subrc IS INITIAL.

    ENDIF.
  ENDMETHOD.


  METHOD schedule_job.
    DATA lw_jobname TYPE btcjob.
    lw_jobname = iv_extsyst && |_| && iv_message.

    DATA(lw_jobcount) = create_job_section( iv_jobname = lw_jobname ).

    submit_interface_report( EXPORTING iv_extsyst  = iv_extsyst
                                       iv_message  = iv_message
                                       iv_key      = iv_key
                                       iv_jobname  = lw_jobname
                                       iv_jobcount = lw_jobcount ).

    close_job_section( EXPORTING iv_jobname =  lw_jobname
                                 iv_jobcount = lw_jobcount ).

  ENDMETHOD.


  METHOD submit_interface_report.

    SUBMIT zmmr_me_interface_outbound AND RETURN
           WITH p_extsys EQ iv_extsyst
           WITH p_msg    EQ iv_message
           WITH p_key    EQ iv_key
           USER sy-uname
           VIA JOB iv_jobname NUMBER iv_jobcount.

  ENDMETHOD.
ENDCLASS.
