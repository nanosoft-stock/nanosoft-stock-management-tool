import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/components/custom_dropdown_input_field.dart';
import 'package:stock_management_tool/core/components/custom_elevated_button.dart';
import 'package:stock_management_tool/core/components/custom_text_input_field.dart';
import 'package:stock_management_tool/features/print_id/presentation/bloc/print_id_bloc.dart';
import 'package:stock_management_tool/injection_container.dart';

class PrintIdView extends StatelessWidget {
  PrintIdView({super.key});

  final PrintIdBloc _printIdBloc = sl.get<PrintIdBloc>();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocConsumer<PrintIdBloc, PrintIdState>(
      bloc: _printIdBloc,
      listenWhen: (prev, next) => next is PrintIdActionState,
      buildWhen: (prev, next) => next is! PrintIdActionState,
      listener: (BuildContext context, PrintIdState state) {
        _blocListener(context, state);
      },
      builder: (BuildContext context, PrintIdState state) {
        return _blocBuilder(context, state);
      },
    );
  }

  void _blocListener(BuildContext context, PrintIdState state) {}

  Widget _blocBuilder(BuildContext context, PrintIdState state) {
    switch (state.runtimeType) {
      case const (LoadingState):
        _printIdBloc.add((LoadedEvent()));
        return _buildLoadingStateWidget();

      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (LoadedState):
        Map<String, dynamic> printIdData = state.printIdData!;
        return _buildLoadedStateWidget(printIdData);

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

  Widget _buildLoadedStateWidget(Map<String, dynamic> printIdData) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(52, 57, 52, 40),
          child: Column(
            children: [
              CustomContainer(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomDropdownInputField(
                          text: "Print Id",
                          controller: TextEditingController(
                              text: printIdData["printable_id"]),
                          items: printIdData["printable_ids"],
                          requestFocusOnTap: false,
                          onSelected: (value) {
                            _printIdBloc.add(PrintIdSelectedEvent(
                                printableId: value,
                                printIdData: printIdData));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextInputField(
                          text: "Count",
                          controller: TextEditingController(
                              text: printIdData["print_count"]),
                          onSelected: (value) {
                            _printIdBloc.add(PrintCountChangedEvent(
                                printCount: value, printIdData: printIdData));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 322.5,
                          child: CustomElevatedButton(
                            onPressed: () {
                              _printIdBloc.add(PrintPressedEvent(
                                  printIdData: printIdData));
                            },
                            text: "Print",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
