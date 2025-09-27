import '../models/pet.dart';
import '../services/petService.dart';


class Petcontroller {
  final Petservice petservice = Petservice();

 Future<List<Pet>> listarPets({String? campo, String? valor}) {
    final filtros = (campo != null && valor != null && valor.isNotEmpty)
        ? {campo: valor}
        : null;
    return petservice.getPets(filtros: filtros);
  }
  
  Future<Pet> adicionarPet(Pet pet) {
    return petservice.createPet(pet);
  }
  Future<void> removerPet(int id) {
    return petservice.deletePet(id);
  }
  Future<Pet> atualizarPet(Pet pet) {
    return petservice.updatePet(pet);
  }
  

}
