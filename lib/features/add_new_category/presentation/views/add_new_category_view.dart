import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/components/custom_elevated_button.dart';
import 'package:stock_management_tool/core/components/custom_snack_bar.dart';
import 'package:stock_management_tool/core/components/custom_text_input_field.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/add_new_category/presentation/bloc/add_new_category_bloc.dart';
import 'package:stock_management_tool/features/add_new_category/presentation/widgets/custom_field_details.dart';

class AddNewCategoryView extends StatelessWidget {
  AddNewCategoryView({super.key});

  final AddNewCategoryBloc _addNewCategoryBloc = sl.get<AddNewCategoryBloc>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double pad = (constraints.maxWidth - 770 - 104) / 2;

        return BlocConsumer<AddNewCategoryBloc, AddNewCategoryState>(
          bloc: _addNewCategoryBloc,
          listenWhen: (prev, next) => next is AddNewCategoryActionState,
          buildWhen: (prev, next) => next is! AddNewCategoryActionState,
          listener: (BuildContext context, AddNewCategoryState state) {
            _blocListener(context, state, constraints, pad);
          },
          builder: (BuildContext context, AddNewCategoryState state) {
            return _blocBuilder(context, state, constraints, pad);
          },
        );
      },
    );
  }

  void _blocListener(BuildContext context, AddNewCategoryState state,
      BoxConstraints constraints, double pad) {
    switch (state.runtimeType) {
      case const (AddNewCategoryActionState):
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

  Widget _blocBuilder(BuildContext context, AddNewCategoryState state,
      BoxConstraints constraints, double pad) {
    switch (state.runtimeType) {
      case const (LoadingState):
        _addNewCategoryBloc.add(CloudDataChangeEvent(
          onChange: (addNewCategoryData) {
            _addNewCategoryBloc.add(LoadedEvent(
                addNewCategoryData:
                    addNewCategoryData.cast<String, dynamic>()));
          },
        ));

        return _buildLoadingStateWidget();

      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (LoadedState):
        Map<String, dynamic> addNewCategoryData = state.addNewCategoryData!;

        return _buildLoadedStateWidget(addNewCategoryData, constraints, pad);

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

  Widget _buildLoadedStateWidget(Map<String, dynamic> addNewCategoryData,
      BoxConstraints constraints, double pad) {
    String displayField = addNewCategoryData["display_field"];
    List localFieldFilters = List.from(addNewCategoryData["rearrange_fields"]);

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
                              child: Form(
                                key: _formKey,
                                child: CustomTextInputField(
                                  text: "Category",
                                  initialValue:
                                      addNewCategoryData["category_text"],
                                  validator: (value) {
                                    if (value == null || value.trim() == "") {
                                      return "Category can't be empty";
                                    } else if (addNewCategoryData["categories"]
                                        .contains(value)) {
                                      return "Category name exists";
                                    }

                                    return null;
                                  },
                                  onSelected: (value) {
                                    _addNewCategoryBloc.add(CategoryTypedEvent(
                                      category: value,
                                      addNewCategoryData: addNewCategoryData,
                                    ));
                                  },
                                ),
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
                                    for (var field in [
                                      "date",
                                      "category",
                                      "item id"
                                    ])
                                      Padding(
                                        key: Key(field),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0, vertical: 5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: displayField == field
                                                ? kButtonBackgroundColor
                                                : kTertiaryBackgroundColor,
                                            borderRadius: kBorderRadius,
                                            boxShadow: kBoxShadowList,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 7.5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _addNewCategoryBloc.add(
                                                          ViewFieldDetailsEvent(
                                                              field: field,
                                                              addNewCategoryData:
                                                                  addNewCategoryData));
                                                    },
                                                    child: Text(
                                                      CaseHelper.convert(
                                                          addNewCategoryData[
                                                                  "field_details"]
                                                              [
                                                              field]["name_case"],
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
                                            _addNewCategoryBloc
                                                .add(RearrangeFieldsEvent(
                                              fields: localFieldFilters,
                                              addNewCategoryData:
                                                  addNewCategoryData,
                                            ));
                                          },
                                          children: localFieldFilters
                                              .map(
                                                (field) => Padding(
                                                  key: Key(field),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 0.0,
                                                      vertical: 5.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: displayField ==
                                                              field
                                                          ? kButtonBackgroundColor
                                                          : kTertiaryBackgroundColor,
                                                      borderRadius:
                                                          kBorderRadius,
                                                      boxShadow: kBoxShadowList,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 7.5),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                _addNewCategoryBloc.add(
                                                                    ViewFieldDetailsEvent(
                                                                        field:
                                                                            field,
                                                                        addNewCategoryData:
                                                                            addNewCategoryData));
                                                              },
                                                              child: Text(
                                                                CaseHelper.convert(
                                                                    addNewCategoryData["field_details"]
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0, vertical: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: kTertiaryBackgroundColor,
                                          borderRadius: kBorderRadius,
                                          boxShadow: kBoxShadowList,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 7.5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _addNewCategoryBloc.add(
                                                      AddNewFieldEvent(
                                                          addNewCategoryData:
                                                              addNewCategoryData));
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: SizedBox(
                                width: 322.5,
                                child: CustomElevatedButton(
                                  text: "Add New Category",
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _addNewCategoryBloc
                                          .add(AddNewCategoryPressedEvent(
                                        addNewCategoryData: addNewCategoryData,
                                      ));
                                    }
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
                const SizedBox(
                  width: 50.0,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 367.5,
                      child: CustomContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                                    if (addNewCategoryData["field_details"]
                                            [displayField]["can_remove"] ==
                                        true)
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: kBorderRadius,
                                          ),
                                        ),
                                        onPressed: () {
                                          _addNewCategoryBloc
                                              .add(RemoveFieldEvent(
                                            addNewCategoryData:
                                                addNewCategoryData,
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
                              FocusScope(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (var data in addNewCategoryData[
                                            "field_data_fields"]
                                        .entries)
                                      CustomFieldDetails(
                                        detailKey: data.key,
                                        displayField: displayField,
                                        text: data.value,
                                        message: addNewCategoryData["tool_tips"]
                                            [data.key],
                                        options: addNewCategoryData["options"],
                                        fieldDetails:
                                            addNewCategoryData["field_details"],
                                        validator: (_) => null,
                                        onSelected: (value) {
                                          _addNewCategoryBloc
                                              .add(DetailsTypedEvent(
                                            title: data.key,
                                            value: value,
                                            addNewCategoryData:
                                                addNewCategoryData,
                                          ));
                                        },
                                        onSubmitted: (value) {
                                          _addNewCategoryBloc
                                              .add(FieldNameTypedEvent(
                                            title: data.key,
                                            value: value,
                                            addNewCategoryData:
                                                addNewCategoryData,
                                          ));
                                        },
                                      ),
                                  ],
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
        : SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          );
  }
}
