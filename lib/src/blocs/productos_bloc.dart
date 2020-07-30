import 'dart:io';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/productos_providers.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc{

  final _productosController = BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = BehaviorSubject<bool>();

  final _productosProvider = ProductosProviders();

  Stream<List<ProductoModel>> get productosStream => _productosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargarProductos() async {
    final productos = await _productosProvider.getProductos();
    _productosController.sink.add(productos);
  }

  void agregarProducto(ProductoModel productoModel) async{
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(productoModel);
    _cargandoController.sink.add(false);
    cargarProductos();
  }

  void editarProducto(ProductoModel productoModel) async{
    _cargandoController.sink.add(true);
    await _productosProvider.actualizarProducto(productoModel);
    _cargandoController.sink.add(false);
    cargarProductos();
  }

  void borrarProducto(String id) async{
    await _productosProvider.deleteProducto(id);
  }

  Future<String> subirFoto(File photo) async{
    _cargandoController.sink.add(true);
    final url = await _productosProvider.subirImagen(photo);
    _cargandoController.sink.add(false);
    return url;
  }

  dispose(){
    _productosController?.close();
    _cargandoController?.close();
  }
}