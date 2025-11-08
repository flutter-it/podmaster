import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:podcast_search/podcast_search.dart';

import '../../common/view/html_text.dart';
import '../../common/view/safe_network_image.dart';
import '../../common/view/sliver_sticky_panel.dart';
import '../../extensions/build_context_x.dart';
import '../podcast_service.dart';
import 'podcast_favorite_button.dart';
import 'podcast_page_episode_list.dart';

class PodcastPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const PodcastPage({super.key, required this.podcastItem});

  final Item podcastItem;

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  bool _showInfo = false;

  @override
  Widget build(BuildContext context) {
    var radius = Radius.circular(
      context.theme.dialogTheme.shape is RoundedRectangleBorder
          ? (context.theme.dialogTheme.shape as RoundedRectangleBorder)
                .borderRadius
                .resolve(TextDirection.ltr)
                .topLeft
                .x
          : 12,
    );
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,

      content: ClipRRect(
        borderRadius: BorderRadiusGeometry.all(radius),

        child: SizedBox(
          height: 800,
          width: 400,
          child: CustomScrollView(
            slivers: [
              if (widget.podcastItem.bestArtworkUrl != null)
                SliverToBoxAdapter(
                  child: Material(
                    color: Colors.transparent,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        SafeNetworkImage(
                          height: 400,
                          width: double.infinity,
                          url: widget.podcastItem.bestArtworkUrl!,
                          fit: BoxFit.cover,
                        ),
                        if (_showInfo)
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 50,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                child: HtmlText(
                                  wrapInFakeScroll: false,
                                  color: Colors.white,
                                  text:
                                      di<PodcastService>()
                                          .getPodcastDescriptionFromCache(
                                            widget.podcastItem.feedUrl,
                                          ) ??
                                      '',
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton.filled(
                            style: _showInfo
                                ? IconButton.styleFrom(
                                    backgroundColor: Colors.black54,
                                  )
                                : null,
                            onPressed: () => setState(() {
                              _showInfo = !_showInfo;
                            }),
                            icon: Icon(
                              Icons.info,
                              color: _showInfo ? Colors.white : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverStickyPanel(
                backgroundColor: context.theme.dialogTheme.backgroundColor,
                controlPanel: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    PodcastFavoriteButton(podcastItem: widget.podcastItem),
                    Flexible(
                      child: Text(
                        widget.podcastItem.collectionName ??
                            context.l10n.podcast,
                        style: context.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              PodcastPageEpisodeList(podcastItem: widget.podcastItem),
            ],
          ),
        ),
      ),
    );
  }
}
