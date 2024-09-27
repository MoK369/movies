import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/image_url/image_url.dart';
import 'package:movies/core/models/movie_trailer_model/movie_trailer_model.dart';
import 'package:movies/core/models/result.dart';
import 'package:movies/core/themes/app_themes.dart';
import 'package:movies/core/view_models/api_view_models/movie_trailer_view_model.dart';
import 'package:movies/core/widgets/cust_cached_network_image.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:movies/modules/movie_details/manager/details_screen_provider.dart';
import 'package:movies/modules/movie_details/widgets/total_duration.dart';
import 'package:movies/modules/movie_details/widgets/volume_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerVideoWidget extends StatefulWidget {
  final Result movie;
  final Widget? widgetUnderTrailer;
  final DetailsScreenProvider detailsScreenProvider;
  final MovieTrailerViewModel movieTrailerViewModel;

  const TrailerVideoWidget(
      {super.key,
      required this.movie,
      required this.movieTrailerViewModel,
      required this.detailsScreenProvider,
      this.widgetUnderTrailer});

  @override
  State<TrailerVideoWidget> createState() => _TrailerVideoWidgetState();
}

class _TrailerVideoWidgetState extends BaseView<TrailerVideoWidget> {
  bool isPlayedClicked = false,
      isFullScreen = false,
      isControllerInitialized = false;
  late YoutubePlayerController youtubePlayerController;

  @override
  void initState() {
    super.initState();
    widget.movieTrailerViewModel.getMoveTrailer(movieId: widget.movie.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: !isPlayedClicked
          ? () {
              setState(() {
                isPlayedClicked = true;
              });
            }
          : null,
      child: !isPlayedClicked
          ? Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: widget.movie.id ?? "",
                  child: CustCachedNetworkImage(
                      width: size.width,
                      height: size.height * 0.27,
                      fit: BoxFit.fill,
                      imageUrl:
                          ImageUrl.getFullUrl(widget.movie.backdropPath ?? "")),
                ),
                Image.asset("assets/icons/play-button_icon.png",
                    scale: 4, color: Colors.white.withOpacity(0.8))
              ],
            )
          : CustomViewModelConsumer<MovieTrailerViewModel, VideoResult>(
              shimmerWidth: size.width,
              shimmerHeight: size.height * 0.25,
              showTextErrorInsteadOfIconError: false,
              successFunction: (successState) {
                var trailer = successState.data;
                initController(trailer.key ?? "");
                return YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: youtubePlayerController,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      SizedBox(
                        height: 70,
                        width: size.width * 0.95,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              const ProgressBar(
                                isExpanded: true,
                                colors: ProgressBarColors(
                                    handleColor: AppThemes.darkOnPrimaryColor,
                                    playedColor: AppThemes.darkOnPrimaryColor),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.33,
                                    child: VolumeWidget(
                                        youtubePlayerController:
                                            youtubePlayerController),
                                  ),
                                  const Spacer(),
                                  CurrentPosition(
                                    controller: youtubePlayerController,
                                  ),
                                  const ImageIcon(
                                    AssetImage(
                                        "assets/icons/forward_slash_icon.png"),
                                    color: Colors.white,
                                  ),
                                  TotalDuration(
                                      youtubePlayerController:
                                          youtubePlayerController),
                                  const PlaybackSpeedButton(),
                                  const FullScreenButton(),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  builder: (context, player) {
                    return Column(
                      children: [
                        player,
                        widget.widgetUnderTrailer ?? const SizedBox(),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }

  void initController(String videoId) {
    try {
      if (!isControllerInitialized) {
        youtubePlayerController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
                mute: false,
                autoPlay: false,
                disableDragSeek: false,
                loop: false,
                isLive: false,
                forceHD: true,
                enableCaption: true,
                controlsVisibleAtStart: true))
          ..addListener(
            () {
              if (isFullScreen != youtubePlayerController.value.isFullScreen) {
                isFullScreen = youtubePlayerController.value.isFullScreen;
                widget.detailsScreenProvider
                    .changeIsFullScreenStatus(isFullScreen);
                debugPrint("$isFullScreen");
                if (isFullScreen) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                }
              }
            },
          );
        isControllerInitialized = true;
      } else {
        return;
      }
    } catch (e) {
      showInfoAlertDialog(titleText: "Error initializing YouTube player");
    }
  }

  @override
  void dispose() {
    if (isPlayedClicked) {
      youtubePlayerController.dispose();
    }
    super.dispose();
  }
}
