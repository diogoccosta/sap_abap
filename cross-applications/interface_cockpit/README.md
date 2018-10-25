# INTERFACE COCKPIT

## Getting Started

It is a sort of objects wich provides control and monitoring of outbound and inbound interfaces based on PO (Process Orchestration) proxy.

### Prerequisite

All codes here have being developed in order to help you in your ABAP daily projects development. In order to upload it corretly on your SAP system you must use [ABAPGit](https://github.com/larshp/abapGit).

Check it on [ABAPGit Doc](http://docs.abapgit.org/guide-install.html).

### Objects

* **Tables**
  - ZBCT_EXTSYS_MSGS:           *master data of systems and messages*
  - ZBCT_INTMSG_LOG:            *store log data*
* **Data Elements**
  - Z...
  - Z
* **Transactions**
  - ZBC_EXTSYS:                 *call SM30 of ZBC_EXTSYS*
  - ZBC_INTERFACE_LOG:          *call ABAP program ZBCR_INT_MESSAGE_LOG*
* **Classes**
  - ZBCCL_PO_INTERFACE:         *class to schedule a job to execute the interfaces*
  - ZBCCL_PO_CALL_MESSAGE:      *a superclass to be used for new interface message classes*
* **Programs**
  - ZBCR_INT_MESSAGE_LOG:       *ABAP program to show the log of the interfaces*
  - ZBCR_INTERFACE_OUTBOUND:    *ABAP program to execute in background the interface message call*
* **Includes**
  - ZBCR_INT_MESSAGE_LOG_TOP:   *data declaration*
  - ZBCR_INT_MESSAGE_LOG_SS:    *selection screen*
  - ZBCR_INT_MESSAGE_LOG_CL:    *local class definition and implementation*
  - ZBCR_INTERFACE_OUTBOUND_SS: *selection screen*
  - ZBCR_INTERFACE_OUTBOUND_CL: *local class definition and implementation*

### How To Use

#### 1. Create Interface Proxy
Using class ```ZBCCL_PO_CALL_MESSAGE``` as a superclass you will create a new class for your specific interface message and then redefine the following methods:
```abap
* GET_DATA( )
* CHECK_DATA( )
* FILLOUT_REQUEST( )
* CALL_MESSAGE( )
```

#### 2. Create Class for Proxy


#### 3. Maintain Basic Data
You have to maintain the Domain ```ZBCDD_SYSTEM``` and fillout with your external systems. Then you have to maintain the table ```ZBC_EXTSYS_MSGS``` using transaction ```ZBC_EXTSYS``` with all interfaces, messages and classes created to be used for each interface message.

#### 4. Call Static Class for Job Process
You will call the static method ```schedule_job( )``` from class ```ZBCCL_PO_INTERFACE``` passing the external system, wich has been previusly maintained in the domain, interface message, wich has been previusly maitained in the table and the key of the message as following:
```abap
  zbccl_po_interface=>schedule_job( EXPORTING iv_extsyst = 'SYS_A'
                                              iv_message = 'postMessageA'
                                              iv_key     = lw_key         ).
```

## Author

* **Diogo Carvalho** - *Initial work* - [diogoccosta](https://github.com/diogoccosta)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/diogoccosta/sap_abap/LICENSE) file for details.


