import 'package:flutter/material.dart';
import 'package:medgis_app/page/widgets/button_section.dart';
import 'package:medgis_app/page/widgets/data_visualization_section.dart';
import 'package:medgis_app/page/widgets/table_section.dart';
import 'package:medgis_app/utils/theme/color_scheme.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PageAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return AppBar(
      leadingWidth: screenSize.width * 0.4,
      leading: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(left: 25),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(150),
              ),
              child: Image.asset(
                'assets/medgis.jpg',
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 25, right: 25),
              margin: const EdgeInsets.only(left: 25),
              decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(150))),
              child: Row(
                children: [
                  Text(
                    "MedRec App",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "by MedGIS",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 25),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              color: colorScheme.surface),
          child: IconButton(
              onPressed: () => _informationDialog(context),
              icon: Icon(
                Icons.auto_awesome_motion_rounded,
                color: colorScheme.primary,
              )),
        )
      ],
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _informationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_motion_rounded,
                  color: colorScheme.primary,
                ),
                const SizedBox(
                  width: 25,
                ),
                Text(
                  "Component Documentation",
                  style: Theme.of(context).textTheme.headlineMedium,
                )
              ],
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close_rounded, color: Colors.red))
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.width * 0.7,
          child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                TableSection(),
                ButtonSection(),
                DataVisualizationSection()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
