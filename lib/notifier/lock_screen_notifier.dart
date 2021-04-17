import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:write_story/constants/config_constant.dart';
import 'package:write_story/screens/lock_screen.dart';
import 'package:write_story/storages/lock_screen_storage.dart';

class LockScreenNotifier extends ChangeNotifier {
  Map<String, String>? _storageLockNumberMap;
  Map<String, String>? _firstStepLockNumberMap;
  Map<String, String>? get firstStepLockNumberMap =>
      this._firstStepLockNumberMap;

  LockScreenFlowType? _type;
  LockScreenFlowType? get type => this._type;

  bool _inited = false;
  bool get inited => this._inited;

  setFlowType(LockScreenFlowType type) {
    this._type = type;
    notifyListeners();
  }

  setfirstStepLockNumberMap(Map<String, String> value) {
    _firstStepLockNumberMap = value;
    print("_firstStepLockNumberMap $_firstStepLockNumberMap");
    notifyListeners();
  }

  String? _errorMessage;
  Map<String, String?>? _lockNumberMap;
  double _opacity = 1;

  LockScreenStorage storage = LockScreenStorage();

  fadeOpacity() {
    _opacity = 0;
    notifyListeners();
    Future.delayed(ConfigConstant.fadeDuration).then((value) {
      _opacity = 1;
      notifyListeners();
    });
  }

  load() async {
    final Map<String, String>? result = await storage.readMap();
    if (result != null) {
      this._storageLockNumberMap = result;
      print("result $result");
    } else {
      this._storageLockNumberMap = null;
    }
    _inited = true;
    notifyListeners();
  }

  setLockNumberMap(Map<String, String?>? lockNumberMap) {
    this._lockNumberMap = lockNumberMap;
    print(this._lockNumberMap);
    notifyListeners();
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
    ..setFlowType(type)
    ..load();
});
