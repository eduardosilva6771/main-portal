// This file is web-only; auth0_flutter_web is web-specific.

import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';

// ── Palette ────────────────────────────────────────────────────────────────
const _kPrimary = Color(0xFF007172);
const _kPrimaryLight = Color(0xFF009A9B);
const _kAccent = Color(0xFFFF9100);
const _kBackground = Color(0xFFF0F5F5);
const _kSurface = Colors.white;
const _kBorder = Color(0xFFDDE8E8);
const _kTextDark = Color(0xFF1C3535);
const _kTextLight = Color(0xFF6B8A8A);
const _kDanger = Color(0xFFB71C1C);
const _kDangerLight = Color(0xFFFFEBEE);
const _kSidebarBg = Color(0xFF004748);

// ── Responsive breakpoints ─────────────────────────────────────────────────
const _kBreakpointLarge = 900.0;
const _kGridBreakpointWide = 800.0;
const _kGridBreakpointMedium = 480.0;

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

  static const List<_ModuleCard> _modules = [
    _ModuleCard(
      label: 'Centro de Custo',
      description: 'Gerencie centros de custo e alocações financeiras.',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF007172),
      urlIndex: 0,
    ),
    _ModuleCard(
      label: 'Inquilinos',
      description: 'Cadastro e gestão de inquilinos e contratos.',
      icon: Icons.people_alt_rounded,
      color: Color(0xFFFF9100),
      urlIndex: 1,
    ),
    _ModuleCard(
      label: 'Tipos de Lançamento',
      description: 'Configure categorias e tipos de lançamentos contábeis.',
      icon: Icons.category_rounded,
      color: Color(0xFF004748),
      urlIndex: 2,
    ),
    _ModuleCard(
      label: 'Formas de Pagamento',
      description: 'Administre formas e métodos de pagamento aceitos.',
      icon: Icons.payment_rounded,
      color: Color(0xFFE65100),
      urlIndex: 3,
    ),
  ];

  static const List<String> _moduleUrls = [
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
    final returnTo = AppConfig.loginPortalUrl.replaceAll(RegExp(r'/$'), '');
    await _auth0.logout(returnToUrl: returnTo);
  }

  Future<void> _openModule(int urlIndex) async {
    final url = _moduleUrls[urlIndex];
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
      modules: _modules,
      onModuleOpen: _openModule,
      onLogout: _logout,
    );
  }
}

// ── Data models ────────────────────────────────────────────────────────────

class _ModuleCard {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final int urlIndex;

  const _ModuleCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.urlIndex,
  });
}

// ── Loading state ──────────────────────────────────────────────────────────

class _LoadingGate extends StatelessWidget {
  const _LoadingGate();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: _kBackground,
      body: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            color: _kPrimary,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}

// ── Error / unauthenticated state ──────────────────────────────────────────

class _ErrorGate extends StatelessWidget {
  final String? error;

  const _ErrorGate({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: error != null
              ? Text(
                  error!,
                  style: const TextStyle(color: _kDanger),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

// ── Main shell ─────────────────────────────────────────────────────────────

class _PortalShell extends StatelessWidget {
  final UserProfile user;
  final List<_ModuleCard> modules;
  final ValueChanged<int> onModuleOpen;
  final VoidCallback onLogout;

  const _PortalShell({
    required this.user,
    required this.modules,
    required this.onModuleOpen,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= _kBreakpointLarge;

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: _buildAppBar(context, showDrawerButton: !isWide),
      drawer: isWide
          ? null
          : Drawer(
              width: 240,
              child: _SidebarContent(
                modules: modules,
                onModuleOpen: onModuleOpen,
                onLogout: onLogout,
              ),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isWide)
            SizedBox(
              width: 240,
              child: _SidebarContent(
                modules: modules,
                onModuleOpen: onModuleOpen,
                onLogout: onLogout,
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _WelcomeBanner(user: user),
                        const SizedBox(height: 36),
                        const _SectionTitle(
                          icon: Icons.apps_rounded,
                          title: 'Módulos disponíveis',
                          subtitle: 'Acesse os portais do ecossistema dudxtec',
                        ),
                        const SizedBox(height: 20),
                        _ModulesGrid(modules: modules, onOpen: onModuleOpen),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context, {
    required bool showDrawerButton,
  }) {
    return AppBar(
      backgroundColor: _kPrimary,
      elevation: 0,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      leading: showDrawerButton
          ? Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            )
          : null,
      title: Padding(
        padding: EdgeInsets.only(
          left: showDrawerButton ? 4 : 20,
          right: 20,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.hub_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'dudxtec',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Main Portal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            _UserMenu(user: user, onLogout: onLogout),
          ],
        ),
      ),
    );
  }
}

// ── Sidebar ────────────────────────────────────────────────────────────────

class _SidebarContent extends StatelessWidget {
  final List<_ModuleCard> modules;
  final ValueChanged<int> onModuleOpen;
  final VoidCallback onLogout;

  const _SidebarContent({
    required this.modules,
    required this.onModuleOpen,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kSidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Brand header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _kAccent.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.hub_rounded,
                    color: _kAccent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'DUDXTEC',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: _kAccent,
                      ),
                    ),
                    Text(
                      'Main Portal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.10), height: 1),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
            child: Text(
              'MÓDULOS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Colors.white.withValues(alpha: 0.40),
              ),
            ),
          ),
          ...modules.map(
            (m) => _SidebarItem(
              icon: m.icon,
              label: m.label,
              onTap: () => onModuleOpen(m.urlIndex),
            ),
          ),
          const Spacer(),
          Divider(color: Colors.white.withValues(alpha: 0.10), height: 1),
          _SidebarItem(
            icon: Icons.logout_rounded,
            label: 'Sair',
            onTap: onLogout,
            isDestructive: true,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Sidebar item ───────────────────────────────────────────────────────────

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDestructive ? _kDanger : Colors.white;
    final hoverBg = widget.isDestructive
        ? _kDanger.withValues(alpha: 0.15)
        : _kAccent.withValues(alpha: 0.12);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: _hovered ? hoverBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered && !widget.isDestructive
                ? _kAccent.withValues(alpha: 0.30)
                : Colors.transparent,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 18,
                    color: _hovered && !widget.isDestructive
                        ? _kAccent
                        : baseColor.withValues(alpha: 0.75),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _hovered && !widget.isDestructive
                          ? Colors.white
                          : baseColor.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Welcome banner ─────────────────────────────────────────────────────────

class _WelcomeBanner extends StatelessWidget {
  final UserProfile user;

  const _WelcomeBanner({required this.user});

  String get _firstName {
    final name = user.name ?? user.email ?? 'Usuário';
    return name.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kPrimary, _kPrimaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _kPrimary.withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo, $_firstName!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user.email ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _kAccent.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _kAccent.withValues(alpha: 0.40),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, size: 14, color: _kAccent),
                      SizedBox(width: 6),
                      Text(
                        'Sessão autenticada',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _kAccent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: _kAccent.withValues(alpha: 0.30),
                width: 2,
              ),
            ),
            child: const Icon(Icons.person_rounded, size: 42, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ── Section title ──────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _kPrimary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _kPrimary, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _kTextDark,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: _kTextLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Modules grid ───────────────────────────────────────────────────────────

class _ModulesGrid extends StatelessWidget {
  final List<_ModuleCard> modules;
  final ValueChanged<int> onOpen;

  const _ModulesGrid({required this.modules, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final columns = w > _kGridBreakpointWide ? 4 : w > _kGridBreakpointMedium ? 2 : 1;
        final cardWidth = (w - (columns - 1) * 16) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: modules
              .map(
                (m) => SizedBox(
                  width: cardWidth,
                  child: _ModuleTile(card: m, onOpen: () => onOpen(m.urlIndex)),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

// ── Module tile ────────────────────────────────────────────────────────────

class _ModuleTile extends StatefulWidget {
  final _ModuleCard card;
  final VoidCallback onOpen;

  const _ModuleTile({required this.card, required this.onOpen});

  @override
  State<_ModuleTile> createState() => _ModuleTileState();
}

class _ModuleTileState extends State<_ModuleTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered
                ? widget.card.color.withValues(alpha: 0.40)
                : _kBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? widget.card.color.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: _hovered ? 16 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: widget.onOpen,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.card.color.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.card.icon, color: widget.card.color, size: 24),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.card.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _kTextDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.card.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _kTextLight,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Acessar',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: widget.card.color,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: widget.card.color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── User menu ──────────────────────────────────────────────────────────────

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
      widget.user.name ?? widget.user.email ?? 'Usuário';

  String get _initials {
    final parts = _displayName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return _displayName.isNotEmpty ? _displayName[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: _kAccent.withValues(alpha: 0.25),
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: Text(
                    _displayName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _open ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white70,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        if (_open)
          Positioned(
            right: 0,
            top: 44,
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(14),
              shadowColor: _kPrimary.withValues(alpha: 0.20),
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _kSurface,
                  border: Border.all(color: _kBorder),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: _kPrimary.withValues(alpha: 0.10),
                          child: Text(
                            _initials,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _kPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _displayName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _kTextDark,
                                ),
                              ),
                              if (widget.user.email != null)
                                Text(
                                  widget.user.email!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: _kTextLight,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: _kBorder, height: 1),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _kDanger),
                          backgroundColor: _kDangerLight,
                          foregroundColor: _kDanger,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: widget.onLogout,
                        icon: const Icon(Icons.logout_rounded, size: 16),
                        label: const Text(
                          'Sair',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
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
