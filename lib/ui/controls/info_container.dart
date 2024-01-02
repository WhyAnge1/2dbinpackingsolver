import 'package:bin_packing_problem_resolver/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoContainer extends StatelessWidget {
  final String title;
  final String data;
  final IconData icon;

  const InfoContainer({
    required this.icon,
    required this.title,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.backgroundColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: AppColors.backgroundColor,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: AppColors.labelGrayTitleColor,
                      fontSize: 15,
                    ),
                  ),
                  Tooltip(
                    message: data,
                    child: Text(
                      data,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.labelColor,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
