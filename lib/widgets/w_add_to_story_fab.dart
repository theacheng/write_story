import 'package:flutter/material.dart';
import 'package:write_story/screens/story_detail_screen.dart';
import 'package:write_story/widgets/vt_ontap_effect.dart';

class AddToStoryFAB extends StatelessWidget {
  const AddToStoryFAB({
    Key key,
    @required this.forDate,
    @required this.onSaved,
  }) : super(key: key);

  final DateTime forDate;
  final ValueChanged<int> onSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kToolbarHeight,
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: VTOnTapEffect(
        onTap: () {},
        effects: [
          VTOnTapEffectItem(
            effectType: VTOnTapEffectType.scaleDown,
            active: 0.9,
          ),
          VTOnTapEffectItem(
            effectType: VTOnTapEffectType.touchableOpacity,
            active: 0.9,
          )
        ],
        child: FloatingActionButton(
          onPressed: () async {
            final dynamic selected =
                await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) {
                  return StoryDetailScreen(
                    futureId: DateTime.now().millisecondsSinceEpoch,
                    forDate: forDate,
                  );
                },
              ),
            );
            if (selected != null && selected is int) {
              if (this.onSaved != null) onSaved(selected);
            }
          },
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          elevation: 0.0,
          highlightElevation: 0.0,
          focusElevation: 0.0,
          hoverElevation: 0.0,
          disabledElevation: 0.0,
        ),
      ),
    );
  }
}
