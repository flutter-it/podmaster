import 'package:flutter/material.dart';

import '../../extensions/build_context_x.dart';
import 'ui_constants.dart';

class SliverStickyPanel extends StatelessWidget {
  const SliverStickyPanel({
    super.key,
    required this.controlPanel,
    this.onStretchTrigger,
    this.backgroundColor,
    this.height = kToolbarHeight,
    this.bottom,
    this.padding,
    this.centerTitle = true,
  });

  final Widget controlPanel;
  final Future<void> Function()? onStretchTrigger;
  final Color? backgroundColor;
  final double height;
  final PreferredSizeWidget? bottom;
  final EdgeInsets? padding;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.zero,
      sliver: SliverAppBar(
        toolbarHeight: height,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        elevation: 0,
        backgroundColor:
            backgroundColor ?? context.theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        pinned: true,
        centerTitle: centerTitle,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kBigPadding),
          child: controlPanel,
        ),
        bottom: bottom,
        onStretchTrigger: onStretchTrigger,
      ),
    );
  }
}
