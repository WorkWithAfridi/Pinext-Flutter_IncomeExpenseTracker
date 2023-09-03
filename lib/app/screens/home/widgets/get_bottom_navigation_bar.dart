import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/shared/widgets/bounce_icons.dart';

class GetBottomNavigationBar extends StatelessWidget {
  const GetBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeframeCubit, HomeframeState>(
      builder: (context, state) {
        return Container(
          color: greyColor.withOpacity(.8),
          height: kToolbarHeight + 20,
          width: double.maxFinite,
          child: Row(
            children: [
              const SizedBox(
                width: defaultPadding * 2,
              ),
              Flexible(
                child: BounceIcon(
                  icon: state.selectedIndex == 0 ? AntIcons.homeFilled : AntIcons.homeOutlined,
                  size: 18,
                  title: state.selectedIndex == 0 ? 'Home' : null,
                  color: state.selectedIndex == 0 ? darkPurpleColor : customBlackColor.withOpacity(.4),
                  onTap: () {
                    context.read<HomeframeCubit>().changeHomeframePage(0);
                  },
                ),
              ),
              Flexible(
                child: BounceIcon(
                  icon: state.selectedIndex == 1 ? AntIcons.databaseFilled : AntIcons.databaseOutlined,
                  size: 18,
                  title: state.selectedIndex == 1 ? 'Archive' : null,
                  color: state.selectedIndex == 1 ? darkPurpleColor : customBlackColor.withOpacity(.4),
                  onTap: () {
                    context.read<HomeframeCubit>().changeHomeframePage(1);
                  },
                ),
              ),
              Flexible(
                child: BounceIcon(
                  icon: state.selectedIndex == 2 ? AntIcons.dollarCircleFilled : AntIcons.dollarCircleOutlined,
                  size: 18,
                  title: state.selectedIndex == 2 ? 'Budget' : null,
                  color: state.selectedIndex == 2 ? darkPurpleColor : customBlackColor.withOpacity(.4),
                  onTap: () {
                    context.read<HomeframeCubit>().changeHomeframePage(2);
                  },
                ),
              ),
              Flexible(
                child: BounceIcon(
                  icon: state.selectedIndex == 3 ? AntIcons.walletFilled : AntIcons.walletOutlined,
                  size: 18,
                  title: state.selectedIndex == 3 ? 'Wallet' : null,
                  color: state.selectedIndex == 3 ? darkPurpleColor : customBlackColor.withOpacity(.4),
                  onTap: () {
                    context.read<HomeframeCubit>().changeHomeframePage(3);
                  },
                ),
              ),
              Flexible(
                child: BounceIcon(
                  icon: state.selectedIndex == 4 ? AntIcons.appstoreFilled : AntIcons.appstoreOutlined,
                  size: 18,
                  title: state.selectedIndex == 4 ? 'More' : null,
                  color: state.selectedIndex == 4 ? darkPurpleColor : customBlackColor.withOpacity(.4),
                  onTap: () {
                    context.read<HomeframeCubit>().changeHomeframePage(4);
                  },
                ),
              ),
              const SizedBox(
                width: defaultPadding * 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
