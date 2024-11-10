import 'package:flutter/material.dart';
import 'package:pro/pages/efficiency_graph.dart';

class CategoriesSection extends StatelessWidget {
  final Function(String) onCategoryTap;

  const CategoriesSection({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Open',
      'Pending',
      'In Progress',
      'Completed',
      'Efficiency',
    ];

    final icons = [
      Icons.open_in_new,
      Icons.pending,
      Icons.work,
      Icons.check_circle,
      Icons.analytics,
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (categories[index] == 'Efficiency') {
                List<int> efficiencyData = calculateEfficiencyData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EfficiencyGraphPage(efficiencyData: efficiencyData),
                  ),
                );
              } else {
                onCategoryTap(categories[index]);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                child: Container(
                  width: 100,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        categories[index],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<int> calculateEfficiencyData() {
    return [70, 80, 90, 85, 95];
  }
}
