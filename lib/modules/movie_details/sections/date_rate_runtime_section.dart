import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/extension_methods/num_extension_methods/num_extension_methods.dart';
import 'package:movies/core/models/movie_details/movie_details_model.dart';
import 'package:movies/core/models/movie_release_dates/release_dates_model.dart';
import 'package:movies/core/movie_certification/movie_certification.dart';
import 'package:movies/core/view_models/api_view_models/movie_details_view_model.dart';
import 'package:movies/core/view_models/api_view_models/release_dates_view_model.dart';
import 'package:movies/core/widgets/movie_vote_number_row.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';

class DateRateRuntimeSection extends StatefulWidget {
  final String? movieReleaseDate;
  final num? movieVote;

  const DateRateRuntimeSection(
      {super.key, required this.movieReleaseDate, required this.movieVote});

  @override
  State<DateRateRuntimeSection> createState() => _DateRateRuntimeSectionState();
}

class _DateRateRuntimeSectionState extends BaseView<DateRateRuntimeSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              (widget.movieReleaseDate == null) ||
                      (widget.movieReleaseDate == "")
                  ? ""
                  : widget.movieReleaseDate!.substring(0, 4),
              style: theme.textTheme.labelSmall,
            ),
            const SizedBox(
              width: 10,
            ),
            CustomViewModelConsumer<ReleaseDateViewModel, ReleaseDateResult>(
              shimmerWidth: size.width * 0.05,
              shimmerHeight: size.height * 0.015,
              showTextErrorInsteadOfIconError: false,
              errorIconSize: 15,
              successFunction: (successState) {
                return Text(
                  MovieCertification.getMovieCertification(
                      successState.data.releaseDates ?? []),
                  style: theme.textTheme.labelSmall,
                );
              },
            ),
            const SizedBox(
              width: 10,
            ),
            CustomViewModelConsumer<MovieDetailsViewModel, MovieDetailsModel>(
              shimmerWidth: size.width * 0.05,
              shimmerHeight: size.height * 0.015,
              showTextErrorInsteadOfIconError: false,
              errorIconSize: 15,
              successFunction: (successState) {
                return Text(
                  (successState.data.runtime
                          ?.getTimeFormatFromNumberOfMinutes()) ??
                      "",
                  style: theme.textTheme.labelSmall,
                );
              },
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5, top: 6),
          child: MovieVoteNumberRow(
            movieVoteNumber: widget.movieVote,
            starIconScale: 1.8,
            voteFontSize: 15,
          ),
        )
      ],
    );
  }
}
