import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class ImageUrlWidget extends StatelessWidget {
  const ImageUrlWidget({super.key, required this.imgUrl});

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    final bool isValidUrl = imgUrl.trim().isNotEmpty;

    return ClipOval(
      child: isValidUrl
          ? Image.network(
        imgUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(AppAssets.defaultAvatar, width: 56, height: 56, fit: BoxFit.cover);
        },
      )
          : Image.asset(
        AppAssets.defaultAvatar,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
      ),
    );
  }
}