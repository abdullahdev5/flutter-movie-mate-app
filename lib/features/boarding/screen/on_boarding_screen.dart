import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/constants/shared_pref_keys.dart';
import 'package:movie_mate_app/core/service/shared_pref_service.dart';
import 'package:movie_mate_app/features/auth/screen/auth_screen.dart';
import 'package:movie_mate_app/features/boarding/model/on_boarding_data.dart';
import 'package:movie_mate_app/features/boarding/widget/on_boarding_page.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  final PageController _controller = PageController();
  int? currentPage;

  final List<OnBoardingData> pages = UnmodifiableListView([
    OnBoardingData(
      imageUrl:
          'https://image.tmdb.org/t/p/w500/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg',
      title: 'Explore Movies',
      description:
          'Discover the latest blockbusters and timeless classics from around the world.',
    ),
    OnBoardingData(
      imageUrl:
          'https://image.tmdb.org/t/p/w500/6MKr3KgOLmzOP6MSuZERO41Lpkt.jpg',
      title: 'Save Your Favorites',
      description:
          'Build your personal watchlist and never miss a movie you love.',
    ),
    OnBoardingData(
      imageUrl:
          'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
      title: 'Watch Anytime',
      description: 'Enjoy movies seamlessly on any device, anytime, anywhere.',
    ),
  ]);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.hasClients) {
        setState(() {
          currentPage = _controller.page?.toInt();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  Future<void> _setUserSeenOnBoarding() async {
    final sharedPrefService = ref.read(sharedPrefServiceProvider);
    await sharedPrefService.setBool(SharedPrefKeys.isUserSeenOnBoarding, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = (currentPage ?? 0) == (pages.length - 1);

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          spacing: 10.0,
          children: [
            // Previous
            Expanded(
              child: TextButton(
                onPressed: (() {
                  final page = (currentPage ?? 0);
                  debugPrint('Page Index: $page');
                  if (page > 0) {
                    _controller.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                }),
                child: const Text('Previous'),
              ),
            ),
            // Next, Get Started
            Expanded(
              child: ElevatedButton(
                onPressed: (() {
                  final page = (currentPage ?? 0);
                  debugPrint('Page Index: $page');
                  if (!isLastPage) {
                    // Animate to Next
                    if (page >= 0 && page < (pages.length - 1)) {
                      _controller.animateToPage(
                        (page + 1),
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  } else {
                    _setUserSeenOnBoarding();
                    // Navigate to Auth Screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => AuthScreen()),
                    );
                  }
                }),
                style: theme.elevatedButtonTheme.style,
                child: isLastPage ? Text('Get Started') : Text('Next'),
              ),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          return OnBoardingPage(
            imageUrl: page.imageUrl,
            title: page.title,
            description: page.description,
          );
        },
      ),
    );
  }
}
