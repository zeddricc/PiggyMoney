import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggymoney/data/category_data.dart';
import 'package:piggymoney/widgets/custom_header.dart';

class CategoryScreen extends ConsumerWidget {
  final String transactionType;

  const CategoryScreen({super.key, required this.transactionType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'Select Category',
              onBackPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sampleCategories.length,
                itemBuilder: (context, index) {
                  final category = sampleCategories[index];
                  if ((transactionType == 'EXPENSES' && category.name == 'Expenses') ||
                      (transactionType == 'INCOME' && category.name == 'Income')) {
                    return ExpansionTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: category.color.withOpacity(0.2),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(category.icon, size: 24, color: category.color),
                      ),
                      title: Text(category.name, style: const TextStyle(fontSize: 18)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: category.subcategories.length,
                            itemBuilder: (context, subIndex) {
                              final subcategory = category.subcategories[subIndex];
                              return GestureDetector(
                                onTap: () {
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
                                        color: subcategory.color.withOpacity(0.2),
                                      ),
                                      padding: const EdgeInsets.all(12.0),
                                      child: Icon(subcategory.icon, size: 24, color: subcategory.color),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      subcategory.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
