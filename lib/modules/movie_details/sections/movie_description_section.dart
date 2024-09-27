import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/models/movie_details/movie_details_model.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/view_models/api_view_models/movie_details_view_model.dart';
import 'package:movies/core/widgets/poster_card.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';

class MovieDescriptionSection extends StatefulWidget {
  final Result movie;

  const MovieDescriptionSection({super.key, required this.movie});

  @override
  State<MovieDescriptionSection> createState() =>
      _MovieDescriptionSectionState();
}

class _MovieDescriptionSectionState extends BaseView<MovieDescriptionSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PosterCard(
            posterWidth: size.width * 0.44,
            posterHeight: (size.width * 0.44) * (190 / 120),
            movie: widget.movie),
        SizedBox(
          height: (size.width * 0.44) * (190 / 120),
          width: size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              children: [
                CustomViewModelConsumer<MovieDetailsViewModel,
                    MovieDetailsModel>(
                  shimmerWidth: size.width * 0.5,
                  shimmerHeight: size.height * 0.1,
                  showTextErrorInsteadOfIconError: false,
                  errorIconSize: 20,
                  successFunction: (successState) {
                    var movieDetails = successState.data;
                    return Expanded(
                      child: GridView.builder(
                        itemCount: movieDetails.genres?.length ?? 0,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 0,
                                childAspectRatio: 130 / 90),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                side: BorderSide(
                                    width: 1.4, color: Color(0xFF514F4F))),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  movieDetails.genres?[index].name ?? "",
                                  style: theme.textTheme.labelSmall!
                                      .copyWith(fontSize: 13),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Text(
                      widget.movie.overview ?? "",
                      style: theme.textTheme.labelSmall!.copyWith(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
