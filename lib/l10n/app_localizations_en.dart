// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'HueyAPPan';

  @override
  String get loginPortalSubtitle => 'Convento Hueyapan Resident Portal';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get loginButton => 'Access Portal';

  @override
  String get registerLink => 'Don\'t have an account? Register here';

  @override
  String get registerHeaderTitle => 'Resident Registration';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get requiredField => 'Required';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get lotLabel => 'Lot';

  @override
  String get houseLabel => 'House';

  @override
  String get residentTypeLabel => 'Resident Type';

  @override
  String get propietarioLabel => 'Owner';

  @override
  String get inquilinoLabel => 'Tenant';

  @override
  String get phoneLabel => 'Mobile Phone';

  @override
  String get phoneRequired => 'Phone is required';

  @override
  String get phoneLengthInvalid => 'Must be exactly 10 digits';

  @override
  String get emailRequiredRegister => 'Email is required';

  @override
  String get emailInvalidRegister => 'Please enter a valid email';

  @override
  String get passwordRequiredRegister => 'Password is required';

  @override
  String get passwordTooShortRegister => 'Minimum 6 characters';

  @override
  String get registerButton => 'Register';

  @override
  String get navHome => 'Home';

  @override
  String get navNews => 'News';

  @override
  String get navPayments => 'Payments';

  @override
  String get navProfile => 'Profile';

  @override
  String get emergencyAlertTitle => 'Emergency Alert';

  @override
  String get emergencyAlertConfirm =>
      'Are you sure you want to trigger the emergency alert?\n\nThis will send a high-priority push notification with sound to all community residents.';

  @override
  String get cancel => 'Cancel';

  @override
  String get activateAlarm => 'Activate Alarm';

  @override
  String get alarmActivatedSuccess => 'Emergency alert activated successfully!';

  @override
  String alarmActivatedError(String error) {
    return 'Error activating alarm: $error';
  }

  @override
  String get emergencyOverlayTitle => 'EMERGENCY ALERT!';

  @override
  String emergencyOverlayBody(String senderName) {
    return 'Resident $senderName has triggered an emergency alert in the community.';
  }

  @override
  String get silenceAlarm => 'Silence Alarm';

  @override
  String get welcomeBack => 'Welcome back,';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get activityMaintenance =>
      'Emergency system maintenance scheduled for next Saturday.';

  @override
  String get activityMaintenanceTime => '1h ago';

  @override
  String get activityAssembly =>
      'Monthly resident assembly meeting minutes are uploaded.';

  @override
  String get activityAssemblyTime => '1d ago';

  @override
  String get homeFeatureTitle => 'Neighborhood Overview';

  @override
  String get homeFeatureSubtitle => 'Convento Hueyapan Safe Community';

  @override
  String get homeFeatureBody =>
      'All systems operational. Security is monitoring access 24/7.';

  @override
  String get myProfile => 'My Profile';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get housingUnitLabel => 'Housing Unit';

  @override
  String housingUnitValue(String unit) {
    return 'Unit $unit';
  }

  @override
  String get residentStatusLabel => 'Resident Status';

  @override
  String get signOut => 'Sign Out';

  @override
  String get maintenanceFees => 'Maintenance Fees';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get amountPaid => 'Amount Paid';

  @override
  String amountPaidValue(String amount) {
    return '\$$amount USD';
  }

  @override
  String get paidStatus => 'PAID';

  @override
  String get mayDues => 'May 2026 Dues';

  @override
  String get aprilFee => 'April 2026 Maintenance Fee';

  @override
  String get aprilFeeDate => 'Paid on Apr 04, 2026';

  @override
  String get marchFee => 'March 2026 Maintenance Fee';

  @override
  String get marchFeeDate => 'Paid on Mar 02, 2026';

  @override
  String get communityNews => 'Community News';

  @override
  String get news1Title => 'New Access Control Guidelines';

  @override
  String get news1Body =>
      'Please ensure your guest register codes are generated via the portal 24 hours prior to their arrival. RFID tags are required for vehicle access.';

  @override
  String get news1Date => 'May 28, 2026';

  @override
  String get news1Author => 'Security Committee';

  @override
  String get news2Title => 'Annual Swimming Pool Opening';

  @override
  String get news2Body =>
      'The neighborhood swimming pool will open for the season starting this Friday. Pool hours are 8:00 AM - 10:00 PM daily. Please review the safety rules posted at the entry.';

  @override
  String get news2Date => 'May 24, 2026';

  @override
  String get news2Author => 'Administration';
}
