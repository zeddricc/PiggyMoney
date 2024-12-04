import 'package:flutter/material.dart';
import 'package:piggymoney/core/theme/app_theme.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackPressed;

  const CustomHeader({
    Key? key,
    required this.title,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: onBackPressed,
          ),
          Expanded(
            child: Text(
              title,
              style: AppTheme.subheadingStyle.copyWith(color: Colors.black, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
} 