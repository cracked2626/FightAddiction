import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

ListTile buildProfileShimmer() {
  return ListTile(
    leading: FadeShimmer.round(
      size: 30,
      fadeTheme: FadeTheme.light,
    ),
    title: FadeShimmer(
      height: 20,
      width: 150,
      radius: 4,
      highlightColor: Color(0xffF9F9FB),
      baseColor: Color(0xffE6E8EB),
    ),
  );
}

FadeShimmer buildStoryShimmer() {
  return FadeShimmer(
    height: 300,
    // width: 150,
    radius: 20,
    highlightColor: Color(0xffF9F9FB),
    baseColor: Color(0xffE6E8EB), width: double.infinity,
  );
}
