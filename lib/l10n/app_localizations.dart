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
  /// **'Hueyappan'**
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
  /// **'Phone'**
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
  /// **'My Payments'**
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
  /// **'Verification requested by {name}{unitInfo}.'**
  String adminOtpDialogBody(String name, String unitInfo);

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

  /// No description provided for @paymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Payments'**
  String get paymentsTitle;

  /// No description provided for @paymentsHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentsHistory;

  /// No description provided for @paymentsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending Dues'**
  String get paymentsPending;

  /// No description provided for @transferDetails.
  ///
  /// In en, this message translates to:
  /// **'Transfer Details'**
  String get transferDetails;

  /// No description provided for @bankNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bankNameLabel;

  /// No description provided for @clabeLabel.
  ///
  /// In en, this message translates to:
  /// **'CLABE'**
  String get clabeLabel;

  /// No description provided for @beneficiaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary'**
  String get beneficiaryLabel;

  /// No description provided for @copySuccess.
  ///
  /// In en, this message translates to:
  /// **'CLABE copied to clipboard'**
  String get copySuccess;

  /// No description provided for @partialPaymentTag.
  ///
  /// In en, this message translates to:
  /// **'Partial Payment'**
  String get partialPaymentTag;

  /// No description provided for @pendingPaymentTag.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingPaymentTag;

  /// No description provided for @paidPaymentTag.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidPaymentTag;

  /// No description provided for @conceptDetails.
  ///
  /// In en, this message translates to:
  /// **'Concept Details'**
  String get conceptDetails;

  /// No description provided for @conceptBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Charge Breakdown'**
  String get conceptBreakdown;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Administration Panel'**
  String get adminPanel;

  /// No description provided for @createConcept.
  ///
  /// In en, this message translates to:
  /// **'Create Payment Concept'**
  String get createConcept;

  /// No description provided for @editConcept.
  ///
  /// In en, this message translates to:
  /// **'Edit Payment Concept'**
  String get editConcept;

  /// No description provided for @deleteConcept.
  ///
  /// In en, this message translates to:
  /// **'Delete Concept'**
  String get deleteConcept;

  /// No description provided for @conceptTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Concept Name'**
  String get conceptTitleLabel;

  /// No description provided for @conceptDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get conceptDescLabel;

  /// No description provided for @conceptTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get conceptTotalCost;

  /// No description provided for @conceptTotalUnits.
  ///
  /// In en, this message translates to:
  /// **'Number of Houses'**
  String get conceptTotalUnits;

  /// No description provided for @amountPerHouseLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount per House'**
  String get amountPerHouseLabel;

  /// No description provided for @subItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Details / Breakdown'**
  String get subItemsLabel;

  /// No description provided for @addSubItem.
  ///
  /// In en, this message translates to:
  /// **'Add detail'**
  String get addSubItem;

  /// No description provided for @itemLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get itemLabel;

  /// No description provided for @itemAmount.
  ///
  /// In en, this message translates to:
  /// **'Cost (optional)'**
  String get itemAmount;

  /// No description provided for @editConceptWarning.
  ///
  /// In en, this message translates to:
  /// **'Note: Editing an existing concept will NOT automatically recalculate already generated dues to avoid altering recorded payments.'**
  String get editConceptWarning;

  /// No description provided for @recordedExpenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Recorded Real Expense'**
  String get recordedExpenseLabel;

  /// No description provided for @availableBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalanceLabel;

  /// No description provided for @totalCollectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Collected'**
  String get totalCollectedLabel;

  /// No description provided for @totalPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Pending'**
  String get totalPendingLabel;

  /// No description provided for @updateExpense.
  ///
  /// In en, this message translates to:
  /// **'Record Real Expense'**
  String get updateExpense;

  /// No description provided for @paidHouses.
  ///
  /// In en, this message translates to:
  /// **'Paid Houses'**
  String get paidHouses;

  /// No description provided for @pendingHouses.
  ///
  /// In en, this message translates to:
  /// **'Pending Houses'**
  String get pendingHouses;

  /// No description provided for @registerPayment.
  ///
  /// In en, this message translates to:
  /// **'Register Payment'**
  String get registerPayment;

  /// No description provided for @amountReceivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment to main fee'**
  String get amountReceivedLabel;

  /// No description provided for @referenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference / Receipt (optional)'**
  String get referenceLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesLabel;

  /// No description provided for @partialAction.
  ///
  /// In en, this message translates to:
  /// **'Partial Payment'**
  String get partialAction;

  /// No description provided for @completeAction.
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get completeAction;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this payment concept? This will delete the concept and all associated housing dues.'**
  String get deleteConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get fieldRequired;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get invalidAmount;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @closedStatus.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closedStatus;

  /// No description provided for @cancelledStatus.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledStatus;

  /// No description provided for @noPaymentsFound.
  ///
  /// In en, this message translates to:
  /// **'No payments found'**
  String get noPaymentsFound;

  /// No description provided for @noPendingPayments.
  ///
  /// In en, this message translates to:
  /// **'You have no pending dues 🎉'**
  String get noPendingPayments;

  /// No description provided for @bankTransferReference.
  ///
  /// In en, this message translates to:
  /// **'Transfer reference'**
  String get bankTransferReference;

  /// No description provided for @referenceCopySuccess.
  ///
  /// In en, this message translates to:
  /// **'Reference copied to clipboard'**
  String get referenceCopySuccess;

  /// No description provided for @extraAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Extra Amount'**
  String get extraAmountLabel;

  /// No description provided for @extraAmountInput.
  ///
  /// In en, this message translates to:
  /// **'Extra amount (e.g. keys, controls, etc.)'**
  String get extraAmountInput;

  /// No description provided for @extraPaid.
  ///
  /// In en, this message translates to:
  /// **'Extra paid'**
  String get extraPaid;

  /// No description provided for @waterStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Supply'**
  String get waterStatusTitle;

  /// No description provided for @waterStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Water available today'**
  String get waterStatusAvailable;

  /// No description provided for @waterStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No water supply today'**
  String get waterStatusUnavailable;

  /// No description provided for @waterStatusMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance in progress'**
  String get waterStatusMaintenance;

  /// No description provided for @waterStatusAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Control (Admin)'**
  String get waterStatusAdminTitle;

  /// No description provided for @waterStatusAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic (1 day yes, 1 no)'**
  String get waterStatusAuto;

  /// No description provided for @waterStatusForceAvailable.
  ///
  /// In en, this message translates to:
  /// **'Force: Available'**
  String get waterStatusForceAvailable;

  /// No description provided for @waterStatusForceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Force: Unavailable'**
  String get waterStatusForceUnavailable;

  /// No description provided for @waterStatusForceMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Force: Maintenance'**
  String get waterStatusForceMaintenance;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A recovery link has been sent to your email.'**
  String get resetEmailSent;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @biometricLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Login'**
  String get biometricLoginTitle;

  /// No description provided for @biometricLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to sign in'**
  String get biometricLoginSubtitle;

  /// No description provided for @biometricLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Biometrics'**
  String get biometricLoginButton;

  /// No description provided for @loginWithCredentials.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email and password'**
  String get loginWithCredentials;

  /// No description provided for @biometricSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Sign-In'**
  String get biometricSetupTitle;

  /// No description provided for @biometricSetupBody.
  ///
  /// In en, this message translates to:
  /// **'Would you like to use biometrics for faster sign-in next time?'**
  String get biometricSetupBody;

  /// No description provided for @enableBiometric.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enableBiometric;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @biometricAuthReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to sign in'**
  String get biometricAuthReason;

  /// No description provided for @biometricAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed.'**
  String get biometricAuthFailed;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics are not available on this device.'**
  String get biometricNotAvailable;

  /// No description provided for @enterPasswordForBiometrics.
  ///
  /// In en, this message translates to:
  /// **'To enable biometric login, please enter your password.'**
  String get enterPasswordForBiometrics;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordPlaceholder;

  /// No description provided for @biometricsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Biometrics enabled'**
  String get biometricsEnabled;

  /// No description provided for @biometricsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Biometrics disabled'**
  String get biometricsDisabled;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPassword;

  /// No description provided for @biometricToggle.
  ///
  /// In en, this message translates to:
  /// **'Biometric Sign-In'**
  String get biometricToggle;

  /// No description provided for @noConceptsCreatedYet.
  ///
  /// In en, this message translates to:
  /// **'No payment concepts created yet'**
  String get noConceptsCreatedYet;

  /// No description provided for @errorLoadingInfo.
  ///
  /// In en, this message translates to:
  /// **'Error loading information'**
  String get errorLoadingInfo;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorGeneric(Object error);

  /// No description provided for @aResident.
  ///
  /// In en, this message translates to:
  /// **'A resident'**
  String get aResident;

  /// No description provided for @criticalAlarm.
  ///
  /// In en, this message translates to:
  /// **'Critical alarm: {name} (Lot {lot})'**
  String criticalAlarm(Object name, Object lot);

  /// No description provided for @paymentMade.
  ///
  /// In en, this message translates to:
  /// **'You made a payment: {concept}'**
  String paymentMade(Object concept);

  /// No description provided for @newPaymentConcept.
  ///
  /// In en, this message translates to:
  /// **'New payment concept: {concept}'**
  String newPaymentConcept(Object concept);

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @newContact.
  ///
  /// In en, this message translates to:
  /// **'New Contact'**
  String get newContact;

  /// No description provided for @contactAdded.
  ///
  /// In en, this message translates to:
  /// **'Contact added successfully'**
  String get contactAdded;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @couldNotLaunchDialer.
  ///
  /// In en, this message translates to:
  /// **'Could not launch dialer'**
  String get couldNotLaunchDialer;

  /// No description provided for @conceptDeleted.
  ///
  /// In en, this message translates to:
  /// **'Concept deleted successfully'**
  String get conceptDeleted;

  /// No description provided for @conceptNotFound.
  ///
  /// In en, this message translates to:
  /// **'Concept not found'**
  String get conceptNotFound;

  /// No description provided for @toConfirm.
  ///
  /// In en, this message translates to:
  /// **'To confirm'**
  String get toConfirm;

  /// No description provided for @amountGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0'**
  String get amountGreaterThanZero;

  /// No description provided for @errorReportingPayment.
  ///
  /// In en, this message translates to:
  /// **'Error reporting payment.'**
  String get errorReportingPayment;

  /// No description provided for @sendReport.
  ///
  /// In en, this message translates to:
  /// **'Send Report'**
  String get sendReport;

  /// No description provided for @amountNotChanged.
  ///
  /// In en, this message translates to:
  /// **'Amount has not changed'**
  String get amountNotChanged;

  /// No description provided for @transactionRegistered.
  ///
  /// In en, this message translates to:
  /// **'Transaction registered successfully'**
  String get transactionRegistered;

  /// No description provided for @conceptUpdated.
  ///
  /// In en, this message translates to:
  /// **'Concept updated'**
  String get conceptUpdated;

  /// No description provided for @conceptCreated.
  ///
  /// In en, this message translates to:
  /// **'Concept created'**
  String get conceptCreated;

  /// No description provided for @pollCreated.
  ///
  /// In en, this message translates to:
  /// **'Poll created successfully'**
  String get pollCreated;

  /// No description provided for @createPoll.
  ///
  /// In en, this message translates to:
  /// **'Create Poll'**
  String get createPoll;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @addOption.
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get addOption;

  /// No description provided for @noPollsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No polls available'**
  String get noPollsAvailable;

  /// No description provided for @newPoll.
  ///
  /// In en, this message translates to:
  /// **'New Poll'**
  String get newPoll;

  /// No description provided for @neighborhoodPolls.
  ///
  /// In en, this message translates to:
  /// **'Neighborhood Polls'**
  String get neighborhoodPolls;

  /// No description provided for @revertRequests.
  ///
  /// In en, this message translates to:
  /// **'Revert Requests'**
  String get revertRequests;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get noPendingRequests;

  /// No description provided for @pollLabel.
  ///
  /// In en, this message translates to:
  /// **'Poll: {title}'**
  String pollLabel(Object title);

  /// No description provided for @userLabel.
  ///
  /// In en, this message translates to:
  /// **'User: {name}'**
  String userLabel(Object name);

  /// No description provided for @houseLotLabel.
  ///
  /// In en, this message translates to:
  /// **'House/Lot: {id}'**
  String houseLotLabel(Object id);

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateLabel(Object date);

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @revertRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Revert request sent to administrator'**
  String get revertRequestSent;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @alreadyVoted.
  ///
  /// In en, this message translates to:
  /// **'Already voted'**
  String get alreadyVoted;

  /// No description provided for @requestRevertVote.
  ///
  /// In en, this message translates to:
  /// **'Request to revert vote'**
  String get requestRevertVote;

  /// No description provided for @vote.
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get vote;

  /// No description provided for @pollClosedNoVote.
  ///
  /// In en, this message translates to:
  /// **'This poll is closed and you did not vote.'**
  String get pollClosedNoVote;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// No description provided for @updateRequiredDesc.
  ///
  /// In en, this message translates to:
  /// **'We have released a new version with important improvements. Please update the app to continue.'**
  String get updateRequiredDesc;

  /// No description provided for @updateInStore.
  ///
  /// In en, this message translates to:
  /// **'Update in Store'**
  String get updateInStore;

  /// No description provided for @alreadyVotedByOther.
  ///
  /// In en, this message translates to:
  /// **'Someone else ({name}) has already voted for Lot {lot}, House {house}'**
  String alreadyVotedByOther(Object name, Object lot, Object house);

  /// No description provided for @waterStatusMaintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Reported'**
  String get waterStatusMaintenanceTitle;

  /// No description provided for @waterStatusMaintenanceBody.
  ///
  /// In en, this message translates to:
  /// **'Maintenance has been reported in the water network. The external service is temporarily interrupted.'**
  String get waterStatusMaintenanceBody;

  /// No description provided for @waterStatusActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Supply'**
  String get waterStatusActiveTitle;

  /// No description provided for @waterStatusActiveBody.
  ///
  /// In en, this message translates to:
  /// **'According to the municipal calendar, the water supply is active today. We invite you to use it responsibly.'**
  String get waterStatusActiveBody;

  /// No description provided for @waterStatusInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'No Scheduled Supply'**
  String get waterStatusInactiveTitle;

  /// No description provided for @waterStatusInactiveBody.
  ///
  /// In en, this message translates to:
  /// **'According to the municipal calendar, there is no water supply scheduled in the area today. We suggest you manage your reserves.'**
  String get waterStatusInactiveBody;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get understood;

  /// No description provided for @navPolls.
  ///
  /// In en, this message translates to:
  /// **'Polls'**
  String get navPolls;

  /// No description provided for @pollWriteResponse.
  ///
  /// In en, this message translates to:
  /// **'Please write your response.'**
  String get pollWriteResponse;

  /// No description provided for @pollOtherOption.
  ///
  /// In en, this message translates to:
  /// **'Other option (Write your own response)'**
  String get pollOtherOption;

  /// No description provided for @pollWriteResponseHint.
  ///
  /// In en, this message translates to:
  /// **'Write your response here...'**
  String get pollWriteResponseHint;

  /// No description provided for @pollQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Question or Title'**
  String get pollQuestionLabel;

  /// No description provided for @pollDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get pollDescriptionLabel;

  /// No description provided for @pollOptionX.
  ///
  /// In en, this message translates to:
  /// **'Option {index}'**
  String pollOptionX(Object index);

  /// No description provided for @pollAllowCustomOptions.
  ///
  /// In en, this message translates to:
  /// **'Allow neighbors to add custom options'**
  String get pollAllowCustomOptions;

  /// No description provided for @pollCustomOptionsDescription.
  ///
  /// In en, this message translates to:
  /// **'If a neighbor writes an existing option, their vote will be added to it.'**
  String get pollCustomOptionsDescription;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @paymentNewTotalAbonadoLabel.
  ///
  /// In en, this message translates to:
  /// **'New Total Paid'**
  String get paymentNewTotalAbonadoLabel;

  /// No description provided for @paymentAmountAbonadoLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get paymentAmountAbonadoLabel;

  /// No description provided for @deleteContactConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This action cannot be undone.'**
  String deleteContactConfirm(Object name);

  /// No description provided for @deleteContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Contact'**
  String get deleteContactTitle;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account and all associated data? This action is irreversible and you will not be able to register again using this same email address.'**
  String get deleteAccountDescription;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been successfully deleted.'**
  String get deleteAccountSuccess;

  /// No description provided for @emailAlreadyDeletedError.
  ///
  /// In en, this message translates to:
  /// **'This email address is blocked because the associated account was deleted.'**
  String get emailAlreadyDeletedError;

  /// No description provided for @requiresRecentLoginError.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, you must log in again before deleting your account. Please sign out and try again.'**
  String get requiresRecentLoginError;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get reportBug;

  /// No description provided for @appIdea.
  ///
  /// In en, this message translates to:
  /// **'App Idea'**
  String get appIdea;

  /// No description provided for @neighborhoodProblem.
  ///
  /// In en, this message translates to:
  /// **'Neighborhood Problem'**
  String get neighborhoodProblem;

  /// No description provided for @whatToReport.
  ///
  /// In en, this message translates to:
  /// **'What do you want to report?'**
  String get whatToReport;

  /// No description provided for @briefTitle.
  ///
  /// In en, this message translates to:
  /// **'Brief Title'**
  String get briefTitle;

  /// No description provided for @detailedDescription.
  ///
  /// In en, this message translates to:
  /// **'Detailed Description'**
  String get detailedDescription;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @reportThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your report!'**
  String get reportThanks;

  /// No description provided for @suggestIdea.
  ///
  /// In en, this message translates to:
  /// **'Suggest Idea'**
  String get suggestIdea;

  /// No description provided for @reportLabel.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportLabel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;
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
