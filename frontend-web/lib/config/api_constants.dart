/// API configuration constants for the Flutter web frontend
class ApiConstants {
  ApiConstants._();

  /// Base URL for the API Gateway endpoint (build-time overridable)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com',
  );

  /// Request timeout in seconds
  static const int requestTimeoutSeconds = 60;

  /// Resource timeout in seconds
  static const int resourceTimeoutSeconds = 120;

  /// Content type for API requests
  static const String contentType = 'application/json';

  /// Authorization header prefix
  static const String authorizationPrefix = 'Bearer ';

  /// Edit status polling interval in milliseconds
  static const int editPollIntervalMs = 2000;

  /// Maximum number of edit status polls (2 min timeout)
  static const int maxEditPolls = 60;
}

/// Input validation constants
class ValidationConstants {
  ValidationConstants._();

  /// Maximum allowed length for findings text
  static const int maxFindingsLength = 50000;

  /// Warning threshold for findings length (show warning when approaching limit)
  static const int findingsWarningThreshold = 45000;

  /// Maximum allowed length for preference text.
  /// Matches the backend cap (MAX_IMPRESSION_LENGTH = 10000) in
  /// backend/shared/validation_limits.py via lambda MAX_PREFERENCE_TEXT_LENGTH.
  static const int maxPreferenceLength = 10000;
}

/// Timing constants for UI feedback
class TimingConstants {
  TimingConstants._();

  /// Delay before dismissing success messages (seconds)
  static const double successMessageDismissDelay = 4.0;

  /// Timer update interval for progress display (seconds)
  static const double timerUpdateInterval = 0.1;

  /// Short delay between phase transitions (milliseconds)
  static const int phaseDelayShortMs = 500;

  /// Long delay between phase transitions (milliseconds)
  static const int phaseDelayLongMs = 1500;

  /// Micro animation duration for hover/tap effects (milliseconds)
  static const int microAnimationMs = 150;

  /// Standard transition duration for page fades, expand/collapse (milliseconds)
  static const int standardTransitionMs = 200;

  /// Medium transition duration for stepper phases, message slide (milliseconds)
  static const int mediumTransitionMs = 300;

  /// Floating icon full cycle duration (milliseconds)
  static const int floatingCycleDurationMs = 3000;

  /// Pulsing button glow full cycle duration (milliseconds)
  static const int pulsingCycleDurationMs = 2000;

  /// Onboarding page swipe transition duration (milliseconds)
  static const int onboardingPageTransitionMs = 300;
}
