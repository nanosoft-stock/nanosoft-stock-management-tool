import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/core/components/custom_autocomplete_text_input_field.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/components/custom_elevated_button.dart';
import 'package:stock_management_tool/core/components/custom_text_input_field.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/print_id/presentation/bloc/print_id_bloc.dart';

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
          child: constraints.maxWidth > 467.0
              ? Column(
                  children: [
                    CustomContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomAutocompleteTextInputField(
                                  text: "Print Id",
                                  initialValue: printIdData["print_id"],
                                  items: printIdData["printable_ids"],
                                  validator: (_) => "",
                                  onSelected: (value) {
                                    _printIdBloc.add(PrintIdSelectedEvent(
                                      printId: value,
                                    ));
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomTextInputField(
                                  text: "Count",
                                  initialValue: printIdData["print_count"],
                                  validator: (_) => "",
                                  onSelected: (value) {
                                    _printIdBloc.add(PrintCountChangedEvent(
                                      printCount: value,
                                    ));
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  width: 322.5,
                                  child: CustomElevatedButton(
                                    onPressed: () {
                                      _printIdBloc
                                          .add(const PrintPressedEvent());
                                    },
                                    text: "Print",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
        );
      },
    );
  }
}
