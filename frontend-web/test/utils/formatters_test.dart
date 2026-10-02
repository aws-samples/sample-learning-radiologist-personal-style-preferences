import 'package:flutter_test/flutter_test.dart';
import 'package:report_preferences_web/utils/formatters.dart';

void main() {
  // ============================================================================
  // formatTimestamp
  // ============================================================================

  group('formatTimestamp', () {
    test('should format Unix timestamp to readable date', () {
      // 1700000000 = Nov 14, 2023 (UTC)
      final result = formatTimestamp(1700000000);

      // DateFormat.yMMMd() produces locale-dependent format like "Nov 14, 2023"
      expect(result, contains('2023'));
      expect(result, contains('14'));
    });

    test('should handle zero timestamp (epoch)', () {
      final result = formatTimestamp(0);

      // Jan 1, 1970 in local time
      expect(result, contains('1970'));
    });

    test('should handle recent timestamp', () {
      // 1708214400 = Feb 18, 2024 (UTC)
      final result = formatTimestamp(1708214400);

      expect(result, contains('2024'));
    });
  });

  // ============================================================================
  // formatTimestampWithTime
  // ============================================================================

  group('formatTimestampWithTime', () {
    test('should include date and time components', () {
      final result = formatTimestampWithTime(1700000000);

      // Format: M/D/YYYY HH:mm
      // Should contain year and a colon for time separator
      expect(result, contains('2023'));
      expect(result, contains(':'));
    });

    test('should pad minutes with leading zero', () {
      // Pick a timestamp where minutes < 10
      // 1700000400 = adds 400 seconds = 6 minutes and 40 seconds after base
      final result = formatTimestampWithTime(1700000400);

      // The result should contain a colon followed by two digits
      final timeMatch = RegExp(r'\d+:\d{2}$').hasMatch(result);
      expect(timeMatch, isTrue,
          reason: 'Minutes should be zero-padded to 2 digits');
    });
  });

  // ============================================================================
  // formatModelName
  // ============================================================================

  group('formatModelName', () {
    test('should map Opus 4.6 model ID to display name', () {
      expect(
        formatModelName('us.anthropic.claude-opus-4-6-v1'),
        'Claude Opus 4.6',
      );
    });

    test('should map Sonnet 4.6 model ID to display name', () {
      expect(
        formatModelName('us.anthropic.claude-sonnet-4-6'),
        'Claude Sonnet 4.6',
      );
    });

    test('should map Haiku 4.5 model ID to display name', () {
      expect(
        formatModelName('us.anthropic.claude-haiku-4-5-v1'),
        'Claude Haiku 4.5',
      );
    });

    test('should handle bare model IDs without prefix', () {
      expect(formatModelName('claude-opus-4-6'), 'Claude Opus 4.6');
      expect(formatModelName('claude-sonnet-4-6'), 'Claude Sonnet 4.6');
      expect(formatModelName('claude-haiku-4-5'), 'Claude Haiku 4.5');
    });

    test('should return unknown model IDs as-is', () {
      expect(formatModelName('some-other-model'), 'some-other-model');
      expect(formatModelName('gpt-4'), 'gpt-4');
    });

    test('should handle empty string', () {
      expect(formatModelName(''), '');
    });
  });
}
