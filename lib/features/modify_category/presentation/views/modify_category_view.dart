import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/core/components/custom_autocomplete_text_input_field.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/components/custom_elevated_button.dart';
import 'package:stock_management_tool/core/components/custom_snack_bar.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/modify_category/presentation/bloc/modify_category_bloc.dart';
import 'package:stock_management_tool/features/modify_category/presentation/widgets/custom_field_details.dart';

class ModifyCategoryView extends StatelessWidget {
  ModifyCategoryView({super.key});

  final ModifyCategoryBloc _modifyCategoryBloc = sl.get<ModifyCategoryBloc>();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double pad = (constraints.maxWidth - 770 - 104) / 2;

        return BlocConsumer<ModifyCategoryBloc, ModifyCategoryState>(
          bloc: _modifyCategoryBloc,
          listenWhen: (prev, next) => next is ModifyCategoryActionState,
          buildWhen: (prev, next) => next is! ModifyCategoryActionState,
          listener: (BuildContext context, ModifyCategoryState state) {
            _blocListener(context, state, constraints, pad);
          },
          builder: (BuildContext context, ModifyCategoryState state) {
            return _blocBuilder(context, state, constraints, pad);
          },
        );
      },
    );
  }

  void _blocListener(BuildContext context, ModifyCategoryState state,
      BoxConstraints constraints, double pad) {
    switch (state.runtimeType) {
      case const (ModifyCategoryActionState):
        SnackBar snackBar = CustomSnackBar(
          content: Text(
            "New Category added successfully",
            style: kLabelTextStyle,
          ),
          margin: EdgeInsets.only(
              left: 302 + pad,
              bottom: constraints.maxHeight - 60,
              right: 52 + pad),
        ).build();

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;

      default:
        break;
    }
  }

  Widget _blocBuilder(BuildContext context, ModifyCategoryState state,
      BoxConstraints constraints, double pad) {
    switch (state.runtimeType) {
      case const (LoadingState):
        _modifyCategoryBloc.add(CloudDataChangeEvent(
          onChange: (modifyCategoryData) {
            _modifyCategoryBloc.add(LoadedEvent(
                modifyCategoryData:
                    modifyCategoryData.cast<String, dynamic>()));
          },
        ));

        return _buildLoadingStateWidget();

      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (LoadedState):
        Map<String, dynamic> modifyCategoryData = state.modifyCategoryData!;

        return _buildLoadedStateWidget(modifyCategoryData, constraints, pad);

      default:
        return Container();
    }
  }

  Widget _buildLoadingStateWidget() {
    return const Center(
      child: SizedBox(
        width: 100,
        child: LinearProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorStateWidget() {
    return const Center(
      child: Text('Error'),
    );
  }

  Widget _buildLoadedStateWidget(Map<String, dynamic> modifyCategoryData,
      BoxConstraints constraints, double pad) {
    String? category = modifyCategoryData["category_text"];
    String? displayField = modifyCategoryData["display_field"];
    List? localFieldFilters = modifyCategoryData["rearrange_fields"] != null
        ? List.from(modifyCategoryData["rearrange_fields"])
        : null;

    return constraints.maxWidth > 770 + 104
        ? Padding(
            padding: EdgeInsets.fromLTRB(52 + pad, 80, 52 + pad, 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 352.5,
                  child: CustomContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: FocusScope(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: CustomAutocompleteTextInputField(
                                text: "Category",
                                initialValue:
                                    modifyCategoryData["category_text"],
                                items: modifyCategoryData["categories"],
                                validator: (_) => null,
                                onSelected: (value) {
                                  _modifyCategoryBloc.add(CategorySelectedEvent(
                                    category: value,
                                    modifyCategoryData: modifyCategoryData,
                                  ));
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (modifyCategoryData["categories"]
                                        .contains(category))
                                      for (var field in [
                                        "date",
                                        "category",
                                        "item id"
                                      ])
                                        Padding(
                                          key: Key(field),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.5, vertical: 5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: displayField == field
                                                  ? kButtonBackgroundColor
                                                  : kTertiaryBackgroundColor,
                                              borderRadius: kBorderRadius,
                                              boxShadow: kBoxShadowList,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 7.5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        _modifyCategoryBloc.add(
                                                            ViewFieldDetailsEvent(
                                                                field: field,
                                                                modifyCategoryData:
                                                                    modifyCategoryData));
                                                      },
                                                      child: Text(
                                                        CaseHelper.convert(
                                                            modifyCategoryData[
                                                                        "field_details"]
                                                                    [field]
                                                                ["name_case"],
                                                            field),
                                                        style: kLabelTextStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    if (modifyCategoryData["categories"]
                                            .contains(category) &&
                                        localFieldFilters != null)
                                      StatefulBuilder(
                                        builder: (BuildContext context,
                                            void Function(void Function())
                                                setState) {
                                          return ReorderableListView(
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            proxyDecorator: (Widget child,
                                                int index,
                                                Animation<double> animation) {
                                              return child;
                                            },
                                            onReorder: (oldIndex, newIndex) {
                                              setState(() {
                                                if (oldIndex < newIndex) {
                                                  newIndex -= 1;
                                                }
                                                final item = localFieldFilters
                                                    .removeAt(oldIndex);
                                                localFieldFilters.insert(
                                                    newIndex, item);
                                              });
                                              _modifyCategoryBloc
                                                  .add(RearrangeFieldsEvent(
                                                fields: localFieldFilters,
                                                modifyCategoryData:
                                                    modifyCategoryData,
                                              ));
                                            },
                                            children: localFieldFilters
                                                .map(
                                                  (field) => Padding(
                                                    key: Key(field),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 2.5,
                                                        vertical: 5.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: displayField ==
                                                                field
                                                            ? kButtonBackgroundColor
                                                            : kTertiaryBackgroundColor,
                                                        borderRadius:
                                                            kBorderRadius,
                                                        boxShadow:
                                                            kBoxShadowList,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    10.0,
                                                                vertical: 7.5),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  _modifyCategoryBloc.add(ViewFieldDetailsEvent(
                                                                      field:
                                                                          field,
                                                                      modifyCategoryData:
                                                                          modifyCategoryData));
                                                                },
                                                                child: Text(
                                                                  CaseHelper.convert(
                                                                      modifyCategoryData["field_details"]
                                                                              [
                                                                              field]
                                                                          [
                                                                          "name_case"],
                                                                      field),
                                                                  style:
                                                                      kLabelTextStyle,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          );
                                        },
                                      ),
                                    if (modifyCategoryData["categories"]
                                        .contains(category))
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2.5, vertical: 5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: kTertiaryBackgroundColor,
                                            borderRadius: kBorderRadius,
                                            boxShadow: kBoxShadowList,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 7.5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _modifyCategoryBloc.add(
                                                        AddNewFieldEvent(
                                                            modifyCategoryData:
                                                                modifyCategoryData));
                                                  },
                                                  child: const Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (modifyCategoryData["categories"]
                                .contains(category))
                              const Divider(),
                            if (modifyCategoryData["categories"]
                                .contains(category))
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: SizedBox(
                                  width: 322.5,
                                  child: CustomElevatedButton(
                                    text: "Modify Category",
                                    onPressed: () {
                                      _modifyCategoryBloc
                                          .add(ModifyCategoryPressedEvent(
                                        modifyCategoryData: modifyCategoryData,
                                      ));
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (modifyCategoryData["categories"].contains(category) &&
                    displayField != null)
                  const SizedBox(
                    width: 50.0,
                  ),
                if (modifyCategoryData["categories"].contains(category) &&
                    displayField != null)
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 367.5,
                        child: CustomContainer(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(7.5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Field Details",
                                        style: kLabelTextStyle,
                                      ),
                                      if (modifyCategoryData["field_details"]
                                              [displayField]["can_remove"] ==
                                          true)
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: kBorderRadius,
                                            ),
                                          ),
                                          onPressed: () {
                                            _modifyCategoryBloc
                                                .add(RemoveFieldEvent(
                                              modifyCategoryData:
                                                  modifyCategoryData,
                                            ));
                                          },
                                          child: Text(
                                            "Remove",
                                            style: kLabelTextStyle,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Expanded(
                                  child: FocusScope(
                                    child: ListView.builder(
                                      itemCount: modifyCategoryData[
                                              "field_data_fields"]
                                          .length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        MapEntry<String, dynamic> data =
                                            modifyCategoryData[
                                                    "field_data_fields"]
                                                .entries
                                                .elementAt(index);

                                        return CustomFieldDetails(
                                          detailKey: data.key,
                                          displayField: displayField,
                                          text: data.value,
                                          message:
                                              modifyCategoryData["tool_tips"]
                                                  [data.key],
                                          options:
                                              modifyCategoryData["options"],
                                          fieldDetails: modifyCategoryData[
                                              "field_details"],
                                          validator: (_) => null,
                                          onSelected: (value) {
                                            _modifyCategoryBloc
                                                .add(DetailsTypedEvent(
                                              title: data.key,
                                              value: value,
                                              modifyCategoryData:
                                                  modifyCategoryData,
                                            ));
                                          },
                                          onSubmitted: (value) {
                                            _modifyCategoryBloc
                                                .add(FieldNameTypedEvent(
                                              title: data.key,
                                              value: value,
                                              modifyCategoryData:
                                                  modifyCategoryData,
                                            ));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        : const SizedBox(
            width: double.infinity,
            height: double.infinity,
          );
  }
}
