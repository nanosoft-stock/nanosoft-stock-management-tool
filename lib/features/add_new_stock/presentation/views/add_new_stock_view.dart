import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/components/custom_elevated_button.dart';
import 'package:stock_management_tool/core/components/custom_snack_bar.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/bloc/add_new_stock_bloc.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/widgets/custom_input_field.dart';
import 'package:stock_management_tool/injection_container.dart';

class AddNewStockView extends StatelessWidget {
  AddNewStockView({super.key});

  final AddNewStockBloc _addNewStockBloc = sl.get<AddNewStockBloc>();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int n = ((constraints.maxWidth - 135) / 390.5).floor();
        double pad = ((constraints.maxWidth - 135) % 390.5) / 2;

        return BlocConsumer<AddNewStockBloc, AddNewStockState>(
          bloc: _addNewStockBloc,
          listenWhen: (prev, next) => next is AddNewStockActionState,
          buildWhen: (prev, next) => next is! AddNewStockActionState,
          listener: (context, state) {
            _blocListener(context, state, constraints, pad);
          },
          builder: (BuildContext context, AddNewStockState state) {
            return _blocBuilder(context, state, constraints, n, pad);
          },
        );
      },
    );
  }

  void _blocListener(BuildContext context, AddNewStockState state,
      BoxConstraints constraints, double pad) {
    switch (state.runtimeType) {
      case const (NewStockAddedActionState):
        SnackBar snackBar = CustomSnackBar(
          content: Text(
            "New stock added successfully",
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

  Widget _blocBuilder(BuildContext context, AddNewStockState state,
      BoxConstraints constraints, int n, double pad) {
    switch (state.runtimeType) {
      case const (LoadingState):
        _addNewStockBloc.add(LoadedEvent());
        return _buildLoadingStateWidget();

      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (LoadedState):
        List fields = state.fields!;
        return _buildLoadedStateWidget(fields, constraints, n, pad);

      default:
        return Container();
    }
  }

  Widget _buildLoadingStateWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorStateWidget() {
    return const Center(
      child: Text('Error'),
    );
  }

  Widget _buildLoadedStateWidget(
      List fields, BoxConstraints constraints, int n, double pad) {
    return constraints.maxWidth > 525
        ? Padding(
            padding: EdgeInsets.fromLTRB(52 + pad, 80, 52 + pad, 40),
            child: Column(
              children: [
                _buildInputFieldsContainer(fields, n),
                const SizedBox(height: 20.0),
                _buildAddNewStockButtonContainer(fields),
              ],
            ),
          )
        : SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          );
  }

  Widget _buildInputFieldsContainer(List fields, int n) {
    return Expanded(
      child: CustomContainer(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: fields.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: n > 0 ? n : 1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              mainAxisExtent: 95,
            ),
            itemBuilder: (context, index) {
              return CustomInputField(
                fields: fields,
                index: index,
                onSelected: (value) {
                  if (fields[index].field == "category" &&
                      fields[index].textValue != value) {
                    fields[index] = fields[index].copyWith(textValue: value);
                    _addNewStockBloc.add(CategorySelectedEvent(fields: fields));
                  } else {
                    fields[index] = fields[index].copyWith(textValue: value);
                    if (fields[index].field == 'sku' &&
                        fields[index].items.contains(value)) {
                      _addNewStockBloc.add(SkuSelectedEvent(fields: fields));
                    }
                  }
                },
                onChecked: () {
                  fields[index] =
                      fields[index].copyWith(locked: !fields[index].locked);
                  _addNewStockBloc.add(CheckBoxTapEvent(fields: fields));
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewStockButtonContainer(List fields) {
    return CustomContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 22.5,
        ),
        child: SizedBox(
          width: 390.5,
          child: CustomElevatedButton(
            text: "Add New Stock",
            onPressed: () async {
              _addNewStockBloc
                  .add(AddNewStockButtonClickedEvent(fields: fields));
            },
          ),
        ),
      ),
    );
  }
}
