# ZBCCL_TAX_CALCULATION

## Getting Started

It is a class wich provides a calculation method for <b>Purchase Order MM</b> and <b>Sales Order SD</b> using FM ```CALCULATE_TAX_ITEM``` furthermore it is widely used in S/4 HANA ERP installation because KONV is not been populated. You can check it on OSS Note [2267308](https://launchpad.support.sap.com/#/notes/2267308).

### Preqrequisite ABAPGit

All codes here have being developed in order to help you in your ABAP daily projects development. In order to upload it corretly on your SAP system you must use [ABAPGit](https://github.com/larshp/abapGit).

Check it on [ABAPGit Doc](http://docs.abapgit.org/guide-install.html).

### Example

You can call the method ```method_name``` in order to receive all price info for all items as following:

```
zbccl_tax_calcuation=>get( ).
```

## Author

* **Diogo Carvalho** - *Initial work* - [diogoccosta](https://github.com/diogoccosta)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/diogoccosta/sap_abap/LICENSE) file for details
