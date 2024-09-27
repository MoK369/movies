import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/database/hive/boxes/watch_list_box.dart';
import 'package:movies/core/extension_methods/string_extension_methods/string_extension_methods.dart';
import 'package:movies/core/image_url/image_url.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/widgets/cust_cached_network_image.dart';
import 'package:movies/core/widgets/movie_vote_number_row.dart';

class PosterCard extends StatefulWidget {
  final double? posterWidth, posterHeight, shimmerWidth, shimmerHeight;
  final bool showBottomSection;
  final Result movie;
  final VoidCallback? onPosterClick, onBookMarkClick;

  const PosterCard({
    super.key,
    required this.movie,
    this.posterWidth,
    this.posterHeight,
    this.showBottomSection = false,
    this.shimmerWidth,
    this.shimmerHeight,
    this.onPosterClick,
    this.onBookMarkClick,
  });

  @override
  State<PosterCard> createState() => _PosterCardState();
}

class _PosterCardState extends BaseView<PosterCard> {
  bool isBookMarked = false;

  @override
  void initState() {
    super.initState();
    checkIsBookMarkedOrNot();
  }

  @override
  void didUpdateWidget(covariant PosterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    checkIsBookMarkedOrNot();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: widget.onPosterClick,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          !widget.showBottomSection
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustCachedNetworkImage(
                    fit: BoxFit.fill,
                    width: widget.posterWidth,
                    height: widget.posterHeight,
                    imagePath: widget.movie.posterPath,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
                      child: CustCachedNetworkImage(
                        fit: BoxFit.fill,
                        width: widget.posterWidth,
                        height: widget.posterHeight,
                        imagePath:
                            ImageUrl.getFullUrl(widget.movie.posterPath ?? ""),
                      ),
                    ),
                    Container(
                      width: widget.posterWidth,
                      height: (widget.posterHeight ?? 0) / 2.2,
                      decoration: const BoxDecoration(
                          color: Color(0xFF343534),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MovieVoteNumberRow(
                                movieVoteNumber: widget.movie.voteAverage),
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              widget.movie.title ?? "",
                              style: theme.textTheme.labelSmall,
                            ),
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              (widget.movie.releaseDate == "") ||
                                      (widget.movie.releaseDate == null)
                                  ? ""
                                  : widget.movie.releaseDate!.getUsDateFormat(),
                              style: theme.textTheme.labelSmall!
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: widget.onBookMarkClick == null
                  ? () {
                whenBookMarkClicked();
              }
                  : () {
                whenBookMarkClicked();
                widget.onBookMarkClick!();
                setState(() {});
              },
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  !isBookMarked
                      ? "assets/icons/bookmark.png"
                      : "assets/icons/saved_mark.png",
                  width: size.width * 0.11,
                ),
              ))
        ],
      ),
    );
  }

  void whenBookMarkClicked() async {
    if (isBookMarked) {
      await WatchListBox.removeASavedMovie(widget.movie.id ?? 0);
      isBookMarked = false;
    } else {
      var result = await WatchListBox.saveToWatchList(
          widget.movie.id ?? 0, widget.movie);
      switch (result) {
        case SuccessState<void>():
          isBookMarked = true;
          break;
        case FailureState<void>():
          showInfoAlertDialog(titleText: result.message);
      }
    }
  }

  void checkIsBookMarkedOrNot() {
    if (WatchListBox.readASavedMovie(widget.movie.id ?? 0) != null) {
      isBookMarked = true;
    } else {
      isBookMarked = false;
    }
  }
}
