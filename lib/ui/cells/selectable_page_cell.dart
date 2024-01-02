import 'package:bin_packing_problem_resolver/models/view_entity/selectable_page_item_view_entity.dart';
import 'package:flutter/material.dart';

class SelectablePageCell extends StatelessWidget {
  final SelectablePageItemViewEntity viewEntity;

  const SelectablePageCell({super.key, required this.viewEntity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewEntity.onTap?.call(viewEntity),
      child: Container(
        decoration: viewEntity.isSelected
            ? const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 50, 48, 67),
                    Color.fromARGB(255, 34, 33, 43),
                    Color.fromARGB(255, 34, 33, 43),
                    Color.fromARGB(255, 34, 33, 43),
                  ],
                ),
              )
            : const BoxDecoration(color: Colors.transparent),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Row(
          children: [
            Icon(
              viewEntity.icon,
              size: 15,
              color: Color.fromARGB(
                  viewEntity.isSelected ? 255 : 155, 236, 236, 241),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                viewEntity.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color.fromARGB(
                      viewEntity.isSelected ? 255 : 155, 236, 236, 241),
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
