import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

class GetHorizontalBar extends StatelessWidget {
  const GetHorizontalBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: customBlackColor.withOpacity(.2),
        ),
      ),
    );
  }
}
