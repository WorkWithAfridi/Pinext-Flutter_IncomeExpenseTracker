import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

class ArchivePage extends StatelessWidget {
  ArchivePage({Key? key}) : super(key: key);

  List months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "November",
    "December",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                "Pinext",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
              const Text(
                "Archives",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: customBlackColor,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        Material(
          elevation: 4,
          child: Container(
            color: whiteColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  ...List.generate(months.length, (index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 20,
                          top: 5,
                          bottom: 5,
                        ),
                        child: Text(
                          months[index],
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: customBlackColor.withOpacity(.8),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Column(
              children: const [
                SizedBox(
                  height: 16,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: const [
                //     Text("Date"),
                //     Text("Description"),
                //     Text("Amount"),
                //   ],
                // )
              ],
            ),
          ),
        )
      ],
    );
  }
}
