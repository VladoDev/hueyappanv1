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
  String get navNotifications => 'Notifications';

  @override
  String get noNotifications => 'You have no notifications';

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
  String get housingUnitLabel => 'Lot';

  @override
  String housingUnitValue(String lot, String house) {
    return '$lot-$house';
  }

  @override
  String get residentStatusLabel => 'Resident Status';

  @override
  String get signOut => 'Sign Out';

  @override
  String get maintenanceFees => 'My Payments';

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

  @override
  String get navContacts => 'Contacts';

  @override
  String get contactsTitle => 'Contact Numbers';

  @override
  String get searchContacts => 'Search contacts...';

  @override
  String get noContactsFound => 'No contacts found';

  @override
  String get favoritesOnly => 'Favorites';

  @override
  String get allContacts => 'All';

  @override
  String get securityCategory => 'Security';

  @override
  String get adminCategory => 'Admin';

  @override
  String get servicesCategory => 'Services';

  @override
  String get emergencyCategory => 'Emergency';

  @override
  String get callConfirmTitle => 'Call Contact';

  @override
  String callConfirmBody(String name, String number) {
    return 'Do you want to make a call to $name at $number?';
  }

  @override
  String get callAction => 'Call';

  @override
  String get roleLabel => 'Role';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleVecino => 'Neighbor';

  @override
  String get recaptchaRequired => 'Please verify that you are not a robot.';

  @override
  String get verifyPhoneRequiredTitle => 'Verification Required';

  @override
  String get verifyPhoneRequiredBody =>
      'In order to send Critical Alerts, you must verify your phone number.';

  @override
  String get requestVerification => 'Request Verification';

  @override
  String get enterOtp => 'Enter OTP code';

  @override
  String get verifyOtp => 'Verify Code';

  @override
  String get otpRequestedSuccess => 'Request sent to administrators.';

  @override
  String get otpVerifiedSuccess => 'Phone successfully verified!';

  @override
  String get otpVerificationFailed => 'The code is incorrect or expired.';

  @override
  String get otpAdminNotificationTitle => 'Verification Request';

  @override
  String otpAdminNotificationBody(String name, String lot, String house) {
    return 'Neighbor $name (Lot $lot-$house) requested OTP verification.';
  }

  @override
  String adminOtpDialogTitle(String name) {
    return 'OTP Code for $name';
  }

  @override
  String adminOtpDialogBody(String name, String unitInfo) {
    return 'Verification requested by $name$unitInfo.';
  }

  @override
  String get adminOtpDialogInstruction =>
      'Verify the neighbor\'s phone number and share this code with them.';

  @override
  String get close => 'Close';

  @override
  String get paymentsTitle => 'Community Payments';

  @override
  String get paymentsHistory => 'Payment History';

  @override
  String get paymentsPending => 'Pending Dues';

  @override
  String get transferDetails => 'Transfer Details';

  @override
  String get bankNameLabel => 'Bank';

  @override
  String get clabeLabel => 'CLABE';

  @override
  String get beneficiaryLabel => 'Beneficiary';

  @override
  String get copySuccess => 'CLABE copied to clipboard';

  @override
  String get partialPaymentTag => 'Partial Payment';

  @override
  String get pendingPaymentTag => 'Pending';

  @override
  String get paidPaymentTag => 'Paid';

  @override
  String get conceptDetails => 'Concept Details';

  @override
  String get conceptBreakdown => 'Charge Breakdown';

  @override
  String get adminPanel => 'Administration Panel';

  @override
  String get createConcept => 'Create Payment Concept';

  @override
  String get editConcept => 'Edit Payment Concept';

  @override
  String get deleteConcept => 'Delete Concept';

  @override
  String get conceptTitleLabel => 'Concept Name';

  @override
  String get conceptDescLabel => 'Description (optional)';

  @override
  String get conceptTotalCost => 'Total Cost';

  @override
  String get conceptTotalUnits => 'Number of Houses';

  @override
  String get amountPerHouseLabel => 'Amount per House';

  @override
  String get subItemsLabel => 'Details / Breakdown';

  @override
  String get addSubItem => 'Add detail';

  @override
  String get itemLabel => 'Description';

  @override
  String get itemAmount => 'Cost (optional)';

  @override
  String get editConceptWarning =>
      'Note: Editing an existing concept will NOT automatically recalculate already generated dues to avoid altering recorded payments.';

  @override
  String get recordedExpenseLabel => 'Recorded Real Expense';

  @override
  String get availableBalanceLabel => 'Available Balance';

  @override
  String get totalCollectedLabel => 'Total Collected';

  @override
  String get totalPendingLabel => 'Total Pending';

  @override
  String get updateExpense => 'Record Real Expense';

  @override
  String get paidHouses => 'Paid Houses';

  @override
  String get pendingHouses => 'Pending Houses';

  @override
  String get registerPayment => 'Register Payment';

  @override
  String get amountReceivedLabel => 'Payment to main fee';

  @override
  String get referenceLabel => 'Reference / Receipt (optional)';

  @override
  String get notesLabel => 'Notes (optional)';

  @override
  String get partialAction => 'Partial Payment';

  @override
  String get completeAction => 'Complete Payment';

  @override
  String get save => 'Save';

  @override
  String get deleteConfirm =>
      'Are you sure you want to delete this payment concept? This will delete the concept and all associated housing dues.';

  @override
  String get delete => 'Delete';

  @override
  String get fieldRequired => 'Required field';

  @override
  String get invalidAmount => 'Invalid amount';

  @override
  String get activeStatus => 'Active';

  @override
  String get closedStatus => 'Closed';

  @override
  String get cancelledStatus => 'Cancelled';

  @override
  String get noPaymentsFound => 'No payments found';

  @override
  String get noPendingPayments => 'You have no pending dues 🎉';

  @override
  String get bankTransferReference => 'Transfer reference';

  @override
  String get referenceCopySuccess => 'Reference copied to clipboard';

  @override
  String get extraAmountLabel => 'Extra Amount';

  @override
  String get extraAmountInput => 'Extra amount (e.g. keys, controls, etc.)';

  @override
  String get extraPaid => 'Extra paid';

  @override
  String get waterStatusTitle => 'Water Supply';

  @override
  String get waterStatusAvailable => 'Water available today';

  @override
  String get waterStatusUnavailable => 'No water supply today';

  @override
  String get waterStatusMaintenance => 'Maintenance in progress';

  @override
  String get waterStatusAdminTitle => 'Water Control (Admin)';

  @override
  String get waterStatusAuto => 'Automatic (1 day yes, 1 no)';

  @override
  String get waterStatusForceAvailable => 'Force: Available';

  @override
  String get waterStatusForceUnavailable => 'Force: Unavailable';

  @override
  String get waterStatusForceMaintenance => 'Force: Maintenance';
}
