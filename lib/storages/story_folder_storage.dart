import 'package:write_story/storages/share_preference_storage.dart';

class StoryFolderStorage extends SharePreferenceStorage {
  @override
  String get key => "StoryFolderID";
}