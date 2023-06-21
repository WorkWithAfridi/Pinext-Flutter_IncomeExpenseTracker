import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/app_settings_screen.dart';
import 'package:pinext/app/screens/home/pages/archive_page.dart';
import 'package:pinext/app/screens/home/pages/budget_page.dart';
import 'package:pinext/app/screens/home/pages/cards_and_balance_page.dart';
import 'package:pinext/app/screens/home/pages/home_page.dart';
import 'package:pinext/app/screens/home/widgets/get_bottom_navigation_bar.dart';
import 'package:pinext/app/services/handlers/app_handler.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';

class Homeframe extends StatefulWidget {
  const Homeframe({super.key});

  @override
  State<Homeframe> createState() => _HomeframeState();
}

class _HomeframeState extends State<Homeframe> {
  @override
  void initState() {
    super.initState();
    CardHandler().getUserCards();

    context.read<ArchiveCubit>().getCurrentMonthTransactionArchive(context);
    if (Platform.isAndroid) {
      // showNotification();
    }
  }

  Future<void> showIntroductions() async {
    final isFirstBoot = await AppHandler().checkIfFirstBoot();
    if (isFirstBoot) {
      await triggerIntroduction();
    }
  }

  Future<void> triggerIntroduction() async {
    await Future.delayed(const Duration(seconds: 1)).then((_) {
      Intro.of(context).start();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeframeCubit(),
        ),
      ],
      child: HomeframeView(),
    );
  }
}

List homeframePages = [const Homepage(), const ArchivePage(), const BudgetPage(), const CardsAndBalancePage(), const AppSettingsScreen()];

class HomeframeView extends StatelessWidget {
  HomeframeView({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Builder(
          builder: (context) {
            final demoBlocState = context.watch<DemoBloc>().state;
            return Text(
              demoBlocState is DemoEnabledState ? 'PINEXT : DEMO-MODE' : 'PINEXT',
              style: regularTextStyle.copyWith(
                fontSize: 16,
              ),
            );
          },
        ),
      ),
      // drawer: const PinextDrawer(),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<HomeframeCubit, HomeframeState>(
              builder: (context, state) {
                return PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: homeframePages.length,
                  controller: state.pageController,
                  onPageChanged: (value) {
                    context.read<HomeframeCubit>().updateHomeframePage(value);
                  },
                  itemBuilder: (context, index) => homeframePages[index] as Widget,
                );
              },
            ),
          ),
          const GetBottomNavigationBar(),
        ],
      ),
    );
  }
}
