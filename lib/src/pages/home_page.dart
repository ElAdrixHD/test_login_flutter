import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/login_bloc.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/pages/producto_page.dart';
import 'package:form_validation/src/providers/productos_providers.dart';

class HomePage extends StatefulWidget {
  static final route = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final providers = new ProductosProviders();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: _crearListado(),
      floatingActionButton: _crearFAB(context),
    );
  }

  Widget _crearFAB(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, ProductPage.route),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: providers.getProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i ){
                return _crearItem(context, snapshot.data[i]);
              },
          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Dismissible(
        onDismissed: (direction){
          if(direction == DismissDirection.startToEnd){
            providers.deleteProducto(data.id);
          }
        },
        key: UniqueKey(),
        background: Container(color: Colors.red,child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(children: <Widget>[Icon(Icons.delete)],),
        ),),
        secondaryBackground: Container(color: Colors.green, child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(children: <Widget>[Icon(Icons.save)],mainAxisAlignment: MainAxisAlignment.end,),
        ),),
        child: ListTile(
          title: Text(data.title),
          subtitle: Text(data.id.toString()),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: (){
            Navigator.pushNamed(context, ProductPage.route, arguments: data).then((value) {
              setState((){});
            });
          },
        ),
      ),
    );
  }
}
