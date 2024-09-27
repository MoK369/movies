import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/core/api_error_message/api_error_message.dart';
import 'package:movies/core/bases/base_view_model.dart';
import 'package:movies/core/bases/base_view_state.dart';
import 'package:movies/core/themes/app_themes.dart';
import 'package:movies/core/widgets/custom_shimmer.dart';
import 'package:provider/provider.dart';

class CustomViewModelConsumer<T extends BaseViewModel<V>, V>
    extends StatelessWidget {
  final double? shimmerWidth, shimmerHeight;
  final Color shimmerBaseColor;
  final bool showAnimationWhenLoading,
      showTextErrorInsteadOfIconError,
      showShimmerInsteadOfCircularProgressIndicator;
  final double errorIconSize;
  final String? animationPath;
  final double? animationWidth;
  final String? textToShowOnErrorInsteadOfErrorMessage;
  final Widget Function(SuccessState<V> successState) successFunction;

  const CustomViewModelConsumer(
      {super.key,
      this.shimmerWidth,
      this.shimmerHeight,
      this.showAnimationWhenLoading = false,
      this.showTextErrorInsteadOfIconError = true,
      this.showShimmerInsteadOfCircularProgressIndicator = true,
      required this.successFunction,
      this.animationPath,
      this.animationWidth,
      this.shimmerBaseColor = AppThemes.darkSecondaryColor,
      this.textToShowOnErrorInsteadOfErrorMessage,
      this.errorIconSize = 10});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Consumer<T>(
      builder: (context, viewModel, child) {
        var state = viewModel.viewState;
        switch (state) {
          case LoadingState<V>():
            return Center(
                child: showAnimationWhenLoading
                    ? Lottie.asset(animationPath ?? "", width: animationWidth)
                    : showShimmerInsteadOfCircularProgressIndicator
                        ? CustomShimmer(
                            width: shimmerWidth,
                            height: shimmerHeight,
                            baseColor: shimmerBaseColor,
                          )
                        : const CircularProgressIndicator());
          case ErrorState<V>():
            if (showTextErrorInsteadOfIconError) {
              return Center(
                  child: Text(
                textToShowOnErrorInsteadOfErrorMessage == null
                    ? ApiErrorMessage.getErrorMessage(
                        serverError: state.serverError,
                        codeError: state.codeError)
                    : textToShowOnErrorInsteadOfErrorMessage!,
                style: theme.textTheme.labelMedium,
              ));
            } else {
              return Center(
                  child: Icon(
                Icons.error_outline,
                color: Colors.white,
                size: errorIconSize,
              ));
            }

          case SuccessState<V>():
            return successFunction(state);
        }
      },
    );
  }
}
