import 'package:flutter/material.dart';
import 'package:piggymoney/core/theme/app_theme.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackPressed;
  final bool isBackButtonVisible;
  final Widget? trailing;

  const CustomHeader({
    Key? key,
    required this.title,
    required this.onBackPressed,
    this.isBackButtonVisible = true,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isBackButtonVisible ? 0 : 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isBackButtonVisible)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBackPressed,
            ),
          Expanded(
            child: Text(
              title,
              style: AppTheme.subheadingStyle.copyWith(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: isBackButtonVisible ? TextAlign.left : TextAlign.center,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
} 