import 'package:flutter/material.dart';

// =============================================================
//  VECINAL APP — DESIGN SYSTEM
//  Temas: Light & Dark
//  Módulos: Emergencias, Avisos, Reuniones, Pagos, Tickets
// =============================================================

// ─────────────────────────────────────────────
//  COLOR TOKENS
// ─────────────────────────────────────────────

class VecinalColors {
  VecinalColors._();

  // ── Primario: Teal (identidad, navegación, acciones principales)
  static const teal50  = Color(0xFFE1F5EE);
  static const teal100 = Color(0xFF9FE1CB);
  static const teal200 = Color(0xFF5DCAA5);
  static const teal400 = Color(0xFF1D9E75);
  static const teal600 = Color(0xFF0F6E56);
  static const teal800 = Color(0xFF085041);
  static const teal900 = Color(0xFF04342C);

  // ── Rojo (emergencias, alertas críticas — uso reservado)
  static const red50  = Color(0xFFFCEBEB);
  static const red100 = Color(0xFFF7C1C1);
  static const red200 = Color(0xFFF09595);
  static const red400 = Color(0xFFE24B4A);
  static const red600 = Color(0xFFA32D2D);
  static const red800 = Color(0xFF791F1F);
  static const red900 = Color(0xFF501313);

  // ── Ámbar (avisos, recordatorios, tickets en progreso)
  static const amber50  = Color(0xFFFAEEDA);
  static const amber100 = Color(0xFFFAC775);
  static const amber200 = Color(0xFFEF9F27);
  static const amber400 = Color(0xFFBA7517);
  static const amber600 = Color(0xFF854F0B);
  static const amber800 = Color(0xFF633806);
  static const amber900 = Color(0xFF412402);

  // ── Azul (información, pagos, historial)
  static const blue50  = Color(0xFFE6F1FB);
  static const blue100 = Color(0xFFB5D4F4);
  static const blue200 = Color(0xFF85B7EB);
  static const blue400 = Color(0xFF378ADD);
  static const blue600 = Color(0xFF185FA5);
  static const blue800 = Color(0xFF0C447C);
  static const blue900 = Color(0xFF042C53);

  // ── Verde (éxito, pagos confirmados, tickets resueltos)
  static const green50  = Color(0xFFEAF3DE);
  static const green100 = Color(0xFFC0DD97);
  static const green200 = Color(0xFF97C459);
  static const green400 = Color(0xFF639922);
  static const green600 = Color(0xFF3B6D11);
  static const green800 = Color(0xFF27500A);
  static const green900 = Color(0xFF173404);

  // ── Purple (reuniones, eventos de comunidad)
  static const purple50  = Color(0xFFEEEDFE);
  static const purple100 = Color(0xFFCECBF6);
  static const purple200 = Color(0xFFAFA9EC);
  static const purple400 = Color(0xFF7F77DD);
  static const purple600 = Color(0xFF534AB7);
  static const purple800 = Color(0xFF3C3489);
  static const purple900 = Color(0xFF26215C);

  // ── Grises neutros
  static const gray50  = Color(0xFFF1EFE8);
  static const gray100 = Color(0xFFD3D1C7);
  static const gray200 = Color(0xFFB4B2A9);
  static const gray400 = Color(0xFF888780);
  static const gray600 = Color(0xFF5F5E5A);
  static const gray800 = Color(0xFF444441);
  static const gray900 = Color(0xFF2C2C2A);

  // ── Superficies (no cambian con el tema, son referencias)
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}

// ─────────────────────────────────────────────
//  SEMANTIC COLOR TOKENS (por módulo)
// ─────────────────────────────────────────────

class VecinalSemanticColors extends ThemeExtension<VecinalSemanticColors> {
  final Color // ── Módulo: Emergencias
      emergencyBg,
      emergencyText,
      emergencyBorder,
      emergencyIcon,

      // ── Módulo: Avisos / Notificaciones
      noticeBg,
      noticeText,
      noticeBorder,
      noticeIcon,

      // ── Módulo: Reuniones / Eventos
      meetingBg,
      meetingText,
      meetingBorder,
      meetingIcon,

      // ── Módulo: Pagos
      paymentBg,
      paymentText,
      paymentBorder,
      paymentIcon,

      // ── Estado: Pago pendiente
      paymentPendingBg,
      paymentPendingText,

      // ── Estado: Pago completado
      paymentSuccessBg,
      paymentSuccessText,

      // ── Estado: Pago vencido
      paymentOverdueBg,
      paymentOverdueText,

      // ── Módulo: Tickets / Desperfectos
      ticketBg,
      ticketText,
      ticketBorder,
      ticketIcon,

      // ── Estado de ticket: Abierto
      ticketOpenBg,
      ticketOpenText,

      // ── Estado de ticket: En progreso
      ticketInProgressBg,
      ticketInProgressText,

      // ── Estado de ticket: Resuelto
      ticketResolvedBg,
      ticketResolvedText,

      // ── Contactos de emergencia
      contactBg,
      contactText,
      contactBorder,

      // ── Superficies generales
      surfacePrimary,
      surfaceSecondary,
      surfaceTertiary,
      surfaceCard,
      surfaceModal,

      // ── Texto
      textPrimary,
      textSecondary,
      textHint,
      textOnPrimary,
      textOnEmergency,

      // ── Bordes
      borderDefault,
      borderStrong,
      borderFocus,

      // ── Primario (brand)
      primaryDefault,
      primaryLight,
      primaryDark,
      primaryContainer,
      onPrimaryContainer,

      // ── Acción destructiva
      destructive,
      destructiveBg,

      // ── Divider
      divider,

      // ── Overlay / Scrim
      scrim,

      // ── Bottom nav / AppBar
      navBackground,
      navSelected,
      navUnselected;

  const VecinalSemanticColors({
    required this.emergencyBg,
    required this.emergencyText,
    required this.emergencyBorder,
    required this.emergencyIcon,
    required this.noticeBg,
    required this.noticeText,
    required this.noticeBorder,
    required this.noticeIcon,
    required this.meetingBg,
    required this.meetingText,
    required this.meetingBorder,
    required this.meetingIcon,
    required this.paymentBg,
    required this.paymentText,
    required this.paymentBorder,
    required this.paymentIcon,
    required this.paymentPendingBg,
    required this.paymentPendingText,
    required this.paymentSuccessBg,
    required this.paymentSuccessText,
    required this.paymentOverdueBg,
    required this.paymentOverdueText,
    required this.ticketBg,
    required this.ticketText,
    required this.ticketBorder,
    required this.ticketIcon,
    required this.ticketOpenBg,
    required this.ticketOpenText,
    required this.ticketInProgressBg,
    required this.ticketInProgressText,
    required this.ticketResolvedBg,
    required this.ticketResolvedText,
    required this.contactBg,
    required this.contactText,
    required this.contactBorder,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceTertiary,
    required this.surfaceCard,
    required this.surfaceModal,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textOnPrimary,
    required this.textOnEmergency,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderFocus,
    required this.primaryDefault,
    required this.primaryLight,
    required this.primaryDark,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.destructive,
    required this.destructiveBg,
    required this.divider,
    required this.scrim,
    required this.navBackground,
    required this.navSelected,
    required this.navUnselected,
  });

  @override
  VecinalSemanticColors copyWith({
    Color? emergencyBg,
    Color? emergencyText,
    Color? emergencyBorder,
    Color? emergencyIcon,
    Color? noticeBg,
    Color? noticeText,
    Color? noticeBorder,
    Color? noticeIcon,
    Color? meetingBg,
    Color? meetingText,
    Color? meetingBorder,
    Color? meetingIcon,
    Color? paymentBg,
    Color? paymentText,
    Color? paymentBorder,
    Color? paymentIcon,
    Color? paymentPendingBg,
    Color? paymentPendingText,
    Color? paymentSuccessBg,
    Color? paymentSuccessText,
    Color? paymentOverdueBg,
    Color? paymentOverdueText,
    Color? ticketBg,
    Color? ticketText,
    Color? ticketBorder,
    Color? ticketIcon,
    Color? ticketOpenBg,
    Color? ticketOpenText,
    Color? ticketInProgressBg,
    Color? ticketInProgressText,
    Color? ticketResolvedBg,
    Color? ticketResolvedText,
    Color? contactBg,
    Color? contactText,
    Color? contactBorder,
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? surfaceTertiary,
    Color? surfaceCard,
    Color? surfaceModal,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? textOnPrimary,
    Color? textOnEmergency,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderFocus,
    Color? primaryDefault,
    Color? primaryLight,
    Color? primaryDark,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? destructive,
    Color? destructiveBg,
    Color? divider,
    Color? scrim,
    Color? navBackground,
    Color? navSelected,
    Color? navUnselected,
  }) {
    return VecinalSemanticColors(
      emergencyBg: emergencyBg ?? this.emergencyBg,
      emergencyText: emergencyText ?? this.emergencyText,
      emergencyBorder: emergencyBorder ?? this.emergencyBorder,
      emergencyIcon: emergencyIcon ?? this.emergencyIcon,
      noticeBg: noticeBg ?? this.noticeBg,
      noticeText: noticeText ?? this.noticeText,
      noticeBorder: noticeBorder ?? this.noticeBorder,
      noticeIcon: noticeIcon ?? this.noticeIcon,
      meetingBg: meetingBg ?? this.meetingBg,
      meetingText: meetingText ?? this.meetingText,
      meetingBorder: meetingBorder ?? this.meetingBorder,
      meetingIcon: meetingIcon ?? this.meetingIcon,
      paymentBg: paymentBg ?? this.paymentBg,
      paymentText: paymentText ?? this.paymentText,
      paymentBorder: paymentBorder ?? this.paymentBorder,
      paymentIcon: paymentIcon ?? this.paymentIcon,
      paymentPendingBg: paymentPendingBg ?? this.paymentPendingBg,
      paymentPendingText: paymentPendingText ?? this.paymentPendingText,
      paymentSuccessBg: paymentSuccessBg ?? this.paymentSuccessBg,
      paymentSuccessText: paymentSuccessText ?? this.paymentSuccessText,
      paymentOverdueBg: paymentOverdueBg ?? this.paymentOverdueBg,
      paymentOverdueText: paymentOverdueText ?? this.paymentOverdueText,
      ticketBg: ticketBg ?? this.ticketBg,
      ticketText: ticketText ?? this.ticketText,
      ticketBorder: ticketBorder ?? this.ticketBorder,
      ticketIcon: ticketIcon ?? this.ticketIcon,
      ticketOpenBg: ticketOpenBg ?? this.ticketOpenBg,
      ticketOpenText: ticketOpenText ?? this.ticketOpenText,
      ticketInProgressBg: ticketInProgressBg ?? this.ticketInProgressBg,
      ticketInProgressText: ticketInProgressText ?? this.ticketInProgressText,
      ticketResolvedBg: ticketResolvedBg ?? this.ticketResolvedBg,
      ticketResolvedText: ticketResolvedText ?? this.ticketResolvedText,
      contactBg: contactBg ?? this.contactBg,
      contactText: contactText ?? this.contactText,
      contactBorder: contactBorder ?? this.contactBorder,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceTertiary: surfaceTertiary ?? this.surfaceTertiary,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceModal: surfaceModal ?? this.surfaceModal,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textOnEmergency: textOnEmergency ?? this.textOnEmergency,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      borderFocus: borderFocus ?? this.borderFocus,
      primaryDefault: primaryDefault ?? this.primaryDefault,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      destructive: destructive ?? this.destructive,
      destructiveBg: destructiveBg ?? this.destructiveBg,
      divider: divider ?? this.divider,
      scrim: scrim ?? this.scrim,
      navBackground: navBackground ?? this.navBackground,
      navSelected: navSelected ?? this.navSelected,
      navUnselected: navUnselected ?? this.navUnselected,
    );
  }

  @override
  VecinalSemanticColors lerp(ThemeExtension<VecinalSemanticColors>? other, double t) {
    if (other is! VecinalSemanticColors) return this;
    return VecinalSemanticColors(
      emergencyBg: Color.lerp(emergencyBg, other.emergencyBg, t)!,
      emergencyText: Color.lerp(emergencyText, other.emergencyText, t)!,
      emergencyBorder: Color.lerp(emergencyBorder, other.emergencyBorder, t)!,
      emergencyIcon: Color.lerp(emergencyIcon, other.emergencyIcon, t)!,
      noticeBg: Color.lerp(noticeBg, other.noticeBg, t)!,
      noticeText: Color.lerp(noticeText, other.noticeText, t)!,
      noticeBorder: Color.lerp(noticeBorder, other.noticeBorder, t)!,
      noticeIcon: Color.lerp(noticeIcon, other.noticeIcon, t)!,
      meetingBg: Color.lerp(meetingBg, other.meetingBg, t)!,
      meetingText: Color.lerp(meetingText, other.meetingText, t)!,
      meetingBorder: Color.lerp(meetingBorder, other.meetingBorder, t)!,
      meetingIcon: Color.lerp(meetingIcon, other.meetingIcon, t)!,
      paymentBg: Color.lerp(paymentBg, other.paymentBg, t)!,
      paymentText: Color.lerp(paymentText, other.paymentText, t)!,
      paymentBorder: Color.lerp(paymentBorder, other.paymentBorder, t)!,
      paymentIcon: Color.lerp(paymentIcon, other.paymentIcon, t)!,
      paymentPendingBg: Color.lerp(paymentPendingBg, other.paymentPendingBg, t)!,
      paymentPendingText: Color.lerp(paymentPendingText, other.paymentPendingText, t)!,
      paymentSuccessBg: Color.lerp(paymentSuccessBg, other.paymentSuccessBg, t)!,
      paymentSuccessText: Color.lerp(paymentSuccessText, other.paymentSuccessText, t)!,
      paymentOverdueBg: Color.lerp(paymentOverdueBg, other.paymentOverdueBg, t)!,
      paymentOverdueText: Color.lerp(paymentOverdueText, other.paymentOverdueText, t)!,
      ticketBg: Color.lerp(ticketBg, other.ticketBg, t)!,
      ticketText: Color.lerp(ticketText, other.ticketText, t)!,
      ticketBorder: Color.lerp(ticketBorder, other.ticketBorder, t)!,
      ticketIcon: Color.lerp(ticketIcon, other.ticketIcon, t)!,
      ticketOpenBg: Color.lerp(ticketOpenBg, other.ticketOpenBg, t)!,
      ticketOpenText: Color.lerp(ticketOpenText, other.ticketOpenText, t)!,
      ticketInProgressBg: Color.lerp(ticketInProgressBg, other.ticketInProgressBg, t)!,
      ticketInProgressText: Color.lerp(ticketInProgressText, other.ticketInProgressText, t)!,
      ticketResolvedBg: Color.lerp(ticketResolvedBg, other.ticketResolvedBg, t)!,
      ticketResolvedText: Color.lerp(ticketResolvedText, other.ticketResolvedText, t)!,
      contactBg: Color.lerp(contactBg, other.contactBg, t)!,
      contactText: Color.lerp(contactText, other.contactText, t)!,
      contactBorder: Color.lerp(contactBorder, other.contactBorder, t)!,
      surfacePrimary: Color.lerp(surfacePrimary, other.surfacePrimary, t)!,
      surfaceSecondary: Color.lerp(surfaceSecondary, other.surfaceSecondary, t)!,
      surfaceTertiary: Color.lerp(surfaceTertiary, other.surfaceTertiary, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceModal: Color.lerp(surfaceModal, other.surfaceModal, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      textOnEmergency: Color.lerp(textOnEmergency, other.textOnEmergency, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      primaryDefault: Color.lerp(primaryDefault, other.primaryDefault, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimaryContainer: Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      destructiveBg: Color.lerp(destructiveBg, other.destructiveBg, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      navSelected: Color.lerp(navSelected, other.navSelected, t)!,
      navUnselected: Color.lerp(navUnselected, other.navUnselected, t)!,
    );
  }
}

// ─────────────────────────────────────────────
//  LIGHT THEME — SEMANTIC VALUES
// ─────────────────────────────────────────────

const vecinalLightColors = VecinalSemanticColors(
  // Emergencias
  emergencyBg:       VecinalColors.red50,
  emergencyText:     VecinalColors.red800,
  emergencyBorder:   VecinalColors.red400,
  emergencyIcon:     VecinalColors.red600,

  // Avisos
  noticeBg:          VecinalColors.amber50,
  noticeText:        VecinalColors.amber800,
  noticeBorder:      VecinalColors.amber200,
  noticeIcon:        VecinalColors.amber400,

  // Reuniones
  meetingBg:         VecinalColors.purple50,
  meetingText:       VecinalColors.purple800,
  meetingBorder:     VecinalColors.purple200,
  meetingIcon:       VecinalColors.purple600,

  // Pagos (módulo general)
  paymentBg:         VecinalColors.blue50,
  paymentText:       VecinalColors.blue800,
  paymentBorder:     VecinalColors.blue200,
  paymentIcon:       VecinalColors.blue600,

  // Estados de pago
  paymentPendingBg:  VecinalColors.amber50,
  paymentPendingText: VecinalColors.amber800,
  paymentSuccessBg:  VecinalColors.green50,
  paymentSuccessText: VecinalColors.green800,
  paymentOverdueBg:  VecinalColors.red50,
  paymentOverdueText: VecinalColors.red800,

  // Tickets (módulo general)
  ticketBg:          VecinalColors.teal50,
  ticketText:        VecinalColors.teal800,
  ticketBorder:      VecinalColors.teal200,
  ticketIcon:        VecinalColors.teal600,

  // Estados de ticket
  ticketOpenBg:      VecinalColors.blue50,
  ticketOpenText:    VecinalColors.blue800,
  ticketInProgressBg: VecinalColors.amber50,
  ticketInProgressText: VecinalColors.amber800,
  ticketResolvedBg:  VecinalColors.green50,
  ticketResolvedText: VecinalColors.green800,

  // Contactos de emergencia
  contactBg:         VecinalColors.red50,
  contactText:       VecinalColors.red800,
  contactBorder:     VecinalColors.red200,

  // Superficies
  surfacePrimary:    VecinalColors.white,
  surfaceSecondary:  VecinalColors.gray50,
  surfaceTertiary:   Color(0xFFF7F6F1),
  surfaceCard:       VecinalColors.white,
  surfaceModal:      VecinalColors.white,

  // Texto
  textPrimary:       VecinalColors.gray900,
  textSecondary:     VecinalColors.gray600,
  textHint:          VecinalColors.gray400,
  textOnPrimary:     VecinalColors.white,
  textOnEmergency:   VecinalColors.white,

  // Bordes
  borderDefault:     VecinalColors.gray100,
  borderStrong:      VecinalColors.gray200,
  borderFocus:       VecinalColors.teal400,

  // Brand primario
  primaryDefault:    VecinalColors.teal400,
  primaryLight:      VecinalColors.teal200,
  primaryDark:       VecinalColors.teal600,
  primaryContainer:  VecinalColors.teal50,
  onPrimaryContainer: VecinalColors.teal800,

  // Destructivo
  destructive:       VecinalColors.red600,
  destructiveBg:     VecinalColors.red50,

  // Divider
  divider:           VecinalColors.gray100,

  // Scrim
  scrim:             Color(0x662C2C2A),

  // Navegación
  navBackground:     VecinalColors.white,
  navSelected:       VecinalColors.teal400,
  navUnselected:     VecinalColors.gray400,
);

// ─────────────────────────────────────────────
//  DARK THEME — SEMANTIC VALUES
// ─────────────────────────────────────────────

const vecinalDarkColors = VecinalSemanticColors(
  // Emergencias
  emergencyBg:       VecinalColors.red900,
  emergencyText:     VecinalColors.red100,
  emergencyBorder:   VecinalColors.red600,
  emergencyIcon:     VecinalColors.red200,

  // Avisos
  noticeBg:          VecinalColors.amber900,
  noticeText:        VecinalColors.amber100,
  noticeBorder:      VecinalColors.amber600,
  noticeIcon:        VecinalColors.amber200,

  // Reuniones
  meetingBg:         VecinalColors.purple900,
  meetingText:       VecinalColors.purple100,
  meetingBorder:     VecinalColors.purple600,
  meetingIcon:       VecinalColors.purple200,

  // Pagos (módulo general)
  paymentBg:         VecinalColors.blue900,
  paymentText:       VecinalColors.blue100,
  paymentBorder:     VecinalColors.blue600,
  paymentIcon:       VecinalColors.blue200,

  // Estados de pago
  paymentPendingBg:  VecinalColors.amber900,
  paymentPendingText: VecinalColors.amber100,
  paymentSuccessBg:  VecinalColors.green900,
  paymentSuccessText: VecinalColors.green100,
  paymentOverdueBg:  VecinalColors.red900,
  paymentOverdueText: VecinalColors.red100,

  // Tickets (módulo general)
  ticketBg:          VecinalColors.teal900,
  ticketText:        VecinalColors.teal100,
  ticketBorder:      VecinalColors.teal600,
  ticketIcon:        VecinalColors.teal200,

  // Estados de ticket
  ticketOpenBg:      VecinalColors.blue900,
  ticketOpenText:    VecinalColors.blue100,
  ticketInProgressBg: VecinalColors.amber900,
  ticketInProgressText: VecinalColors.amber100,
  ticketResolvedBg:  VecinalColors.green900,
  ticketResolvedText: VecinalColors.green100,

  // Contactos de emergencia
  contactBg:         VecinalColors.red900,
  contactText:       VecinalColors.red100,
  contactBorder:     VecinalColors.red600,

  // Superficies
  surfacePrimary:    Color(0xFF1A1A18),
  surfaceSecondary:  Color(0xFF222220),
  surfaceTertiary:   Color(0xFF2A2A28),
  surfaceCard:       Color(0xFF242422),
  surfaceModal:      Color(0xFF2C2C2A),

  // Texto
  textPrimary:       VecinalColors.gray50,
  textSecondary:     VecinalColors.gray200,
  textHint:          VecinalColors.gray600,
  textOnPrimary:     VecinalColors.white,
  textOnEmergency:   VecinalColors.white,

  // Bordes
  borderDefault:     Color(0xFF3A3A38),
  borderStrong:      VecinalColors.gray600,
  borderFocus:       VecinalColors.teal200,

  // Brand primario
  primaryDefault:    VecinalColors.teal200,
  primaryLight:      VecinalColors.teal100,
  primaryDark:       VecinalColors.teal400,
  primaryContainer:  VecinalColors.teal900,
  onPrimaryContainer: VecinalColors.teal100,

  // Destructivo
  destructive:       VecinalColors.red200,
  destructiveBg:     VecinalColors.red900,

  // Divider
  divider:           Color(0xFF333331),

  // Scrim
  scrim:             Color(0xCC000000),

  // Navegación
  navBackground:     Color(0xFF1A1A18),
  navSelected:       VecinalColors.teal200,
  navUnselected:     VecinalColors.gray600,
);

// ─────────────────────────────────────────────
//  TIPOGRAFÍA
// ─────────────────────────────────────────────

class VecinalTextStyles {
  VecinalTextStyles._();

  // Encabezados
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.35,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.4,
  );

  // Cuerpo
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Labels / UI
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
  );

  // Especiales
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.4,
  );

  // Badge / chip compacto
  static const TextStyle badge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
}

// ─────────────────────────────────────────────
//  ESPACIADO Y RADIOS
// ─────────────────────────────────────────────

class VecinalSpacing {
  VecinalSpacing._();
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double base = 16;
  static const double lg   = 20;
  static const double xl   = 24;
  static const double xxl  = 32;
  static const double xxxl = 48;
}

class VecinalRadius {
  VecinalRadius._();
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 20;
  static const double full = 999;
}

// ─────────────────────────────────────────────
//  SOMBRAS
// ─────────────────────────────────────────────

class VecinalShadows {
  VecinalShadows._();

  static const List<BoxShadow> cardLight = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x06000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> cardDark = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> emergencyBanner = [
    BoxShadow(
      color: Color(0x33E24B4A),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}

// ─────────────────────────────────────────────
//  FLUTTER ThemeData — LIGHT
// ─────────────────────────────────────────────

ThemeData vecinalLightTheme() {
  final c = vecinalLightColors;

  final colorScheme = ColorScheme(
    brightness:           Brightness.light,
    primary:              c.primaryDefault,
    onPrimary:            c.textOnPrimary,
    primaryContainer:     c.primaryContainer,
    onPrimaryContainer:   c.onPrimaryContainer,
    secondary:            VecinalColors.purple600,
    onSecondary:          VecinalColors.white,
    secondaryContainer:   VecinalColors.purple50,
    onSecondaryContainer: VecinalColors.purple800,
    tertiary:             VecinalColors.amber400,
    onTertiary:           VecinalColors.white,
    tertiaryContainer:    VecinalColors.amber50,
    onTertiaryContainer:  VecinalColors.amber800,
    error:                c.destructive,
    onError:              VecinalColors.white,
    errorContainer:       c.destructiveBg,
    onErrorContainer:     VecinalColors.red800,
    surface:              c.surfacePrimary,
    onSurface:            c.textPrimary,
    onSurfaceVariant:     c.textSecondary,
    outline:              c.borderDefault,
    outlineVariant:       c.borderStrong,
    shadow:               VecinalColors.black,
    scrim:                c.scrim,
    inverseSurface:       VecinalColors.gray900,
    onInverseSurface:     VecinalColors.gray50,
    inversePrimary:       VecinalColors.teal200,
    surfaceTint:          c.primaryDefault,
  );

  return ThemeData(
    useMaterial3:   true,
    brightness:     Brightness.light,
    colorScheme:    colorScheme,

    // Registrar los colores semánticos personalizados en las extensiones del tema
    extensions: <ThemeExtension<dynamic>>[c],

    // ── Scaffold
    scaffoldBackgroundColor: c.surfaceTertiary,

    // ── AppBar
    appBarTheme: AppBarTheme(
      centerTitle:        true,
      backgroundColor:    c.surfacePrimary,
      foregroundColor:    c.textPrimary,
      elevation:          0,
      scrolledUnderElevation: 1,
      shadowColor:        c.scrim,
      titleTextStyle:     VecinalTextStyles.headlineSmall.copyWith(
        color: c.textPrimary,
      ),
      iconTheme:          IconThemeData(color: c.textPrimary, size: 24),
    ),

    // ── Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:      c.navBackground,
      selectedItemColor:    c.navSelected,
      unselectedItemColor:  c.navUnselected,
      type:                 BottomNavigationBarType.fixed,
      elevation:            8,
      selectedLabelStyle:   VecinalTextStyles.labelSmall,
      unselectedLabelStyle: VecinalTextStyles.labelSmall,
    ),

    // ── NavigationBar (M3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:          c.navBackground,
      indicatorColor:           c.primaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: c.navSelected, size: 24);
        }
        return IconThemeData(color: c.navUnselected, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return VecinalTextStyles.labelSmall.copyWith(color: c.navSelected);
        }
        return VecinalTextStyles.labelSmall.copyWith(color: c.navUnselected);
      }),
    ),

    // ── Cards
    cardTheme: CardThemeData(
      color:        c.surfaceCard,
      elevation:    0,
      shape:        RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.lg),
        side: BorderSide(color: c.borderDefault, width: 0.5),
      ),
      margin:       const EdgeInsets.all(0),
    ),

    // ── ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:   c.primaryDefault,
        foregroundColor:   c.textOnPrimary,
        disabledBackgroundColor: c.borderDefault,
        disabledForegroundColor: c.textHint,
        elevation:         0,
        padding:           const EdgeInsets.symmetric(
          horizontal: VecinalSpacing.xl,
          vertical: VecinalSpacing.md,
        ),
        shape:             RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.md),
        ),
        textStyle:         VecinalTextStyles.labelLarge,
      ),
    ),

    // ── OutlinedButton
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.primaryDefault,
        side:            BorderSide(color: c.primaryDefault, width: 1.5),
        padding:         const EdgeInsets.symmetric(
          horizontal: VecinalSpacing.xl,
          vertical: VecinalSpacing.md,
        ),
        shape:           RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.md),
        ),
        textStyle:       VecinalTextStyles.labelLarge,
      ),
    ),

    // ── TextButton
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.primaryDefault,
        textStyle:       VecinalTextStyles.labelLarge,
        padding:         const EdgeInsets.symmetric(
          horizontal: VecinalSpacing.sm,
          vertical: VecinalSpacing.xs,
        ),
      ),
    ),

    // ── FilledButton (acción de emergencia)
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.destructive,
        foregroundColor: VecinalColors.white,
        textStyle:       VecinalTextStyles.labelLarge,
        padding:         const EdgeInsets.symmetric(
          horizontal: VecinalSpacing.xl,
          vertical: VecinalSpacing.md,
        ),
        shape:           RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.md),
        ),
      ),
    ),

    // ── FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor:   c.primaryDefault,
      foregroundColor:   c.textOnPrimary,
      elevation:         2,
      shape:             RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.lg),
      ),
    ),

    // ── InputDecoration
    inputDecorationTheme: InputDecorationTheme(
      filled:            true,
      fillColor:         c.surfaceSecondary,
      contentPadding:    const EdgeInsets.symmetric(
        horizontal: VecinalSpacing.base,
        vertical: VecinalSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        borderSide: BorderSide(color: c.borderDefault, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        borderSide: BorderSide(color: c.borderDefault, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        borderSide: BorderSide(color: c.borderFocus, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        borderSide: BorderSide(color: c.destructive, width: 1),
      ),
      hintStyle:         VecinalTextStyles.bodyMedium.copyWith(
        color: c.textHint,
      ),
      labelStyle:        VecinalTextStyles.bodyMedium.copyWith(
        color: c.textSecondary,
      ),
      prefixIconColor:   c.textSecondary,
      suffixIconColor:   c.textSecondary,
    ),

    // ── Chip
    chipTheme: ChipThemeData(
      backgroundColor:        c.surfaceSecondary,
      selectedColor:          c.primaryContainer,
      disabledColor:          c.borderDefault,
      labelStyle:             VecinalTextStyles.labelMedium.copyWith(
        color: c.textSecondary,
      ),
      secondaryLabelStyle:    VecinalTextStyles.labelMedium.copyWith(
        color: c.onPrimaryContainer,
      ),
      padding:                const EdgeInsets.symmetric(
        horizontal: VecinalSpacing.sm,
        vertical: VecinalSpacing.xs,
      ),
      shape:                  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.full),
        side: BorderSide(color: c.borderDefault, width: 0.5),
      ),
      elevation:              0,
    ),

    // ── Divider
    dividerTheme: DividerThemeData(
      color:     c.divider,
      thickness: 0.5,
      space:     0,
    ),

    // ── ListTile
    listTileTheme: ListTileThemeData(
      tileColor:         Colors.transparent,
      selectedTileColor: c.primaryContainer,
      iconColor:         c.textSecondary,
      textColor:         c.textPrimary,
      subtitleTextStyle: VecinalTextStyles.bodySmall.copyWith(
        color: c.textSecondary,
      ),
      titleTextStyle:    VecinalTextStyles.bodyMedium.copyWith(
        color: c.textPrimary,
      ),
      contentPadding:    const EdgeInsets.symmetric(
        horizontal: VecinalSpacing.base,
        vertical: VecinalSpacing.xs,
      ),
      shape:             RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
      ),
    ),

    // ── Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: c.surfaceModal,
      elevation:       0,
      shape:           RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.xl),
      ),
      titleTextStyle:  VecinalTextStyles.headlineSmall.copyWith(
        color: c.textPrimary,
      ),
      contentTextStyle: VecinalTextStyles.bodyMedium.copyWith(
        color: c.textSecondary,
      ),
    ),

    // ── BottomSheet
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor:    c.surfaceModal,
      modalBackgroundColor: c.surfaceModal,
      elevation:          0,
      shape:              RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(VecinalRadius.xl),
        ),
      ),
    ),

    // ── SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor:  VecinalColors.gray900,
      contentTextStyle: VecinalTextStyles.bodyMedium.copyWith(
        color: VecinalColors.gray50,
      ),
      actionTextColor:  VecinalColors.teal200,
      behavior:         SnackBarBehavior.floating,
      shape:            RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
      ),
    ),

    // ── Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primaryDefault;
        return c.borderStrong;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primaryContainer;
        return c.surfaceSecondary;
      }),
    ),

    // ── Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primaryDefault;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(VecinalColors.white),
      side: BorderSide(color: c.borderStrong, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.xs),
      ),
    ),

    // ── Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primaryDefault;
        return c.borderStrong;
      }),
    ),

    // ── Tabs
    tabBarTheme: TabBarThemeData(
      labelColor:         c.primaryDefault,
      unselectedLabelColor: c.textSecondary,
      indicatorColor:     c.primaryDefault,
      indicatorSize:      TabBarIndicatorSize.tab,
      labelStyle:         VecinalTextStyles.labelLarge,
      unselectedLabelStyle: VecinalTextStyles.labelLarge,
      dividerColor:       c.divider,
    ),

    // ── ProgressIndicator
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color:            c.primaryDefault,
      linearTrackColor: c.primaryContainer,
    ),

    // ── Badge
    badgeTheme: BadgeThemeData(
      backgroundColor: c.destructive,
      textColor:       VecinalColors.white,
      textStyle:       VecinalTextStyles.badge,
      padding:         const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    ),

    // ── IconButton
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: c.textSecondary,
        highlightColor:  c.primaryContainer,
      ),
    ),

    // ── Typography
    textTheme: TextTheme(
      displayLarge:   VecinalTextStyles.displayLarge.copyWith(color: c.textPrimary),
      headlineLarge:  VecinalTextStyles.headlineLarge.copyWith(color: c.textPrimary),
      headlineMedium: VecinalTextStyles.headlineMedium.copyWith(color: c.textPrimary),
      headlineSmall:  VecinalTextStyles.headlineSmall.copyWith(color: c.textPrimary),
      bodyLarge:      VecinalTextStyles.bodyLarge.copyWith(color: c.textPrimary),
      bodyMedium:     VecinalTextStyles.bodyMedium.copyWith(color: c.textPrimary),
      bodySmall:      VecinalTextStyles.bodySmall.copyWith(color: c.textSecondary),
      labelLarge:     VecinalTextStyles.labelLarge.copyWith(color: c.textPrimary),
      labelMedium:    VecinalTextStyles.labelMedium.copyWith(color: c.textSecondary),
      labelSmall:     VecinalTextStyles.labelSmall.copyWith(color: c.textSecondary),
    ),
  );
}

// ─────────────────────────────────────────────
//  FLUTTER ThemeData — DARK
// ─────────────────────────────────────────────

ThemeData vecinalDarkTheme() {
  final c = vecinalDarkColors;

  final colorScheme = ColorScheme(
    brightness:           Brightness.dark,
    primary:              c.primaryDefault,
    onPrimary:            VecinalColors.teal900,
    primaryContainer:     c.primaryContainer,
    onPrimaryContainer:   c.onPrimaryContainer,
    secondary:            VecinalColors.purple200,
    onSecondary:          VecinalColors.purple900,
    secondaryContainer:   VecinalColors.purple900,
    onSecondaryContainer: VecinalColors.purple100,
    tertiary:             VecinalColors.amber200,
    onTertiary:           VecinalColors.amber900,
    tertiaryContainer:    VecinalColors.amber900,
    onTertiaryContainer:  VecinalColors.amber100,
    error:                c.destructive,
    onError:              VecinalColors.red900,
    errorContainer:       c.destructiveBg,
    onErrorContainer:     VecinalColors.red100,
    surface:              c.surfacePrimary,
    onSurface:            c.textPrimary,
    onSurfaceVariant:     c.textSecondary,
    outline:              c.borderDefault,
    outlineVariant:       c.borderStrong,
    shadow:               VecinalColors.black,
    scrim:                c.scrim,
    inverseSurface:       VecinalColors.gray100,
    onInverseSurface:     VecinalColors.gray900,
    inversePrimary:       VecinalColors.teal600,
    surfaceTint:          c.primaryDefault,
  );

  return ThemeData(
    useMaterial3:   true,
    brightness:     Brightness.dark,
    colorScheme:    colorScheme,

    // Registrar los colores semánticos personalizados en las extensiones del tema
    extensions: <ThemeExtension<dynamic>>[c],

    scaffoldBackgroundColor: c.surfaceTertiary,

    appBarTheme: AppBarTheme(
      centerTitle:        true,
      backgroundColor:    c.surfacePrimary,
      foregroundColor:    c.textPrimary,
      elevation:          0,
      scrolledUnderElevation: 1,
      shadowColor:        c.scrim,
      titleTextStyle:     VecinalTextStyles.headlineSmall.copyWith(
        color: c.textPrimary,
      ),
      iconTheme:          IconThemeData(color: c.textPrimary, size: 24),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:      c.navBackground,
      selectedItemColor:    c.navSelected,
      unselectedItemColor:  c.navUnselected,
      type:                 BottomNavigationBarType.fixed,
      elevation:            8,
      selectedLabelStyle:   VecinalTextStyles.labelSmall,
      unselectedLabelStyle: VecinalTextStyles.labelSmall,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:          c.navBackground,
      indicatorColor:           c.primaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: c.navSelected, size: 24);
        }
        return IconThemeData(color: c.navUnselected, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return VecinalTextStyles.labelSmall.copyWith(color: c.navSelected);
        }
        return VecinalTextStyles.labelSmall.copyWith(color: c.navUnselected);
      }),
    ),

    cardTheme: CardThemeData(
      color:        c.surfaceCard,
      elevation:    0,
      shape:        RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.lg),
        side: BorderSide(color: c.borderDefault, width: 0.5),
      ),
      margin:       const EdgeInsets.all(0),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:   c.primaryDefault,
        foregroundColor:   VecinalColors.teal900,
        disabledBackgroundColor: c.borderDefault,
        disabledForegroundColor: c.textHint,
        elevation:         0,
        padding:           const EdgeInsets.symmetric(
          horizontal: VecinalSpacing.xl,
          vertical: VecinalSpacing.md,
        ),
        shape:             RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.md),
        ),
        textStyle:         VecinalTextStyles.labelLarge,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.primaryDefault,
        side:            BorderSide(color: c.primaryDefault, width: 1.5),
        padding:         const EdgeInsets.symmetric(
          horizontal: VecinalSpacing.xl,
          vertical: VecinalSpacing.md,
        ),
        shape:           RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.md),
        ),
        textStyle:       VecinalTextStyles.labelLarge,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.primaryDefault,
        textStyle:       VecinalTextStyles.labelLarge,
        padding:         const EdgeInsets.symmetric(
          horizontal: VecinalSpacing.sm,
          vertical: VecinalSpacing.xs,
        ),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.destructive,
        foregroundColor: VecinalColors.red900,
        textStyle:       VecinalTextStyles.labelLarge,
        padding:         const EdgeInsets.symmetric(
          horizontal: VecinalSpacing.xl,
          vertical: VecinalSpacing.md,
        ),
        shape:           RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.md),
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor:   c.primaryDefault,
      foregroundColor:   VecinalColors.teal900,
      elevation:         2,
      shape:             RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.lg),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled:            true,
      fillColor:         c.surfaceSecondary,
      contentPadding:    const EdgeInsets.symmetric(
        horizontal: VecinalSpacing.base,
        vertical: VecinalSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        borderSide: BorderSide(color: c.borderDefault, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        borderSide: BorderSide(color: c.borderDefault, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        borderSide: BorderSide(color: c.borderFocus, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        borderSide: BorderSide(color: c.destructive, width: 1),
      ),
      hintStyle:         VecinalTextStyles.bodyMedium.copyWith(
        color: c.textHint,
      ),
      labelStyle:        VecinalTextStyles.bodyMedium.copyWith(
        color: c.textSecondary,
      ),
      prefixIconColor:   c.textSecondary,
      suffixIconColor:   c.textSecondary,
    ),

    chipTheme: ChipThemeData(
      backgroundColor:        c.surfaceSecondary,
      selectedColor:          c.primaryContainer,
      disabledColor:          c.borderDefault,
      labelStyle:             VecinalTextStyles.labelMedium.copyWith(
        color: c.textSecondary,
      ),
      secondaryLabelStyle:    VecinalTextStyles.labelMedium.copyWith(
        color: c.onPrimaryContainer,
      ),
      padding:                const EdgeInsets.symmetric(
        horizontal: VecinalSpacing.sm,
        vertical: VecinalSpacing.xs,
      ),
      shape:                  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.full),
        side: BorderSide(color: c.borderDefault, width: 0.5),
      ),
      elevation:              0,
    ),

    dividerTheme: DividerThemeData(
      color:     c.divider,
      thickness: 0.5,
      space:     0,
    ),

    listTileTheme: ListTileThemeData(
      tileColor:         Colors.transparent,
      selectedTileColor: c.primaryContainer,
      iconColor:         c.textSecondary,
      textColor:         c.textPrimary,
      subtitleTextStyle: VecinalTextStyles.bodySmall.copyWith(
        color: c.textSecondary,
      ),
      titleTextStyle:    VecinalTextStyles.bodyMedium.copyWith(
        color: c.textPrimary,
      ),
      contentPadding:    const EdgeInsets.symmetric(
        horizontal: VecinalSpacing.base,
        vertical: VecinalSpacing.xs,
      ),
      shape:             RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: c.surfaceModal,
      elevation:       0,
      shape:           RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.xl),
      ),
      titleTextStyle:  VecinalTextStyles.headlineSmall.copyWith(
        color: c.textPrimary,
      ),
      contentTextStyle: VecinalTextStyles.bodyMedium.copyWith(
        color: c.textSecondary,
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor:    c.surfaceModal,
      modalBackgroundColor: c.surfaceModal,
      elevation:          0,
      shape:              RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(VecinalRadius.xl),
        ),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor:  VecinalColors.gray100,
      contentTextStyle: VecinalTextStyles.bodyMedium.copyWith(
        color: VecinalColors.gray900,
      ),
      actionTextColor:  VecinalColors.teal600,
      behavior:         SnackBarBehavior.floating,
      shape:            RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primaryDefault;
        return c.borderStrong;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primaryContainer;
        return c.surfaceSecondary;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primaryDefault;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(VecinalColors.teal900),
      side: BorderSide(color: c.borderStrong, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.xs),
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primaryDefault;
        return c.borderStrong;
      }),
    ),

    tabBarTheme: TabBarThemeData(
      labelColor:         c.primaryDefault,
      unselectedLabelColor: c.textSecondary,
      indicatorColor:     c.primaryDefault,
      indicatorSize:      TabBarIndicatorSize.tab,
      labelStyle:         VecinalTextStyles.labelLarge,
      unselectedLabelStyle: VecinalTextStyles.labelLarge,
      dividerColor:       c.divider,
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color:            c.primaryDefault,
      linearTrackColor: c.primaryContainer,
    ),

    badgeTheme: BadgeThemeData(
      backgroundColor: c.destructive,
      textColor:       VecinalColors.red900,
      textStyle:       VecinalTextStyles.badge,
      padding:         const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: c.textSecondary,
        highlightColor:  c.primaryContainer,
      ),
    ),

    textTheme: TextTheme(
      displayLarge:   VecinalTextStyles.displayLarge.copyWith(color: c.textPrimary),
      headlineLarge:  VecinalTextStyles.headlineLarge.copyWith(color: c.textPrimary),
      headlineMedium: VecinalTextStyles.headlineMedium.copyWith(color: c.textPrimary),
      headlineSmall:  VecinalTextStyles.headlineSmall.copyWith(color: c.textPrimary),
      bodyLarge:      VecinalTextStyles.bodyLarge.copyWith(color: c.textPrimary),
      bodyMedium:     VecinalTextStyles.bodyMedium.copyWith(color: c.textPrimary),
      bodySmall:      VecinalTextStyles.bodySmall.copyWith(color: c.textSecondary),
      labelLarge:     VecinalTextStyles.labelLarge.copyWith(color: c.textPrimary),
      labelMedium:    VecinalTextStyles.labelMedium.copyWith(color: c.textSecondary),
      labelSmall:     VecinalTextStyles.labelSmall.copyWith(color: c.textSecondary),
    ),
  );
}

// ─────────────────────────────────────────────
//  USO EN MaterialApp
// ─────────────────────────────────────────────
//
//  MaterialApp(
//    theme:     vecinalLightTheme(),
//    darkTheme: vecinalDarkTheme(),
//    themeMode: ThemeMode.system,   // o .light / .dark
//    ...
//  )
//
// ─────────────────────────────────────────────
//  ACCESO A COLORES SEMÁNTICOS
// ─────────────────────────────────────────────
//
//  // En tu widget:
//  final vc = context.vecinalColors;
//
//  Container(
//    color: vc.emergencyBg,
//    child: Text('Emergencia', style: TextStyle(color: vc.emergencyText)),
//  )

extension VecinalThemeExtension on BuildContext {
  VecinalSemanticColors get vecinalColors => 
      Theme.of(this).extension<VecinalSemanticColors>() ?? vecinalLightColors;
}
