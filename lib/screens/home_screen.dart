import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';

class EntryType {
  final String id;
  String name;
  String description;

  EntryType({required this.id, required this.name, required this.description});
}

class HomeScreen extends StatefulWidget {
  final UserProfile user;
  final Future<void> Function() onLogout;

  const HomeScreen({super.key, required this.user, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<EntryType> _entryTypes = [
    EntryType(id: '1', name: 'Receita', description: 'Entrada de recursos financeiros'),
    EntryType(id: '2', name: 'Despesa', description: 'Saída de recursos financeiros'),
    EntryType(id: '3', name: 'Transferência', description: 'Movimentação entre contas'),
  ];

  int _selectedNavIndex = 2;

  void _navigateTo(String url) {
    launchUrl(Uri.parse(url));
  }

  void _showEntryTypeDialog({EntryType? entryType}) {
    final nameController = TextEditingController(text: entryType?.name ?? '');
    final descController = TextEditingController(text: entryType?.description ?? '');
    final formKey = GlobalKey<FormState>();
    final isEditing = entryType != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Tipo de Lançamento' : 'Novo Tipo de Lançamento'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a descrição' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  if (isEditing) {
                    entryType.name = nameController.text.trim();
                    entryType.description = descController.text.trim();
                  } else {
                    _entryTypes.add(EntryType(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text.trim(),
                      description: descController.text.trim(),
                    ));
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text(isEditing ? 'Salvar' : 'Criar'),
          ),
        ],
      ),
    );
  }

  void _deleteEntryType(EntryType entryType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir o tipo "${entryType.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _entryTypes.remove(entryType));
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.user.email ?? widget.user.name ?? 'Usuário';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Type Portal'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(userName, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: widget.onLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedNavIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedNavIndex = index);
              switch (index) {
                case 0:
                  _navigateTo(AppConfig.costCenterPortalUrl);
                  break;
                case 1:
                  _navigateTo(AppConfig.tenantPortalUrl);
                  break;
                case 3:
                  _navigateTo(AppConfig.paymentMethodPortalUrl);
                  break;
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.account_balance),
                label: Text('Centro de Custo'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.business),
                label: Text('Inquilino'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.category),
                label: Text('Tipo de Lançamento'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.payment),
                label: Text('Forma de Pagamento'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipos de Lançamento',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _entryTypes.isEmpty
                        ? const Center(
                            child: Text('Nenhum tipo de lançamento cadastrado.'),
                          )
                        : ListView.separated(
                            itemCount: _entryTypes.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final entry = _entryTypes[index];
                              return ListTile(
                                leading: const Icon(Icons.label_outline),
                                title: Text(entry.name),
                                subtitle: Text(entry.description),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined),
                                      tooltip: 'Editar',
                                      onPressed: () => _showEntryTypeDialog(entryType: entry),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      tooltip: 'Excluir',
                                      onPressed: () => _deleteEntryType(entry),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEntryTypeDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Novo Tipo'),
      ),
    );
  }
}
