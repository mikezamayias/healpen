import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MoodJourneyTile extends ConsumerWidget {
  const MoodJourneyTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      reverse: true,
      shrinkWrap: true,
      itemBuilder: (_, __) => SizedBox(
        height: 10.h,
        child: Container(
          color: Colors.blue,
        ),
      ),
      separatorBuilder: (_, __) => SizedBox(
        height: 5.h,
        child: Container(
          color: Colors.green,
        ),
      ),
      itemCount: 3,
    );
  }
}
