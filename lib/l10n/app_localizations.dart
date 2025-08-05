import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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
    Locale('vi')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'P2Lan Transfer'**
  String get title;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version Information'**
  String get versionInfo;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @versionType.
  ///
  /// In en, this message translates to:
  /// **'Version Type'**
  String get versionType;

  /// No description provided for @versionTypeDev.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get versionTypeDev;

  /// No description provided for @versionTypeBeta.
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get versionTypeBeta;

  /// No description provided for @versionTypeRelease.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get versionTypeRelease;

  /// No description provided for @versionTypeDevDisplay.
  ///
  /// In en, this message translates to:
  /// **'Development Version'**
  String get versionTypeDevDisplay;

  /// No description provided for @versionTypeBetaDisplay.
  ///
  /// In en, this message translates to:
  /// **'Beta Version'**
  String get versionTypeBetaDisplay;

  /// No description provided for @versionTypeReleaseDisplay.
  ///
  /// In en, this message translates to:
  /// **'Release Version'**
  String get versionTypeReleaseDisplay;

  /// No description provided for @githubRepo.
  ///
  /// In en, this message translates to:
  /// **'GitHub Repository'**
  String get githubRepo;

  /// No description provided for @githubRepoDesc.
  ///
  /// In en, this message translates to:
  /// **'View source code of the application on GitHub'**
  String get githubRepoDesc;

  /// No description provided for @creditAck.
  ///
  /// In en, this message translates to:
  /// **'Credits & Acknowledgements'**
  String get creditAck;

  /// No description provided for @creditAckDesc.
  ///
  /// In en, this message translates to:
  /// **'Libraries and resources used in this app'**
  String get creditAckDesc;

  /// No description provided for @donorsAck.
  ///
  /// In en, this message translates to:
  /// **'Supporters Acknowledgment'**
  String get donorsAck;

  /// No description provided for @donorsAckDesc.
  ///
  /// In en, this message translates to:
  /// **'List of publicly acknowledged supporters. Thank you very much!'**
  String get donorsAckDesc;

  /// No description provided for @supportDesc.
  ///
  /// In en, this message translates to:
  /// **'P2Lan Transfer helps you transfer data between devices on the same network more easily. If you find it useful, consider supporting me to maintain and improve it. Thank you very much!'**
  String get supportDesc;

  /// No description provided for @supportOnGitHub.
  ///
  /// In en, this message translates to:
  /// **'Support on GitHub'**
  String get supportOnGitHub;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// No description provided for @donateDesc.
  ///
  /// In en, this message translates to:
  /// **'Support me if you find this app useful'**
  String get donateDesc;

  /// No description provided for @oneTimeDonation.
  ///
  /// In en, this message translates to:
  /// **'One-time Donation'**
  String get oneTimeDonation;

  /// No description provided for @momoDonateDesc.
  ///
  /// In en, this message translates to:
  /// **'Support me via Momo'**
  String get momoDonateDesc;

  /// No description provided for @donorBenefits.
  ///
  /// In en, this message translates to:
  /// **'Supporter Benefits'**
  String get donorBenefits;

  /// No description provided for @donorBenefit1.
  ///
  /// In en, this message translates to:
  /// **'Be listed in the acknowledgments and share your comments (if you want).'**
  String get donorBenefit1;

  /// No description provided for @donorBenefit2.
  ///
  /// In en, this message translates to:
  /// **'Prioritized feedback consideration.'**
  String get donorBenefit2;

  /// No description provided for @donorBenefit3.
  ///
  /// In en, this message translates to:
  /// **'Access to beta (debug) versions, however updates are not guaranteed to be frequent.'**
  String get donorBenefit3;

  /// No description provided for @donorBenefit4.
  ///
  /// In en, this message translates to:
  /// **'Access to dev repo (Github Sponsors only).'**
  String get donorBenefit4;

  /// No description provided for @checkForNewVersion.
  ///
  /// In en, this message translates to:
  /// **'Check for New Version'**
  String get checkForNewVersion;

  /// No description provided for @checkForNewVersionDesc.
  ///
  /// In en, this message translates to:
  /// **'Check if there is a new version of the app and download the latest version if available'**
  String get checkForNewVersionDesc;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @routine.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get routine;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @viewMode.
  ///
  /// In en, this message translates to:
  /// **'View Mode'**
  String get viewMode;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @archives.
  ///
  /// In en, this message translates to:
  /// **'Archives'**
  String get archives;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @userInterface.
  ///
  /// In en, this message translates to:
  /// **'User Interface'**
  String get userInterface;

  /// No description provided for @userInterfaceDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme, language and appearance settings'**
  String get userInterfaceDesc;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @viewCacheDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewCacheDetails;

  /// No description provided for @cacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cache Size'**
  String get cacheSize;

  /// No description provided for @clearAllCache.
  ///
  /// In en, this message translates to:
  /// **'Clear All Cache'**
  String get clearAllCache;

  /// No description provided for @clearStorageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Storage Settings'**
  String get clearStorageSettingsTitle;

  /// No description provided for @clearStorageSettingsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearStorageSettingsConfirm;

  /// No description provided for @clearStorageSettingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get clearStorageSettingsCancel;

  /// No description provided for @clearStorageSettingsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This action will permanently delete all cached data including templates, history, and temporary files. Your app settings will be preserved.'**
  String get clearStorageSettingsConfirmation;

  /// No description provided for @clearStorageSettingsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Storage settings cleared successfully'**
  String get clearStorageSettingsSuccess;

  /// No description provided for @viewLogs.
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get viewLogs;

  /// No description provided for @clearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear Logs'**
  String get clearLogs;

  /// No description provided for @logRetention.
  ///
  /// In en, this message translates to:
  /// **'Log Retention'**
  String get logRetention;

  /// No description provided for @logRetentionDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String logRetentionDays(int days);

  /// No description provided for @logRetentionForever.
  ///
  /// In en, this message translates to:
  /// **'Keep forever'**
  String get logRetentionForever;

  /// No description provided for @logRetentionDescDetail.
  ///
  /// In en, this message translates to:
  /// **'Choose log retention period (5-30 days in 5-day intervals, or forever)'**
  String get logRetentionDescDetail;

  /// No description provided for @dataAndStorage.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get dataAndStorage;

  /// No description provided for @dataAndStorageDesc.
  ///
  /// In en, this message translates to:
  /// **'Cache, logs & data retention settings'**
  String get dataAndStorageDesc;

  /// Warning text for caches that cannot be cleared
  ///
  /// In en, this message translates to:
  /// **'The following caches cannot be cleared because they are currently in use:'**
  String get cannotClearFollowingCaches;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Label for saved devices
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @trusted.
  ///
  /// In en, this message translates to:
  /// **'Trusted'**
  String get trusted;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @fileName.
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get fileName;

  /// No description provided for @overwrite.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @aboutDesc.
  ///
  /// In en, this message translates to:
  /// **'App information and acknowledgements'**
  String get aboutDesc;

  /// No description provided for @random.
  ///
  /// In en, this message translates to:
  /// **'Random Generator'**
  String get random;

  /// No description provided for @holdToDeleteInstruction.
  ///
  /// In en, this message translates to:
  /// **'Hold the delete button for 5 seconds to confirm'**
  String get holdToDeleteInstruction;

  /// No description provided for @holdToDelete.
  ///
  /// In en, this message translates to:
  /// **'Hold to delete...'**
  String get holdToDelete;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @importResults.
  ///
  /// In en, this message translates to:
  /// **'Import Results'**
  String get importResults;

  /// No description provided for @importSummary.
  ///
  /// In en, this message translates to:
  /// **'{successCount} successful, {failCount} failed'**
  String importSummary(Object failCount, Object successCount);

  /// No description provided for @successfulImports.
  ///
  /// In en, this message translates to:
  /// **'Successful imports ({count})'**
  String successfulImports(Object count);

  /// No description provided for @failedImports.
  ///
  /// In en, this message translates to:
  /// **'Failed imports ({count})'**
  String failedImports(Object count);

  /// No description provided for @noImportsAttempted.
  ///
  /// In en, this message translates to:
  /// **'No files were selected for import'**
  String get noImportsAttempted;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @batchDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get batchDelete;

  /// No description provided for @confirmBatchDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Batch Delete'**
  String get confirmBatchDelete;

  /// No description provided for @typeConfirmToDelete.
  ///
  /// In en, this message translates to:
  /// **'Type \"confirm\" to delete {count} selected templates:'**
  String typeConfirmToDelete(Object count);

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copyToClipboard;

  /// No description provided for @filterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by Type'**
  String get filterByType;

  /// No description provided for @bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get bookmark;

  /// No description provided for @numberOfDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String numberOfDays(int count);

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @weekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get weekday;

  /// No description provided for @first.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get first;

  /// No description provided for @last.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get last;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @minValue.
  ///
  /// In en, this message translates to:
  /// **'Minimum Value'**
  String get minValue;

  /// No description provided for @maxValue.
  ///
  /// In en, this message translates to:
  /// **'Maximum Value'**
  String get maxValue;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @yesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes or No?'**
  String get yesNo;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteWithFile.
  ///
  /// In en, this message translates to:
  /// **'Delete with file'**
  String get deleteWithFile;

  /// No description provided for @deleteTaskOnly.
  ///
  /// In en, this message translates to:
  /// **'Delete task only'**
  String get deleteTaskOnly;

  /// No description provided for @deleteTaskWithFile.
  ///
  /// In en, this message translates to:
  /// **'Delete task with file'**
  String get deleteTaskWithFile;

  /// No description provided for @deleteTaskWithFileConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task and file?'**
  String get deleteTaskWithFileConfirm;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @generationHistory.
  ///
  /// In en, this message translates to:
  /// **'Generation History'**
  String get generationHistory;

  /// No description provided for @generatedAt.
  ///
  /// In en, this message translates to:
  /// **'Generated at'**
  String get generatedAt;

  /// No description provided for @noHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Your BMI calculation history will appear here'**
  String get noHistoryMessage;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @resetToDefaultsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings to their default values?'**
  String get resetToDefaultsConfirm;

  /// No description provided for @keep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keep;

  /// Button to clear all selected files
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @converterTools.
  ///
  /// In en, this message translates to:
  /// **'Converter Tools'**
  String get converterTools;

  /// No description provided for @calculatorTools.
  ///
  /// In en, this message translates to:
  /// **'Calculator Tools'**
  String get calculatorTools;

  /// No description provided for @bytes.
  ///
  /// In en, this message translates to:
  /// **'Bytes'**
  String get bytes;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Cache info with log size
  ///
  /// In en, this message translates to:
  /// **'Cache: {cacheSize} (+{logSize} log)'**
  String cacheWithLogSize(String cacheSize, String logSize);

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get timeout;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// Unknown status or value
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @statusInfo.
  ///
  /// In en, this message translates to:
  /// **'Status: {info}'**
  String statusInfo(String info);

  /// No description provided for @logsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Logs available'**
  String get logsAvailable;

  /// No description provided for @notAvailableYet.
  ///
  /// In en, this message translates to:
  /// **'Not available yet'**
  String get notAvailableYet;

  /// No description provided for @scrollToTop.
  ///
  /// In en, this message translates to:
  /// **'Scroll to Top'**
  String get scrollToTop;

  /// No description provided for @scrollToBottom.
  ///
  /// In en, this message translates to:
  /// **'Scroll to Bottom'**
  String get scrollToBottom;

  /// No description provided for @logActions.
  ///
  /// In en, this message translates to:
  /// **'Log Actions'**
  String get logActions;

  /// No description provided for @logApplication.
  ///
  /// In en, this message translates to:
  /// **'Log Application'**
  String get logApplication;

  /// No description provided for @previousChunk.
  ///
  /// In en, this message translates to:
  /// **'Previous Chunk'**
  String get previousChunk;

  /// No description provided for @nextChunk.
  ///
  /// In en, this message translates to:
  /// **'Next Chunk'**
  String get nextChunk;

  /// No description provided for @load.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get load;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadAll.
  ///
  /// In en, this message translates to:
  /// **'Load All'**
  String get loadAll;

  /// No description provided for @firstPart.
  ///
  /// In en, this message translates to:
  /// **'First Part'**
  String get firstPart;

  /// No description provided for @lastPart.
  ///
  /// In en, this message translates to:
  /// **'Last Part'**
  String get lastPart;

  /// No description provided for @largeFile.
  ///
  /// In en, this message translates to:
  /// **'Large File'**
  String get largeFile;

  /// No description provided for @loadingLargeFile.
  ///
  /// In en, this message translates to:
  /// **'Loading large file...'**
  String get loadingLargeFile;

  /// No description provided for @loadingLogContent.
  ///
  /// In en, this message translates to:
  /// **'Loading log content...'**
  String get loadingLogContent;

  /// No description provided for @largeFileDetected.
  ///
  /// In en, this message translates to:
  /// **'Large file detected. Using optimized loading...'**
  String get largeFileDetected;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// Focus mode setting label
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusModeEnabled;

  /// No description provided for @focusModeEnabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Focus mode activated. {exitInstruction}'**
  String focusModeEnabledMessage(String exitInstruction);

  /// No description provided for @focusModeDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Focus mode deactivated. All interface elements are now visible.'**
  String get focusModeDisabledMessage;

  /// No description provided for @exitFocusModeDesktop.
  ///
  /// In en, this message translates to:
  /// **'Tap the focus icon in the app bar to exit'**
  String get exitFocusModeDesktop;

  /// No description provided for @exitFocusModeMobile.
  ///
  /// In en, this message translates to:
  /// **'Zoom out or tap the focus icon to exit'**
  String get exitFocusModeMobile;

  /// No description provided for @aspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatio;

  /// No description provided for @joystickMode.
  ///
  /// In en, this message translates to:
  /// **'Joystick Mode'**
  String get joystickMode;

  /// Button to confirm reset
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @selectedColor.
  ///
  /// In en, this message translates to:
  /// **'Selected Color'**
  String get selectedColor;

  /// No description provided for @predefinedColors.
  ///
  /// In en, this message translates to:
  /// **'Predefined Colors'**
  String get predefinedColors;

  /// No description provided for @customColor.
  ///
  /// In en, this message translates to:
  /// **'Custom Color'**
  String get customColor;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @deletingOldLogs.
  ///
  /// In en, this message translates to:
  /// **'Deleting old logs...'**
  String get deletingOldLogs;

  /// Message showing how many old log files were deleted
  ///
  /// In en, this message translates to:
  /// **'Deleted {count} old log files'**
  String deletedOldLogFiles(int count);

  /// No description provided for @noOldLogFilesToDelete.
  ///
  /// In en, this message translates to:
  /// **'No old log files to delete'**
  String get noOldLogFilesToDelete;

  /// Error message when deleting logs fails
  ///
  /// In en, this message translates to:
  /// **'Error deleting logs: {error}'**
  String errorDeletingLogs(String error);

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @networkSecurityWarning.
  ///
  /// In en, this message translates to:
  /// **'Network Security Warning'**
  String get networkSecurityWarning;

  /// No description provided for @unsecureNetworkDetected.
  ///
  /// In en, this message translates to:
  /// **'Unsecure network detected'**
  String get unsecureNetworkDetected;

  /// No description provided for @currentNetwork.
  ///
  /// In en, this message translates to:
  /// **'Current Network'**
  String get currentNetwork;

  /// No description provided for @securityLevel.
  ///
  /// In en, this message translates to:
  /// **'Security Level'**
  String get securityLevel;

  /// No description provided for @securityRisks.
  ///
  /// In en, this message translates to:
  /// **'Security Risks'**
  String get securityRisks;

  /// No description provided for @unsecureNetworkRisks.
  ///
  /// In en, this message translates to:
  /// **'On unsecure networks, your data transmissions may be intercepted by malicious users. Only proceed if you trust the network and other users.'**
  String get unsecureNetworkRisks;

  /// No description provided for @proceedAnyway.
  ///
  /// In en, this message translates to:
  /// **'Proceed Anyway'**
  String get proceedAnyway;

  /// No description provided for @secureNetwork.
  ///
  /// In en, this message translates to:
  /// **'Secure (WPA/WPA2)'**
  String get secureNetwork;

  /// No description provided for @unsecureNetwork.
  ///
  /// In en, this message translates to:
  /// **'Unsecure (Open/No Password)'**
  String get unsecureNetwork;

  /// No description provided for @unknownSecurity.
  ///
  /// In en, this message translates to:
  /// **'Unknown Security'**
  String get unknownSecurity;

  /// No description provided for @startNetworking.
  ///
  /// In en, this message translates to:
  /// **'Start Networking'**
  String get startNetworking;

  /// No description provided for @stopNetworking.
  ///
  /// In en, this message translates to:
  /// **'Stop Networking'**
  String get stopNetworking;

  /// No description provided for @transferReRequests.
  ///
  /// In en, this message translates to:
  /// **'Transfer Requests'**
  String get transferReRequests;

  /// No description provided for @transferTasks.
  ///
  /// In en, this message translates to:
  /// **'Transfer Tasks'**
  String get transferTasks;

  /// No description provided for @pairingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pairing Requests'**
  String get pairingRequests;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @transfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get transfers;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @connectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// No description provided for @networkInfo.
  ///
  /// In en, this message translates to:
  /// **'Network Info'**
  String get networkInfo;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @discoveredDevices.
  ///
  /// In en, this message translates to:
  /// **'Discovered devices'**
  String get discoveredDevices;

  /// No description provided for @pairedDevices.
  ///
  /// In en, this message translates to:
  /// **'Paired devices'**
  String get pairedDevices;

  /// No description provided for @activeTransfers.
  ///
  /// In en, this message translates to:
  /// **'Active transfers'**
  String get activeTransfers;

  /// No description provided for @completedTransfers.
  ///
  /// In en, this message translates to:
  /// **'Completed transfers'**
  String get completedTransfers;

  /// No description provided for @failedTransfers.
  ///
  /// In en, this message translates to:
  /// **'Failed transfers'**
  String get failedTransfers;

  /// No description provided for @noDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevicesFound;

  /// No description provided for @searchingForDevices.
  ///
  /// In en, this message translates to:
  /// **'Searching for devices...'**
  String get searchingForDevices;

  /// No description provided for @startNetworkingToDiscover.
  ///
  /// In en, this message translates to:
  /// **'Start networking to discover devices'**
  String get startNetworkingToDiscover;

  /// No description provided for @noActiveTransfers.
  ///
  /// In en, this message translates to:
  /// **'No active transfers'**
  String get noActiveTransfers;

  /// No description provided for @transfersWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Data transfers will appear here'**
  String get transfersWillAppearHere;

  /// No description provided for @paired.
  ///
  /// In en, this message translates to:
  /// **'Paired'**
  String get paired;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last Seen'**
  String get lastSeen;

  /// No description provided for @pairedSince.
  ///
  /// In en, this message translates to:
  /// **'Paired Since'**
  String get pairedSince;

  /// No description provided for @pair.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get pair;

  /// No description provided for @cancelTransfer.
  ///
  /// In en, this message translates to:
  /// **'Cancel Transfer'**
  String get cancelTransfer;

  /// No description provided for @confirmCancelTransfer.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this transfer?'**
  String get confirmCancelTransfer;

  /// Title for the permission request dialog
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get p2pPermissionRequiredTitle;

  /// Explanation for why location permission is needed for P2P
  ///
  /// In en, this message translates to:
  /// **'To discover nearby devices using WiFi, this app needs access to your location. This is an Android requirement for scanning WiFi networks. Your location data is not stored or shared. The app is client-side and we do not collect any user data.'**
  String get p2pPermissionExplanation;

  /// Button text to continue with granting permission
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get p2pPermissionContinue;

  /// Button text to cancel the permission request
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get p2pPermissionCancel;

  /// Title for the nearby devices permission request dialog
  ///
  /// In en, this message translates to:
  /// **'Nearby Devices Permission Required'**
  String get p2pNearbyDevicesPermissionTitle;

  /// Explanation for why nearby WiFi devices permission is needed for P2P
  ///
  /// In en, this message translates to:
  /// **'To discover nearby devices on modern Android versions, this app needs access to nearby WiFi devices. This permission allows the app to scan for WiFi networks without accessing your location. Your data is not stored or shared. The app is client-side and we do not collect any user data.'**
  String get p2pNearbyDevicesPermissionExplanation;

  /// No description provided for @sendData.
  ///
  /// In en, this message translates to:
  /// **'Send Data'**
  String get sendData;

  /// No description provided for @savedDevices.
  ///
  /// In en, this message translates to:
  /// **'Saved Devices'**
  String get savedDevices;

  /// Title for the P2Lan Transfer screen
  ///
  /// In en, this message translates to:
  /// **'P2Lan Transfer'**
  String get p2lanTransfer;

  /// Notification type for P2LAN active status
  ///
  /// In en, this message translates to:
  /// **'P2LAN Status'**
  String get p2lanStatus;

  /// Notification type for detailed file transfer status
  ///
  /// In en, this message translates to:
  /// **'File Transfer Status'**
  String get fileTransferStatus;

  /// Question in user pairing dialog
  ///
  /// In en, this message translates to:
  /// **'Do you want to pair with this device?'**
  String get pairWithDevice;

  /// Label for device ID field
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceId;

  /// Label for when device was discovered
  ///
  /// In en, this message translates to:
  /// **'Discovery Time'**
  String get discoveryTime;

  /// Checkbox label to save connection
  ///
  /// In en, this message translates to:
  /// **'Save Connection'**
  String get saveConnection;

  /// Description for save connection option
  ///
  /// In en, this message translates to:
  /// **'Automatically reconnect when both devices are online'**
  String get autoReconnectDescription;

  /// Information about pairing process
  ///
  /// In en, this message translates to:
  /// **'The other user will receive a pairing request and needs to accept to complete the pairing.'**
  String get pairingNotificationInfo;

  /// Button to send pairing request
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// Time indication for very recent actions
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr ago'**
  String hoursAgo(int hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(int days);

  /// Text when there are no pairing requests
  ///
  /// In en, this message translates to:
  /// **'No pairing requests'**
  String get noPairingRequests;

  /// Text indicating source of pairing request
  ///
  /// In en, this message translates to:
  /// **'Pairing request from:'**
  String get pairingRequestFrom;

  /// Label for when request was sent
  ///
  /// In en, this message translates to:
  /// **'Sent Time'**
  String get sentTime;

  /// No description provided for @trustThisUser.
  ///
  /// In en, this message translates to:
  /// **'Trust this user'**
  String get trustThisUser;

  /// No description provided for @allowFileTransfersWithoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Allow file transfers without confirmation'**
  String get allowFileTransfersWithoutConfirmation;

  /// Security warning about pairing
  ///
  /// In en, this message translates to:
  /// **'Only accept pairing from devices you trust.'**
  String get onlyAcceptFromTrustedDevices;

  /// Tooltip for previous request button
  ///
  /// In en, this message translates to:
  /// **'Previous request'**
  String get previousRequest;

  /// Tooltip for next request button
  ///
  /// In en, this message translates to:
  /// **'Next request'**
  String get nextRequest;

  /// Button to reject pairing/transfer request
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Button to accept pairing/transfer request
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Title for incoming file transfer dialog
  ///
  /// In en, this message translates to:
  /// **'Incoming Files'**
  String get incomingFiles;

  /// Text showing sender wants to send files
  ///
  /// In en, this message translates to:
  /// **'wants to send you {count} file(s)'**
  String wantsToSendYouFiles(int count);

  /// Header for list of files to receive
  ///
  /// In en, this message translates to:
  /// **'Files to receive:'**
  String get filesToReceive;

  /// Label for total file size
  ///
  /// In en, this message translates to:
  /// **'Total size:'**
  String get totalSize;

  /// Tooltip for local files button
  ///
  /// In en, this message translates to:
  /// **'Local Files'**
  String get localFiles;

  /// Tooltip and label for manual discovery
  ///
  /// In en, this message translates to:
  /// **'Manual Discovery'**
  String get manualDiscovery;

  /// Tooltip for transfer settings button
  ///
  /// In en, this message translates to:
  /// **'Transfer Settings'**
  String get transferSettings;

  /// Subtitle for saved devices section
  ///
  /// In en, this message translates to:
  /// **'Saved devices currently available'**
  String get savedDevicesCurrentlyAvailable;

  /// Subtitle for discovered devices section
  ///
  /// In en, this message translates to:
  /// **'Recently discovered devices'**
  String get recentlyDiscoveredDevices;

  /// Menu option to view device info
  ///
  /// In en, this message translates to:
  /// **'View Info'**
  String get viewInfo;

  /// Menu option to trust device
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get trust;

  /// Menu option to remove trust
  ///
  /// In en, this message translates to:
  /// **'Remove Trust'**
  String get removeTrust;

  /// Menu option to unpair device
  ///
  /// In en, this message translates to:
  /// **'Unpair'**
  String get unpair;

  /// Label for current device
  ///
  /// In en, this message translates to:
  /// **'This Device'**
  String get thisDevice;

  /// Label for file cache section
  ///
  /// In en, this message translates to:
  /// **'File Cache'**
  String get fileCache;

  /// Button to reload cache size
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// Button to clear cache
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Debug button label
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// Error message for settings load failure
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings: {error}'**
  String failedToLoadSettings(String error);

  /// Confirmation to remove trust from device
  ///
  /// In en, this message translates to:
  /// **'Remove trust from {deviceName}?'**
  String removeTrustFrom(String deviceName);

  /// Button to remove/delete
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Title for unpair dialog
  ///
  /// In en, this message translates to:
  /// **'Unpair from {deviceName}'**
  String unpairFrom(String deviceName);

  /// Description of unpair action
  ///
  /// In en, this message translates to:
  /// **'This will remove the pairing completely from both devices. You will need to pair again in the future.\n\nThe other device will also be notified and their connection will be removed.'**
  String get unpairDescription;

  /// Button text for unpair confirmation
  ///
  /// In en, this message translates to:
  /// **'Hold to Unpair'**
  String get holdToUnpair;

  /// Text shown during unpair process
  ///
  /// In en, this message translates to:
  /// **'Unpairing...'**
  String get unpairing;

  /// Instruction for unpair confirmation
  ///
  /// In en, this message translates to:
  /// **'Hold the button for 1 second to confirm unpair'**
  String get holdButtonToConfirmUnpair;

  /// Success message when task and file are deleted
  ///
  /// In en, this message translates to:
  /// **'Task and file deleted successfully'**
  String get taskAndFileDeletedSuccessfully;

  /// Status text during file sending
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// Button to send selected files
  ///
  /// In en, this message translates to:
  /// **'Send files'**
  String get sendFiles;

  /// Button to add files
  ///
  /// In en, this message translates to:
  /// **'Add Files'**
  String get addFiles;

  /// Message when no files are selected
  ///
  /// In en, this message translates to:
  /// **'No files selected'**
  String get noFilesSelected;

  /// Instructions for file options
  ///
  /// In en, this message translates to:
  /// **'Tap or right-click for options'**
  String get tapRightClickForOptions;

  /// Option for unlimited size/count
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// Description of UDP protocol
  ///
  /// In en, this message translates to:
  /// **'Faster but less reliable, good for large files'**
  String get udpDescription;

  /// Option to create folders by date
  ///
  /// In en, this message translates to:
  /// **'Create date folders'**
  String get createDateFolders;

  /// Option to create folders by sender
  ///
  /// In en, this message translates to:
  /// **'Create sender folders'**
  String get createSenderFolders;

  /// Option for immediate UI updates
  ///
  /// In en, this message translates to:
  /// **'Immediate'**
  String get immediate;

  /// No organization option
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Button and dialog title to reset settings
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get resetToDefaults;

  /// Tab label for storage settings
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// Tab label for network settings
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// Section header for user preferences
  ///
  /// In en, this message translates to:
  /// **'User Preferences'**
  String get userPreferences;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Label for UI refresh rate setting
  ///
  /// In en, this message translates to:
  /// **'UI Refresh Rate'**
  String get uiRefreshRate;

  /// Section header for current config display
  ///
  /// In en, this message translates to:
  /// **'Current Configuration'**
  String get currentConfiguration;

  /// Label for protocol setting
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get protocol;

  /// Label for maximum file size setting
  ///
  /// In en, this message translates to:
  /// **'Max File Size'**
  String get maxFileSize;

  /// Label for maximum total size setting
  ///
  /// In en, this message translates to:
  /// **'Maximum total size (per transfer batch)'**
  String get maxTotalSize;

  /// Label for concurrent tasks setting
  ///
  /// In en, this message translates to:
  /// **'Concurrent Tasks'**
  String get concurrentTasks;

  /// Label for chunk size setting
  ///
  /// In en, this message translates to:
  /// **'Chunk Size'**
  String get chunkSize;

  /// Label for file organization setting
  ///
  /// In en, this message translates to:
  /// **'File Organization'**
  String get fileOrganization;

  /// Label for download path
  ///
  /// In en, this message translates to:
  /// **'Download Path'**
  String get downloadPath;

  /// Label for total disk space
  ///
  /// In en, this message translates to:
  /// **'Total Space'**
  String get totalSpace;

  /// Label for free disk space
  ///
  /// In en, this message translates to:
  /// **'Free Space'**
  String get freeSpace;

  /// Label for used disk space
  ///
  /// In en, this message translates to:
  /// **'Used Space'**
  String get usedSpace;

  /// Message when no download path is configured
  ///
  /// In en, this message translates to:
  /// **'No Download Path Set'**
  String get noDownloadPathSet;

  /// Section header for download location settings
  ///
  /// In en, this message translates to:
  /// **'Download Location'**
  String get downloadLocation;

  /// Label for download folder setting
  ///
  /// In en, this message translates to:
  /// **'Download Folder'**
  String get downloadFolder;

  /// Section header for Android storage permissions
  ///
  /// In en, this message translates to:
  /// **'Android Storage Access'**
  String get androidStorageAccess;

  /// Button to use app-specific folder
  ///
  /// In en, this message translates to:
  /// **'Use App Folder'**
  String get useAppFolder;

  /// Section header for size limit settings
  ///
  /// In en, this message translates to:
  /// **'Size Limits'**
  String get sizeLimits;

  /// Section header for performance settings
  ///
  /// In en, this message translates to:
  /// **'Performance Tuning'**
  String get performanceTuning;

  /// Description for concurrent transfers setting
  ///
  /// In en, this message translates to:
  /// **' = faster overall but higher CPU usage'**
  String get concurrentTransfersDescription;

  /// Description for chunk size setting
  ///
  /// In en, this message translates to:
  /// **'Higher sizes = faster transfers but more memory usage'**
  String get transferChunkSizeDescription;

  /// No description provided for @loadingDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Loading device information...'**
  String get loadingDeviceInfo;

  /// No description provided for @tempFilesDescription.
  ///
  /// In en, this message translates to:
  /// **'Temporary files from P2Lan file transfers'**
  String get tempFilesDescription;

  /// No description provided for @networkDebugCompleted.
  ///
  /// In en, this message translates to:
  /// **'Network debug completed. Check logs for details.'**
  String get networkDebugCompleted;

  /// No description provided for @lastRefresh.
  ///
  /// In en, this message translates to:
  /// **'Last refresh: {time}'**
  String lastRefresh(String time);

  /// No description provided for @p2pNetworkingPaused.
  ///
  /// In en, this message translates to:
  /// **'P2P networking is paused due to internet connection loss. It will automatically resume when connection is restored.'**
  String get p2pNetworkingPaused;

  /// No description provided for @noDevicesInRange.
  ///
  /// In en, this message translates to:
  /// **'No devices in range. Try refreshing.'**
  String get noDevicesInRange;

  /// No description provided for @initialDiscoveryInProgress.
  ///
  /// In en, this message translates to:
  /// **'Initial discovery in progress...'**
  String get initialDiscoveryInProgress;

  /// No description provided for @refreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// No description provided for @startedSending.
  ///
  /// In en, this message translates to:
  /// **'Started sending {count} files to {name}'**
  String startedSending(int count, String name);

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @discoveringDevices.
  ///
  /// In en, this message translates to:
  /// **'Discovering devices...'**
  String get discoveringDevices;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @pairing.
  ///
  /// In en, this message translates to:
  /// **'Pairing...'**
  String get pairing;

  /// No description provided for @checkingNetwork.
  ///
  /// In en, this message translates to:
  /// **'Checking network...'**
  String get checkingNetwork;

  /// No description provided for @connectedViaMobileData.
  ///
  /// In en, this message translates to:
  /// **'Connected via mobile data (secure)'**
  String get connectedViaMobileData;

  /// No description provided for @connectedToWifi.
  ///
  /// In en, this message translates to:
  /// **'Connected to {name} ({security})'**
  String connectedToWifi(String name, String security);

  /// No description provided for @secure.
  ///
  /// In en, this message translates to:
  /// **'secure'**
  String get secure;

  /// No description provided for @unsecure.
  ///
  /// In en, this message translates to:
  /// **'unsecure'**
  String get unsecure;

  /// No description provided for @connectedViaEthernet.
  ///
  /// In en, this message translates to:
  /// **'Connected via Ethernet (secure)'**
  String get connectedViaEthernet;

  /// No description provided for @noNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'No network connection'**
  String get noNetworkConnection;

  /// No description provided for @maxConcurrentTasks.
  ///
  /// In en, this message translates to:
  /// **'Max Concurrent Tasks'**
  String get maxConcurrentTasks;

  /// No description provided for @customDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Custom Display Name'**
  String get customDisplayName;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// No description provided for @deviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter custom device name...'**
  String get deviceNameHint;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @generalDesc.
  ///
  /// In en, this message translates to:
  /// **'Device name, notifications & user preferences'**
  String get generalDesc;

  /// No description provided for @receiverLocationSizeLimits.
  ///
  /// In en, this message translates to:
  /// **'Receiver Location & Size Limits'**
  String get receiverLocationSizeLimits;

  /// No description provided for @receiverLocationSizeLimitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Download folder, file organization & size limits'**
  String get receiverLocationSizeLimitsDesc;

  /// No description provided for @networkSpeed.
  ///
  /// In en, this message translates to:
  /// **'Network & Speed'**
  String get networkSpeed;

  /// No description provided for @networkSpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Protocol settings, performance tuning & optimization'**
  String get networkSpeedDesc;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @advancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Security, encryption & compression settings'**
  String get advancedDesc;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @secondsLabel.
  ///
  /// In en, this message translates to:
  /// **'second'**
  String get secondsLabel;

  /// No description provided for @secondsPlural.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get secondsPlural;

  /// No description provided for @onlineDevices.
  ///
  /// In en, this message translates to:
  /// **'Online Devices'**
  String get onlineDevices;

  /// No description provided for @newDevices.
  ///
  /// In en, this message translates to:
  /// **'New Devices'**
  String get newDevices;

  /// No description provided for @addTrust.
  ///
  /// In en, this message translates to:
  /// **'Add Trust'**
  String get addTrust;

  /// No description provided for @p2pTemporarilyDisabled.
  ///
  /// In en, this message translates to:
  /// **'P2P temporarily disabled - waiting for internet connection'**
  String get p2pTemporarilyDisabled;

  /// No description provided for @fileOrgNoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Files go directly to download folder'**
  String get fileOrgNoneDescription;

  /// No description provided for @fileOrgDateDescription.
  ///
  /// In en, this message translates to:
  /// **'Organize by date (YYYY-MM-DD)'**
  String get fileOrgDateDescription;

  /// No description provided for @fileOrgSenderDescription.
  ///
  /// In en, this message translates to:
  /// **'Organize by sender display name'**
  String get fileOrgSenderDescription;

  /// No description provided for @settingsTabGeneric.
  ///
  /// In en, this message translates to:
  /// **'Generic'**
  String get settingsTabGeneric;

  /// No description provided for @settingsTabStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get settingsTabStorage;

  /// No description provided for @settingsTabNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get settingsTabNetwork;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @displayNameDescription.
  ///
  /// In en, this message translates to:
  /// **'Customize how your device appears to other users'**
  String get displayNameDescription;

  /// No description provided for @enterDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Enter display name'**
  String get enterDisplayName;

  /// No description provided for @deviceDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Display Name'**
  String get deviceDisplayNameLabel;

  /// No description provided for @deviceDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter custom display name...'**
  String get deviceDisplayNameHint;

  /// No description provided for @defaultDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Default: {name}'**
  String defaultDisplayName(String name);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notSupportedOnWindows.
  ///
  /// In en, this message translates to:
  /// **'Not supported on Windows'**
  String get notSupportedOnWindows;

  /// No description provided for @uiPerformance.
  ///
  /// In en, this message translates to:
  /// **'User Interface Performance'**
  String get uiPerformance;

  /// No description provided for @uiRefreshRateDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how often transfer progress updates in the UI. Higher frequencies work better on powerful devices.'**
  String get uiRefreshRateDescription;

  /// No description provided for @previouslyPairedOffline.
  ///
  /// In en, this message translates to:
  /// **'Previously paired devices (offline)'**
  String get previouslyPairedOffline;

  /// No description provided for @appInstallationId.
  ///
  /// In en, this message translates to:
  /// **'App Installation ID'**
  String get appInstallationId;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @selectDownloadFolder.
  ///
  /// In en, this message translates to:
  /// **'Select download folder'**
  String get selectDownloadFolder;

  /// No description provided for @maxFileSizePerFile.
  ///
  /// In en, this message translates to:
  /// **'Maximum file size (per file)'**
  String get maxFileSizePerFile;

  /// No description provided for @transferProtocol.
  ///
  /// In en, this message translates to:
  /// **'Transfer Protocol'**
  String get transferProtocol;

  /// No description provided for @concurrentTransfers.
  ///
  /// In en, this message translates to:
  /// **'Concurrent transfers'**
  String get concurrentTransfers;

  /// No description provided for @transferChunkSize.
  ///
  /// In en, this message translates to:
  /// **'Transfer chunk size'**
  String get transferChunkSize;

  /// No description provided for @defaultValue.
  ///
  /// In en, this message translates to:
  /// **'(Default)'**
  String get defaultValue;

  /// No description provided for @androidStorageAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'For security, it\'s recommended to use the app-specific folder. You can select other folders, but this may require additional permissions.'**
  String get androidStorageAccessDescription;

  /// No description provided for @storageInfo.
  ///
  /// In en, this message translates to:
  /// **'Storage Information'**
  String get storageInfo;

  /// No description provided for @noDownloadPathSetDescription.
  ///
  /// In en, this message translates to:
  /// **'Please select a download folder in the Storage tab to see storage information.'**
  String get noDownloadPathSetDescription;

  /// No description provided for @enableNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'To receive notifications for pairing and file transfers, you need to enable them in the system settings.'**
  String get enableNotificationsDescription;

  /// No description provided for @maxFileSizePerFileDescription.
  ///
  /// In en, this message translates to:
  /// **'Larger files will be automatically rejected'**
  String get maxFileSizePerFileDescription;

  /// No description provided for @maxTotalSizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Total size limit for all files in a single transfer request'**
  String get maxTotalSizeDescription;

  /// No description provided for @concurrentTransfersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'More transfers = faster overall but higher CPU usage'**
  String get concurrentTransfersSubtitle;

  /// No description provided for @transferChunkSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Higher sizes = faster transfers but more memory usage'**
  String get transferChunkSizeSubtitle;

  /// No description provided for @protocolTcpReliable.
  ///
  /// In en, this message translates to:
  /// **'TCP (Reliable)'**
  String get protocolTcpReliable;

  /// No description provided for @protocolTcpDescription.
  ///
  /// In en, this message translates to:
  /// **'More reliable, better for important files'**
  String get protocolTcpDescription;

  /// No description provided for @protocolUdpFast.
  ///
  /// In en, this message translates to:
  /// **'UDP (Fast)'**
  String get protocolUdpFast;

  /// No description provided for @fileOrgNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get fileOrgNone;

  /// No description provided for @fileOrgDate.
  ///
  /// In en, this message translates to:
  /// **'By Date'**
  String get fileOrgDate;

  /// No description provided for @fileOrgSender.
  ///
  /// In en, this message translates to:
  /// **'By Sender Name'**
  String get fileOrgSender;

  /// No description provided for @selectOperation.
  ///
  /// In en, this message translates to:
  /// **'Select Operation'**
  String get selectOperation;

  /// No description provided for @filterAndSort.
  ///
  /// In en, this message translates to:
  /// **'Filter and Sort'**
  String get filterAndSort;

  /// No description provided for @tapToSelectAgain.
  ///
  /// In en, this message translates to:
  /// **'Tap to select again'**
  String get tapToSelectAgain;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @selectDestinationFolder.
  ///
  /// In en, this message translates to:
  /// **'Select destination folder'**
  String get selectDestinationFolder;

  /// No description provided for @openInApp.
  ///
  /// In en, this message translates to:
  /// **'Open in App'**
  String get openInApp;

  /// No description provided for @openInExplorer.
  ///
  /// In en, this message translates to:
  /// **'Open in Explorer'**
  String get openInExplorer;

  /// No description provided for @copyTo.
  ///
  /// In en, this message translates to:
  /// **'Copy to'**
  String get copyTo;

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to'**
  String get moveTo;

  /// No description provided for @moveOrCopyAndRename.
  ///
  /// In en, this message translates to:
  /// **'Move or Copy and Rename'**
  String get moveOrCopyAndRename;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete file'**
  String get confirmDelete;

  /// No description provided for @removeSelected.
  ///
  /// In en, this message translates to:
  /// **'Remove selected content'**
  String get removeSelected;

  /// No description provided for @noFilesFound.
  ///
  /// In en, this message translates to:
  /// **'No files found'**
  String get noFilesFound;

  /// No description provided for @emptyFolder.
  ///
  /// In en, this message translates to:
  /// **'Empty folder'**
  String get emptyFolder;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'file'**
  String get file;

  /// No description provided for @fileInfo.
  ///
  /// In en, this message translates to:
  /// **'File information'**
  String get fileInfo;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @clearAllBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Clear all bookmarks'**
  String get clearAllBookmarks;

  /// No description provided for @clearAllBookmarksConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete all history entries? This action cannot be undone.'**
  String get clearAllBookmarksConfirm;

  /// No description provided for @path.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get path;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @modified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get modified;

  /// No description provided for @p2lanOptionRememberBatchExpandState.
  ///
  /// In en, this message translates to:
  /// **'Remember Batch Expand State'**
  String get p2lanOptionRememberBatchExpandState;

  /// No description provided for @p2lanOptionRememberBatchExpandStateDesc.
  ///
  /// In en, this message translates to:
  /// **'Remember the expand state of each batch when the app is closed and reopened'**
  String get p2lanOptionRememberBatchExpandStateDesc;

  /// No description provided for @securityAndEncryption.
  ///
  /// In en, this message translates to:
  /// **'Security & Encryption'**
  String get securityAndEncryption;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @p2lanOptionEncryptionNoneDesc.
  ///
  /// In en, this message translates to:
  /// **'No encryption (fastest transfer)'**
  String get p2lanOptionEncryptionNoneDesc;

  /// No description provided for @p2lanOptionEncryptionAesGcmDesc.
  ///
  /// In en, this message translates to:
  /// **'Strong encryption, best for high-end devices with hardware acceleration'**
  String get p2lanOptionEncryptionAesGcmDesc;

  /// No description provided for @p2lanOptionEncryptionChaCha20Desc.
  ///
  /// In en, this message translates to:
  /// **'Optimized for mobile devices, better performance'**
  String get p2lanOptionEncryptionChaCha20Desc;

  /// No description provided for @p2lanOptionEncryptionNoneAbout.
  ///
  /// In en, this message translates to:
  /// **'Data is transferred without encryption. This provides the fastest transfer speeds but offers no security protection. Only use this on trusted networks.'**
  String get p2lanOptionEncryptionNoneAbout;

  /// No description provided for @p2lanOptionEncryptionAesGcmAbout.
  ///
  /// In en, this message translates to:
  /// **'AES-256-GCM is a widely used encryption standard that provides strong security. It is best suited for high-end devices with hardware acceleration, but may be slower on older or low-end Android devices.'**
  String get p2lanOptionEncryptionAesGcmAbout;

  /// No description provided for @p2lanOptionEncryptionChaCha20About.
  ///
  /// In en, this message translates to:
  /// **'ChaCha20-Poly1305 is a modern encryption algorithm designed for both security and speed, especially on mobile devices.\nIt is recommended for most Android devices because it works efficiently even without hardware acceleration, providing strong protection with better performance than AES on many phones.'**
  String get p2lanOptionEncryptionChaCha20About;

  /// No description provided for @storagePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to select custom folder'**
  String get storagePermissionRequired;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chatWith.
  ///
  /// In en, this message translates to:
  /// **'Chat with {name}'**
  String chatWith(String name);

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @deleteChatWith.
  ///
  /// In en, this message translates to:
  /// **'Delete chat with {name}?'**
  String deleteChatWith(String name);

  /// No description provided for @deleteChatDesc.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the chat history with this user. This action cannot be undone.'**
  String get deleteChatDesc;

  /// No description provided for @noChatExists.
  ///
  /// In en, this message translates to:
  /// **'No chat yet.'**
  String get noChatExists;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Start chatting!'**
  String get noMessages;

  /// No description provided for @fileLost.
  ///
  /// In en, this message translates to:
  /// **'File is lost on the device'**
  String get fileLost;

  /// No description provided for @fileLostRequest.
  ///
  /// In en, this message translates to:
  /// **'File lost request'**
  String get fileLostRequest;

  /// No description provided for @fileLostRequestDesc.
  ///
  /// In en, this message translates to:
  /// **'This file is lost or cannot be found. You can request the sender to resend it if they still keep their file on their device.'**
  String get fileLostRequestDesc;

  /// No description provided for @fileLostOnBothSides.
  ///
  /// In en, this message translates to:
  /// **'File is lost on both sides'**
  String get fileLostOnBothSides;

  /// No description provided for @noPathToCopy.
  ///
  /// In en, this message translates to:
  /// **'No path to copy'**
  String get noPathToCopy;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get deleteMessage;

  /// No description provided for @deleteMessageDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get deleteMessageDesc;

  /// No description provided for @deleteMessageAndFile.
  ///
  /// In en, this message translates to:
  /// **'Delete message and file'**
  String get deleteMessageAndFile;

  /// No description provided for @deleteMessageAndFileDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message and the attached file?'**
  String get deleteMessageAndFileDesc;

  /// No description provided for @errorOpeningFile.
  ///
  /// In en, this message translates to:
  /// **'Error opening file'**
  String get errorOpeningFile;

  /// No description provided for @errorOpeningFileDetails.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while trying to open the file: {error}'**
  String errorOpeningFileDetails(String error);

  /// No description provided for @attachFile.
  ///
  /// In en, this message translates to:
  /// **'Attach files'**
  String get attachFile;

  /// No description provided for @attachMedia.
  ///
  /// In en, this message translates to:
  /// **'Attach media'**
  String get attachMedia;

  /// No description provided for @chatCustomization.
  ///
  /// In en, this message translates to:
  /// **'Chat Customization'**
  String get chatCustomization;

  /// No description provided for @chatCustomizationSaved.
  ///
  /// In en, this message translates to:
  /// **'Chat customization saved successfully'**
  String get chatCustomizationSaved;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @sendAt.
  ///
  /// In en, this message translates to:
  /// **'Send at {time}'**
  String sendAt(String time);

  /// No description provided for @loadingOldMessages.
  ///
  /// In en, this message translates to:
  /// **'Loading old messages...'**
  String get loadingOldMessages;

  /// No description provided for @messageRetention.
  ///
  /// In en, this message translates to:
  /// **'Message Retention'**
  String get messageRetention;

  /// No description provided for @messageRetentionDesc.
  ///
  /// In en, this message translates to:
  /// **'Set how long messages are kept in the chat before being automatically deleted.'**
  String get messageRetentionDesc;

  /// No description provided for @p2pChatAutoCopyIncomingMessages.
  ///
  /// In en, this message translates to:
  /// **'Synchronize clipboard'**
  String get p2pChatAutoCopyIncomingMessages;

  /// No description provided for @p2pChatAutoCopyIncomingMessagesDesc.
  ///
  /// In en, this message translates to:
  /// **'When enabled, new messages, if they are images or text, will be automatically copied to the device\'s clipboard.'**
  String get p2pChatAutoCopyIncomingMessagesDesc;

  /// No description provided for @p2pChatDeleteAfterCopy.
  ///
  /// In en, this message translates to:
  /// **'Delete message after copying'**
  String get p2pChatDeleteAfterCopy;

  /// No description provided for @p2pChatDeleteAfterCopyDesc.
  ///
  /// In en, this message translates to:
  /// **'When enabled, messages will be deleted after being copied to the clipboard.'**
  String get p2pChatDeleteAfterCopyDesc;

  /// No description provided for @p2pChatClipboardSharing.
  ///
  /// In en, this message translates to:
  /// **'Clipboard sharing'**
  String get p2pChatClipboardSharing;

  /// No description provided for @p2pChatClipboardSharingDesc.
  ///
  /// In en, this message translates to:
  /// **'When enabled, new content appearing in the clipboard, if it is text or images, will be automatically recognized and a message will be sent. This feature will register a process and consume resources, so it is recommended to enable it only when necessary.'**
  String get p2pChatClipboardSharingDesc;

  /// No description provided for @p2pChatDeleteAfterShare.
  ///
  /// In en, this message translates to:
  /// **'Delete message after sharing'**
  String get p2pChatDeleteAfterShare;

  /// No description provided for @p2pChatDeleteAfterShareDesc.
  ///
  /// In en, this message translates to:
  /// **'When enabled, messages will be deleted after being shared from the clipboard.'**
  String get p2pChatDeleteAfterShareDesc;

  /// No description provided for @p2pChatCustomizationAndroidCaution.
  ///
  /// In en, this message translates to:
  /// **'## [warning, orange] Note for Android devices\n- Clipboard-related features may not work stably with images.\n- The clipboard sharing feature only works when the app is running in the foreground (meaning you must be actively using the app, or have it open in a floating window, mini window, or split-screen) and you must be in this chat conversation.\n- The clipboard sharing feature will register a monitoring task that may impact device performance, so enable it only when truly necessary and disable it when not in use.\n'**
  String get p2pChatCustomizationAndroidCaution;

  /// No description provided for @clearTransferBatch.
  ///
  /// In en, this message translates to:
  /// **'Clear Batch'**
  String get clearTransferBatch;

  /// No description provided for @clearTransferBatchDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear this batch from the transfer list?'**
  String get clearTransferBatchDesc;

  /// No description provided for @clearTransferBatchWithFiles.
  ///
  /// In en, this message translates to:
  /// **'Clear Batch with Files'**
  String get clearTransferBatchWithFiles;

  /// No description provided for @clearTransferBatchWithFilesDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear this batch and delete all files associated with it?'**
  String get clearTransferBatchWithFilesDesc;

  /// No description provided for @dataCompression.
  ///
  /// In en, this message translates to:
  /// **'Data Compression'**
  String get dataCompression;

  /// No description provided for @enableCompression.
  ///
  /// In en, this message translates to:
  /// **'Enable Compression'**
  String get enableCompression;

  /// No description provided for @enableCompressionDesc.
  ///
  /// In en, this message translates to:
  /// **'Compress files before sending to reduce transfer size. This may increase CPU usage.'**
  String get enableCompressionDesc;

  /// No description provided for @compressionAlgorithm.
  ///
  /// In en, this message translates to:
  /// **'Compression Algorithm'**
  String get compressionAlgorithm;

  /// No description provided for @compressionAlgorithmAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto (Smart Selection)'**
  String get compressionAlgorithmAuto;

  /// No description provided for @compressionAlgorithmGZIP.
  ///
  /// In en, this message translates to:
  /// **'GZIP (Best Compression)'**
  String get compressionAlgorithmGZIP;

  /// No description provided for @compressionAlgorithmDEFLATE.
  ///
  /// In en, this message translates to:
  /// **'DEFLATE (Fastest)'**
  String get compressionAlgorithmDEFLATE;

  /// No description provided for @compressionAlgorithmNone.
  ///
  /// In en, this message translates to:
  /// **'None (Disabled)'**
  String get compressionAlgorithmNone;

  /// No description provided for @estimatedSpeed.
  ///
  /// In en, this message translates to:
  /// **'Estimated Speed'**
  String get estimatedSpeed;

  /// No description provided for @compressionThreshold.
  ///
  /// In en, this message translates to:
  /// **'Compression Threshold'**
  String get compressionThreshold;

  /// No description provided for @compressionThresholdDesc.
  ///
  /// In en, this message translates to:
  /// **'Minimum file size to apply compression. Smaller files may not benefit from compression.'**
  String get compressionThresholdDesc;

  /// No description provided for @adaptiveCompression.
  ///
  /// In en, this message translates to:
  /// **'Adaptive Compression'**
  String get adaptiveCompression;

  /// No description provided for @adaptiveCompressionDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically adjusts compression level based on file type and size for optimal performance.'**
  String get adaptiveCompressionDesc;

  /// No description provided for @performanceInfo.
  ///
  /// In en, this message translates to:
  /// **'Performance Information'**
  String get performanceInfo;

  /// No description provided for @performanceInfoEncrypt.
  ///
  /// In en, this message translates to:
  /// **'Encryption'**
  String get performanceInfoEncrypt;

  /// No description provided for @performanceInfoCompress.
  ///
  /// In en, this message translates to:
  /// **'Compression'**
  String get performanceInfoCompress;

  /// No description provided for @performanceInfoExpectedImprovement.
  ///
  /// In en, this message translates to:
  /// **'Expected Improvement'**
  String get performanceInfoExpectedImprovement;

  /// No description provided for @performanceInfoSecuLevel.
  ///
  /// In en, this message translates to:
  /// **'Security Level'**
  String get performanceInfoSecuLevel;

  /// No description provided for @compressionBenefits.
  ///
  /// In en, this message translates to:
  /// **'Compression Benefits'**
  String get compressionBenefits;

  /// No description provided for @compressionBenefitsInfo.
  ///
  /// In en, this message translates to:
  /// **'• Text files: 3-5x faster transfers\n• Source code: 2-4x faster transfers\n• JSON/XML data: 4-6x faster transfers\n• Media files: No overhead (auto-detected)'**
  String get compressionBenefitsInfo;

  /// No description provided for @performanceWarning.
  ///
  /// In en, this message translates to:
  /// **'Performance Warning'**
  String get performanceWarning;

  /// No description provided for @performanceWarningInfo.
  ///
  /// In en, this message translates to:
  /// **'Encryption and compression may cause crashes on some Android devices, especially older or lower-end models. If you experience crashes, disable these features for stable transfers.'**
  String get performanceWarningInfo;

  /// No description provided for @resetToSafeDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to Safe Defaults'**
  String get resetToSafeDefaults;

  /// No description provided for @ddefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get ddefault;

  /// No description provided for @aggressive.
  ///
  /// In en, this message translates to:
  /// **'Aggressive'**
  String get aggressive;

  /// No description provided for @conservative.
  ///
  /// In en, this message translates to:
  /// **'Conservative'**
  String get conservative;

  /// No description provided for @veryConservative.
  ///
  /// In en, this message translates to:
  /// **'Very Conservative'**
  String get veryConservative;

  /// No description provided for @onlyMajorGains.
  ///
  /// In en, this message translates to:
  /// **'Only Major Gains'**
  String get onlyMajorGains;

  /// No description provided for @fastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest'**
  String get fastest;

  /// No description provided for @strongest.
  ///
  /// In en, this message translates to:
  /// **'Strongest'**
  String get strongest;

  /// No description provided for @mobileOptimized.
  ///
  /// In en, this message translates to:
  /// **'Mobile Optimized'**
  String get mobileOptimized;

  /// No description provided for @upToNumberXFaster.
  ///
  /// In en, this message translates to:
  /// **'Up to {number}x Faster'**
  String upToNumberXFaster(int number);

  /// No description provided for @baseline.
  ///
  /// In en, this message translates to:
  /// **'Baseline'**
  String get baseline;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @notRecommended.
  ///
  /// In en, this message translates to:
  /// **'Not Recommended'**
  String get notRecommended;

  /// No description provided for @encrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted'**
  String get encrypted;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @adaptive.
  ///
  /// In en, this message translates to:
  /// **'Adaptive'**
  String get adaptive;

  /// No description provided for @enterAChatToStart.
  ///
  /// In en, this message translates to:
  /// **'Enter a chat to start messaging'**
  String get enterAChatToStart;

  /// No description provided for @chatList.
  ///
  /// In en, this message translates to:
  /// **'Chat List'**
  String get chatList;

  /// No description provided for @chatDetails.
  ///
  /// In en, this message translates to:
  /// **'Chat Details'**
  String get chatDetails;

  /// No description provided for @addChat.
  ///
  /// In en, this message translates to:
  /// **'Add Chat'**
  String get addChat;

  /// No description provided for @addChatDesc.
  ///
  /// In en, this message translates to:
  /// **'Add a new chat with a user to start messaging.'**
  String get addChatDesc;

  /// No description provided for @noUserOnline.
  ///
  /// In en, this message translates to:
  /// **'No user is online at the moment.'**
  String get noUserOnline;

  /// No description provided for @clearAllTransfers.
  ///
  /// In en, this message translates to:
  /// **'Clear All Transfers'**
  String get clearAllTransfers;

  /// No description provided for @clearAllTransfersDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all history transfers?'**
  String get clearAllTransfersDesc;

  /// No description provided for @mobileLayout.
  ///
  /// In en, this message translates to:
  /// **'Mobile Layout'**
  String get mobileLayout;

  /// No description provided for @useCompactLayout.
  ///
  /// In en, this message translates to:
  /// **'Use Compact Layout'**
  String get useCompactLayout;

  /// No description provided for @useCompactLayoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Hide icons on the navigation bar and use a more compact layout to save space.'**
  String get useCompactLayoutDesc;

  /// No description provided for @userExperience.
  ///
  /// In en, this message translates to:
  /// **'User Experience'**
  String get userExperience;

  /// No description provided for @showShortcutsInTooltips.
  ///
  /// In en, this message translates to:
  /// **'Show shortcuts in tooltips'**
  String get showShortcutsInTooltips;

  /// No description provided for @showShortcutsInTooltipsDesc.
  ///
  /// In en, this message translates to:
  /// **'Display keyboard shortcuts when hovering over buttons'**
  String get showShortcutsInTooltipsDesc;

  /// No description provided for @numberFilesSendToUser.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s) sent to {name}'**
  String numberFilesSendToUser(int count, String name);

  /// No description provided for @numberFilesReceivedFromUser.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s) received from {name}'**
  String numberFilesReceivedFromUser(int count, String name);

  /// No description provided for @sendToUser.
  ///
  /// In en, this message translates to:
  /// **'Send to {name}'**
  String sendToUser(String name);

  /// No description provided for @receiveFromUser.
  ///
  /// In en, this message translates to:
  /// **'Receive from {name}'**
  String receiveFromUser(String name);

  /// No description provided for @allCompleted.
  ///
  /// In en, this message translates to:
  /// **'All completed'**
  String get allCompleted;

  /// No description provided for @completedWithErrors.
  ///
  /// In en, this message translates to:
  /// **'Completed with errors'**
  String get completedWithErrors;

  /// No description provided for @transfering.
  ///
  /// In en, this message translates to:
  /// **'Transferring'**
  String get transfering;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// No description provided for @completedTasksNumber.
  ///
  /// In en, this message translates to:
  /// **'{count} completed tasks'**
  String completedTasksNumber(int count);

  /// No description provided for @transferringTasksNumber.
  ///
  /// In en, this message translates to:
  /// **'{count} transferring tasks'**
  String transferringTasksNumber(int count);

  /// No description provided for @failedTasksNumber.
  ///
  /// In en, this message translates to:
  /// **'{count} failed tasks'**
  String failedTasksNumber(int count);

  /// No description provided for @clearTask.
  ///
  /// In en, this message translates to:
  /// **'Clear Task'**
  String get clearTask;

  /// No description provided for @requesting.
  ///
  /// In en, this message translates to:
  /// **'Requesting'**
  String get requesting;

  /// No description provided for @waitingForApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get waitingForApproval;

  /// No description provided for @beingRefused.
  ///
  /// In en, this message translates to:
  /// **'Being refused'**
  String get beingRefused;

  /// No description provided for @receiving.
  ///
  /// In en, this message translates to:
  /// **'Receiving...'**
  String get receiving;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @clearNotification.
  ///
  /// In en, this message translates to:
  /// **'Clear Notification'**
  String get clearNotification;

  /// No description provided for @clearNotificationInfo1.
  ///
  /// In en, this message translates to:
  /// **'You are disabling notifications. There may be active notifications from this app.'**
  String get clearNotificationInfo1;

  /// No description provided for @clearNotificationInfo2.
  ///
  /// In en, this message translates to:
  /// **'Would you like to clear all existing notifications?'**
  String get clearNotificationInfo2;

  /// No description provided for @pickLanguage.
  ///
  /// In en, this message translates to:
  /// **'Pick Language'**
  String get pickLanguage;

  /// No description provided for @pickTheme.
  ///
  /// In en, this message translates to:
  /// **'Pick Theme'**
  String get pickTheme;

  /// No description provided for @welcomeToApp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to P2Lan Transfer'**
  String get welcomeToApp;

  /// No description provided for @privacyStatement.
  ///
  /// In en, this message translates to:
  /// **'Privacy Statement'**
  String get privacyStatement;

  /// No description provided for @privacyStatementDesc.
  ///
  /// In en, this message translates to:
  /// **'This application is a client-side app and does not collect any user data. The permissions requested by the app are solely for enabling its normal functions and are not used to collect personal information. All data remains on your device and is only shared when you choose to transfer files with other devices on your network.'**
  String get privacyStatementDesc;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Use'**
  String get agreeToTerms;

  /// No description provided for @startUsingApp.
  ///
  /// In en, this message translates to:
  /// **'Start Using App'**
  String get startUsingApp;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @termsOfUseView.
  ///
  /// In en, this message translates to:
  /// **'View Terms of Use of this application'**
  String get termsOfUseView;

  /// No description provided for @setupComplete.
  ///
  /// In en, this message translates to:
  /// **'Setup Complete'**
  String get setupComplete;

  /// No description provided for @languageSelection.
  ///
  /// In en, this message translates to:
  /// **'Language Selection'**
  String get languageSelection;

  /// No description provided for @themeSelection.
  ///
  /// In en, this message translates to:
  /// **'Theme Selection'**
  String get themeSelection;

  /// No description provided for @privacyAndTerms.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Terms'**
  String get privacyAndTerms;

  /// No description provided for @selectYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get selectYourLanguage;

  /// No description provided for @selectYourTheme.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred theme'**
  String get selectYourTheme;

  /// No description provided for @mustAgreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the Terms of Use to continue'**
  String get mustAgreeToTerms;

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

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get noData;

  /// No description provided for @aboutToOpenUrlOutsideApp.
  ///
  /// In en, this message translates to:
  /// **'You are about to open a URL outside the app!'**
  String get aboutToOpenUrlOutsideApp;

  /// No description provided for @ccontinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get ccontinue;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @thanksLibAuthor.
  ///
  /// In en, this message translates to:
  /// **'Thank You, Library Authors!'**
  String get thanksLibAuthor;

  /// No description provided for @thanksLibAuthorDesc.
  ///
  /// In en, this message translates to:
  /// **'This app uses several open-source libraries that make it possible. We are grateful to all the authors for their hard work and dedication.'**
  String get thanksLibAuthorDesc;

  /// No description provided for @thanksDonors.
  ///
  /// In en, this message translates to:
  /// **'Thank You, Supporters!'**
  String get thanksDonors;

  /// No description provided for @thanksDonorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Special thanks to our supporters who support the development of this app. Your contributions help us keep improving and maintaining the project.'**
  String get thanksDonorsDesc;

  /// No description provided for @thanksForUrSupport.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your support!'**
  String get thanksForUrSupport;

  /// No description provided for @supporterS.
  ///
  /// In en, this message translates to:
  /// **'Supporter(s)'**
  String get supporterS;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit the app'**
  String get pressBackAgainToExit;

  /// No description provided for @canNotOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Cannot open file'**
  String get canNotOpenFile;

  /// No description provided for @canNotOpenUrl.
  ///
  /// In en, this message translates to:
  /// **'Cannot open URL'**
  String get canNotOpenUrl;

  /// No description provided for @errorOpeningUrl.
  ///
  /// In en, this message translates to:
  /// **'Error opening URL'**
  String get errorOpeningUrl;

  /// No description provided for @linkCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get linkCopiedToClipboard;

  /// No description provided for @invalidFileName.
  ///
  /// In en, this message translates to:
  /// **'Invalid file name'**
  String get invalidFileName;

  /// No description provided for @actionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Action cancelled'**
  String get actionCancelled;

  /// No description provided for @fileExists.
  ///
  /// In en, this message translates to:
  /// **'File already exists'**
  String get fileExists;

  /// No description provided for @fileExistsDesc.
  ///
  /// In en, this message translates to:
  /// **'A file with this name already exists in the destination folder. Do you want to overwrite it?'**
  String get fileExistsDesc;

  /// No description provided for @fileMovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'File đã được di chuyển thành công'**
  String get fileMovedSuccessfully;

  /// No description provided for @fileCopiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'File đã được sao chép thành công'**
  String get fileCopiedSuccessfully;

  /// No description provided for @fileRenamedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'File đã được đổi tên thành công'**
  String get fileRenamedSuccessfully;

  /// No description provided for @renameFile.
  ///
  /// In en, this message translates to:
  /// **'Rename File'**
  String get renameFile;

  /// No description provided for @newFileName.
  ///
  /// In en, this message translates to:
  /// **'New File Name'**
  String get newFileName;

  /// No description provided for @errorRenamingFile.
  ///
  /// In en, this message translates to:
  /// **'Error renaming file'**
  String get errorRenamingFile;

  /// No description provided for @fileDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'File deleted successfully'**
  String get fileDeletedSuccessfully;

  /// No description provided for @errorDeletingFile.
  ///
  /// In en, this message translates to:
  /// **'Error deleting file'**
  String get errorDeletingFile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @localFolderInitializationError.
  ///
  /// In en, this message translates to:
  /// **'Local folder initialization error'**
  String get localFolderInitializationError;

  /// No description provided for @pleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get pleaseTryAgainLater;

  /// No description provided for @apkNotSupportedDesc.
  ///
  /// In en, this message translates to:
  /// **'The current application does not (or does not yet) support APK installation. You can move the APK file to a public folder and install it from your device\'s file browser.'**
  String get apkNotSupportedDesc;

  /// No description provided for @theseWillBeCleared.
  ///
  /// In en, this message translates to:
  /// **'The following items will be cleared'**
  String get theseWillBeCleared;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @deviceNameAutoDetected.
  ///
  /// In en, this message translates to:
  /// **'Device name is automatically detected'**
  String get deviceNameAutoDetected;

  /// No description provided for @transferProgressAutoCleanup.
  ///
  /// In en, this message translates to:
  /// **'Transfer Progress Auto-Cleanup'**
  String get transferProgressAutoCleanup;

  /// No description provided for @autoRemoveTransferMessages.
  ///
  /// In en, this message translates to:
  /// **'Automatically remove transfer progress after completion or cancellation'**
  String get autoRemoveTransferMessages;

  /// No description provided for @removeProgressOnSuccess.
  ///
  /// In en, this message translates to:
  /// **'Remove progress when transfers complete successfully'**
  String get removeProgressOnSuccess;

  /// No description provided for @cancelledTransfers.
  ///
  /// In en, this message translates to:
  /// **'Cancelled transfers'**
  String get cancelledTransfers;

  /// No description provided for @removeProgressOnCancel.
  ///
  /// In en, this message translates to:
  /// **'Remove progress when transfers are cancelled'**
  String get removeProgressOnCancel;

  /// No description provided for @removeProgressOnFail.
  ///
  /// In en, this message translates to:
  /// **'Remove progress when transfers fail'**
  String get removeProgressOnFail;

  /// No description provided for @cleanupDelay.
  ///
  /// In en, this message translates to:
  /// **'Cleanup delay'**
  String get cleanupDelay;

  /// No description provided for @notificationRequestPermission.
  ///
  /// In en, this message translates to:
  /// **'Request Notification Permission'**
  String get notificationRequestPermission;

  /// No description provided for @notificationRequestPermissionDesc.
  ///
  /// In en, this message translates to:
  /// **'The app needs to be granted notification permission in order to notify you. If you have pressed the \'Grant Permission\' button but the permission dialog still does not appear, please manually grant notification permission in the app\'s permission settings.'**
  String get notificationRequestPermissionDesc;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @checkingForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

  /// No description provided for @noNewUpdates.
  ///
  /// In en, this message translates to:
  /// **'No new updates'**
  String get noNewUpdates;

  /// No description provided for @updateCheckError.
  ///
  /// In en, this message translates to:
  /// **'Error checking updates: {errorMessage}'**
  String updateCheckError(String errorMessage);

  /// No description provided for @usingLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'You are using the latest version'**
  String get usingLatestVersion;

  /// No description provided for @newVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get newVersionAvailable;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current: {version}'**
  String currentVersion(String version);

  /// No description provided for @publishDate.
  ///
  /// In en, this message translates to:
  /// **'Publish date: {publishDate}'**
  String publishDate(String publishDate);

  /// No description provided for @releaseNotes.
  ///
  /// In en, this message translates to:
  /// **'Release notes'**
  String get releaseNotes;

  /// No description provided for @noReleaseNotes.
  ///
  /// In en, this message translates to:
  /// **'No release notes'**
  String get noReleaseNotes;

  /// No description provided for @alreadyLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'Already the latest version'**
  String get alreadyLatestVersion;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @selectVersionToDownload.
  ///
  /// In en, this message translates to:
  /// **'Select version to download'**
  String get selectVersionToDownload;

  /// No description provided for @filteredForPlatform.
  ///
  /// In en, this message translates to:
  /// **'Filtered for {getPlatformName}'**
  String filteredForPlatform(String getPlatformName);

  /// No description provided for @sizeInMB.
  ///
  /// In en, this message translates to:
  /// **'Size: {sizeInMB}'**
  String sizeInMB(String sizeInMB);

  /// No description provided for @uploadDate.
  ///
  /// In en, this message translates to:
  /// **'Upload date: {updatedAt}'**
  String uploadDate(String updatedAt);

  /// No description provided for @confirmDownload.
  ///
  /// In en, this message translates to:
  /// **'Confirm download'**
  String get confirmDownload;

  /// No description provided for @confirmDownloadMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to download this version?\n\nFile name: {name}\nSize: {sizeInMB}'**
  String confirmDownloadMessage(String name, String sizeInMB);

  /// No description provided for @currentPlatform.
  ///
  /// In en, this message translates to:
  /// **'Current platform'**
  String get currentPlatform;

  /// No description provided for @eerror.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get eerror;
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
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
