import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../extensions/build_context_x.dart';
import '../player/view/player_view.dart';
import '../podcasts/download_manager.dart';
import '../podcasts/view/podcast_collection_view.dart';
import '../podcasts/view/podcast_search_view.dart';

class Home extends StatelessWidget with WatchItMixin {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    registerStreamHandler(
      select: (DownloadManager m) => m.messageStream,
      handler: downloadMessageStreamHandler,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: YaruWindowTitleBar(
          border: BorderSide.none,

          titleSpacing: 0,
          title: TabBar(
            tabs: [
              Tab(text: context.l10n.search),
              Tab(text: context.l10n.collection),
            ],
          ),
        ),
        body: const TabBarView(
          children: [PodcastSearchViewNew(), PodcastCollectionView()],
        ),
        bottomNavigationBar: const PlayerView(),
      ),
    );
  }
}
