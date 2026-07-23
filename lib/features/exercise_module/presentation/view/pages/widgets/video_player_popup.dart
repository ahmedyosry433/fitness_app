import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';

class VideoPlayerPopup extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPopup({super.key, required this.videoUrl});

  @override
  State<VideoPlayerPopup> createState() => _VideoPlayerPopupState();
}

class _VideoPlayerPopupState extends State<VideoPlayerPopup> {
  late YoutubePlayerController _controller;
  bool _isValidUrl = true;

  @override
  void initState() {
    super.initState();
    String? videoId;
    if (widget.videoUrl.contains('youtu.be/')) {
      videoId = widget.videoUrl.split('youtu.be/').last.split('?').first;
    } else if (widget.videoUrl.contains('v=')) {
      videoId = widget.videoUrl.split('v=').last.split('&').first;
    } else {
      videoId = widget.videoUrl;
    }

    if (videoId.isNotEmpty) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          mute: false,
          showFullscreenButton: true,
        ),
      );
    } else {
      _isValidUrl = false;
    }
  }

  @override
  void dispose() {
    if (_isValidUrl) {
      _controller.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValidUrl) {
      return Dialog(
        backgroundColor: AppColors.black22,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LocaleKeys.exercise_invalid_video_url.tr(),
                style: 16.regular.copyWith(color: AppColors.whiteFF),
              ),
              SizedBox(height: 15.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.orangePrimary),
                child: Text(LocaleKeys.exercise_close.tr(), style: 14.regular.copyWith(color: AppColors.whiteFF)),
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: YoutubePlayer(
          controller: _controller,
        ),
      ),
    );
  }
}
