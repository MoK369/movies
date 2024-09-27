import 'package:flutter/material.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/modules/discover_screen/discover_screen.dart';
import 'package:movies/modules/home/home_screen.dart';
import 'package:movies/modules/movie_details/movie_details_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case MovieDetailsScreen.routName:
        if (args is Result) {
          return MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: args),
          );
        } else {
          return _errorRoute();
        }
      case DiscoverScreen.routeName:
        if (args is DiscoverScreenWantedData) {
          return MaterialPageRoute(
            builder: (context) => DiscoverScreen(data: args),
          );
        } else {
          return _errorRoute();
        }
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Container(
          color: Colors.red,
          child: const Center(
            child: Text(
              "Error! You Have Navigated To A Wrong Route. Or Navigated With Wrong Arguments",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
