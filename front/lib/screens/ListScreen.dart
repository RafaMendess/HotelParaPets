import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../controllers/petController.dart';
import '../utills/dateUtills.dart';

class ListScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ListScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'nome_tutor';

  final Petcontroller _controller = Petcontroller();
  List<Pet> _pets = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  Future<void> _fetchPets() async {
    setState(() => _isLoading = true);
    try {
      String? valorFormatado = _searchController.text.isEmpty
          ? null
          : (_selectedFilter == 'data_entrada' || _selectedFilter == 'data_saida')
              ? formatarDataParaBackend(_searchController.text)
              : _searchController.text;

      final pets = await _controller.listarPets(
        campo: _searchController.text.isEmpty ? null : _selectedFilter,
        valor: valorFormatado,
      );

      setState(() => _pets = pets);
    } catch (e) {
      print("Erro ao buscar pets: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar pets: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removePet(Pet pet) async {
    try {
      await _controller.removerPet(pet.id);
      setState(() {
        _pets.remove(pet);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hospedagem de ${pet.nome_tutor} excluída")),
      );
    } catch (e) {
      print("Erro ao deletar pet: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao deletar pet: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Hospedagens"),
        backgroundColor: Colors.orange.shade600,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _fetchPets(),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: const [
                    DropdownMenuItem(value: 'nome_tutor', child: Text('Nome do tutor')),
                    DropdownMenuItem(value: 'contato_tutor', child: Text('Contato')),
                    DropdownMenuItem(value: 'especie', child: Text('Espécie')),
                    DropdownMenuItem(value: 'raca', child: Text('Raça')),
                    DropdownMenuItem(value: 'data_entrada', child: Text('Data de Entrada')),
                    DropdownMenuItem(value: 'data_saida', child: Text('Data de Saída')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedFilter = value);
                      _fetchPets();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _pets.isEmpty
                      ? const Center(child: Text("Nenhum pet encontrado"))
                      : ListView.builder(
                          itemCount: _pets.length,
                          itemBuilder: (context, index) {
                            final pet = _pets[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: ExpansionTile(
                                leading: Icon(
                                  pet.especie.toLowerCase() == 'cachorro'
                                      ? Icons.pets
                                      : Icons.pets_outlined,
                                  color: Colors.orange.shade700,
                                ),
                                title: Text(
                                  pet.nome_tutor,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("Espécie: ${pet.especie}"),
                                childrenPadding: const EdgeInsets.all(12),
                                children: [
                                  _buildDetailRow("Tutor", pet.nome_tutor),
                                  _buildDetailRow("Contato", pet.contato_tutor),
                                  _buildDetailRow("Raça", pet.raca),
                                  _buildDetailRow(
                                      "Data Entrada",
                                      formatarDataParaExibicao(pet.data_entrada)),
                                  _buildDetailRow(
                                    "Data Saída",
                                    pet.data_saida != null
                                        ? formatarDataParaExibicao(pet.data_saida!)
                                        : "Ainda hospedado",
                                  ),
                                  _buildDetailRow(
                                      "Diárias até agora", "${pet.diariasAteAgora}"),
                                  _buildDetailRow(
                                    "Diárias previstas",
                                    pet.diariasPrevistas?.toString() ?? "—",
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _removePet(pet),
                                      icon: const Icon(Icons.delete, color: Colors.white),
                                      label: const Text("Excluir"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}