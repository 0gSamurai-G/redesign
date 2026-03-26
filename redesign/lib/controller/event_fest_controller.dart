import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EventFestController extends GetxController {
  // Normal days event data list
  final RxList<Map<String, String>> normalDaysEventCards = [
    {
      'image': 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
      'title': 'Game On with\nPlayZ',
      'badge': 'TRENDING NOW',
      'buttonTitle': 'Explore Games Near You',
    },
    {
      'image': 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
      'title': 'Book Grounds\nInstantly',
      'badge': 'NEAR YOU',
      'buttonTitle': 'Book Grounds',
    },
    {
      'image': 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2',
      'title': 'Find Your\nSquad',
      'badge': 'COMMUNITY',
      'buttonTitle': 'Join Community',
    },
  ].obs;

  // Festival event data map
  final RxMap<String, RxMap<String, dynamic>> festivalEventData = {
    'diwali': {
      'enable': false,
      'lottieUrl':
          'https://lottie.host/18fcdfab-05a0-4164-aad9-e3a16c9c49fb/ws3tunGcTL.json',
      'cards': <Map<String, String>>[
        {
          'image':
              'https://img.freepik.com/free-photo/diwali-celebration-illustration_23-2151871785.jpg?semt=ais_hybrid&w=740&q=80',
          'title': 'Happy Diwali!\nPlay Now',
          'badge': 'FESTIVAL',
          'buttonTitle': 'Join Diwali Fest',
        },
        {
          'image':
              'https://t4.ftcdn.net/jpg/16/90/15/83/360_F_1690158375_o7BFIUp7K8A7Apg5bZMV3ABBuW3fGIi4.jpg',
          'title': 'Diwali Special\nMatches',
          'badge': 'LIMITED TIME',
          'buttonTitle': 'Explore More',
        },
      ],
    }.obs,
    'christmas': {
      'enable': false,
      'lottieUrl':
          'https://lottie.host/248079e3-6652-4eaf-b588-83039515c208/xIoUez8MS3.json',
      'lottieSpeed': 1.5,
      'lottieEndProgress': 0.33,
      'cards': <Map<String, String>>[
        {
          'image': 'https://images.unsplash.com/photo-1543589077-47d81606c1df',
          'title': 'Merry\nChristmas',
          'badge': 'FESTIVAL',
          'buttonTitle': 'Christmas Cup',
        },
        {
          'image':
              'https://images.unsplash.com/photo-1512474932049-78ac69ede12c',
          'title': 'Winter\nWonderland',
          'badge': 'SPECIAL',
          'buttonTitle': 'Join Tournament',
        },
      ],
    }.obs,
    'ipl': {
      'enable': true,
      'lottieUrl':
          'https://lottie.host/b3836c41-49e3-4ad1-8c2a-e3f7772f39aa/RPZJEQQ1rL.json',
      'lottieProgress': 0.2, // Starts from specified progress
      'lottieSpeed': 1.4, // Playback speed multiplier
      'cards': <Map<String, String>>[
        {
          'image':
              'https://t3.ftcdn.net/jpg/09/04/45/28/360_F_904452820_k8HyrfkqGVzvfip05i31DRr9M8RtiuJ3.jpg',
          'title': 'IPL Fever!\nGame On',
          'badge': 'CRICKET',
          'buttonTitle': 'Play Now',
        },
        {
          'image':
              'https://www.mxmindia.com/wp-content/uploads/2022/01/ipl-logo.jpg',
          'title': 'Match Day\nMadness',
          'badge': 'LEAGUE',
          'buttonTitle': 'View Leaderboard',
        },
      ],
    }.obs,
    'independence_day': {
      'enable': false,
      'lottieUrl':
          'https://lottie.host/1e609bc8-c215-4a19-b54d-76da5947b7cd/pFnoaNUmvt.json',
      'lottieSpeed': 1.5,
      'lottieAlignment': 'bottom',
      'cards': <Map<String, String>>[
        {
          'image':
              'https://images.unsplash.com/photo-1532375810709-75b1da00537c?auto=format&fit=crop&q=80&w=1080',
          'title': 'Happy\nIndependence Day',
          'badge': 'INDIA',
          'buttonTitle': 'Tricolor Matches',
        },
        {
          'image':
              'https://images.unsplash.com/photo-1565551904791-f92e463a5042?auto=format&fit=crop&q=80&w=1080',
          'title': 'Freedom\nGames',
          'badge': 'PATRIOTIC',
          'buttonTitle': 'Play Now',
        },
      ],
    }.obs,
    'republic_day': {
      'enable': false,
      'lottieUrl':
          'https://lottie.host/1e609bc8-c215-4a19-b54d-76da5947b7cd/pFnoaNUmvt.json',
      'lottieSpeed': 1.5,
      'lottieAlignment': 'bottom',
      'cards': <Map<String, String>>[
        {
          'image':
              'https://images.unsplash.com/photo-1541414779316-956a5084c0d4?auto=format&fit=crop&q=80&w=1080',
          'title': 'Happy\nRepublic Day',
          'badge': 'INDIA',
          'buttonTitle': 'Grand Parade Cups',
        },
        {
          'image':
              'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?auto=format&fit=crop&q=80&w=1080',
          'title': 'Constitution\nMatches',
          'badge': 'PATRIOTIC',
          'buttonTitle': 'Join Games',
        },
      ],
    }.obs,
    'yoga_day': {
      'enable': false,
      'lottieUrl':
          'https://lottie.host/2d1d261b-bbfe-401b-9bd8-eb352473cc31/NnNt8QVtA2.json',
      'lottieSpeed': 1.5,
      'lottieEndProgress': 0.75,
      'cards': <Map<String, String>>[
        {
          'image':
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&q=80&w=1080',
          'title': 'International\nYoga Day',
          'badge': 'WELLNESS',
          'buttonTitle': 'Join Yoga Fest',
        },
        {
          'image':
              'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&q=80&w=1080',
          'title': 'Mindful\nMovements',
          'badge': 'ZEN',
          'buttonTitle': 'Book Session',
        },
      ],
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

  // Helper getter for the Home Screen Slider
  List<Map<String, String>> get activeSlides {
    if (activeFestival.value.isNotEmpty) {
      final festData = festivalEventData[activeFestival.value];
      if (festData != null) {
        if (festData.containsKey('cards')) {
          return List<Map<String, String>>.from(festData['cards']);
        } else {
          return [
            {
              'image': festData['imageUrl']?.toString() ?? '',
              'title': festData['title']?.toString() ?? '',
              'badge': festData['subtitle']?.toString() ?? 'FESTIVAL',
              'buttonTitle': festData['buttonTitle']?.toString() ?? 'Join Now',
            },
          ];
        }
      }
    }
    return normalDaysEventCards;
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
      shouldShowLottie.value = true;

      // Preload lottie to prevent loading delay on home screen
      final url = festivalEventData[enabledFestival]?['lottieUrl'];
      if (url != null && url.toString().isNotEmpty) {
        try {
          await NetworkLottie(url).load();
        } catch (e) {
          // Ignore preloading errors
        }
      }
    }
  }

  Future<void> markLottieAsShown() async {
    if (activeFestival.value.isNotEmpty) {
      shouldShowLottie.value = false;
    }
  }
}
