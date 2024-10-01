import 'package:flutter/material.dart';

class ButtonSectionDescription extends StatelessWidget {
  const ButtonSectionDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "label": "1.",
        "widget": SizedBox(
          width: 150,
          child: TextButton(
            onPressed: () {},
            child: const Row(
              children: [
                Icon(Icons.add_rounded),
                SizedBox(width: 5),
                Text("Add Patient"),
              ],
            ),
          ),
        ),
      },
      {
        "label": "2.",
        "widget": SizedBox(
          width: 150,
          child: TextButton(
            onPressed: () {},
            child: const Row(
              children: [
                Icon(Icons.add_rounded),
                SizedBox(width: 5),
                Text("Add Record"),
              ],
            ),
          ),
        ),
      },
      {"label": "3.", "icon": Icons.edit_rounded},
      {"label": "4.", "icon": Icons.info_outline_rounded},
      {"label": "5.", "icon": Icons.arrow_back_rounded},
      {
        "label": "6.",
        "icon": Icons.download_rounded,
      },
      {"label": "7.", "icon": Icons.delete_rounded, "color": Colors.red},
      {"label": "8.", "icon": Icons.close_rounded, "color": Colors.red},
    ];

    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.map((item) {
              if (item.containsKey("widget")) {
                return ReusableRowItem(
                  label: item['label'],
                  button: item['widget'],
                );
              } else {
                return ReusableIconButton(
                  label: item['label'],
                  icon: item['icon'],
                  color: item.containsKey('color') ? item['color'] : null,
                );
              }
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class ReusableRowItem extends StatelessWidget {
  final String label;
  final Widget button;

  const ReusableRowItem({
    super.key,
    required this.label,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        button,
      ],
    );
  }
}

class ReusableIconButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;

  const ReusableIconButton({
    super.key,
    required this.label,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        IconButton(
          onPressed: () {},
          icon: Icon(icon, color: color),
        ),
      ],
    );
  }
}
