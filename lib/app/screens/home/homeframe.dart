import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/homeframe_page_controller_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/screens/home/pages/homepage.dart';

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
  const Center(
    child: Text("Page 1"),
  ),
  const Center(
    child: Text("Page 2"),
  ),
  const Center(
    child: Text("Page 3"),
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
                icon: Icon(Icons.wallet),
                label: "Wallet",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                ),
                label: "List",
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
