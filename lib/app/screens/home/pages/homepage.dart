import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/bloc/homepage_filter_cubit/homepage_filter_cubit.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/theme_data/colors.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomepageFilterCubit(),
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getHeight(context),
      width: getWidth(context),
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
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: customBlackColor.withOpacity(.6),
                  ),
                ),
                const Text(
                  "Khondakar Afridi",
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
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  BlocBuilder<HomepageFilterCubit, HomepageFilterState>(
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
              children: const [
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Your Cards",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: customBlackColor,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 185,
            child: SingleChildScrollView(
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
        ],
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
          context.read<HomepageFilterCubit>().changeMenuFilter(
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
            style: TextStyle(
              color:
                  selectedFilter == filtertitle ? whiteColor : customBlackColor,
              fontWeight: FontWeight.bold,
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
        height: 180,
        width: getWidth(context) * .8,
        decoration: BoxDecoration(
          color: customBlackColor,
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
      ),
    );
  }
}
