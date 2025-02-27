import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDi7GvH_8fgdcxOcRr4Xr59-P5tuGxQEeo",
      appId: "1:992531166009:android:ad679ac88cb0c6baa96ee8",
      messagingSenderId: "992531166009",
      projectId: "conexaofirebase1-376ff",
      databaseURL: "https://conexaofirebase1-376ff-default-rtdb.firebaseio.com/",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? _codigo;
  String? _descricao;
  String? _valor;
  TextEditingController _codigoController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCodigo();
    _getDescricao();
    _getValor();
  }

  Future<void> _getCodigo() async {
    final event = await _database.child('codigo').once();
    setState(() {
      _codigo = event.snapshot.value?.toString();
    });
  }
  Future<void> _getDescricao() async {
    final event = await _database.child('descricao').once();
    setState(() {
      _descricao = event.snapshot.value?.toString();
    });
  }
  Future<void> _getValor() async {
    final event = await _database.child('valor').once();
    setState(() {
      _valor = event.snapshot.value?.toString();
    });
  }

  Future<void> _atualizarProduto() async {
    if (_valorController.text.isNotEmpty) {
      await _database.child('valor').set(_valorController.text);
      _getValor(); 
      _valorController.clear(); 
    }

    if(_codigoController.text.isNotEmpty){
      await _database.child('codigo').set(_codigoController.text);
      _getCodigo();
      _codigoController.clear();
    }

    if(_descricaoController.text.isNotEmpty){
      await _database.child('descricao').set(_descricaoController.text);
      _getDescricao();
      _descricaoController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Produtos")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _codigo == null
                  ? CircularProgressIndicator()
                  : Text("Código: $_codigo, Descrição: $_descricao, Valor: $_valor"),
              SizedBox(height: 20),
              TextField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: "Novo Código",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: "Nova Descrição",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: "Novo Valor",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _atualizarProduto,
                child: Text("Atualizar Produto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}