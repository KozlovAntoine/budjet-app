import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdRequest request = AdRequest(
    keywords: <String>['Games', 'Finance', 'Budget'],
    nonPersonalizedAds: true,
  );

  static int interaction = 0;

  static void incr() {
    interaction++;
  }
}
