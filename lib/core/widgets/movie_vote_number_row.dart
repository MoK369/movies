import 'package:flutter/material.dart';
import 'package:movies/core/movie_vote/movie_vote.dart';

class MovieVoteNumberRow extends StatelessWidget {
  final num? movieVoteNumber;
  final double starIconScale;
  final double voteFontSize;

  const MovieVoteNumberRow(
      {super.key,
      required this.movieVoteNumber,
      this.starIconScale = 2.2,
      this.voteFontSize = 13});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Image.asset(
            "assets/icons/star_icon.png",
            scale: starIconScale,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          textAlign: TextAlign.start,
          MovieVote.getVoteAverage(movieVoteNumber ?? 0),
          style: theme.textTheme.labelMedium!.copyWith(fontSize: voteFontSize),
        ),
      ],
    );
  }
}
