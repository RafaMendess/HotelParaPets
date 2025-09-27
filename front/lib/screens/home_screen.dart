import 'package:flutter/material.dart';
import 'RegisterScreen.dart';
import 'ListScreen.dart';
import 'EditScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gradientBackground = BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.orange.shade50, Colors.pink.shade50],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );

    final _ = BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, Colors.white],
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.orange.shade100,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    );

    return Scaffold(
      body: Container(
        decoration: gradientBackground,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.orange.shade400, Colors.pink.shade400],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.favorite, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bem-vindo ao Hotel de Pets',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Cuidando com carinho dos seus companheiros',
                      style: TextStyle(fontSize: 14, color: Colors.orangeAccent),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Buttons
                Column(
                  children: [
                    buildActionCard(
                      context,
                      title: 'Cadastrar PET',
                      subtitle: 'Nova hospedagem',
                      icon: Icons.add_circle,
                      gradientColors: [Colors.green.shade500, Colors.green.shade600],
                       onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen(onBack: () {
                          Navigator.pop(context);
                        })),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildActionCard(
                      context,
                      title: 'Listar Hospedagens',
                      subtitle: 'Ver todos os pets',
                      icon: Icons.list,
                      gradientColors: [Colors.blue.shade500, Colors.blue.shade600],
                      onTap: () => Navigator.push(
                       context,
                        MaterialPageRoute(builder: (_) =>  ListScreen(onBack: () {
                          Navigator.pop(context);
                        })),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildActionCard(
                      context,
                      title: 'Editar Hospedagem',
                      subtitle: 'Modificar dados',
                      icon: Icons.edit,
                      gradientColors: [Colors.purple.shade500, Colors.purple.shade600],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditScreen(onBack: () {
                          Navigator.pop(context);
                        })),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActionCard(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required List<Color> gradientColors,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 3)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
