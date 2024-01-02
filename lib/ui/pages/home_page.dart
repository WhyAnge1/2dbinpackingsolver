import 'package:bin_packing_problem_resolver/helpers/page_opened_in_drawer.dart';
import 'package:bin_packing_problem_resolver/models/view_entity/selectable_page_item_view_entity.dart';
import 'package:bin_packing_problem_resolver/ui/cells/selectable_page_cell.dart';
import 'package:bin_packing_problem_resolver/ui/pages/ant_colony_page.dart';
import 'package:bin_packing_problem_resolver/ui/pages/configuration_page.dart';
import 'package:bin_packing_problem_resolver/ui/pages/hill_climbing_page.dart';
import 'package:bin_packing_problem_resolver/ui/pages/history_page.dart';
import 'package:bin_packing_problem_resolver/ui/pages/simulated_annealing_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();
  final pageItems = [
    SelectablePageItemViewEntity(
        title: "Hill climbing",
        icon: MdiIcons.chartLineVariant,
        page: const HillClimbingPage()),
    SelectablePageItemViewEntity(
        title: "Simulated annealing",
        icon: MdiIcons.fireAlert,
        page: const SimulatedAnnealingPage()),
    SelectablePageItemViewEntity(
        title: "Ant colony",
        icon: MdiIcons.swapHorizontalVariant,
        page: const AntColonyPage()),
    SelectablePageItemViewEntity(
        title: "History", icon: MdiIcons.history, page: HistoryPage()),
    SelectablePageItemViewEntity(
        title: "Configuration",
        icon: MdiIcons.cog,
        page: const ConfigurationPage()),
  ];

  @override
  void initState() {
    pageItems.first.isSelected = true;
    pageItems.last.onTap = _onPageItemTapped;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15.0),
        color: Color.fromARGB(255, 34, 33, 43),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      size: 40,
                      MdiIcons.packageVariantClosedCheck,
                      color: Color.fromARGB(255, 125, 121, 171),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pageItems.length - 1,
                      itemBuilder: (context, index) {
                        var viewEntity = pageItems[index];
                        viewEntity.onTap = _onPageItemTapped;

                        return SelectablePageCell(
                          viewEntity: viewEntity,
                        );
                      },
                    ),
                  ),
                  SelectablePageCell(viewEntity: pageItems.last),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 244, 244, 245),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: pageItems.map((e) => e.page).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPageItemTapped(SelectablePageItemViewEntity tappedItem) {
    setState(() {
      for (var item in pageItems) {
        item.isSelected = false;
      }
      tappedItem.isSelected = true;
      pageController.jumpToPage(pageItems.indexOf(tappedItem));

      if (tappedItem.page is PageOpenedInDrawerMixin) {
        var pageWithMixin = tappedItem.page as PageOpenedInDrawerMixin;

        if (pageWithMixin.onPageOpenedInDrawer != null) {
          pageWithMixin.onPageOpenedInDrawer?.call();
        }
      }
    });
  }
}
