import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/productos_bloc.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/utils/utils.dart' as util;
import 'package:image_picker/image_picker.dart';

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
  ProductosBloc bloc;
  File photo;

  @override
  Widget build(BuildContext context) {
    bloc = Provider.productosBloc(context);
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
            onPressed: ()=> _procesarImagen(ImageSource.gallery),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: ()=>_procesarImagen(ImageSource.camera),
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
                _mostrarFoto(),
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

  void _submit() async{
     if(!formKey.currentState.validate()) return;

     formKey.currentState.save();

     setState(() {
       _guardando = true;
     });

     if(photo != null){
       producto.url = await bloc.subirFoto(photo);
     }

     if(producto.id == null){
       bloc.agregarProducto(producto);
       setState(() {
         _guardando = false;
       });
       _snackbar("Registro Creado");
       Navigator.pop(context);
     }else{
       bloc.editarProducto(producto);
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

  _mostrarFoto(){
    if(producto.url != null){
      return FadeInImage(image: NetworkImage(producto.url),fit: BoxFit.cover, height: 300.0, placeholder: AssetImage("assets/jar-loading.gif"),);
    }else{
      return (photo == null) ? Image(
        image: AssetImage('assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      ) : Image.file(
        File(photo.path),
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }


  _procesarImagen(ImageSource tipo)async {
    final _picker = ImagePicker();
    final _pickerPhoto = await _picker.getImage(source: tipo);

    photo = File(_pickerPhoto.path);

    if(photo != null){
      producto.url = null;
    }

    setState(() {});
  }
}
