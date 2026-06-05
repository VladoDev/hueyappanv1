import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'HueyAPPan'**
  String get appName;

  /// No description provided for @loginPortalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Convento Hueyapan Resident Portal'**
  String get loginPortalSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Access Portal'**
  String get loginButton;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register here'**
  String get registerLink;

  /// No description provided for @registerHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Resident Registration'**
  String get registerHeaderTitle;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @lotLabel.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get lotLabel;

  /// No description provided for @houseLabel.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get houseLabel;

  /// No description provided for @residentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Resident Type'**
  String get residentTypeLabel;

  /// No description provided for @propietarioLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get propietarioLabel;

  /// No description provided for @inquilinoLabel.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get inquilinoLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Phone'**
  String get phoneLabel;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get phoneRequired;

  /// No description provided for @phoneLengthInvalid.
  ///
  /// In en, this message translates to:
  /// **'Must be exactly 10 digits'**
  String get phoneLengthInvalid;

  /// No description provided for @emailRequiredRegister.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequiredRegister;

  /// No description provided for @emailInvalidRegister.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalidRegister;

  /// No description provided for @passwordRequiredRegister.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequiredRegister;

  /// No description provided for @passwordTooShortRegister.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get passwordTooShortRegister;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get navNews;

  /// No description provided for @navPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get navPayments;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications'**
  String get noNotifications;

  /// No description provided for @emergencyAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Alert'**
  String get emergencyAlertTitle;

  /// No description provided for @emergencyAlertConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to trigger the emergency alert?\n\nThis will send a high-priority push notification with sound to all community residents.'**
  String get emergencyAlertConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @activateAlarm.
  ///
  /// In en, this message translates to:
  /// **'Activate Alarm'**
  String get activateAlarm;

  /// No description provided for @alarmActivatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Emergency alert activated successfully!'**
  String get alarmActivatedSuccess;

  /// No description provided for @alarmActivatedError.
  ///
  /// In en, this message translates to:
  /// **'Error activating alarm: {error}'**
  String alarmActivatedError(String error);

  /// No description provided for @emergencyOverlayTitle.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY ALERT!'**
  String get emergencyOverlayTitle;

  /// No description provided for @emergencyOverlayBody.
  ///
  /// In en, this message translates to:
  /// **'Resident {senderName} has triggered an emergency alert in the community.'**
  String emergencyOverlayBody(String senderName);

  /// No description provided for @silenceAlarm.
  ///
  /// In en, this message translates to:
  /// **'Silence Alarm'**
  String get silenceAlarm;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @activityMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Emergency system maintenance scheduled for next Saturday.'**
  String get activityMaintenance;

  /// No description provided for @activityMaintenanceTime.
  ///
  /// In en, this message translates to:
  /// **'1h ago'**
  String get activityMaintenanceTime;

  /// No description provided for @activityAssembly.
  ///
  /// In en, this message translates to:
  /// **'Monthly resident assembly meeting minutes are uploaded.'**
  String get activityAssembly;

  /// No description provided for @activityAssemblyTime.
  ///
  /// In en, this message translates to:
  /// **'1d ago'**
  String get activityAssemblyTime;

  /// No description provided for @homeFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Neighborhood Overview'**
  String get homeFeatureTitle;

  /// No description provided for @homeFeatureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Convento Hueyapan Safe Community'**
  String get homeFeatureSubtitle;

  /// No description provided for @homeFeatureBody.
  ///
  /// In en, this message translates to:
  /// **'All systems operational. Security is monitoring access 24/7.'**
  String get homeFeatureBody;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @housingUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get housingUnitLabel;

  /// No description provided for @housingUnitValue.
  ///
  /// In en, this message translates to:
  /// **'{lot}-{house}'**
  String housingUnitValue(String lot, String house);

  /// No description provided for @residentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Resident Status'**
  String get residentStatusLabel;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @maintenanceFees.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Fees'**
  String get maintenanceFees;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @amountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get amountPaid;

  /// No description provided for @amountPaidValue.
  ///
  /// In en, this message translates to:
  /// **'\${amount} USD'**
  String amountPaidValue(String amount);

  /// No description provided for @paidStatus.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get paidStatus;

  /// No description provided for @mayDues.
  ///
  /// In en, this message translates to:
  /// **'May 2026 Dues'**
  String get mayDues;

  /// No description provided for @aprilFee.
  ///
  /// In en, this message translates to:
  /// **'April 2026 Maintenance Fee'**
  String get aprilFee;

  /// No description provided for @aprilFeeDate.
  ///
  /// In en, this message translates to:
  /// **'Paid on Apr 04, 2026'**
  String get aprilFeeDate;

  /// No description provided for @marchFee.
  ///
  /// In en, this message translates to:
  /// **'March 2026 Maintenance Fee'**
  String get marchFee;

  /// No description provided for @marchFeeDate.
  ///
  /// In en, this message translates to:
  /// **'Paid on Mar 02, 2026'**
  String get marchFeeDate;

  /// No description provided for @communityNews.
  ///
  /// In en, this message translates to:
  /// **'Community News'**
  String get communityNews;

  /// No description provided for @news1Title.
  ///
  /// In en, this message translates to:
  /// **'New Access Control Guidelines'**
  String get news1Title;

  /// No description provided for @news1Body.
  ///
  /// In en, this message translates to:
  /// **'Please ensure your guest register codes are generated via the portal 24 hours prior to their arrival. RFID tags are required for vehicle access.'**
  String get news1Body;

  /// No description provided for @news1Date.
  ///
  /// In en, this message translates to:
  /// **'May 28, 2026'**
  String get news1Date;

  /// No description provided for @news1Author.
  ///
  /// In en, this message translates to:
  /// **'Security Committee'**
  String get news1Author;

  /// No description provided for @news2Title.
  ///
  /// In en, this message translates to:
  /// **'Annual Swimming Pool Opening'**
  String get news2Title;

  /// No description provided for @news2Body.
  ///
  /// In en, this message translates to:
  /// **'The neighborhood swimming pool will open for the season starting this Friday. Pool hours are 8:00 AM - 10:00 PM daily. Please review the safety rules posted at the entry.'**
  String get news2Body;

  /// No description provided for @news2Date.
  ///
  /// In en, this message translates to:
  /// **'May 24, 2026'**
  String get news2Date;

  /// No description provided for @news2Author.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get news2Author;

  /// No description provided for @navContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get navContacts;

  /// No description provided for @contactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Numbers'**
  String get contactsTitle;

  /// No description provided for @searchContacts.
  ///
  /// In en, this message translates to:
  /// **'Search contacts...'**
  String get searchContacts;

  /// No description provided for @noContactsFound.
  ///
  /// In en, this message translates to:
  /// **'No contacts found'**
  String get noContactsFound;

  /// No description provided for @favoritesOnly.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesOnly;

  /// No description provided for @allContacts.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allContacts;

  /// No description provided for @securityCategory.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityCategory;

  /// No description provided for @adminCategory.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminCategory;

  /// No description provided for @servicesCategory.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesCategory;

  /// No description provided for @emergencyCategory.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergencyCategory;

  /// No description provided for @callConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Call Contact'**
  String get callConfirmTitle;

  /// No description provided for @callConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Do you want to make a call to {name} at {number}?'**
  String callConfirmBody(String name, String number);

  /// No description provided for @callAction.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callAction;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleLabel;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get roleAdmin;

  /// No description provided for @roleVecino.
  ///
  /// In en, this message translates to:
  /// **'Neighbor'**
  String get roleVecino;

  /// No description provided for @recaptchaRequired.
  ///
  /// In en, this message translates to:
  /// **'Please verify that you are not a robot.'**
  String get recaptchaRequired;

  /// No description provided for @verifyPhoneRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Required'**
  String get verifyPhoneRequiredTitle;

  /// No description provided for @verifyPhoneRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'In order to send Critical Alerts, you must verify your phone number.'**
  String get verifyPhoneRequiredBody;

  /// No description provided for @requestVerification.
  ///
  /// In en, this message translates to:
  /// **'Request Verification'**
  String get requestVerification;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP code'**
  String get enterOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyOtp;

  /// No description provided for @otpRequestedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request sent to administrators.'**
  String get otpRequestedSuccess;

  /// No description provided for @otpVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone successfully verified!'**
  String get otpVerifiedSuccess;

  /// No description provided for @otpVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'The code is incorrect or expired.'**
  String get otpVerificationFailed;

  /// No description provided for @otpAdminNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Request'**
  String get otpAdminNotificationTitle;

  /// No description provided for @otpAdminNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Neighbor {name} (Lot {lot}-{house}) requested OTP verification.'**
  String otpAdminNotificationBody(String name, String lot, String house);

  /// No description provided for @adminOtpDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Code for {name}'**
  String adminOtpDialogTitle(String name);

  /// No description provided for @adminOtpDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Verification requested by {name} (Lot {lot}-{house}).'**
  String adminOtpDialogBody(String name, String lot, String house);

  /// No description provided for @adminOtpDialogInstruction.
  ///
  /// In en, this message translates to:
  /// **'Verify the neighbor\'s phone number and share this code with them.'**
  String get adminOtpDialogInstruction;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
