import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<dynamic> userList = [];

  // Método para fazer a requisição HTTP e buscar os dados
  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      // Decodifica o corpo da resposta JSON e armazena na lista
      final jsonResponse = json.decode(response.body);
      setState(() {
        userList = jsonResponse;
      });
    } else {
      // Se houve algum erro na requisição, imprime no console
      print('Erro na requisição: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Chama a função de buscar usuários na inicialização
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumo de API - Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Usuários'),
        ),
        body: ListView.builder(
          itemCount: userList.length, // Tamanho da lista de usuários
          itemBuilder: (context, index) {
            final user = userList[index];
            // Alterna as cores de fundo: cinza para ímpares, branco para pares
            final backgroundColor = (index % 2 == 0) ? Colors.white : Colors.grey[300];

            return Container(
              color: backgroundColor, // Aplica a cor de fundo alternada
              padding: const EdgeInsets.all(16.0), // Espaçamento interno
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Margem entre os itens
              child: ListTile(
                title: Text('${user['id']} - ${user['name']}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Usuário: ${user['username']}'),
                    Text('E-mail: ${user['email']}'),
                    Text('Telefone: ${user['phone']}'),
                    Text('Endereço: ${user['address']['street']}, ${user['address']['suite']}, ${user['address']['city']}'),
                    Text('Website: ${user['website']}'),
                    Text('Empresa: ${user['company']['name']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
