// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'HueyAPPan';

  @override
  String get loginPortalSubtitle => 'Portal de Residentes Convento Hueyapan';

  @override
  String get emailLabel => 'Correo Electrónico';

  @override
  String get emailRequired => 'El correo es requerido';

  @override
  String get emailInvalid => 'Ingresa un correo válido';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordRequired => 'La contraseña es requerida';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get loginButton => 'Acceder al Portal';

  @override
  String get registerLink => '¿No tienes cuenta? Regístrate aquí';

  @override
  String get registerHeaderTitle => 'Registro de Residente';

  @override
  String get firstNameLabel => 'Nombre';

  @override
  String get requiredField => 'Requerido';

  @override
  String get lastNameLabel => 'Apellidos';

  @override
  String get lotLabel => 'Lote';

  @override
  String get houseLabel => 'Casa';

  @override
  String get residentTypeLabel => 'Tipo de Residente';

  @override
  String get propietarioLabel => 'Propietario';

  @override
  String get inquilinoLabel => 'Inquilino';

  @override
  String get phoneLabel => 'Teléfono Móvil';

  @override
  String get phoneRequired => 'El teléfono es requerido';

  @override
  String get phoneLengthInvalid => 'Debe tener exactamente 10 dígitos';

  @override
  String get emailRequiredRegister => 'El correo es requerido';

  @override
  String get emailInvalidRegister => 'Ingresa un correo válido';

  @override
  String get passwordRequiredRegister => 'La contraseña es requerida';

  @override
  String get passwordTooShortRegister => 'Mínimo 6 caracteres';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get navHome => 'Inicio';

  @override
  String get navNews => 'Noticias';

  @override
  String get navPayments => 'Pagos';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navNotifications => 'Notificaciones';

  @override
  String get noNotifications => 'No tienes notificaciones';

  @override
  String get emergencyAlertTitle => 'Alerta de Emergencia';

  @override
  String get emergencyAlertConfirm =>
      '¿Estás seguro de que deseas activar la alerta de emergencia?\n\nEsta acción enviará una notificación de alerta crítica con sonido a todos los residentes de la comunidad.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get activateAlarm => 'Activar Alarma';

  @override
  String get alarmActivatedSuccess =>
      '¡Alerta de emergencia activada con éxito!';

  @override
  String alarmActivatedError(String error) {
    return 'Error al activar la alarma: $error';
  }

  @override
  String get emergencyOverlayTitle => '¡ALERTA DE EMERGENCIA!';

  @override
  String emergencyOverlayBody(String senderName) {
    return 'El residente $senderName ha activado una alerta de emergencia en la comunidad.';
  }

  @override
  String get silenceAlarm => 'Silenciar Alarma';

  @override
  String get welcomeBack => 'Bienvenido de nuevo,';

  @override
  String get recentActivity => 'Actividad Reciente';

  @override
  String get activityMaintenance =>
      'Mantenimiento del sistema de emergencias programado para el próximo sábado.';

  @override
  String get activityMaintenanceTime => 'Hace 1h';

  @override
  String get activityAssembly =>
      'Las minutas de la asamblea mensual de residentes han sido subidas.';

  @override
  String get activityAssemblyTime => 'Hace 1d';

  @override
  String get homeFeatureTitle => 'Resumen de la Comunidad';

  @override
  String get homeFeatureSubtitle => 'Comunidad Segura Convento Hueyapan';

  @override
  String get homeFeatureBody =>
      'Todos los sistemas operativos. Seguridad monitoreando los accesos 24/7.';

  @override
  String get myProfile => 'Mi Perfil';

  @override
  String get accountInformation => 'Información de la Cuenta';

  @override
  String get housingUnitLabel => 'Lote';

  @override
  String housingUnitValue(String lot, String house) {
    return '$lot-$house';
  }

  @override
  String get residentStatusLabel => 'Estado de Residente';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get maintenanceFees => 'Mis Pagos';

  @override
  String get paymentHistory => 'Historial de Pagos';

  @override
  String get amountPaid => 'Monto Pagado';

  @override
  String amountPaidValue(String amount) {
    return '\$$amount USD';
  }

  @override
  String get paidStatus => 'PAGADO';

  @override
  String get mayDues => 'Cuotas de Mayo 2026';

  @override
  String get aprilFee => 'Cuota de Mantenimiento de Abril 2026';

  @override
  String get aprilFeeDate => 'Pagado el 04 de abr, 2026';

  @override
  String get marchFee => 'Cuota de Mantenimiento de Marzo 2026';

  @override
  String get marchFeeDate => 'Pagado el 02 de mar, 2026';

  @override
  String get communityNews => 'Noticias de la Comunidad';

  @override
  String get news1Title => 'Nuevas Pautas de Control de Acceso';

  @override
  String get news1Body =>
      'Por favor, asegúrese de que los códigos de registro de invitados se generen a través del portal 24 horas antes de su llegada. Se requieren etiquetas RFID para el acceso vehicular.';

  @override
  String get news1Date => '28 de mayo, 2026';

  @override
  String get news1Author => 'Comité de Seguridad';

  @override
  String get news2Title => 'Apertura Anual de la Alberca';

  @override
  String get news2Body =>
      'La alberca del vecindario abrirá para la temporada a partir de este viernes. El horario de la alberca es de 8:00 AM a 10:00 PM todos los días. Por favor, revise las reglas de seguridad publicadas en la entrada.';

  @override
  String get news2Date => '24 de mayo, 2026';

  @override
  String get news2Author => 'Administración';

  @override
  String get navContacts => 'Contactos';

  @override
  String get contactsTitle => 'Números de Contacto';

  @override
  String get searchContacts => 'Buscar contactos...';

  @override
  String get noContactsFound => 'No se encontraron contactos';

  @override
  String get favoritesOnly => 'Favoritos';

  @override
  String get allContacts => 'Todos';

  @override
  String get securityCategory => 'Seguridad';

  @override
  String get adminCategory => 'Admin';

  @override
  String get servicesCategory => 'Servicios';

  @override
  String get emergencyCategory => 'Emergencia';

  @override
  String get callConfirmTitle => 'Llamar Contacto';

  @override
  String callConfirmBody(String name, String number) {
    return '¿Deseas realizar una llamada a $name al $number?';
  }

  @override
  String get callAction => 'Llamar';

  @override
  String get roleLabel => 'Rol';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleVecino => 'Vecino';

  @override
  String get recaptchaRequired => 'Por favor verifica que no eres un robot.';

  @override
  String get verifyPhoneRequiredTitle => 'Verificación Requerida';

  @override
  String get verifyPhoneRequiredBody =>
      'Para poder enviar Alertas Críticas, necesitas verificar tu número de teléfono.';

  @override
  String get requestVerification => 'Solicitar Verificación';

  @override
  String get enterOtp => 'Ingresa el código OTP';

  @override
  String get verifyOtp => 'Verificar Código';

  @override
  String get otpRequestedSuccess => 'Solicitud enviada a los administradores.';

  @override
  String get otpVerifiedSuccess => '¡Teléfono verificado correctamente!';

  @override
  String get otpVerificationFailed => 'El código es incorrecto o ha expirado.';

  @override
  String get otpAdminNotificationTitle => 'Solicitud de Verificación';

  @override
  String otpAdminNotificationBody(String name, String lot, String house) {
    return 'El vecino $name (Lote $lot-$house) ha solicitado verificación OTP.';
  }

  @override
  String adminOtpDialogTitle(String name) {
    return 'Código OTP para $name';
  }

  @override
  String adminOtpDialogBody(String name, String unitInfo) {
    return 'Verificación solicitada por $name$unitInfo.';
  }

  @override
  String get adminOtpDialogInstruction =>
      'Verifica el teléfono del vecino y comunícale este código.';

  @override
  String get close => 'Cerrar';

  @override
  String get paymentsTitle => 'Pagos de la Privada';

  @override
  String get paymentsHistory => 'Historial de Pagos';

  @override
  String get paymentsPending => 'Adeudos Pendientes';

  @override
  String get transferDetails => 'Datos de Transferencia';

  @override
  String get bankNameLabel => 'Banco';

  @override
  String get clabeLabel => 'CLABE';

  @override
  String get beneficiaryLabel => 'Beneficiario';

  @override
  String get copySuccess => 'CLABE copiada al portapapeles';

  @override
  String get partialPaymentTag => 'Pago Parcial';

  @override
  String get pendingPaymentTag => 'Pendiente';

  @override
  String get paidPaymentTag => 'Liquidado';

  @override
  String get conceptDetails => 'Detalles del Concepto';

  @override
  String get conceptBreakdown => 'Desglose de Cobro';

  @override
  String get adminPanel => 'Panel de Administración';

  @override
  String get createConcept => 'Crear Concepto de Pago';

  @override
  String get editConcept => 'Editar Concepto de Pago';

  @override
  String get deleteConcept => 'Eliminar Concepto';

  @override
  String get conceptTitleLabel => 'Nombre del Concepto';

  @override
  String get conceptDescLabel => 'Descripción (opcional)';

  @override
  String get conceptTotalCost => 'Costo Total';

  @override
  String get conceptTotalUnits => 'Número de Casas';

  @override
  String get amountPerHouseLabel => 'Monto por Casa';

  @override
  String get subItemsLabel => 'Detalles / Desglose';

  @override
  String get addSubItem => 'Agregar detalle';

  @override
  String get itemLabel => 'Descripción';

  @override
  String get itemAmount => 'Costo (opcional)';

  @override
  String get editConceptWarning =>
      'Nota: Editar un concepto existente NO recalculará automáticamente los adeudos ya generados para no alterar pagos registrados.';

  @override
  String get recordedExpenseLabel => 'Gasto Real Registrado';

  @override
  String get availableBalanceLabel => 'Saldo Disponible';

  @override
  String get totalCollectedLabel => 'Total Recaudado';

  @override
  String get totalPendingLabel => 'Total Pendiente';

  @override
  String get updateExpense => 'Registrar Gasto Real';

  @override
  String get paidHouses => 'Casas que ya pagaron';

  @override
  String get pendingHouses => 'Casas pendientes';

  @override
  String get registerPayment => 'Registrar Pago';

  @override
  String get amountReceivedLabel => 'Abono a la cuota principal';

  @override
  String get referenceLabel => 'Referencia / Comprobante (opcional)';

  @override
  String get notesLabel => 'Notas (opcional)';

  @override
  String get partialAction => 'Pago Parcial';

  @override
  String get completeAction => 'Pago Completo';

  @override
  String get save => 'Guardar';

  @override
  String get deleteConfirm =>
      '¿Estás seguro de que deseas eliminar este concepto de pago? Esta acción eliminará el concepto y todos los adeudos de las casas.';

  @override
  String get delete => 'Eliminar';

  @override
  String get fieldRequired => 'Campo requerido';

  @override
  String get invalidAmount => 'Monto no válido';

  @override
  String get activeStatus => 'Activo';

  @override
  String get closedStatus => 'Cerrado';

  @override
  String get cancelledStatus => 'Cancelado';

  @override
  String get noPaymentsFound => 'No se encontraron pagos';

  @override
  String get noPendingPayments => 'No tienes adeudos pendientes 🎉';

  @override
  String get bankTransferReference => 'Referencia bancaria';

  @override
  String get referenceCopySuccess => 'Referencia copiada al portapapeles';

  @override
  String get extraAmountLabel => 'Monto Extra';

  @override
  String get extraAmountInput => 'Monto extra (ej. llaves, controles, etc.)';

  @override
  String get extraPaid => 'Extra pagado';

  @override
  String get waterStatusTitle => 'Suministro de Agua';

  @override
  String get waterStatusAvailable => 'Agua disponible hoy';

  @override
  String get waterStatusUnavailable => 'Sin suministro hoy';

  @override
  String get waterStatusMaintenance => 'Mantenimiento en curso';

  @override
  String get waterStatusAdminTitle => 'Control de Agua (Admin)';

  @override
  String get waterStatusAuto => 'Automático (1 día sí, 1 no)';

  @override
  String get waterStatusForceAvailable => 'Forzar: Disponible';

  @override
  String get waterStatusForceUnavailable => 'Forzar: Sin suministro';

  @override
  String get waterStatusForceMaintenance => 'Forzar: Mantenimiento';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordTitle => 'Recuperar Contraseña';

  @override
  String get forgotPasswordSubtitle =>
      'Ingresa tu correo y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get sendResetLink => 'Enviar Enlace';

  @override
  String get resetEmailSent =>
      'Se ha enviado un enlace de recuperación a tu correo.';

  @override
  String get backToLogin => 'Volver al inicio de sesión';

  @override
  String get biometricLoginTitle => 'Inicio Rápido';

  @override
  String get biometricLoginSubtitle => 'Toca para iniciar sesión';

  @override
  String get biometricLoginButton => 'Iniciar con Biométrico';

  @override
  String get loginWithCredentials => 'Iniciar con usuario y contraseña';

  @override
  String get biometricSetupTitle => 'Inicio de Sesión Rápido';

  @override
  String get biometricSetupBody =>
      '¿Deseas usar tu biométrico para iniciar sesión más rápido la próxima vez?';

  @override
  String get enableBiometric => 'Activar';

  @override
  String get notNow => 'Ahora no';

  @override
  String get biometricAuthReason => 'Autentícate para iniciar sesión';

  @override
  String get biometricAuthFailed => 'La autenticación biométrica falló.';

  @override
  String get biometricNotAvailable =>
      'Los biométricos no están disponibles en este dispositivo.';
}
