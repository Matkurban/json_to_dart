import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
    Locale('zh'),
  ];

  /// No description provided for @advancedJsonConversionTool.
  ///
  /// In en, this message translates to:
  /// **'Advanced JSON Conversion Tool'**
  String get advancedJsonConversionTool;

  /// No description provided for @conversionError.
  ///
  /// In en, this message translates to:
  /// **'Conversion Error'**
  String get conversionError;

  /// No description provided for @enterValidJsonPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid JSON format to proceed'**
  String get enterValidJsonPrompt;

  /// No description provided for @confirmClear.
  ///
  /// In en, this message translates to:
  /// **'Confirm Clear?'**
  String get confirmClear;

  /// No description provided for @clearWarning.
  ///
  /// In en, this message translates to:
  /// **'Once cleared, data cannot be recovered. Proceed with caution.'**
  String get clearWarning;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete?'**
  String get confirmDelete;

  /// No description provided for @deleteHistoryWarning.
  ///
  /// In en, this message translates to:
  /// **'You are about to delete a history record. This cannot be undone.'**
  String get deleteHistoryWarning;

  /// No description provided for @operationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Operation Prompt'**
  String get operationPrompt;

  /// No description provided for @fileSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'File saved successfully'**
  String get fileSaveSuccess;

  /// No description provided for @fileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'File save failed'**
  String get fileSaveFailed;

  /// No description provided for @enterJsonPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter JSON to proceed'**
  String get enterJsonPrompt;

  /// No description provided for @enterClassNamePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter a class name to proceed'**
  String get enterClassNamePrompt;

  /// No description provided for @jsonToDartTool.
  ///
  /// In en, this message translates to:
  /// **'JSON to Dart'**
  String get jsonToDartTool;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @jsonInput.
  ///
  /// In en, this message translates to:
  /// **'JSON Input'**
  String get jsonInput;

  /// No description provided for @previewJsonView.
  ///
  /// In en, this message translates to:
  /// **'Preview JSON View'**
  String get previewJsonView;

  /// No description provided for @clearInput.
  ///
  /// In en, this message translates to:
  /// **'Clear Input'**
  String get clearInput;

  /// No description provided for @jsonInputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter or paste JSON content here...'**
  String get jsonInputPlaceholder;

  /// No description provided for @dartOutput.
  ///
  /// In en, this message translates to:
  /// **'Dart Output'**
  String get dartOutput;

  /// No description provided for @saveAsFile.
  ///
  /// In en, this message translates to:
  /// **'Save as File'**
  String get saveAsFile;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// No description provided for @copyJson.
  ///
  /// In en, this message translates to:
  /// **'Copy JSON'**
  String get copyJson;

  /// No description provided for @generateDartHint.
  ///
  /// In en, this message translates to:
  /// **'Click Generate to get Dart class code'**
  String get generateDartHint;

  /// No description provided for @nonNullableFields.
  ///
  /// In en, this message translates to:
  /// **'Non-nullable Fields'**
  String get nonNullableFields;

  /// No description provided for @generateToJson.
  ///
  /// In en, this message translates to:
  /// **'Generate toJson'**
  String get generateToJson;

  /// No description provided for @generateFromJson.
  ///
  /// In en, this message translates to:
  /// **'Generate fromJson'**
  String get generateFromJson;

  /// No description provided for @formatJson.
  ///
  /// In en, this message translates to:
  /// **'Format JSON'**
  String get formatJson;

  /// No description provided for @generateDartClass.
  ///
  /// In en, this message translates to:
  /// **'Generate Dart Class'**
  String get generateDartClass;

  /// No description provided for @addToHistory.
  ///
  /// In en, this message translates to:
  /// **'Save to History'**
  String get addToHistory;

  /// No description provided for @mainClassNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Class Name'**
  String get mainClassNameLabel;

  /// No description provided for @mainClassNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter main class name'**
  String get mainClassNamePlaceholder;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get codeCopied;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistory;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

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

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @dart.
  ///
  /// In en, this message translates to:
  /// **'Dart'**
  String get dart;

  /// No description provided for @java.
  ///
  /// In en, this message translates to:
  /// **'Java'**
  String get java;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @officialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official Website'**
  String get officialWebsite;

  /// No description provided for @githubRepo.
  ///
  /// In en, this message translates to:
  /// **'GitHub Repository'**
  String get githubRepo;

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

  /// No description provided for @previewCode.
  ///
  /// In en, this message translates to:
  /// **'Preview Code'**
  String get previewCode;

  /// No description provided for @convertJsonToJava.
  ///
  /// In en, this message translates to:
  /// **'Convert JSON to Java'**
  String get convertJsonToJava;

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageName;

  /// No description provided for @javaCode.
  ///
  /// In en, this message translates to:
  /// **'Java Code'**
  String get javaCode;

  /// No description provided for @useLombok.
  ///
  /// In en, this message translates to:
  /// **'Use Lombok'**
  String get useLombok;

  /// No description provided for @generateGetterSetter.
  ///
  /// In en, this message translates to:
  /// **'Generate Getter/Setter'**
  String get generateGetterSetter;

  /// No description provided for @generateBuilder.
  ///
  /// In en, this message translates to:
  /// **'Generate Builder'**
  String get generateBuilder;

  /// No description provided for @generateToString.
  ///
  /// In en, this message translates to:
  /// **'Generate ToString'**
  String get generateToString;

  /// No description provided for @useOptional.
  ///
  /// In en, this message translates to:
  /// **'Use Optional'**
  String get useOptional;

  /// No description provided for @generateJavaClass.
  ///
  /// In en, this message translates to:
  /// **'Generate Java Class'**
  String get generateJavaClass;

  /// No description provided for @clearClassName.
  ///
  /// In en, this message translates to:
  /// **'Clear Class Name'**
  String get clearClassName;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No History Yet'**
  String get noHistoryYet;

  /// No description provided for @forceTypeCasting.
  ///
  /// In en, this message translates to:
  /// **'Force Type Casting'**
  String get forceTypeCasting;

  /// No description provided for @generateCopyWith.
  ///
  /// In en, this message translates to:
  /// **'Generate copyWith'**
  String get generateCopyWith;

  /// No description provided for @flutterMobileMirrorConfig.
  ///
  /// In en, this message translates to:
  /// **'Flutter Mobile Mirror Config'**
  String get flutterMobileMirrorConfig;

  /// No description provided for @androidStudioDartTemplate.
  ///
  /// In en, this message translates to:
  /// **'AndroidStudio Dart File Template'**
  String get androidStudioDartTemplate;

  /// No description provided for @jsonToJava.
  ///
  /// In en, this message translates to:
  /// **'JSON to Java'**
  String get jsonToJava;

  /// No description provided for @jsonGenerator.
  ///
  /// In en, this message translates to:
  /// **'JSON Generator'**
  String get jsonGenerator;

  /// No description provided for @jsonOutput.
  ///
  /// In en, this message translates to:
  /// **'JSON Output'**
  String get jsonOutput;

  /// No description provided for @jsonFields.
  ///
  /// In en, this message translates to:
  /// **'JSON Fields'**
  String get jsonFields;

  /// No description provided for @addField.
  ///
  /// In en, this message translates to:
  /// **'Add Field'**
  String get addField;

  /// No description provided for @clearFields.
  ///
  /// In en, this message translates to:
  /// **'Clear Fields'**
  String get clearFields;

  /// No description provided for @key.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get key;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @enterKey.
  ///
  /// In en, this message translates to:
  /// **'Enter key'**
  String get enterKey;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get enterValue;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get selectType;

  /// No description provided for @string.
  ///
  /// In en, this message translates to:
  /// **'String'**
  String get string;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @boolean.
  ///
  /// In en, this message translates to:
  /// **'Boolean'**
  String get boolean;

  /// No description provided for @array.
  ///
  /// In en, this message translates to:
  /// **'Array'**
  String get array;

  /// No description provided for @object.
  ///
  /// In en, this message translates to:
  /// **'Object'**
  String get object;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @saveToHistory.
  ///
  /// In en, this message translates to:
  /// **'Save to History'**
  String get saveToHistory;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
