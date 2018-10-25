# INTERFACE COCKPIT

## Getting Started

It is a sort of objects wich provides control and monitoring of outbound and inbound interfaces based on PO (Process Orchestration) proxy.

### Prerequisite

All codes here have being developed in order to help you in your ABAP daily projects development. In order to upload it corretly on your SAP system you must use [ABAPGit](https://github.com/larshp/abapGit).

Check it on [ABAPGit Doc](http://docs.abapgit.org/guide-install.html).

### Basic Structure

* **Tables**
  - ZBCT_EXTSYS
  - ZBCT_INT_LOG
* **Data Elements**
  - Z
  - Z
* **Transactions**
  - ZBC_EXTSYS
  - ZBC_INTERFACE_LOG
* **Classes**
  - ZBCCL
  - ZBCCL
* **Programs**
  - ZBCR_

### How To Use

#### Maintain Basic Data
#### Create Interface Proxy
#### Create Class for Proxy
#### Call Static Class for Job Process

```abap
zbccl_po_interface=>schedule_job( ).
```


## Author

* **Diogo Carvalho** - *Initial work* - [diogoccosta](https://github.com/diogoccosta)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/diogoccosta/sap_abap/LICENSE) file for details.


