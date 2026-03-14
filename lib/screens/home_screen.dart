// This file is web-only; auth0_flutter_web is web-specific.

import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Auth0Web _auth0 = Auth0Web(AppConfig.auth0Domain, AppConfig.auth0ClientId);

  UserProfile? _user;
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(label: 'Inicio', icon: Icons.home_outlined, selectedIcon: Icons.home),
    _NavItem(label: 'Centro de Custo', icon: Icons.account_balance_outlined, selectedIcon: Icons.account_balance),
    _NavItem(label: 'Inquilinos', icon: Icons.people_outline, selectedIcon: Icons.people),
    _NavItem(label: 'Tipos de Lancamento', icon: Icons.category_outlined, selectedIcon: Icons.category),
    _NavItem(label: 'Formas de Pagamento', icon: Icons.payment_outlined, selectedIcon: Icons.payment),
  ];

  static const List<String> _moduleUrls = [
    '',
    AppConfig.costCenterPortalUrl,
    AppConfig.tenantPortalUrl,
    AppConfig.entryTypePortalUrl,
    AppConfig.paymentMethodPortalUrl,
  ];

  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  Future<void> _handleCallback() async {
    try {
      await _auth0.onLoad();
      final hasValidCredentials = await _auth0.hasValidCredentials();

      UserProfile? user;
      if (hasValidCredentials) {
        final credentials = await _auth0.credentials();
        user = credentials.user;
      }

      setState(() {
        _user = user;
        _isLoading = false;
      });

      if (_user == null) {
        await _redirectToLogin();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      await _redirectToLogin();
    }
  }

  Future<void> _redirectToLogin() async {
    await launchUrl(
      Uri.parse(AppConfig.loginPortalUrl),
      webOnlyWindowName: '_self',
    );
  }

  Future<void> _logout() async {
    final returnTo = AppConfig.loginPortalUrl.replaceAll(RegExp(r'/$'), '');
    await _auth0.logout(returnToUrl: returnTo);
  }

  Future<void> _openModule(int index) async {
    if (index == 0) return;
    final url = _moduleUrls[index];
    if (url.isNotEmpty) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const _LoadingGate();
    }

    if (_user == null) {
      return _ErrorGate(error: _error);
    }

    return _PortalShell(
      user: _user!,
      selectedIndex: _selectedIndex,
      navItems: _navItems,
      onNavSelected: (index) {
        if (index == 0) {
          setState(() => _selectedIndex = 0);
        } else {
          _openModule(index);
        }
      },
      onLogout: _logout,
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

class _LoadingGate extends StatelessWidget {
  const _LoadingGate();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4F7FB),
      body: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            color: Color(0xFF0F4AB4),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}

class _ErrorGate extends StatelessWidget {
  final String? error;

  const _ErrorGate({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: error != null
              ? Text(
                  error!,
                  style: const TextStyle(color: Color(0xFF952424)),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _PortalShell extends StatelessWidget {
  final UserProfile user;
  final int selectedIndex;
  final List<_NavItem> navItems;
  final ValueChanged<int> onNavSelected;
  final VoidCallback onLogout;

  const _PortalShell({
    required this.user,
    required this.selectedIndex,
    required this.navItems,
    required this.onNavSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'MAIN PORTAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: Colors.brown.shade700,
                    ),
                  ),
                  const Text(
                    'Workspace',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF23190F),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'Portal principal',
                style: TextStyle(fontSize: 14, color: Color(0xFF586781)),
              ),
              const SizedBox(width: 16),
              _UserMenu(user: user, onLogout: onLogout),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFD8E0EC)),
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Colors.white,
            selectedIndex: selectedIndex,
            onDestinationSelected: onNavSelected,
            labelType: NavigationRailLabelType.all,
            destinations: navItems
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          Container(width: 1, color: const Color(0xFFD8E0EC)),
          const Expanded(
            child: SizedBox.expand(),
          ),
        ],
      ),
    );
  }
}

class _UserMenu extends StatefulWidget {
  final UserProfile user;
  final VoidCallback onLogout;

  const _UserMenu({required this.user, required this.onLogout});

  @override
  State<_UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<_UserMenu> {
  bool _open = false;

  String get _displayName =>
      widget.user.email ?? widget.user.name ?? 'Usuário';

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFD8E0EC)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          onPressed: () => setState(() => _open = !_open),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline, size: 18, color: Color(0xFF3B4D68)),
              const SizedBox(width: 6),
              Text(
                _displayName,
                style: const TextStyle(fontSize: 13, color: Color(0xFF3B4D68)),
              ),
            ],
          ),
        ),
        if (_open)
          Positioned(
            right: 0,
            top: 38,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 260,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD8E0EC)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _displayName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5A6881),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ambiente autenticado',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8A96AE),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEBC5C5)),
                        backgroundColor: const Color(0xFFFFF5F5),
                        foregroundColor: const Color(0xFF8A2E2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        minimumSize: const Size.fromHeight(36),
                      ),
                      onPressed: widget.onLogout,
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
