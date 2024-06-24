import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/components/custom_elevated_button.dart';
import 'package:stock_management_tool/core/components/custom_snack_bar.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/bloc/add_new_stock_bloc.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/widgets/custom_input_field.dart';

class AddNewStockView extends StatelessWidget {
  AddNewStockView({super.key});

  final AddNewStockBloc _addNewStockBloc = sl.get<AddNewStockBloc>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double pad = ((constraints.maxWidth - 135) % 390.5) / 2;

        return BlocConsumer<AddNewStockBloc, AddNewStockState>(
          bloc: _addNewStockBloc,
          listenWhen: (prev, next) => next is AddNewStockActionState,
          buildWhen: (prev, next) => next is! AddNewStockActionState,
          listener: (context, state) {
            _blocListener(context, state, constraints, pad);
          },
          builder: (BuildContext context, AddNewStockState state) {
            return _blocBuilder(context, state, constraints, pad);
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
      BoxConstraints constraints, double pad) {
    switch (state.runtimeType) {
      case const (LoadingState):
        _addNewStockBloc.add(CloudDataChangeEvent(
          onChange: (fields) {
            _addNewStockBloc.add(LoadedEvent(fields: fields));
          },
        ));

        return _buildLoadingStateWidget();

      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (LoadedState):
        List fields = state.fields!;
        return _buildLoadedStateWidget(fields, constraints, pad);

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

  Widget _buildLoadedStateWidget(
      List fields, BoxConstraints constraints, double pad) {
    return constraints.maxWidth > 525
        ? Padding(
            padding: EdgeInsets.fromLTRB(52 + pad, 80, 52 + pad, 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: constraints.maxWidth - 104,
                      child: _buildInputFieldsContainer(fields),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _buildAddNewStockButtonContainer(fields),
                ],
              ),
            ),
          )
        : SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          );
  }

  Widget _buildInputFieldsContainer(List fields) {
    return CustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            verticalDirection: VerticalDirection.down,
            children: [
              for (int index = 0; index < fields.length; index++)
                CustomInputField(
                  field: fields[index],
                  onSelected: (field, value) {
                    if (["category", "sku", "container id"]
                        .contains(fields[index]["field"])) {
                      _addNewStockBloc.add(ValueSelectedEvent(
                          field: field, value: value, fields: fields));
                    } else {
                      _addNewStockBloc.add(ValueTypedEvent(
                          field: field, value: value, fields: fields));
                    }
                  },
                  onChecked: (field, value) {
                    _addNewStockBloc.add(CheckBoxTapEvent(
                        field: field, value: value, fields: fields));
                  },
                ),
            ],
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
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _addNewStockBloc
                    .add(AddNewStockButtonClickedEvent(fields: fields));
              }
            },
          ),
        ),
      ),
    );
  }
}
