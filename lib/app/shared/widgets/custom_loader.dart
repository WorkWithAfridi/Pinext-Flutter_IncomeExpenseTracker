import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader({
    required this.title,
    this.isGuest = false,
    super.key,
  });
  final String title;
  final bool isGuest;

  @override
  _CustomLoader createState() => _CustomLoader();
}

class _CustomLoader extends State<CustomLoader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.1),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 26,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          width: MediaQuery.of(context).size.width * .6,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      customBlackColor,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: customBlackColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
