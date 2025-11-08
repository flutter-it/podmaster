import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:podcast_search/podcast_search.dart';

extension CountryX on Country {
  static Country? get platformDefault => Country.values.firstWhereOrNull(
    (c) =>
        c.code.toLowerCase() ==
        WidgetsBinding.instance.platformDispatcher.locale.countryCode
            ?.toLowerCase(),
  );
}
