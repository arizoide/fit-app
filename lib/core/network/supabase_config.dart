import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // URLs padrão configuráveis via variáveis de ambiente ou runtime
  static const String defaultUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://xyzcompany.supabase.co');
  static const String defaultAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_key');

  static bool _isInitialized = false;

  static Future<void> initialize({String? url, String? anonKey}) async {
    final targetUrl = url ?? defaultUrl;
    final targetKey = anonKey ?? defaultAnonKey;

    try {
      if (targetUrl.isNotEmpty && !targetUrl.contains('xyzcompany')) {
        await Supabase.initialize(
          url: targetUrl,
          anonKey: targetKey,
        );
        _isInitialized = true;
      } else {
        debugPrint('[SupabaseConfig] Utilizando modo offline/local para FitMorph AI.');
      }
    } catch (e) {
      debugPrint('[SupabaseConfig] Erro ao inicializar Supabase: $e. Rodando em modo standalone local.');
      _isInitialized = false;
    }
  }

  static SupabaseClient? get client {
    if (_isInitialized) {
      return Supabase.instance.client;
    }
    return null;
  }

  static bool get isConfigured => _isInitialized;
}
