import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:storypad/constants/config_constant.dart';
import 'package:storypad/mixins/change_notifier_mixin.dart';
import 'package:storypad/screens/lock_screen.dart';
import 'package:storypad/storages/lock_screen_storage.dart';
import 'package:storypad/widgets/vt_ontap_effect.dart';

class LockScreenNotifier extends ChangeNotifier with ChangeNotifierMixin {
  Map<String, String>? _storageLockNumberMap;
  Map<String, String>? _firstStepLockNumberMap;
  Map<String, String>? get firstStepLockNumberMap =>
      this._firstStepLockNumberMap;

  LockScreenFlowType? _type;
  LockScreenFlowType? get type => this._type;

  bool _inited = false;
  bool get inited => this._inited;

  bool _ignoring = false;
  bool get ignoring => this._ignoring;
  set ignoring(bool value) {
    if (this._ignoring == value) return;
    this._ignoring = value;
    notifyListeners();
  }

  setFlowType(LockScreenFlowType type, bool updateState) {
    this._type = type;
    if (updateState) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        notifyListeners();
      });
    }
  }

  void setfirstStepLockNumberMap(Map<String, String> value) {
    _firstStepLockNumberMap = value;
    print("_firstStepLockNumberMap $_firstStepLockNumberMap");
    notifyListeners();
  }

  String? _errorMessage;
  Map<String, String?>? _lockNumberMap;
  double _opacity = 1;

  LockScreenStorage storage = LockScreenStorage();

  void fadeOpacity() {
    _opacity = 0;
    notifyListeners();
    Future.delayed(ConfigConstant.fadeDuration).then((value) {
      _opacity = 1;
      notifyListeners();
    });
  }

  Future<void> load() async {
    ignoring = true;
    final Map<String, String>? result = await storage.readMap();
    if (result != null) {
      this._storageLockNumberMap = result;
      print("result $result");
    } else {
      this._storageLockNumberMap = null;
    }
    _inited = true;
    ignoring = false;
  }

  Future<void> setLockNumberMap(
    Map<String, String?>? lockNumberMap, {
    bool fadeLock = false,
  }) async {
    if (fadeLock && lockNumberMap == null) {
      ignoring = true;
      var newMap = this._lockNumberMap;
      await Future.delayed(Duration(milliseconds: 200));
      for (int i = 3; i >= 0; i--) {
        await Future.delayed(Duration(milliseconds: 50)).then((value) {
          newMap?["$i"] = null;
          this._lockNumberMap = newMap;
          notifyListeners();
        });
      }
      onTapVibrate();
      ignoring = false;
    } else {
      this._lockNumberMap = lockNumberMap;
      print(this._lockNumberMap);
      notifyListeners();
    }
  }

  bool get isMax {
    int i = 0;
    lockNumberMap.entries.forEach((e) {
      if (e.value == null) {
        i++;
      }
    });
    if (i == 0) {
      return true;
    } else {
      return false;
    }
  }

  String? get errorMessage => this._errorMessage;
  double get opacity => this._opacity;
  Map<String, String>? get storageLockNumberMap => _storageLockNumberMap;
  Map<String, String?> get lockNumberMap {
    return _lockNumberMap ?? {"0": null, "1": null, "2": null, "3": null};
  }

  void setErrorMessage(String? message) {
    if (message != this._errorMessage) {
      this._errorMessage = message;
      fadeOpacity();
    }
  }
}

final lockScreenProvider = ChangeNotifierProvider.autoDispose
    .family<LockScreenNotifier, LockScreenFlowType>(
  (ref, LockScreenFlowType type) {
    return LockScreenNotifier()
      ..setFlowType(type, false)
      ..load();
  },
);
