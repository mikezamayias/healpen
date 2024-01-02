import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'sf_sentiment_score.dart';

class SentimentChartHeader extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 36.h;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const SfSentimentScore();
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
