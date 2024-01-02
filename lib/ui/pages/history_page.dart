import 'package:bin_packing_problem_resolver/cubit/cubits/history_cubit.dart';
import 'package:bin_packing_problem_resolver/cubit/states/history_state.dart';
import 'package:bin_packing_problem_resolver/helpers/page_opened_in_drawer.dart';
import 'package:bin_packing_problem_resolver/resources/app_colors.dart';
import 'package:bin_packing_problem_resolver/ui/cells/history_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget with PageOpenedInDrawerMixin {
  HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin {
  final cubit = HistoryCubit();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    widget.onPageOpenedInDrawer = onPageOpenedInDrawer;

    cubit.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.only(
          left: 50,
          right: 50,
          top: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Algorithms history",
                  style: TextStyle(
                    color: AppColors.labelColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            BlocBuilder<HistoryCubit, HistoryState>(
              bloc: cubit,
              builder: (context, state) {
                return state is LoadedDataHistoryState
                    ? Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 40,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: state.history.length,
                          itemBuilder: (context, index) {
                            return HistoryCell(
                              model: state.history[index],
                              index: state.history.length - index,
                            );
                          },
                        ),
                      )
                    : Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  void onPageOpenedInDrawer() {
    cubit.loadHistory();
  }
}
