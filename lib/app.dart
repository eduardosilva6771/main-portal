// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MainPortalApp extends StatelessWidget {
  const MainPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0f4ab4),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Auth0Web _auth0;
  Credentials? _credentials;
  bool _isLoading = true;
  String? _error;

  String get _loginPortalUrl =>
      dotenv.maybeGet('AUTH0_LOGIN_PORTAL_URL') ?? 'http://localhost:5172/';

  String get _loginRedirectUrl =>
      _loginPortalUrl.replaceAll(RegExp(r'/$'), '');

  @override
  void initState() {
    super.initState();
    _auth0 = Auth0Web(
      dotenv.maybeGet('AUTH0_DOMAIN') ??
          'dev-usvbyuppee5767fg.us.auth0.com',
      dotenv.maybeGet('AUTH0_CLIENT_ID') ??
          'B4pqqYpFZYQN6U7FMaV5NNKU5Nbmn3t1',
    );
    _handleLoad();
  }

  Future<void> _handleLoad() async {
    try {
      await _auth0.onLoad(
        audience: dotenv.maybeGet('AUTH0_AUDIENCE') ?? 'http://localhost:3000',
      );
      final hasCredentials = await _auth0.hasValidCredentials();
      if (!hasCredentials) {
        html.window.location.assign(_loginPortalUrl);
        return;
      }
      final creds = await _auth0.credentials();
      if (!mounted) return;
      setState(() {
        _credentials = creds;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await _auth0.logout(returnToUrl: _loginRedirectUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const _LoadingScreen();
    }

    if (_credentials == null) {
      return _ErrorScreen(error: _error);
    }

    return PortalShell(
      credentials: _credentials!,
      onLogout: _logout,
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4F7FB),
      body: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0f4ab4)),
          ),
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: error != null
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Color(0xFF952424)),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class PortalShell extends StatelessWidget {
  const PortalShell({
    super.key,
    required this.credentials,
    required this.onLogout,
  });

  final Credentials credentials;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final userName = credentials.user.email ??
        credentials.user.name ??
        'Usuário';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MAIN PORTAL',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: Color(0xFF6e4220),
                ),
              ),
              Text(
                'Workspace',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23190f),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5a6881),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ambiente autenticado',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF62708a),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: onLogout,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0f4ab4),
                    side: const BorderSide(color: Color(0xFFbfd1f4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Sair'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: const SizedBox.expand(),
    );
  }
}
