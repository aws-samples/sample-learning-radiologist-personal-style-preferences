// Amplify configuration for Cognito authentication.
// Values can be overridden at build time via --dart-define flags:
//   flutter build web --dart-define=COGNITO_POOL_ID=... --dart-define=COGNITO_CLIENT_ID=... --dart-define=AWS_REGION=...

/// Cognito configuration values (build-time overridable with defaults)
class CognitoConfig {
  CognitoConfig._();

  static const String userPoolId = String.fromEnvironment(
    'COGNITO_POOL_ID',
    defaultValue: 'us-east-1_XXXXXXXXX',
  );
  static const String appClientId = String.fromEnvironment(
    'COGNITO_CLIENT_ID',
    defaultValue: 'XXXXXXXXXXXXXXXXXXXXXXXXXX',
  );
  static const String region = String.fromEnvironment(
    'AWS_REGION',
    defaultValue: 'us-east-1',
  );
}

/// Amplify JSON config string built from CognitoConfig values
String get amplifyConfig => '''{
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify-cli/0.1.0",
        "Version": "0.1.0",
        "IdentityManager": {
          "Default": {}
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "${CognitoConfig.userPoolId}",
            "AppClientId": "${CognitoConfig.appClientId}",
            "Region": "${CognitoConfig.region}"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH"
          }
        }
      }
    }
  }
}''';
