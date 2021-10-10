import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdManager {
  static final AdRequest request = AdRequest(
    keywords: <String>['Games', 'Finance', 'Budget'],
    nonPersonalizedAds: true,
  );

  static int interaction = 0;
  static bool showAd = false;

  static Future<void> incr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0);
    if (!showAd) {
      counter++;
      print('Pressed $counter times.');
      await prefs.setInt('counter', counter);
    }
    if (counter % 30 == 0) {
      showAd = true;
      counter++;
      await prefs.setInt('counter', counter);
    }
    interaction = counter;
  }

  static void closeAd() {
    showAd = false;
  }
}
