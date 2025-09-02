import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/features/main/movie/screen/movie_screen.dart';
import 'package:movie_mate_app/features/main/profile/screen/profile_screen.dart';
import 'package:movie_mate_app/features/main/search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final List<Widget> screens = [
    MovieScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlurryContainer(
          blur: 20,
          borderRadius: BorderRadius.circular(30.0),
          padding: EdgeInsets.zero,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: isDarkMode ? white : black,
              unselectedItemColor: red,
              iconSize: 22,
              onTap: (index) {
                currentIndex = index;
                setState(() {});
              },
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.home_outlined),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.home_filled),
                  ),
                  label: ''
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.search),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.search),
                  ),
                  label: ''
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.person_2_outlined),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.person),
                  ),
                  label: ''
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(index: currentIndex, children: screens),
    );
  }
}
