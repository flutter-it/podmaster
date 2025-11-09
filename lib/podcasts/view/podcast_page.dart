import 'package:blur/blur.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:podcast_search/podcast_search.dart';

import '../../common/view/html_text.dart';
import '../../common/view/safe_network_image.dart';
import '../../common/view/sliver_sticky_panel.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/build_context_x.dart';
import '../data/podcast_genre.dart';
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
          width: 450,
          child: CustomScrollView(
            slivers: [
              if (widget.podcastItem.bestArtworkUrl != null)
                SliverToBoxAdapter(
                  child: Material(
                    color: Colors.transparent,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Blur(
                          blur: _showInfo ? 10 : 0,
                          colorOpacity: _showInfo ? 0.7 : 0,
                          blurColor: const Color.fromARGB(255, 48, 48, 48),
                          child: SafeNetworkImage(
                            height: 400,
                            width: double.infinity,
                            url: widget.podcastItem.bestArtworkUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (_showInfo) ...[
                          Positioned(
                            bottom: kMediumPadding,
                            left: kMediumPadding,
                            top: 55,
                            right: kMediumPadding,
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
                            top: kMediumPadding,
                            left: 50,
                            right: kMediumPadding,
                            child: SizedBox(
                              width: 400,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  children:
                                      widget.podcastItem.genre
                                          ?.map(
                                            (e) => Padding(
                                              padding: const EdgeInsets.only(
                                                right: kSmallPadding,
                                              ),
                                              child: Container(
                                                height:
                                                    context
                                                        .theme
                                                        .buttonTheme
                                                        .height -
                                                    2,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal:
                                                          kMediumPadding,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    PodcastGenre.values
                                                            .firstWhereOrNull(
                                                              (element) =>
                                                                  element.name
                                                                      .toLowerCase() ==
                                                                  e.name
                                                                      .toLowerCase(),
                                                            )
                                                            ?.localize(
                                                              context.l10n,
                                                            ) ??
                                                        e.name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ),
                        ],
                        Positioned(
                          top: kMediumPadding,
                          left: kMediumPadding,
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: _showInfo
                                  ? context.colorScheme.primary
                                  : Colors.black54,
                            ),
                            onPressed: () => setState(() {
                              _showInfo = !_showInfo;
                            }),
                            icon: Icon(
                              Icons.info,
                              color: _showInfo
                                  ? context.colorScheme.onPrimary
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverStickyPanel(
                height: 80,
                backgroundColor: context.theme.dialogTheme.backgroundColor,
                centerTitle: false,
                controlPanel: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: PodcastFavoriteButton(
                    podcastItem: widget.podcastItem,
                  ),
                  title: Text(
                    '${widget.podcastItem.artistName}',
                    style: context.textTheme.bodySmall,
                    overflow: TextOverflow.visible,
                    maxLines: 3,
                  ),
                  subtitle: Text(
                    widget.podcastItem.collectionName ?? context.l10n.podcast,
                  ),
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
