import 'package:advanced_flutter/infra/cache/adapter/cache_manager_adapter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

CacheManagerAdapter makeCacheManagerAdapter() {
  return CacheManagerAdapter(client: DefaultCacheManager());
}
