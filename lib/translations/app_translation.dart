import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'app_name': 'PushtiRanna',
      'favorites': 'My Favorites',
      'settings': 'Settings',
      'language': 'Language',
      'no_favorites': 'No favorite recipes yet',
      'search_hint': 'Search Bengali recipes...',
      'ingredients': 'Ingredients',
      'steps': 'Cooking Steps',
      'description': 'Description',
      'add_favorite': 'Add Favorite',
      'remove_favorite': 'Remove Favorite',
    },

    'bn_BD': {
      'app_name': 'পুষ্টিরান্না',
      'favorites': 'আমার প্রিয়',
      'settings': 'সেটিংস',
      'language': 'ভাষা',
      'no_favorites': 'কোনো প্রিয় রেসিপি নেই',
      'search_hint': 'বাঙালি রেসিপি খুঁজুন...',
      'ingredients': 'উপকরণ',
      'steps': 'রান্নার ধাপ',
      'description': 'বিবরণ',
      'add_favorite': 'প্রিয়তে যোগ করুন',
      'remove_favorite': 'প্রিয় থেকে সরান',
    }
  };
}