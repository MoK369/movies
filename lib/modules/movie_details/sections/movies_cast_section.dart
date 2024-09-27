import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/models/movie_credits_model/movie_credits_model.dart';
import 'package:movies/core/view_models/api_view_models/movie_credits_view_model.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:movies/modules/movie_details/widgets/cast_card.dart';

class MoviesCastSection extends StatefulWidget {
  const MoviesCastSection({super.key});

  @override
  State<MoviesCastSection> createState() => _MoviesCastSectionState();
}

class _MoviesCastSectionState extends BaseView<MoviesCastSection> {
  bool showMoviesCastSection = true;

  @override
  Widget build(BuildContext context) {
    return !showMoviesCastSection
        ? SizedBox()
        : Container(
            color: const Color(0xFF282A28).withOpacity(0.5),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Movie's Cast:",
                  style: theme.textTheme.labelMedium!.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: size.height * 0.4,
                  child: CustomViewModelConsumer<MovieCreditsViewModel,
                      List<Cast>>(
                    shimmerWidth: size.width * 0.95,
                    shimmerHeight: size.height * 0.35,
                    successFunction: (successState) {
                      var castList = successState.data;
                      if (castList.isEmpty) {
                        showMoviesCastSection = false;
                        WidgetsBinding.instance.addPostFrameCallback(
                          (timeStamp) {
                            setState(() {});
                          },
                        );
                      }
                      return ListView.builder(
                        cacheExtent: 500,
                        scrollDirection: Axis.horizontal,
                        itemCount: castList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: CastCard(
                                cast: castList[index],
                                profileImageWidth: size.width * 0.33,
                                profileImageHeight:
                                    (size.width * 0.33) * (12 / 10)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
