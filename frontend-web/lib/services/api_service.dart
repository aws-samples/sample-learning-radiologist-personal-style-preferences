import 'dart:async';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../config/api_constants.dart';
import '../utils/logger.dart';
import '../models/api_models.dart';
import '../models/case.dart';
import '../models/preference.dart';
import '../models/user_settings.dart';
import 'auth_service.dart';

/// API service for communicating with the backend
class ApiService {
  ApiService(this._authService) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout:
          const Duration(seconds: ApiConstants.requestTimeoutSeconds),
      receiveTimeout:
          const Duration(seconds: ApiConstants.resourceTimeoutSeconds),
      headers: {
        'Content-Type': ApiConstants.contentType,
      },
    ));

    // Add JWT interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _authService.getIdToken();
        if (token != null) {
          options.headers['Authorization'] =
              '${ApiConstants.authorizationPrefix}$token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token expired or invalid — sign out so the user
          // is redirected to the login screen.
          _authService.signOut();
        }
        // Log status/type only — never error.response.data, which can echo PHI.
        devLog('API Error: ${error.type} status=${error.response?.statusCode}');
        handler.next(error);
      },
    ));
  }

  final AuthService _authService;
  late final Dio _dio;

  // ============================================================================
  // Cases
  // ============================================================================

  /// Get all cases for the current user
  Future<CasesResponse> getCases() async {
    final response = await _dio.get('/cases');
    return CasesResponse.fromJson(response.data);
  }

  /// Get detailed case information
  Future<CaseDetail> getCaseDetail(String caseId) async {
    final response = await _dio.get('/cases/$caseId');
    return CaseDetail.fromJson(response.data);
  }

  /// Update case findings
  Future<UpdateCaseResponse> updateCase(
      String caseId, String findings) async {
    final request = UpdateCaseRequest(findings: findings);
    // Log shape only — request/response bodies contain PHI (findings text).
    devLog('[ApiService] updateCase request: findings length=${findings.length}');
    final response = await _dio.put(
      '/cases/$caseId',
      data: request.toJson(),
    );
    devLog('[ApiService] updateCase response type: ${response.data.runtimeType}');
    return UpdateCaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  // ============================================================================
  // Generation
  // ============================================================================

  /// Generate an impression for a case
  Future<GenerateResponse> generateImpression({
    required String caseId,
    required String findings,
    bool clinicalInterpretation = false,
  }) async {
    final request = GenerateRequest(
      caseId: caseId,
      findings: findings,
      clinicalInterpretation: clinicalInterpretation,
      idempotencyKey: const Uuid().v4(),
    );
    final response = await _dio.post(
      '/generate',
      data: request.toJson(),
    );
    return GenerateResponse.fromJson(response.data);
  }

  // ============================================================================
  // Edit (Async Pattern)
  // ============================================================================

  /// Start an edit operation (async - returns immediately)
  Future<EditStartResponse> startEdit({
    required String caseId,
    required String originalImpression,
    required String editedImpression,
    required String findings,
  }) async {
    final request = EditRequest(
      caseId: caseId,
      originalImpression: originalImpression,
      editedImpression: editedImpression,
      findings: findings,
      idempotencyKey: const Uuid().v4(),
    );
    final response = await _dio.post(
      '/edit',
      data: request.toJson(),
    );
    return EditStartResponse.fromJson(response.data);
  }

  /// Get edit operation status (for polling)
  Future<EditStatusResponse> getEditStatus(String editId) async {
    final response = await _dio.get('/edit/$editId/status');
    return EditStatusResponse.fromJson(response.data);
  }

  /// Save edit with polling (convenience method)
  ///
  /// This starts an edit operation and polls until completion.
  /// [onPhaseChange] is called with phase updates for UI feedback.
  Future<EditStatusResponse> saveEdit({
    required String caseId,
    required String originalImpression,
    required String editedImpression,
    required String findings,
    void Function(SavePhase)? onPhaseChange,
  }) async {
    // Start the edit operation
    final startResponse = await startEdit(
      caseId: caseId,
      originalImpression: originalImpression,
      editedImpression: editedImpression,
      findings: findings,
    );

    // Poll for completion
    int pollCount = 0;
    const maxPolls = ApiConstants.maxEditPolls;
    const pollInterval = Duration(milliseconds: ApiConstants.editPollIntervalMs);

    while (pollCount < maxPolls) {
      await Future.delayed(pollInterval);
      pollCount++;

      // Update UI phase based on poll count
      if (pollCount > 2) {
        onPhaseChange?.call(SavePhase.extracting);
      }
      if (pollCount > 5) {
        onPhaseChange?.call(SavePhase.validating);
      }

      final status = await getEditStatus(startResponse.editId);
      if (status.isComplete) {
        onPhaseChange?.call(SavePhase.finishing);
        return status;
      }
    }

    // Timeout
    throw ApiException(408, 'Edit operation timed out');
  }

  // ============================================================================
  // Preferences
  // ============================================================================

  /// Get all learned preferences
  Future<PreferencesResponse> getPreferences() async {
    final response = await _dio.get('/preferences');
    return PreferencesResponse.fromJson(response.data);
  }

  /// Get all rejected preferences (audit trail)
  Future<RejectedPreferencesResponse> getRejectedPreferences() async {
    final response = await _dio.get('/preferences/rejected');
    return RejectedPreferencesResponse.fromJson(response.data);
  }

  /// Delete a preference
  Future<DeletePreferenceResponse> deletePreference(
      String preferenceId) async {
    final response = await _dio.delete('/preferences/$preferenceId');
    return DeletePreferenceResponse.fromJson(response.data);
  }

  /// Update a preference
  Future<UpdatePreferenceResponse> updatePreference(
    String preferenceId,
    String preferenceText,
  ) async {
    final request = UpdatePreferenceRequest(preferenceText: preferenceText);
    final response = await _dio.put(
      '/preferences/$preferenceId',
      data: request.toJson(),
    );
    return UpdatePreferenceResponse.fromJson(response.data);
  }

  // ============================================================================
  // Settings
  // ============================================================================

  /// Get user settings
  Future<UserSettings> getSettings() async {
    final response = await _dio.get('/settings');
    return UserSettings.fromJson(response.data);
  }

  /// Update user settings
  Future<UpdateSettingsResponse> updateSettings(
      UpdateSettingsRequest request) async {
    final response = await _dio.put(
      '/settings',
      data: request.toJson(),
    );
    return UpdateSettingsResponse.fromJson(response.data);
  }

  /// Reset app to defaults
  Future<void> resetApp() async {
    await _dio.post('/settings/reset');
  }
}

/// Save operation phases for UI feedback
enum SavePhase {
  saving,
  analyzing,
  extracting,
  validating,
  finishing,
}

/// Generation phases for UI feedback
enum GenerationPhase {
  starting,
  retrieving,
  generating,
  refining,
  finishing,
}

/// Custom API exception
class ApiException implements Exception {
  ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
