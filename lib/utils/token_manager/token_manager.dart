import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TokenManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys used for storing tokens and expiration time
  final String _accessTokenKey = 'accessToken';
  final String _refreshTokenKey = 'refreshToken';
  final String _expirationKey = 'accessTokenExpiration';

  // Save tokens and expiration time
  Future<void> saveTokens(String accessToken, String refreshToken, int expiresIn) async {
    final DateTime expirationTime = DateTime.now().add(Duration(seconds: expiresIn));

    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _expirationKey, value: expirationTime.toIso8601String());
  }

  // Retrieve the access token
  Future<String?> getAccessToken() async {
    print("get acess:${_accessTokenKey}");
    return await _storage.read(key: _accessTokenKey);
  }

  // Retrieve the refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Check if the access token has expired
  Future<bool> isAccessTokenExpired() async {
    String? expirationString = await _storage.read(key: _expirationKey);
    if (expirationString != null) {
      DateTime expirationTime = DateTime.parse(expirationString);
      return DateTime.now().isAfter(expirationTime);
    }
    return true; // Token is expired or doesn't exist.
  }

  // Refresh the access token using the refresh token
  Future<void> refreshAccessToken(String refreshTokenEndpoint) async {
    String? refreshToken = await getRefreshToken();
    
    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse(refreshTokenEndpoint),
        body: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String newAccessToken = data['accessToken'];
        int expiresIn = data['expiresIn'];

        // Save the new access token and expiration time
        await saveTokens(newAccessToken, refreshToken, expiresIn);
      } else {
        // Handle error (e.g., redirect to login)
        throw Exception("Failed to refresh access token");
      }
    } else {
      // Handle missing refresh token (e.g., force user to log in again)
      throw Exception("Refresh token not found");
    }
  }

  // Logout and clear the stored tokens
  Future<void> logout() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _expirationKey);
  }

  // Make authenticated API call
  Future<http.Response> makeAuthenticatedApiCall(String endpoint, Map<String, String> body, String refreshTokenEndpoint) async {
    // Check if the access token is expired
    bool tokenExpired = await isAccessTokenExpired();
    if (tokenExpired) {
      // Refresh the access token if expired
      await refreshAccessToken(refreshTokenEndpoint);
    }

    // Get the access token after refresh
    String? accessToken = await getAccessToken();
    
    // Proceed with the API call using the new or valid access token
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );

    return response;

}
}