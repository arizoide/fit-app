import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds - Branco Gelo & Superfícies Claras Premium
  static const Color background = Color(0xFFF4F7FB);   // Branco Gelo nórdico, límpido e suave
  static const Color surface = Color(0xFFFFFFFF);      // Branco puro para elevação e cartões
  static const Color surfaceLight = Color(0xFFE8EEF5); // Superfície de apoio com sutil tom gelo
  static const Color cardBg = Color(0xFFFFFFFF);       // Fundo dos cartões
  static const Color cardBorder = Color(0xFFE2E8F0);   // Borda sutil e nítida (Slate 200)

  // Brand & Action Accents - Adaptados para contraste de alta definição
  static const Color neonLime = Color(0xFF00C853);      // Verde Esmeralda/Lime atlético e energizante
  static const Color neonLimeGlow = Color(0x2800C853);  // Sombra suave e elegante
  static const Color electricCyan = Color(0xFF0284C7);  // Azul Ciano atlético de alta legibilidade
  static const Color electricCyanGlow = Color(0x220284C7);
  static const Color pulseOrange = Color(0xFFEA580C);   // Laranja atlético vibrante
  static const Color alertRed = Color(0xFFDC2626);      // Vermelho alerta
  static const Color purpleAccent = Color(0xFF7C3AED);  // Púrpura

  // Muscle Group Badges (Cores com alto contraste em fundo branco gelo)
  static const Color chestColor = Color(0xFFE11D48);    // Rose/Red
  static const Color backColor = Color(0xFF0284C7);     // Sky/Cyan
  static const Color legsColor = Color(0xFF059669);     // Emerald
  static const Color shouldersColor = Color(0xFFD97706); // Amber
  static const Color armsColor = Color(0xFF9333EA);     // Purple
  static const Color coreColor = Color(0xFF16A34A);     // Green

  // Text Colors (Contraste Slate profundo)
  static const Color textPrimary = Color(0xFF0F172A);   // Preto grafite profundo (Slate 900)
  static const Color textSecondary = Color(0xFF475569); // Slate 600 equilibrado
  static const Color textMuted = Color(0xFF64748B);     // Slate 500 para legendas e hints
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonLime, electricCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGlassGradient = LinearGradient(
    colors: [Color(0xF5FFFFFF), Color(0xEDF4F7FB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
