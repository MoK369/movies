import 'package:flutter/material.dart';
import 'package:movies/core/constants/asset_paths/asset_paths.dart';
import 'package:rive/rive.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Center(
      child: FittedBox(
        child: Column(
          children: [
            SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.2,
                child: RiveAnimation.asset(
                  AssetPaths.errorAnimation,
                )),
            SizedBox(
              height: 16,
            ),
            Text("An error occurred. Please try again later",
                style: theme.textTheme.labelSmall)
          ],
        ),
      ),
    );
  }
}
