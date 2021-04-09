import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/edit_mode.dart';
import '../../../generated/l10n.dart';
import '../../../models/app_model.dart';
import '../../../models/contact_model.dart';
import '../../../models/edit_model.dart';
import '../../../models/item.dart';
import '../../../ui/common/buttons.dart';
import '../../../ui/common/info_action_widget.dart';
import '../../../ui/pages/reorder_page/reorder_widget.dart';
import '../../../ui/theme.dart';

class ReorderPage extends StatelessWidget {
  final EditMode editMode;

  const ReorderPage(this.editMode);

  @override
  Widget build(BuildContext context) {
    var _favItems = <Item>[];

    if (editMode == EditMode.apps) {
      _favItems = Provider.of<AppModel>(context).favApps;
    } else {
      _favItems = Provider.of<ContactModel>(context).favContacts;
    }

    void backToHome() {
      Navigator.pop(context);
    }

    void saveFavItems(List<String> newFavItems) {
      if (editMode == EditMode.apps) {
        Provider.of<AppModel>(context, listen: false).saveFavApps(newFavItems);
      } else {
        Provider.of<ContactModel>(context, listen: false)
            .saveFavContacts(newFavItems);
      }
    }

    return ChangeNotifierProvider(
      create: (_) => EditModel(favItems: _favItems),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                child: Consumer<EditModel>(
                  builder: (_, editModel, __) => Column(
                    children: <Widget>[
                      if (editModel.sortedItems.isNotEmpty) ...[
                        Expanded(
                          child: ReorderWidget(editModel,
                              showId:
                                  editMode == EditMode.contacts ? true : false),
                        ),
                      ] else ...[
                        InfoActionWidget.close(
                          message: S.of(context).msgNoData,
                          buttonLabel: S.of(context).btnBackToHome,
                          buttonOnClickAction: backToHome,
                        )
                      ]
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PrimaryButton(S.of(context).btnBackToHome, backToHome),
              ),
            ],
          ),
        ),
        floatingActionButton: Consumer<EditModel>(
          builder: (context, editModel, _) {
            if (editModel.isListModified) {
              return Padding(
                padding: EdgeInsets.only(bottom: Values.fabSafeBottomPadding),
                child: FloatingActionButton.extended(
                  icon: Icon(Icons.save),
                  label: Text('Save'),
                  onPressed: () {
                    saveFavItems(editModel.getFavIds());
                    Navigator.pop(context);
                  },
                ),
              );
            } else {
              return Container(height: 0, width: 0);
            }
          },
        ),
      ),
    );
  }
}
