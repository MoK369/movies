import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/modules/home/pages/browse_page/browse_page.dart';
import 'package:movies/modules/home/pages/home_page/home_page.dart';
import 'package:movies/modules/home/pages/search_page/search_page.dart';
import 'package:movies/modules/home/pages/watch_list_page/watch_list_page.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "HomeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentBarItemIndex = 0;
  DateTime? lastPressed;
  final PageController pageController = PageController(initialPage: 0);
  final List<Widget> pages = [
    HomePage(),
    SearchPage(),
    BrowsePage(),
    WatchListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            DateTime now = DateTime.now();
            bool isWarning = (lastPressed == null) ||
                (now.difference(lastPressed!) > Duration(seconds: 2));
            if (isWarning) {
              lastPressed = DateTime.now();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Press back again to exit"),
                duration: Duration(seconds: 2),
              ));
              return;
            }
            SystemNavigator.pop();
            lastPressed = null;
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: currentBarItemIndex,
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) {
                    setState(() {
                      currentBarItemIndex = value;
                      pageController.animateToPage(value,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut);
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon:
                            ImageIcon(AssetImage("assets/icons/home_icon.png")),
                        label: "HOME"),
                    BottomNavigationBarItem(
                        icon: ImageIcon(
                            AssetImage("assets/icons/search_icon.png")),
                        label: "SEARCH"),
                    BottomNavigationBarItem(
                        icon: ImageIcon(
                            AssetImage("assets/icons/material_movie_icon.png")),
                        label: "BROWSE"),
                    BottomNavigationBarItem(
                        icon: ImageIcon(
                            AssetImage("assets/icons/bookmarks_icon.png")),
                        label: "WATCHLIST"),
                  ]),
              body: PageView(
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    currentBarItemIndex = value;
                  });
                },
                controller: pageController,
                children: pages,
              )),
        ),
      ),
    );
  }
}
