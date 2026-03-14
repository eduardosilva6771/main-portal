import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'config/app_config.dart';
import 'screens/loading_screen.dart';
import 'screens/home_screen.dart';

class EntryTypePortalApp extends StatelessWidget {
  const EntryTypePortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Entry Type Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
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
  UserProfile? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _auth0 = Auth0Web(AppConfig.auth0Domain, AppConfig.auth0ClientId);
    _initialize();
  }

  Future<void> _initialize() async {
    await _auth0.onLoad(audience: AppConfig.auth0Audience);
    final credentials = _auth0.credentials;
    if (credentials != null) {
      setState(() {
        _user = credentials.user;
        _isLoading = false;
      });
    } else {
      await _auth0.loginWithRedirect(
        redirectUrl: AppConfig.redirectUri,
        audience: AppConfig.auth0Audience,
      );
    }
  }

  Future<void> _logout() async {
    await _auth0.logout(returnToUrl: AppConfig.loginPortalUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const LoadingScreen();
    return HomeScreen(user: _user!, onLogout: _logout);
  }
}
