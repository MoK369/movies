import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/models/movie_trailer_model/movie_trailer_model.dart';
import 'package:movies/core/view_models/api_view_models/movie_trailer_view_model.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:movies/modules/movie_details/manager/details_screen_provider.dart';
import 'package:provider/provider.dart';

class TitleAndLinkSection extends StatefulWidget {
  final String? movieTitle;
  final void Function(VideoResult videoResult) onTitleLongPress;

  const TitleAndLinkSection(
      {super.key, required this.movieTitle, required this.onTitleLongPress});

  @override
  State<TitleAndLinkSection> createState() => _TitleAndLinkSectionState();
}

class _TitleAndLinkSectionState extends BaseView<TitleAndLinkSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomViewModelConsumer<MovieTrailerViewModel, VideoResult>(
            shimmerWidth: size.width * 0.6,
            shimmerHeight: size.height * 0.03,
            textToShowOnErrorInsteadOfErrorMessage: (widget.movieTitle ?? ""),
            successFunction: (successState) {
              var videoResult = successState.data;
              return InkWell(
                splashColor: Colors.transparent,
                onLongPress: () {
                  widget.onTitleLongPress(videoResult);
                },
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: widget.movieTitle ?? "",
                      style: theme.textTheme.labelMedium),
                  WidgetSpan(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      Icons.link,
                      color: Colors.white,
                      size: 20,
                    ),
                  ))
                ])),
              );
            }),
        Selector<DetailsScreenProvider, String?>(
          builder: (context, launchingUrlErrorMessage, child) {
            if (launchingUrlErrorMessage != "") {
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  showInfoAlertDialog(
                      titleText: launchingUrlErrorMessage!.substring(0, 21));
                },
              );
            }
            return SizedBox();
          },
          selector: (context, detailsScreenProvider) =>
              detailsScreenProvider.launchingUrlErrorMessage,
        )
      ],
    );
  }
}
