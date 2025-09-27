import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../controllers/petController.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onBack;

  const RegisterScreen({super.key, required this.onBack});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  final TextEditingController _racaController = TextEditingController();
  DateTime? _dataEntrada;
  DateTime? _dataSaida;
  String? _especie;

  final Petcontroller controller = Petcontroller();
  bool _loading = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: const Text("Cadastrar Nova Hospedagem"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Nome do Tutor
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: "Nome do Tutor *",
                        ),
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? "Campo obrigatório"
                                : null,
                      ),
                      const SizedBox(height: 12),

                      // Contato
                      TextFormField(
                        controller: _contatoController,
                        decoration: const InputDecoration(
                          labelText: "Contato do Tutor *",
                        ),
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? "Campo obrigatório"
                                : null,
                      ),
                      const SizedBox(height: 12),

                      // Raça
                      TextFormField(
                        controller: _racaController,
                        decoration: const InputDecoration(
                          labelText: "Raça *",
                        ),
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? "Campo obrigatório"
                                : null,
                      ),
                      const SizedBox(height: 12),

                      // Espécie
                      DropdownButtonFormField<String>(
                        value: _especie,
                        decoration: const InputDecoration(
                          labelText: "Espécie *",
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: "Cachorro", child: Text("Cachorro")),
                          DropdownMenuItem(
                              value: "Gato", child: Text("Gato")),
                        ],
                        onChanged: (value) => setState(() => _especie = value),
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? "Campo obrigatório"
                                : null,
                      ),
                      const SizedBox(height: 12),

                      // Data de Entrada
                      TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Data de Entrada *",
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() => _dataEntrada = date);
                          }
                        },
                        controller: TextEditingController(
                          text: _dataEntrada == null
                              ? ""
                              : _dataEntrada!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                        ),
                        validator: (_) => _dataEntrada == null
                            ? "Campo obrigatório"
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Data de Saída (opcional)
                      TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Data de Saída (opcional)",
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _dataEntrada ?? DateTime.now(),
                            firstDate: _dataEntrada ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() => _dataSaida = date);
                          }
                        },
                        controller: TextEditingController(
                          text: _dataSaida == null
                              ? ""
                              : _dataSaida!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botões
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _loading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final pet = Pet(
                                          id: 0, // backend vai gerar
                                          nome_tutor: _nomeController.text,
                                          contato_tutor:
                                              _contatoController.text,
                                          especie: _especie!,
                                          raca: _racaController.text,
                                          data_entrada: _dataEntrada!,
                                          data_saida: _dataSaida,
                                        );

                                        setState(() => _loading = true);
                                        try {
                                          await controller.adicionarPet(pet);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Hospedagem cadastrada com sucesso!")),
                                          );

                                          widget.onBack();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Erro ao cadastrar: $e")),
                                          );
                                        } finally {
                                          setState(() => _loading = false);
                                        }
                                      }
                                    },
                              icon: const Icon(Icons.save),
                              label: _loading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text("Criar"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: widget.onBack,
                              child: const Text("Sair"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
