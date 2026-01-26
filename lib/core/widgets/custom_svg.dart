import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_enums.dart';

class SvgHelper {
  static Widget fromSource({
    required String path,
    SvgSourceType type = .asset,
    double height = 20,
    double width = 20,
    Color? color,
  }) => switch (type) {
    .asset => _buildAssetSvg(path, height, width, color),
    .network => _buildNetworkSvg(path, height, width, color),
  };

  static Widget _buildAssetSvg(
    String assetName,
    double height,
    double width,
    Color? color,
  ) {
    return SvgPicture.asset(
      assetName,
      height: height,
      width: width,
      fit: .contain,
      colorFilter: color == null ? null : .mode(color, .srcIn),
    );
  }

  static Widget _buildNetworkSvg(
    String url,
    double height,
    double width,
    Color? color,
  ) {
    return SvgPicture.network(
      url,
      height: height,
      width: width,
      fit: .contain,
      colorFilter: color == null ? null : .mode(color, .srcIn),
    );
  }
}
