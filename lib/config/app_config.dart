class AppConfig {
  AppConfig._();

  static const auth0Domain = String.fromEnvironment(
    'AUTH0_DOMAIN',
    defaultValue: 'dev-usvbyuppee5767fg.us.auth0.com',
  );

  static const auth0ClientId = String.fromEnvironment(
    'AUTH0_CLIENT_ID',
    defaultValue: 'B4pqqYpFZYQN6U7FMaV5NNKU5Nbmn3t1',
  );

  static const auth0Audience = String.fromEnvironment(
    'AUTH0_AUDIENCE',
    defaultValue: 'http://localhost:3000',
  );

  static const loginPortalUrl = String.fromEnvironment(
    'LOGIN_PORTAL_URL',
    defaultValue: 'http://localhost:5172/',
  );

  static const costCenterPortalUrl = String.fromEnvironment(
    'COST_CENTER_PORTAL_URL',
    defaultValue: 'http://localhost:5173/',
  );

  static const tenantPortalUrl = String.fromEnvironment(
    'TENANT_PORTAL_URL',
    defaultValue: 'http://localhost:5174/',
  );

  static const entryTypePortalUrl = String.fromEnvironment(
    'ENTRY_TYPE_PORTAL_URL',
    defaultValue: 'http://localhost:5176/',
  );

  static const paymentMethodPortalUrl = String.fromEnvironment(
    'PAYMENT_METHOD_PORTAL_URL',
    defaultValue: 'http://localhost:5175/',
  );
}
