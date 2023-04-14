import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/archive_cubit/search_cubit/search_cubit.dart';
import 'package:pinext/app/bloc/archive_cubit/user_statistics_cubit/user_statistics_cubit.dart';
import 'package:pinext/app/screens/home/widgets/transaction_list.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/handlers/file_handler.dart';
import 'package:pinext/app/shared/widgets/customYearPicker.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return const ArchiveMonthView();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArchiveCubit(),
        ),
        BlocProvider(
          create: (context) => ArchiveSearchCubit(),
        ),
        BlocProvider(
          create: (context) => UserStatisticsCubit(),
        ),
      ],
      child: const ArchiveMonthView(),
    );
  }
}

class ArchiveMonthView extends StatefulWidget {
  const ArchiveMonthView({super.key});

  @override
  State<ArchiveMonthView> createState() => _ArchiveMonthViewState();
}

class _ArchiveMonthViewState extends State<ArchiveMonthView> {
  String dateTimeNow = DateTime.now().toString();

  late ScrollController monthScrollController;

  @override
  void initState() {
    monthScrollController = ScrollController(initialScrollOffset: 40.0 * (int.parse(currentMonth) - 1));
    super.initState();
  }

  @override
  void dispose() {
    monthScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ArchiveSearchCubit>().resetState();
    context.read<UserStatisticsCubit>().resetState();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Animate(
                    effects: const [
                      SlideEffect(),
                      FadeEffect(),
                    ],
                    child: Text(
                      'Archives',
                      style: cursiveTextStyle.copyWith(
                        fontSize: 25,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  BlocBuilder<ArchiveCubit, ArchiveState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          final selectedMonth = '0${int.parse(state.selectedMonth)}'.length > 2
                              ? '0${int.parse(state.selectedMonth)}'.substring(1, 3)
                              : '0${int.parse(state.selectedMonth)}';
                          GetCustomSnackbar(
                            title: 'Generating Report',
                            message: 'Your report is being generated, please be patient! :)',
                            snackbarType: SnackbarType.info,
                            context: context,
                          );
                          FileHandler().createReportForMonth(
                            int.parse(
                              selectedMonth,
                            ),
                            context,
                            state.selectedYear,
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Generate report',
                              style: boldTextStyle.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Icon(
                              Icons.download,
                              size: 18,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      final selectedDate = DateTime.now();
                      showDialog(
                        context: context,
                        builder: (BuildContext builderContext) {
                          return AlertDialog(
                            title: Text(
                              'Please select a year to view records from that year.',
                              style: regularTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            content: SizedBox(
                              width: 300,
                              height: 300,
                              child: CustomYearPicker(
                                firstDate: DateTime(DateTime.now().year - 100),
                                lastDate: DateTime(DateTime.now().year),
                                initialDate: DateTime.now(),
                                selectedDate: selectedDate,
                                onChanged: (DateTime dateTime) {
                                  context.read<ArchiveCubit>().changeYear(dateTime.year.toString());
                                  context.read<UserStatisticsCubit>().resetState();

                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: BlocBuilder<ArchiveCubit, ArchiveState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.selectedYear,
                              style: boldTextStyle.copyWith(
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Icon(
                              Icons.edit_calendar_rounded,
                              color: primaryColor,
                              size: 25,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
        Material(
          elevation: 4,
          child: Container(
            color: whiteColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: monthScrollController,
              scrollDirection: Axis.horizontal,
              child: BlocBuilder<ArchiveCubit, ArchiveState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      ...List.generate(months.length, (index) {
                        final currentMonth = months[index];
                        return GestureDetector(
                          onTap: () {
                            context.read<ArchiveCubit>().changeMonth((index).toString());
                            context.read<UserStatisticsCubit>().noDataFound(true);
                            context.read<UserStatisticsCubit>().resetState();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: currentMonth == 'December' ? defaultPadding : 8),
                            child: state.selectedMonth.toString() == (index).toString()
                                ? Chip(
                                    label: Text(
                                      currentMonth,
                                      style: regularTextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: whiteColor,
                                      ),
                                    ),
                                    backgroundColor: primaryColor,
                                  )
                                : Chip(
                                    elevation: 0,
                                    label: Text(
                                      currentMonth,
                                      style: regularTextStyle.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: customBlackColor.withOpacity(.6),
                                      ),
                                    ),
                                    backgroundColor: greyColor,
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
        TransactionsList(),
      ],
    );
  }
}
