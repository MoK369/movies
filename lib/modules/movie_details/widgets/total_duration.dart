import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TotalDuration extends StatefulWidget {
  final YoutubePlayerController youtubePlayerController;

  const TotalDuration({super.key, required this.youtubePlayerController});

  @override
  State<TotalDuration> createState() => _TotalDurationState();
}

class _TotalDurationState extends State<TotalDuration> {
  Duration totalVideoDuration = const Duration();

  @override
  void initState() {
    super.initState();
    widget.youtubePlayerController.addListener(
      () {
        if (widget.youtubePlayerController.value.isReady &&
            !widget.youtubePlayerController.value.hasError) {
          final duration = widget.youtubePlayerController.metadata.duration;
          if (duration != Duration.zero) {
            setState(() {
              totalVideoDuration = duration;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getDurationFormat(totalVideoDuration),
      style: const TextStyle(color: Colors.white),
    );
  }

  String getDurationFormat(Duration totalDuration) {
    DateTime totalDateTime = getDateTimeInHoursMinutesSeconds(totalDuration);
    if (totalDateTime.hour == 0) {
      var outputFormat = DateFormat("mm:ss");
      return outputFormat.format(totalDateTime);
    } else {
      var outputFormat = DateFormat("hh:mm:ss");
      return outputFormat.format(totalDateTime);
    }
  }

  DateTime getDateTimeInHoursMinutesSeconds(Duration totalDuration) {
    int totalSeconds = totalDuration.inSeconds;
    int hours = totalSeconds ~/ 3600;
    totalSeconds = totalSeconds % 3600;
    int minutes = totalSeconds ~/ 60;
    totalSeconds = totalSeconds % 60;
    int seconds = totalSeconds;

    return DateTime(0, 0, 0, hours, minutes, seconds);
  }
}
