import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get auth0Domain =>
      dotenv.env['AUTH0_DOMAIN'] ?? 'dev-usvbyuppee5767fg.us.auth0.com';

  static String get auth0ClientId =>
      dotenv.env['AUTH0_CLIENT_ID'] ?? 'B4pqqYpFZYQN6U7FMaV5NNKU5Nbmn3t1';

  static String get auth0Audience =>
      dotenv.env['AUTH0_AUDIENCE'] ?? 'http://localhost:3000';

  static String get redirectUri =>
      dotenv.env['AUTH0_REDIRECT_URI'] ?? 'http://localhost:5176/';

  static String get loginPortalUrl =>
      dotenv.env['LOGIN_PORTAL_URL'] ?? 'http://localhost:5172/';

  static String get costCenterPortalUrl =>
      dotenv.env['COST_CENTER_PORTAL_URL'] ?? 'http://localhost:5173/';

  static String get tenantPortalUrl =>
      dotenv.env['TENANT_PORTAL_URL'] ?? 'http://localhost:5174/';

  static String get paymentMethodPortalUrl =>
      dotenv.env['PAYMENT_METHOD_PORTAL_URL'] ?? 'http://localhost:5175/';
}
