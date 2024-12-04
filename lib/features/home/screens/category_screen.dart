import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggymoney/models/sample_data.dart';
import 'package:piggymoney/widgets/custom_header.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'Add Transaction',
              onBackPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sampleCategories.length,
                itemBuilder: (context, index) {
                  final category = sampleCategories[index];
                  return ExpansionTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: category.color.withOpacity(
                            0.2), // Use category color with opacity
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(category.icon,
                          size: 24, color: category.color), // Icon color
                    ),
                    title: Text(category.name,
                        style: const TextStyle(fontSize: 18)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // Number of columns
                            childAspectRatio: 0.8, // Aspect ratio for each item
                            crossAxisSpacing: 8, // Reduced spacing
                            mainAxisSpacing: 8, // Reduced spacing
                          ),
                          itemCount: category.subcategories.length,
                          itemBuilder: (context, subIndex) {
                            final subcategory =
                                category.subcategories[subIndex];
                            return GestureDetector(
                              onTap: () {
                                // Navigate back with the selected category and subcategory
                                Navigator.pop(context, {
                                  'category': category.name,
                                  'subcategory': subcategory.name,
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: subcategory.color.withOpacity(
                                          0.2), // Background color for the subcategory icon
                                    ),
                                    padding: const EdgeInsets.all(
                                        12.0), // Reduced padding
                                    child: Icon(subcategory.icon,
                                        size: 24,
                                        color: subcategory.color), // Icon color
                                  ),
                                  const SizedBox(
                                      height:
                                          4), // Reduced space between icon and text
                                  Text(
                                    subcategory.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12), // Smaller font size
                                    overflow: TextOverflow
                                        .ellipsis, // Prevent overflow
                                    maxLines: 1, // Limit to one line
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
