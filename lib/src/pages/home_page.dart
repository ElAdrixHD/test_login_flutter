import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/productos_bloc.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/pages/producto_page.dart';

class HomePage extends StatelessWidget {
  static final route = "/home";
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: _crearListado(productosBloc),
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

  Widget _crearListado(ProductosBloc bloc) {
    return StreamBuilder(
      stream: bloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
              padding: EdgeInsets.all(20.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i ){
                return _crearItem(bloc,context, snapshot.data[i]);
              },
          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Widget _crearItem(ProductosBloc bloc, BuildContext context, ProductoModel data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Dismissible(
        onDismissed: (direction){
          if(direction == DismissDirection.startToEnd){
            bloc.borrarProducto(data.id);
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
        child: Card(
          child: Column(
            children: <Widget>[
              FadeInImage(image: NetworkImage(data.url),fit: BoxFit.cover, height: 300.0, placeholder: AssetImage("assets/jar-loading.gif"),),
              ListTile(
                title: Text(data.title),
                subtitle: Text(data.id.toString()),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                  Navigator.pushNamed(context, ProductPage.route, arguments: data);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
