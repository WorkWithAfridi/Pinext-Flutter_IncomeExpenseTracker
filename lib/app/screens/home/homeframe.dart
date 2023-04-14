import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:pinext/app/app_data/app_constants/app_labels.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/app_settings_screen.dart';
import 'package:pinext/app/screens/home/pages/archive_page.dart';
import 'package:pinext/app/screens/home/pages/budget_page.dart';
import 'package:pinext/app/screens/home/pages/budget_pages/add_subscription_page.dart';
import 'package:pinext/app/screens/home/pages/cards_and_balance_page.dart';
import 'package:pinext/app/screens/home/pages/home_page.dart';
import 'package:pinext/app/screens/home/widgets/app_drawer.dart';
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

checkIfOldUser() {}

class HomeframeView extends StatelessWidget {
  HomeframeView({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeframeCubit, HomeframeState>(
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: IntroStepBuilder(
                order: 6,
                text: intro_label_six,
                builder: (context, introkey) {
                  return const Icon(
                    Icons.menu,
                    color: customBlackColor,
                  );
                },
              ),
            ),
            centerTitle: true,
            title: Builder(
              builder: (context) {
                final demoBlocState = context.watch<DemoBloc>().state;
                return Text(
                  demoBlocState is DemoEnabledState ? 'PINEXT : DEMO-MODE' : 'PINEXT',
                  style: regularTextStyle.copyWith(
                    fontSize: 20,
                  ),
                );
              },
            ),
          ),
          drawer: const PinextDrawer(),
          body: PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: homeframePages.length,
            controller: state.pageController,
            onPageChanged: (value) {
              context.read<HomeframeCubit>().updateHomeframePage(value);
            },
            itemBuilder: (context, index) => homeframePages[index] as Widget,
          ),
          floatingActionButton: state.selectedIndex == 0 || state.selectedIndex == 2
              ? IntroStepBuilder(
                  order: 1,
                  text: intro_label_one,
                  builder: (context, introkey) {
                    return FloatingActionButton(
                      onPressed: () {
                        if (state.selectedIndex == 0) {
                          context.read<HomeframeCubit>().openAddTransactionsPage(context);
                        } else if (state.selectedIndex == 2) {
                          Navigator.push(
                            context,
                            CustomTransitionPageRoute(
                              childWidget: AddSubscriptionPage(),
                            ),
                          );
                        }
                      },
                      backgroundColor: customBlackColor,
                      child: const Icon(
                        Icons.add,
                        color: whiteColor,
                        size: 18,
                      ),
                    );
                  },
                )
              : state.selectedIndex == 4
                  ? FloatingActionButton(
                      onPressed: () {
                        context.read<HomeframeCubit>().showAboutDialog(context);
                      },
                      backgroundColor: customBlackColor,
                      child: Text(
                        '?',
                        style: boldTextStyle.copyWith(
                          color: whiteColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
          floatingActionButtonLocation: state.selectedIndex != 4 ? FloatingActionButtonLocation.miniEndTop : FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: BottomNavigationBar(
            key: key,
            currentIndex: state.selectedIndex,
            onTap: (value) {
              context.read<HomeframeCubit>().changeHomeframePage(value);
            },
            selectedItemColor: customBlackColor,
            unselectedItemColor: customBlackColor.withOpacity(.4),
            type: BottomNavigationBarType.fixed,
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            selectedLabelStyle: regularTextStyle.copyWith(fontSize: 12),
            unselectedLabelStyle: regularTextStyle.copyWith(fontSize: 10),
            items: [
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                  order: 2,
                  text: intro_label_two,
                  builder: (context, introkey) {
                    return Icon(
                      AntIcons.homeOutlined,
                      size: state.selectedIndex == 0 ? 20 : 16,
                    );
                  },
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                  order: 3,
                  text: intro_label_three,
                  builder: (context, introkey) {
                    return Icon(
                      AntIcons.databaseOutlined,
                      size: state.selectedIndex == 1 ? 20 : 16,
                    );
                  },
                ),
                label: 'Archive',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  AntIcons.dollarCircleOutlined,
                  size: state.selectedIndex == 2 ? 20 : 16,
                ),
                label: 'Budget',
              ),
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                  order: 4,
                  text: intro_label_four,
                  builder: (context, introkey) {
                    return Icon(
                      AntIcons.walletOutlined,
                      size: state.selectedIndex == 3 ? 20 : 16,
                    );
                  },
                ),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                  order: 5,
                  text: intro_label_five,
                  builder: (context, introkey) {
                    return Icon(
                      AntIcons.appstoreOutlined,
                      size: state.selectedIndex == 4 ? 20 : 16,
                    );
                  },
                ),
                label: 'More',
              ),
            ],
          ),
        );
      },
    );
  }
}
