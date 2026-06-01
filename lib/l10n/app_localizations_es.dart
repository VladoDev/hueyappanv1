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
  String get housingUnitLabel => 'Unidad de Vivienda';

  @override
  String housingUnitValue(String unit) {
    return 'Unidad $unit';
  }

  @override
  String get residentStatusLabel => 'Estado de Residente';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get maintenanceFees => 'Cuotas de Mantenimiento';

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
}
