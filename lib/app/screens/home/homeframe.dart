import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/homeframe_navbar_cubit/homeframe_navbar_cubit.dart';
import 'package:pinext/app/screens/home/pages/homepage.dart';

class Homeframe extends StatelessWidget {
  const Homeframe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeframeNavbarCubit(),
        )
      ],
      child: const HomeframeView(),
    );
  }
}

class HomeframeView extends StatelessWidget {
  const HomeframeView({Key? key}) : super(key: key);
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
      body: const Homepage(),
      bottomNavigationBar:
          BlocBuilder<HomeframeNavbarCubit, HomeframeNavbarState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (value) {
              context.read<HomeframeNavbarCubit>().changeNavbarState(value);
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
