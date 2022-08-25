import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/homeframe_page_controller_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/screens/home/pages/archive_page.dart';
import 'package:pinext/app/screens/home/pages/cards_and_balance_page.dart';
import 'package:pinext/app/screens/home/pages/home_page.dart';

class Homeframe extends StatelessWidget {
  const Homeframe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeframePageCubit(),
        )
      ],
      child: HomeframeView(),
    );
  }
}

List homeframePages = [
  const Homepage(),
  ArchivePage(),
  CardsAndBalancePage(),
  const Center(
    child: Text("profile"),
  ),
];

class HomeframeView extends StatelessWidget {
  HomeframeView({Key? key}) : super(key: key);
  final homeframePageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: customBlueColor,
          ),
        ),
      ),
      body: BlocBuilder<HomeframePageCubit, HomeframePageState>(
        builder: (context, state) {
          return PageView.builder(
            itemCount: homeframePages.length,
            controller: state.pageController,
            onPageChanged: ((value) {
              context.read<HomeframePageCubit>().changeHomeframePage(value);
            }),
            itemBuilder: ((context, index) => homeframePages[index]),
          );
        },
      ),
      floatingActionButton: BlocBuilder<HomeframePageCubit, HomeframePageState>(
        builder: (context, state) {
          return state.selectedIndex == 0
              ? FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: customBlackColor,
                  child: const Icon(
                    Icons.add,
                    color: whiteColor,
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      bottomNavigationBar: BlocBuilder<HomeframePageCubit, HomeframePageState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (value) {
              context.read<HomeframePageCubit>().changeHomeframePage(value);
            },
            selectedItemColor: customBlueColor,
            unselectedItemColor: customBlackColor.withOpacity(.4),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                ),
                label: "Archive",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet),
                label: "Wallet",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "User",
              ),
            ],
          );
        },
      ),
    );
  }
}
