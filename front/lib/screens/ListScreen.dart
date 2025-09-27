import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../controllers/petController.dart';
import '../utills/dateUtills.dart';

class EditScreen extends StatefulWidget {
  final VoidCallback onBack;

  const EditScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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

  Future<void> _editarPet(Pet pet) async {
    try {
      await _controller.atualizarPet(pet);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Alterações salvas!")));
      _fetchPets(); 
    } catch (e) {
      print("Erro ao atualizar pet: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro ao atualizar pet: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Hospedagens"),
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

                            final nomeCtrl = TextEditingController(text: pet.nome_tutor);
                            final contatoCtrl =
                                TextEditingController(text: pet.contato_tutor);
                            final especieCtrl =
                                TextEditingController(text: pet.especie);
                            final racaCtrl = TextEditingController(text: pet.raca);
                            final dataEntradaCtrl = TextEditingController(
                                text:
                                    formatarDataParaExibicao(pet.data_entrada));
                            final dataSaidaCtrl = TextEditingController(
                                text: pet.data_saida != null
                                    ? formatarDataParaExibicao(pet.data_saida!)
                                    : '');

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ExpansionTile(
                                leading: Icon(
                                  pet.especie.toLowerCase() == 'cachorro'
                                      ? Icons.pets
                                      : Icons.pets_outlined,
                                  color: Colors.orange.shade700,
                                ),
                                title: Text(pet.nome_tutor),
                                subtitle: Text("Espécie: ${pet.especie}"),
                                childrenPadding: const EdgeInsets.all(12),
                                children: [
                                  _buildEditableField("Nome do Tutor", nomeCtrl,
                                      (val) => pet.nome_tutor = val),
                                  _buildEditableField("Contato", contatoCtrl,
                                      (val) => pet.contato_tutor = val),
                                  _buildEditableField("Espécie", especieCtrl,
                                      (val) => pet.especie = val),
                                  _buildEditableField("Raça", racaCtrl,
                                      (val) => pet.raca = val),
                                  _buildEditableField("Data Entrada", dataEntradaCtrl,
                                      (val) => pet.data_entrada = parseDataBR(val)),
                                  _buildEditableField("Data Saída", dataSaidaCtrl,
                                      (val) => pet.data_saida =
                                          val.isNotEmpty ? parseDataBR(val) : null),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => _editarPet(pet),
                                        child: const Text("Salvar"),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.orange.shade600),
                                      ),
                                      ElevatedButton(
                                        onPressed: widget.onBack,
                                        child: const Text("Sair"),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey.shade400),
                                      ),
                                    ],
                                  )
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

  Widget _buildEditableField(
      String label, TextEditingController controller, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
