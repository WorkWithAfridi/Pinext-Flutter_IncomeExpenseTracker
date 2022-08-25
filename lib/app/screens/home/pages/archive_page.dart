import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/archive_month_controller_cubit/archive_month_cubit.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchiveMonthCubit(),
      child: ArchiveMonthView(),
    );
  }
}

class ArchiveMonthView extends StatelessWidget {
  ArchiveMonthView({Key? key}) : super(key: key);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Archives",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: customBlackColor,
                    ),
                  ),
                  Text(
                    "2022",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: customBlackColor,
                    ),
                  ),
                ],
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
              child: BlocBuilder<ArchiveMonthCubit, ArchiveMonthState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      ...List.generate(months.length, (index) {
                        String currentMonth = months[index];
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<ArchiveMonthCubit>()
                                .changeMonth(currentMonth);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              right: 20,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Text(
                              currentMonth,
                              style: TextStyle(
                                fontWeight: state.selectedMonth == currentMonth
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                                color: state.selectedMonth == currentMonth
                                    ? customBlackColor
                                    : customBlackColor.withOpacity(.4),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  ListView.builder(
                    itemCount: months.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ${months[index]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: customBlackColor,
                              ),
                            ),
                            ListView.builder(
                              itemCount: 6,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context, index) {
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "12/12/12",
                                          style: TextStyle(
                                            color: customBlackColor
                                                .withOpacity(.80),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 32,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Bought something off Ryans Shantinager Branch",
                                            style: TextStyle(
                                              color: customBlackColor
                                                  .withOpacity(.80),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "- 120000Tk",
                                            style: TextStyle(
                                              color: customBlackColor
                                                  .withOpacity(.80),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 1,
                                      width: getWidth(context),
                                      color: customBlackColor.withOpacity(.05),
                                    )
                                  ],
                                );
                              }),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
