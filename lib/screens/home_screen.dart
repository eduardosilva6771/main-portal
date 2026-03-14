// This file is web-only; auth0_flutter_web is web-specific.

import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';

// ─── Design Tokens ───────────────────────────────────────────────────────────

const _kPrimary = Color(0xFF1A56DB);
const _kSidebarBg = Color(0xFF0F172A);
const _kBackground = Color(0xFFF1F5F9);
const _kSurface = Color(0xFFFFFFFF);
const _kBorder = Color(0xFFE2E8F0);
const _kText = Color(0xFF0F172A);
const _kTextMuted = Color(0xFF64748B);
const _kSidebarText = Color(0xFF94A3B8);
const _kSidebarTextActive = Color(0xFFFFFFFF);
const _kSidebarActiveBg = Color(0xFF1E293B);
const _kSidebarWidth = 240.0;

// ─── Module data ─────────────────────────────────────────────────────────────

class _Module {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final String url;

  const _Module({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.url,
  });

  Color colorWithOpacity(double opacity) =>
      Color.fromRGBO(color.red, color.green, color.blue, opacity);
}

const List<_Module> _kModules = [
  _Module(
    label: 'Centro de Custo',
    description: 'Gerencie centros de custo e alocações orçamentárias',
    icon: Icons.account_balance_outlined,
    color: Color(0xFF2563EB),
    url: AppConfig.costCenterPortalUrl,
  ),
  _Module(
    label: 'Inquilinos',
    description: 'Cadastro e gestão de inquilinos do sistema',
    icon: Icons.people_outline,
    color: Color(0xFF7C3AED),
    url: AppConfig.tenantPortalUrl,
  ),
  _Module(
    label: 'Tipos de Lançamento',
    description: 'Configure categorias de lançamentos contábeis',
    icon: Icons.category_outlined,
    color: Color(0xFF059669),
    url: AppConfig.entryTypePortalUrl,
  ),
  _Module(
    label: 'Formas de Pagamento',
    description: 'Gerencie métodos e condições de pagamento',
    icon: Icons.payment_outlined,
    color: Color(0xFFD97706),
    url: AppConfig.paymentMethodPortalUrl,
  ),
];

// ─── HomeScreen ───────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Auth0Web _auth0 =
      Auth0Web(AppConfig.auth0Domain, AppConfig.auth0ClientId);

  UserProfile? _user;
  bool _isLoading = true;
  String? _error;
  bool _authRedirectStarted = false;

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
        await _startLogin();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      await _redirectToLoginPortal();
    }
  }

  Future<void> _startLogin() async {
    if (_authRedirectStarted) return;
    _authRedirectStarted = true;

    final redirectUrl = '${Uri.base.origin}/';
    await _auth0.loginWithRedirect(
      redirectUrl: redirectUrl,
      audience: AppConfig.auth0Audience,
    );
  }

  Future<void> _redirectToLoginPortal() async {
    await launchUrl(
      Uri.parse(AppConfig.loginPortalUrl),
      webOnlyWindowName: '_self',
    );
  }

  Future<void> _logout() async {
    final returnTo =
        AppConfig.loginPortalUrl.replaceAll(RegExp(r'/$'), '');
    await _auth0.logout(returnToUrl: returnTo);
  }

  Future<void> _openModule(String url) async {
    if (url.isNotEmpty) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const _LoadingGate();
    if (_user == null) return _ErrorGate(error: _error);
    return _PortalShell(
      user: _user!,
      onModuleOpen: _openModule,
      onLogout: _logout,
    );
  }
}

// ─── Loading Gate ─────────────────────────────────────────────────────────────

// ── Loading state ──────────────────────────────────────────────────────────

class _LoadingGate extends StatelessWidget {
  const _LoadingGate();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: _kBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                color: _kPrimary,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Carregando...',
              style: TextStyle(color: _kTextMuted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error Gate ───────────────────────────────────────────────────────────────

class _ErrorGate extends StatelessWidget {
  final String? error;

  const _ErrorGate({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: error != null
              ? Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          error!,
                          style:
                              const TextStyle(color: Color(0xFF991B1B)),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

// ─── Portal Shell ─────────────────────────────────────────────────────────────

class _PortalShell extends StatelessWidget {
  final UserProfile user;
  final ValueChanged<String> onModuleOpen;
  final VoidCallback onLogout;

  const _PortalShell({
    required this.user,
    required this.onModuleOpen,
    required this.onLogout,
  });

  String get _displayName => user.name ?? user.email ?? 'Usuário';

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: Row(
        children: [
          _Sidebar(
            displayName: _displayName,
            onModuleOpen: onModuleOpen,
            onLogout: onLogout,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _WelcomeHero(
                          greeting: _greeting,
                          displayName: _displayName,
                        ),
                        const SizedBox(height: 40),
                        _ModuleGrid(onModuleOpen: onModuleOpen),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sidebar ─────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final String displayName;
  final ValueChanged<String> onModuleOpen;
  final VoidCallback onLogout;

  const _Sidebar({
    required this.displayName,
    required this.onModuleOpen,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kSidebarWidth,
      color: _kSidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SidebarBrand(),
          const SizedBox(height: 8),
          const _SidebarNavItem(
            icon: Icons.home_outlined,
            label: 'Início',
            selected: true,
          ),
          const SizedBox(height: 16),
          const _SidebarSectionLabel(title: 'MÓDULOS'),
          const SizedBox(height: 4),
          ..._kModules.map(
            (m) => _SidebarNavItem(
              icon: m.icon,
              label: m.label,
              onTap: () => onModuleOpen(m.url),
            ),
          ),
          const Spacer(),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: const Color(0xFF1E293B),
          ),
          _SidebarUser(displayName: displayName, onLogout: onLogout),
        ],
      ),
    );
  }
}

class _SidebarBrand extends StatelessWidget {
  const _SidebarBrand();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _kPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.hub_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'dudxtec',
              style: TextStyle(
                color: _kSidebarTextActive,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarSectionLabel extends StatelessWidget {
  final String title;

  const _SidebarSectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final showActive = widget.selected || _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: widget.selected
                ? _kSidebarActiveBg
                : _hovered
                    ? _kSidebarActiveBg
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18,
                color:
                    showActive ? _kSidebarTextActive : _kSidebarText,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: showActive
                        ? _kSidebarTextActive
                        : _kSidebarText,
                    fontSize: 14,
                    fontWeight: widget.selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
              if (widget.onTap != null)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _hovered ? 1.0 : 0.0,
                  child: const Icon(
                    Icons.open_in_new,
                    size: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarUser extends StatelessWidget {
  final String displayName;
  final VoidCallback onLogout;

  const _SidebarUser({
    required this.displayName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: _kPrimary,
                  child: Text(
                    displayName.isNotEmpty
                        ? displayName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _kSidebarTextActive,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        'Autenticado',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _SidebarNavItem(
            icon: Icons.logout,
            label: 'Sair',
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: _kSurface,
        border: Border(bottom: BorderSide(color: _kBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: const Row(
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              color: _kText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Welcome Hero ─────────────────────────────────────────────────────────────

class _WelcomeHero extends StatelessWidget {
  final String greeting;
  final String displayName;

  const _WelcomeHero({
    required this.greeting,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A56DB), Color(0xFF1340A0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting,',
                  style: const TextStyle(
                    color: Color(0xB3FFFFFF),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selecione um módulo abaixo para começar.',
                  style: TextStyle(
                    color: Color(0x99FFFFFF),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0x26FFFFFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.dashboard_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Module Grid ─────────────────────────────────────────────────────────────

class _ModuleGrid extends StatelessWidget {
  final ValueChanged<String> onModuleOpen;

  const _ModuleGrid({required this.onModuleOpen});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Módulos do Sistema',
          style: TextStyle(
            color: _kText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Acesse os módulos disponíveis na sua conta',
          style: TextStyle(color: _kTextMuted, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _kModules
              .map((m) => _ModuleCard(module: m, onOpen: onModuleOpen))
              .toList(),
        ),
      ],
    );
  }
}

// ─── Module Card ─────────────────────────────────────────────────────────────

class _ModuleCard extends StatefulWidget {
  final _Module module;
  final ValueChanged<String> onOpen;

  const _ModuleCard({required this.module, required this.onOpen});

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.module;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onOpen(m.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 240,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered ? m.colorWithOpacity(0.45) : _kBorder,
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: m.colorWithOpacity(0.14),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: m.colorWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(m.icon, color: m.color, size: 22),
              ),
              const SizedBox(height: 14),
              Text(
                m.label,
                style: const TextStyle(
                  color: _kText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                m.description,
                style: const TextStyle(
                  color: _kTextMuted,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Acessar módulo',
                    style: TextStyle(
                      color: m.color,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: m.color, size: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

