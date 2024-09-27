import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VolumeWidget extends StatefulWidget {
  final YoutubePlayerController youtubePlayerController;

  const VolumeWidget({super.key, required this.youtubePlayerController});

  @override
  State<VolumeWidget> createState() => _VolumeWidgetState();
}

class _VolumeWidgetState extends State<VolumeWidget> {
  double volume = 100;
  bool isVolumeMuted = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: -20,
      leading: IconButton(
          onPressed: () {
            setState(() {
              isVolumeMuted = !isVolumeMuted;
              isVolumeMuted ? volume = 0 : volume = 50;
            });
            if (isVolumeMuted) {
              widget.youtubePlayerController.mute();
            } else {
              widget.youtubePlayerController.unMute();
              widget.youtubePlayerController.setVolume(50);
            }
          },
          icon: getVolumeIcon(volume)),
      title: Slider(
        value: volume,
        min: 0,
        max: 100,
        divisions: 20,
        label: volume.toInt().toString(),
        onChanged: (value) {
          setState(() {
            volume = value;
            if (volume == 0) {
              isVolumeMuted = true;
            }
          });
          if (volume == 0) {
            widget.youtubePlayerController.mute();
          } else {
            widget.youtubePlayerController.unMute();
          }
          widget.youtubePlayerController.setVolume(volume.round());
        },
      ),
    );
  }

  Icon getVolumeIcon(double volume) {
    switch (volume) {
      case >= 50:
        return const Icon(
          Icons.volume_up,
          color: Colors.white,
          size: 25,
        );
      case < 50 && > 0:
        return const Icon(
          Icons.volume_down,
          color: Colors.white,
          size: 25,
        );
      case 0:
        return const Icon(
          Icons.volume_off,
          color: Colors.white,
          size: 25,
        );
      default:
        return const Icon(
          Icons.volume_up,
          color: Colors.white,
          size: 25,
        );
    }
  }
}
