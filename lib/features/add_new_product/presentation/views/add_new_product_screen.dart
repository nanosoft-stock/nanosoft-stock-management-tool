import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/bloc/add_new_product_bloc.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/widgets/input_field_widget.dart';
import 'package:stock_management_tool/injection_container.dart';

class AddNewProductScreen extends StatelessWidget {
  AddNewProductScreen({super.key});

  final AddNewProductBloc _addNewProductBloc = sl.get<AddNewProductBloc>();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocConsumer<AddNewProductBloc, AddNewProductState>(
      bloc: _addNewProductBloc,
      listener: (context, state) {},
      builder: _blocBuilder,
    );
  }

  Widget _blocBuilder(context, state) {
    debugPrint("build: ${state.runtimeType}");
    switch (state.runtimeType) {
      case const (AddNewProductLoadingState):
        _addNewProductBloc.add(AddNewProductLoadedEvent());
        return _buildLoadingStateWidget();

      case const (AddNewProductErrorState):
        return _buildErrorStateWidget();

      case const (AddNewProductLoadedState):
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

  Widget _buildLoadedStateWidget(List<dynamic> fields) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int n = ((constraints.maxWidth - 135) / 338).floor();
        double pad = ((constraints.maxWidth - 135) % 338) / 2;
        return constraints.maxWidth > 475
            ? Padding(
                padding: EdgeInsets.fromLTRB(52 + pad, 80, 52 + pad, 40),
                child: Column(
                  children: [
                    _buildInputFieldsContainer(fields, n),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildAddNewProductButtonContainer(fields),
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
                    fields[index].textValue = value;
                    _addNewProductBloc.add(AddNewProductCategorySelectedEvent(fields: fields));
                  }
                  fields[index].textValue = value;
                  debugPrint("value: ${fields[index].field} $value");
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewProductButtonContainer(List<dynamic> fields) {
    return CustomContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 22.5,
        ),
        child: SizedBox(
          width: 338,
          child: CustomElevatedButton(
            text: "Add New Product",
            onPressed: () async {
              _addNewProductBloc.add(AddNewProductButtonClickedEvent(fields: fields));
            },
          ),
        ),
      ),
    );
  }
}
