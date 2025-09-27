import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet.dart';


class Petservice {
  final String baseUrl = 'http://localhost:3000/pets';

  Future<List<Pet>> getPets({Map<String, String>? filtros}) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: filtros);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar pets");
    }
  }

  Future<Pet> createPet(Pet pet) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );

    if (response.statusCode == 201) {
      return Pet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Erro ao criar pet");
    }
  }

  Future<void> deletePet(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar pet");
    }
  }

   Future<Pet> updatePet(Pet pet) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${pet.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );

    if (response.statusCode == 200) {
      return Pet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Erro ao atualizar pet");
    }
  }

}