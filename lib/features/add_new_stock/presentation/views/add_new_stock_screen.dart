import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/bloc/add_new_stock_bloc.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/widgets/input_field_widget.dart';
import 'package:stock_management_tool/injection_container.dart';

class AddNewStockScreen extends StatelessWidget {
  AddNewStockScreen({super.key});

  final AddNewStockBloc _addNewStockBloc = sl.get<AddNewStockBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNewStockBloc, AddNewStockState>(
      bloc: _addNewStockBloc,
      listenWhen: (prev, next) => next is AddNewStockActionState,
      buildWhen: (prev, next) => next is! AddNewStockActionState,
      listener: (context, state) {
        print("listen ${state.runtimeType}");
        // var banner = MaterialBanner(
        //   content: Text("Success"),
        //   actions: [Container()],
        //   elevation: 5,
        //   margin: EdgeInsets.fromLTRB(450, 20, 200, 20),
        // );
        // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        // ScaffoldMessenger.of(context).showMaterialBanner(banner);
      },
      builder: _blocBuilder,
    );
  }

  Widget _blocBuilder(context, state) {
    debugPrint("build: ${state.runtimeType}");
    switch (state.runtimeType) {
      case const (AddNewStockLoadingState):
        _addNewStockBloc.add(AddNewStockLoadedEvent());
        return _buildLoadingStateWidget();

      case const (AddNewStockErrorState):
        return _buildErrorStateWidget();

      case const (AddNewStockLoadedState):
        List fields = state.fields!;
        return _buildLoadedStateWidget(fields);

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

  Widget _buildLoadedStateWidget(List fields) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int n = ((constraints.maxWidth - 135) / 390.5).floor();
        double pad = ((constraints.maxWidth - 135) % 390.5) / 2;
        return constraints.maxWidth > 525
            ? Padding(
                padding: EdgeInsets.fromLTRB(52 + pad, 80, 52 + pad, 40),
                child: Column(
                  children: [
                    _buildInputFieldsContainer(fields, n),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildAddNewStockButtonContainer(fields),
                  ],
                ),
              )
            : SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              );
      },
    );
  }

  Widget _buildInputFieldsContainer(List<dynamic> fields, int n) {
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
              return InputFieldWidget(
                fields: fields,
                index: index,
                onSelected: (value) {
                  if (fields[index].field == "category" && fields[index].textValue != value) {
                    fields[index] = fields[index].copyWith(textValue: value);
                    _addNewStockBloc.add(AddNewStockCategorySelectedEvent(fields: fields));
                  } else {
                    fields[index] = fields[index].copyWith(textValue: value);
                    if (fields[index].field == 'sku' && fields[index].items.contains(value)) {
                      _addNewStockBloc.add(AddNewStockSkuSelectedEvent(fields: fields));
                    }
                  }
                },
                onChecked: () {
                  fields[index] = fields[index].copyWith(locked: !fields[index].locked);
                  _addNewStockBloc.add(AddNewStockCheckBoxTapEvent(fields: fields));
                },
              );
            },
          ),
        ),
      ),
    );
  }

  CustomContainer _buildAddNewStockButtonContainer(List<dynamic> fields) {
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
              _addNewStockBloc.add(AddNewStockButtonClickedEvent(fields: fields));
            },
          ),
        ),
      ),
    );
  }
}
