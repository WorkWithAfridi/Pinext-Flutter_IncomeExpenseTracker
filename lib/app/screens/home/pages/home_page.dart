import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/theme_data/colors.dart';
import '../../../bloc/homepage_cubit/homepage_cubit.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomepageCubit(),
        ),
      ],
      child: HomepageView(),
    );
  }
}

class HomepageView extends StatelessWidget {
  HomepageView({
    Key? key,
  }) : super(key: key);

  final List homepageFilters = [
    'Overview',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly'
  ];

  Map<String, double> demoData = {
    "Office fare": 50,
    "Lunch": 150,
    "Snacks": 100,
    "Hangout": 80,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getHeight(context),
      width: getWidth(context),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
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
                    "Good morning,",
                    style: regularTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.6),
                    ),
                  ),
                  Text(
                    "Khondakar Afridi",
                    style: boldTextStyle.copyWith(
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    BlocBuilder<HomepageCubit, HomepageState>(
                      builder: (context, state) {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: homepageFilters.length,
                          itemBuilder: ((context, index) {
                            return MenuFilterPill(
                              filtertitle: homepageFilters[index],
                              selectedFilter: state.selectedFilter,
                            );
                          }),
                        );
                      },
                    ),
                    const SizedBox(
                      width: defaultPadding - 10,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Your Cards",
                    style: boldTextStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 185,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: ((context, index) {
                        return const PinextCard();
                      }),
                    ),
                    const SizedBox(
                      width: defaultPadding - 10,
                    ),
                  ],
                ),
              ),
            ),
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
                    "Expenses",
                    style: boldTextStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(
                            defaultPadding,
                          ),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              defaultBorder,
                            ),
                            color: customBlackColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  "- 1200Tk",
                                  style: boldTextStyle.copyWith(
                                    fontSize: 25,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                              Text(
                                "Today",
                                style: boldTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: whiteColor.withOpacity(.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(
                            defaultPadding,
                          ),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              defaultBorder,
                            ),
                            color: customBlueColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  "- 27000Tk",
                                  style: boldTextStyle.copyWith(
                                    fontSize: 25,
                                    color: whiteColor.withOpacity(.8),
                                  ),
                                ),
                              ),
                              Text(
                                "This week",
                                style: boldTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.all(
                      defaultPadding,
                    ),
                    width: getWidth(context),
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(
                        defaultBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's overview",
                          style: boldTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: customBlackColor.withOpacity(.4),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        PieChart(
                          dataMap: demoData,
                          animationDuration: const Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 2,
                          colorList: const [
                            cyanColor,
                            customBlackColor,
                            customBlueColor,
                          ],
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 40,
                          centerText: "Today",
                          legendOptions: const LegendOptions(
                            showLegends: false,
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        ListView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                      color: cyanColor,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Snacks",
                                        style: boldTextStyle.copyWith(
                                          fontSize: 14,
                                          color:
                                              customBlackColor.withOpacity(.8),
                                        ),
                                      ),
                                      Text(
                                        "Amount: 100Tk",
                                        style: regularTextStyle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color:
                                              customBlackColor.withOpacity(.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Top Transactions in August",
                    style: boldTextStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                      style: regularTextStyle.copyWith(
                                        color:
                                            customBlackColor.withOpacity(.80),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 32,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Bought something off Ryans Shantinager Branch",
                                        style: regularTextStyle.copyWith(
                                          color:
                                              customBlackColor.withOpacity(.80),
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
                                        style: boldTextStyle.copyWith(
                                          color:
                                              customBlackColor.withOpacity(.80),
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
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MenuFilterPill extends StatelessWidget {
  MenuFilterPill({
    Key? key,
    required this.filtertitle,
    required this.selectedFilter,
  }) : super(key: key);

  String filtertitle;
  String selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          context.read<HomepageCubit>().changeMenuFilter(
                filtertitle,
              );
        },
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            // vertical: 10,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selectedFilter == filtertitle ? customBlueColor : greyColor,
            borderRadius: BorderRadius.circular(
              defaultBorder,
            ),
          ),
          child: Text(
            filtertitle,
            style: boldTextStyle.copyWith(
              color: selectedFilter == filtertitle
                  ? whiteColor
                  : customBlackColor.withOpacity(.4),
            ),
          ),
        ),
      ),
    );
  }
}

class PinextCard extends StatelessWidget {
  const PinextCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.all(
          15,
        ),
        height: 180,
        width: getWidth(context) * .8,
        decoration: BoxDecoration(
          color: customBlueColor,
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Bkash",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: whiteColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current balance",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: whiteColor.withOpacity(.4),
                      ),
                    ),
                    const Text(
                      "67000Tk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: whiteColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last transaction",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                      color: whiteColor.withOpacity(.4),
                    ),
                  ),
                  const Text(
                    "12/12/12",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
