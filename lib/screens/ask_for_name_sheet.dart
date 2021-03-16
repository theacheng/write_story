import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:write_story/models/user_model.dart';
import 'package:write_story/notifier/user_model_notifier.dart';
import 'package:write_story/screens/home_screen.dart';
import 'package:write_story/widgets/vt_ontap_effect.dart';

class AskForNameSheet extends HookWidget {
  const AskForNameSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = useProvider(userModelProvider);
    final statusBarHeight = MediaQuery.of(context).padding.top;

    final nameNotEmpty =
        notifier.nickname != null && notifier.nickname.trim().isNotEmpty;
    bool canContinue = nameNotEmpty;
    if (notifier.user != null && notifier.user.nickname != null) {
      canContinue =
          nameNotEmpty && notifier.user.nickname != notifier.nickname.trim();
    }

    final _theme = Theme.of(context);

    final _continueButton = buildContinueButton(
      nameNotEmpty: canContinue,
      context: context,
      onTap: () async {
        final success = await notifier.setUser(
          UserModel(
            nickname: notifier.nickname.trim(),
            createOn: DateTime.now(),
          ),
        );

        if (success) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 1000),
              child: HomeScreen(),
            ),
          );
        }
      },
    );

    return LayoutBuilder(
      builder: (context, constrant) {
        bool tablet = constrant.maxWidth > constrant.maxHeight;
        final lottieHeight =
            tablet ? constrant.maxHeight / 2 : constrant.maxWidth / 2;

        final initHeight = (constrant.maxHeight -
                lottieHeight -
                statusBarHeight -
                kToolbarHeight) /
            constrant.maxHeight;

        final child = Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeaderText(_theme),
                const SizedBox(height: 24.0),
                Container(
                  child: buildTextField(notifier, _theme, context),
                ),
              ],
            ),
            _continueButton,
          ],
        );
        return DraggableScrollableSheet(
          initialChildSize: initHeight,
          maxChildSize: 1,
          minChildSize: 0.2,
          builder: (context, controller) {
            return Container(
              child: child,
              height: double.infinity,
              decoration: buildBoxDecoration(context),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 32.0,
              ),
            );
          },
        );
      },
    );
  }

  Widget buildHeaderText(ThemeData _theme) {
    final _style =
        _theme.textTheme.headline4.copyWith(color: _theme.primaryColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "សួរស្តី!",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: _style,
        ),
        Text(
          "តើខ្ងុំគួរហៅអ្នកដូចម្តេចដែរ?",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: _theme.textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget buildTextField(
    UserModelNotifier notifier,
    ThemeData _theme,
    BuildContext context,
  ) {
    final _textTheme = _theme.textTheme;

    final _style = _textTheme.subtitle1.copyWith(
      color: _textTheme.bodyText1.color.withOpacity(0.7),
    );

    final _hintStyle = _textTheme.subtitle1.copyWith(
      color: _theme.disabledColor,
    );

    final _decoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
      fillColor: _theme.scaffoldBackgroundColor,
      hintText: "ឈ្មោះក្រៅរបស់អ្នក...",
      hintStyle: _hintStyle,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      textAlign: TextAlign.center,
      style: _style,
      maxLines: 1,
      initialValue: notifier.user != null ? notifier.user.nickname : null,
      decoration: _decoration,
      onChanged: (String value) {
        notifier.setNickname(value);
      },
    );
  }

  Widget buildContinueButton({
    bool nameNotEmpty,
    VoidCallback onTap,
    BuildContext context,
  }) {
    final _theme = Theme.of(context);

    final _effects = [
      VTOnTapEffectItem(effectType: VTOnTapEffectType.scaleDown),
      VTOnTapEffectItem(
        effectType: VTOnTapEffectType.touchableOpacity,
        active: 0.5,
      ),
    ];

    final _decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: nameNotEmpty
            ? _theme.primaryColor
            : _theme.scaffoldBackgroundColor);

    return IgnorePointer(
      ignoring: !nameNotEmpty,
      child: VTOnTapEffect(
        onTap: onTap,
        effects: _effects,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          decoration: _decoration,
          alignment: Alignment.center,
          child: Text(
            "បន្តរ",
            style: _theme.textTheme.bodyText1.copyWith(
              color: nameNotEmpty ? Colors.white : _theme.disabledColor,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    final _theme = Theme.of(context);
    const borderRadius = const BorderRadius.vertical(
      top: const Radius.circular(10),
    );

    final boxShadow = [
      BoxShadow(
        offset: Offset(0.0, -1.0),
        color: _theme.shadowColor.withOpacity(0.15),
        blurRadius: 10.0,
      ),
    ];

    return BoxDecoration(
      color: Colors.white,
      boxShadow: boxShadow,
      borderRadius: borderRadius,
    );
  }
}