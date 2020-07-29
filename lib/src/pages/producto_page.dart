import 'package:flutter/material.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/productos_providers.dart';
import 'package:form_validation/src/utils/utils.dart' as util;

class ProductPage extends StatefulWidget {
  static final route = "/product";

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductoModel producto = ProductoModel();
  bool _guardando = false;
  final provider = ProductosProviders();

  @override
  Widget build(BuildContext context) {
    final prodArg = ModalRoute.of(context).settings.arguments;
    if(prodArg != null){
      producto = prodArg;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Producto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _crearName(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearName() {
    return TextFormField(
      initialValue: producto.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Producto"),
      onSaved: (value) => producto.title = value,
      validator: (value){
        if(value.length<3){
          return "Ingrese un nombre válido";
        }else return null;
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: "Precio"),
      onSaved: (value) => producto.value = double.parse(value),
      validator: (value){
        if(util.isNumber(value)){
          return null;
        }else{
          return "Solo numeros";
        }
      },
    );
  }

  Widget _crearBtn() {
    return RaisedButton.icon(
      label: Text("Guardar"),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null: () => _submit(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  void _submit(){
     if(!formKey.currentState.validate()) return;

     formKey.currentState.save();

     setState(() {
       _guardando = true;
     });

     if(producto.id == null){
       provider.crearProducto(producto);
       setState(() {
         _guardando = false;
       });
       _snackbar("Registro Creado");
     }else{
       provider.actualizarProducto(producto);
       setState(() {
         _guardando = false;
       });
       _snackbar("Registro Actualizado");
       Navigator.pop(context);
     }

  }

  void _snackbar(String msg){
    final snack = SnackBar(content: Text(msg), duration: Duration(milliseconds: 1500),);
    scaffoldKey.currentState.showSnackBar(snack);
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text("Disponible"),
      activeColor: Colors.deepPurple,
      onChanged: (value){
        setState(() {
          producto.disponible = value;
        });
      },
    );
  }
}
