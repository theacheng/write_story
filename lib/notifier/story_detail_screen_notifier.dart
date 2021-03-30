import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:write_story/database/w_database.dart';
import 'package:write_story/models/story_model.dart';

class StoryDetailScreenNotifier extends ChangeNotifier {
  final WDatabase wDatabase = WDatabase.instance;
  StoryModel draftStory;

  bool hasChanged = false;
  bool _imageLoading = false;

  StoryDetailScreenNotifier(this.draftStory);

  Future<bool> updateStory(StoryModel story) async {
    final success = await wDatabase.updateStory(story: story);
    if (success) {
      this.hasChanged = true;
    }
    return success;
  }

  Future<bool> addStory(StoryModel story) async {
    final success = await wDatabase.addStory(story: story);
    if (success) {
      this.hasChanged = true;
    }
    return success;
  }

  void setDraftStory(StoryModel story) {
    this.draftStory = story;
  }

  Future<bool> removeStoryById(int id) async {
    final success = await wDatabase.removeStoryById(id);
    if (success) {
      this.hasChanged = true;
    }
    return success;
  }

  void setImageLoading(bool value) {
    _imageLoading = value;
    notifyListeners();
  }

  bool get imageLoading => this._imageLoading;
}

final storydetailScreenNotifier =
    ChangeNotifierProvider.family<StoryDetailScreenNotifier, StoryModel>(
  (ref, story) {
    return StoryDetailScreenNotifier(story);
  },
);
