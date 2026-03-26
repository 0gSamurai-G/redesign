import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventFestController extends GetxController {
  // Normal days event data
  final RxMap<String, dynamic> normalDaysEventCard = {
    'imageUrl': 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
    'title': 'Game On with PlayZ',
    'subtitle': 'Join exciting matches',
    'buttonTitle': 'Explore Games',
  }.obs;

  // Festival event data map
  final RxMap<String, RxMap<String, dynamic>> festivalEventData = {
    'diwali': {
      'enable': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1510368155990-2eaf2db0c5a3',
      'title': 'Happy Diwali!',
      'subtitle': 'Light up your game',
      'buttonTitle': 'Join Diwali Fest',
      'lottieUrl':
          'https://lottie.host/75b511ad-4e3c-431a-a15e-0ea88ca3be60/Y1kAkqA4yP.lottie', // Using a placeholder Diwali firework .lottie
    }.obs,
    'christmas': {
      'enable': false,
      'imageUrl': 'https://images.unsplash.com/photo-1543589077-47d81606c1df',
      'title': 'Merry Christmas',
      'subtitle': 'Festive season matches',
      'buttonTitle': 'Christmas Cup',
      'lottieUrl': 'https://assets3.lottiefiles.com/packages/lf20_xyz.lottie',
    }.obs,
  }.obs;

  // Track if we should show the lottie (only first time app is opened)
  final RxBool shouldShowLottie = false.obs;

  // Track which festival is currently enabled
  final RxString activeFestival = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkFestivalAndLottieStatus();
  }

  Future<void> _checkFestivalAndLottieStatus() async {
    // Check which festival is enabled
    String enabledFestival = '';
    for (var entry in festivalEventData.entries) {
      if (entry.value['enable'] == true) {
        enabledFestival = entry.key;
        break;
      }
    }

    activeFestival.value = enabledFestival;

    if (enabledFestival.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final hasShown =
          prefs.getBool('has_shown_festival_lottie_$enabledFestival') ?? false;

      if (!hasShown) {
        shouldShowLottie.value = true;
      }
    }
  }

  Future<void> markLottieAsShown() async {
    if (activeFestival.value.isNotEmpty) {
      shouldShowLottie.value = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
        'has_shown_festival_lottie_${activeFestival.value}',
        true,
      );
    }
  }
}
