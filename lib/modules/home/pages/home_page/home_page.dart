import 'package:flutter/material.dart';
import 'package:movies/core/api_error_message/api_error_message.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/view_models/api_view_models/popular_movies_view_model.dart';
import 'package:movies/core/view_models/api_view_models/top_rated_movies_view_model.dart';
import 'package:movies/core/view_models/api_view_models/upcoming_dates_view_model.dart';
import 'package:movies/modules/home/pages/home_page/sections/new_releases_section.dart';
import 'package:movies/modules/home/pages/home_page/sections/recommended_section.dart';
import 'package:movies/modules/home/pages/home_page/sections/top_side_section.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseView<HomePage> {
  final PopularMoviesViewModel popularMoviesViewModel =
      PopularMoviesViewModel();
  final UpcomingMoviesViewModel upcomingMoviesViewModel =
      UpcomingMoviesViewModel();
  final TopRatedMoviesViewModel topRatedMoviesViewModel =
      TopRatedMoviesViewModel();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => popularMoviesViewModel),
          ChangeNotifierProvider(create: (context) => upcomingMoviesViewModel),
          ChangeNotifierProvider(create: (context) => topRatedMoviesViewModel),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopSideSection(
                popularMoviesViewModel: popularMoviesViewModel,
                upcomingMoviesViewModel: upcomingMoviesViewModel,
              ),
              NewReleasesSection(
                upcomingMoviesViewModel: upcomingMoviesViewModel,
                popularMoviesViewModel: popularMoviesViewModel,
              ),
              const SizedBox(
                height: 20,
              ),
              RecommendedSection(
                topRatedMoviesViewModel: topRatedMoviesViewModel,
              )
            ],
          ),
        ));
  }
}
