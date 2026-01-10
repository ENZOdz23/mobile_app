import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
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
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

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
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile App'**
  String get appTitle;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @prospects.
  ///
  /// In en, this message translates to:
  /// **'Prospects'**
  String get prospects;

  /// No description provided for @prospectsAndContacts.
  ///
  /// In en, this message translates to:
  /// **'Prospects and Contacts'**
  String get prospectsAndContacts;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @offersB2B.
  ///
  /// In en, this message translates to:
  /// **'B2B Offers'**
  String get offersB2B;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get helpAndSupport;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWallet;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @addProspect.
  ///
  /// In en, this message translates to:
  /// **'Add Prospect'**
  String get addProspect;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @planMeeting.
  ///
  /// In en, this message translates to:
  /// **'Plan Meeting'**
  String get planMeeting;

  /// No description provided for @newContract.
  ///
  /// In en, this message translates to:
  /// **'New Contract'**
  String get newContract;

  /// No description provided for @myStats.
  ///
  /// In en, this message translates to:
  /// **'My Stats'**
  String get myStats;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @myIndicators.
  ///
  /// In en, this message translates to:
  /// **'My Indicators'**
  String get myIndicators;

  /// No description provided for @monthlyGoals.
  ///
  /// In en, this message translates to:
  /// **'Monthly Goals'**
  String get monthlyGoals;

  /// No description provided for @salesOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Monthly Sales'**
  String get salesOfMonth;

  /// No description provided for @newClients.
  ///
  /// In en, this message translates to:
  /// **'New Clients'**
  String get newClients;

  /// No description provided for @meetingsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Meetings Completed'**
  String get meetingsCompleted;

  /// No description provided for @activeProspects.
  ///
  /// In en, this message translates to:
  /// **'Active Prospects'**
  String get activeProspects;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @disconnection.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnection;

  /// No description provided for @requestOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Request OTP Code'**
  String get requestOtpCode;

  /// No description provided for @phoneNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This phone number is not registered.'**
  String get phoneNotRegistered;

  /// No description provided for @manageYourSales.
  ///
  /// In en, this message translates to:
  /// **'Manage your sales with our application'**
  String get manageYourSales;

  /// No description provided for @manageYourSalesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your sales anytime with our Prospectra online application.'**
  String get manageYourSalesSubtitle;

  /// No description provided for @deleteContact.
  ///
  /// In en, this message translates to:
  /// **'Delete this contact?'**
  String get deleteContact;

  /// No description provided for @actionIrreversible.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible.'**
  String get actionIrreversible;

  /// No description provided for @phoneNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Phone number not available'**
  String get phoneNotAvailable;

  /// No description provided for @unableToCall.
  ///
  /// In en, this message translates to:
  /// **'Unable to call'**
  String get unableToCall;

  /// No description provided for @meetingPlannedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Meeting planned successfully'**
  String get meetingPlannedSuccess;

  /// No description provided for @clientOrProspect.
  ///
  /// In en, this message translates to:
  /// **'Client / Prospect'**
  String get clientOrProspect;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @howToChangePassword.
  ///
  /// In en, this message translates to:
  /// **'How to change my password?'**
  String get howToChangePassword;

  /// No description provided for @howToChangePasswordAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > Security > Change Password.'**
  String get howToChangePasswordAnswer;

  /// No description provided for @howToContactSupport.
  ///
  /// In en, this message translates to:
  /// **'How to contact support?'**
  String get howToContactSupport;

  /// No description provided for @howToContactSupportAnswer.
  ///
  /// In en, this message translates to:
  /// **'You can call us or send an email using the buttons above.'**
  String get howToContactSupportAnswer;

  /// No description provided for @appNotSyncing.
  ///
  /// In en, this message translates to:
  /// **'The app is not syncing'**
  String get appNotSyncing;

  /// No description provided for @startTest.
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get startTest;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// No description provided for @enterprise.
  ///
  /// In en, this message translates to:
  /// **'Enterprise'**
  String get enterprise;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @downloadSpeed.
  ///
  /// In en, this message translates to:
  /// **'Download Speed'**
  String get downloadSpeed;

  /// No description provided for @uploadSpeed.
  ///
  /// In en, this message translates to:
  /// **'Upload Speed'**
  String get uploadSpeed;

  /// No description provided for @latency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get latency;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @networkSpeedTest.
  ///
  /// In en, this message translates to:
  /// **'Network Speed Test'**
  String get networkSpeedTest;

  /// No description provided for @cancelTest.
  ///
  /// In en, this message translates to:
  /// **'Cancel Test'**
  String get cancelTest;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @downloadTest.
  ///
  /// In en, this message translates to:
  /// **'Download test...'**
  String get downloadTest;

  /// No description provided for @uploadTest.
  ///
  /// In en, this message translates to:
  /// **'Upload test...'**
  String get uploadTest;

  /// No description provided for @commercial.
  ///
  /// In en, this message translates to:
  /// **'Sales Representative'**
  String get commercial;

  /// No description provided for @totalProspects.
  ///
  /// In en, this message translates to:
  /// **'Total Prospects'**
  String get totalProspects;

  /// No description provided for @totalContacts.
  ///
  /// In en, this message translates to:
  /// **'Total Contacts'**
  String get totalContacts;

  /// No description provided for @recentActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Activities'**
  String get recentActivities;

  /// No description provided for @prospectAdded.
  ///
  /// In en, this message translates to:
  /// **'Prospect added'**
  String get prospectAdded;

  /// No description provided for @prospectAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Prospect added successfully'**
  String get prospectAddedSuccess;

  /// No description provided for @contactAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Contact added successfully'**
  String get contactAddedSuccess;

  /// No description provided for @noClientFound.
  ///
  /// In en, this message translates to:
  /// **'No client found'**
  String get noClientFound;

  /// No description provided for @noProspectFound.
  ///
  /// In en, this message translates to:
  /// **'No prospect found'**
  String get noProspectFound;

  /// No description provided for @noEvent.
  ///
  /// In en, this message translates to:
  /// **'No event'**
  String get noEvent;

  /// No description provided for @newEvent.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get newEvent;

  /// No description provided for @newState.
  ///
  /// In en, this message translates to:
  /// **'New state!'**
  String get newState;

  /// No description provided for @deleteProspect.
  ///
  /// In en, this message translates to:
  /// **'Delete this prospect?'**
  String get deleteProspect;

  /// No description provided for @noInterlocutor.
  ///
  /// In en, this message translates to:
  /// **'No interlocutor'**
  String get noInterlocutor;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @changeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get changeStatus;

  /// No description provided for @interested.
  ///
  /// In en, this message translates to:
  /// **'Interested'**
  String get interested;

  /// No description provided for @notInterested.
  ///
  /// In en, this message translates to:
  /// **'Not interested'**
  String get notInterested;

  /// No description provided for @notSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Not successful'**
  String get notSuccessful;

  /// No description provided for @statusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status updated'**
  String get statusUpdated;

  /// No description provided for @interlocutorCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Interlocutor created successfully'**
  String get interlocutorCreatedSuccess;

  /// No description provided for @prospect.
  ///
  /// In en, this message translates to:
  /// **'Prospect'**
  String get prospect;

  /// No description provided for @prospectNotFound.
  ///
  /// In en, this message translates to:
  /// **'Prospect not found'**
  String get prospectNotFound;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @contactNotFound.
  ///
  /// In en, this message translates to:
  /// **'Contact not found'**
  String get contactNotFound;

  /// No description provided for @emailNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Email not available'**
  String get emailNotAvailable;

  /// No description provided for @unableToSendEmail.
  ///
  /// In en, this message translates to:
  /// **'Unable to send email'**
  String get unableToSendEmail;

  /// No description provided for @emailNotAvailableForMeeting.
  ///
  /// In en, this message translates to:
  /// **'Email not available to start a meeting'**
  String get emailNotAvailableForMeeting;

  /// No description provided for @shareMeetingLink.
  ///
  /// In en, this message translates to:
  /// **'Share the Google Meet link with'**
  String get shareMeetingLink;

  /// No description provided for @unableToStartMeet.
  ///
  /// In en, this message translates to:
  /// **'Unable to start Google Meet'**
  String get unableToStartMeet;

  /// No description provided for @interlocutors.
  ///
  /// In en, this message translates to:
  /// **'Interlocutors'**
  String get interlocutors;

  /// No description provided for @companyDetails.
  ///
  /// In en, this message translates to:
  /// **'Company details'**
  String get companyDetails;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select a state'**
  String get selectState;

  /// No description provided for @selectCompany.
  ///
  /// In en, this message translates to:
  /// **'Select a company'**
  String get selectCompany;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @wilaya.
  ///
  /// In en, this message translates to:
  /// **'Wilaya'**
  String get wilaya;

  /// No description provided for @commune.
  ///
  /// In en, this message translates to:
  /// **'Commune'**
  String get commune;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @legalForm.
  ///
  /// In en, this message translates to:
  /// **'Legal Form'**
  String get legalForm;

  /// No description provided for @sector.
  ///
  /// In en, this message translates to:
  /// **'Sector'**
  String get sector;

  /// No description provided for @nif.
  ///
  /// In en, this message translates to:
  /// **'NIF'**
  String get nif;

  /// No description provided for @rc.
  ///
  /// In en, this message translates to:
  /// **'RC'**
  String get rc;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpCode;

  /// No description provided for @yourOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Your OTP code is:'**
  String get yourOtpCode;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @welcomeToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Dashboard!'**
  String get welcomeToDashboard;

  /// No description provided for @noRouteFor.
  ///
  /// In en, this message translates to:
  /// **'No route defined for'**
  String get noRouteFor;

  /// No description provided for @accessForbidden.
  ///
  /// In en, this message translates to:
  /// **'Access forbidden. You do not have permission to perform this action.'**
  String get accessForbidden;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Mobilis. All rights reserved.'**
  String get copyright;

  /// No description provided for @appNotSyncingAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try pulling down to refresh.'**
  String get appNotSyncingAnswer;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelp;

  /// No description provided for @supportAvailable.
  ///
  /// In en, this message translates to:
  /// **'Our team is available 24/7'**
  String get supportAvailable;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'We take your privacy very seriously. All your data is encrypted and stored securely.'**
  String get privacyPolicyContent;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @dataUsageContent.
  ///
  /// In en, this message translates to:
  /// **'Your data is used only to improve your user experience and provide you with personalized services.'**
  String get dataUsageContent;

  /// No description provided for @shareUsageData.
  ///
  /// In en, this message translates to:
  /// **'Share usage data'**
  String get shareUsageData;

  /// No description provided for @allowGeolocation.
  ///
  /// In en, this message translates to:
  /// **'Allow geolocation'**
  String get allowGeolocation;

  /// No description provided for @marketingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Marketing notifications'**
  String get marketingNotifications;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @recharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get recharge;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @latestTransactions.
  ///
  /// In en, this message translates to:
  /// **'Latest Transactions'**
  String get latestTransactions;

  /// No description provided for @salesCommission.
  ///
  /// In en, this message translates to:
  /// **'Sales Commission'**
  String get salesCommission;

  /// No description provided for @withdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get withdrawal;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
    case 'fr':
      return SFr();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
