import 'dart:ui';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslatePreferences
{
    static const String _selectedLocaleKey = 'selected_locale';

    final LocalizationDelegate delegate;

    static TranslatePreferences _instance;

    TranslatePreferences._(this.delegate)
    {
        delegate.onLocaleChanged = saveLocale;
    }

    void saveLocale(Locale locale) async
    {
        final preferences = await SharedPreferences.getInstance();

        await preferences.setString(_selectedLocaleKey, localeToString(locale));
    }

    void loadSavedLocale() async
    {
        final preferences = await SharedPreferences.getInstance();

        if(await preferences.containsKey(_selectedLocaleKey))
        {
            var locale = await preferences.getString(_selectedLocaleKey);

            await delegate.changeLocale(localeFromString(locale));
        }
    }

    static Future initialize(LocalizationDelegate delegate) async
    {
        var preferences = _instance ?? (_instance = TranslatePreferences._(delegate));

        await preferences.loadSavedLocale();
    }
}
