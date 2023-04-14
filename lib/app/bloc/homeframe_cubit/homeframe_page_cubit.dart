import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

part 'homeframe_page_state.dart';

class HomeframeCubit extends Cubit<HomeframeState> {
  HomeframeCubit()
      : super(
          HoemframeInitialState(
            selectedIndex: 0,
            pageController: PageController(),
          ),
        );

  void changeHomeframePage(int index) {
    state.pageController.jumpToPage(index);
    emit(
      HoemframeInitialState(
        selectedIndex: index,
        pageController: state.pageController,
      ),
    );
  }

  void updateHomeframePage(int index) {
    emit(
      HoemframeInitialState(
        selectedIndex: index,
        pageController: state.pageController,
      ),
    );
  }

  void openAddTransactionsPage(BuildContext context) {
    Navigator.pushNamed(
      context,
      ROUTES.getAddTransactionsRoute,
    );
  }

  void showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Hello!!',
            style: boldTextStyle.copyWith(
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ListBody(
              children: [
                Text(
                  """
Meet PINEXT, the ultimate personal expense tracker that makes managing your finances a breeze. PINEXT is designed to help you stay on top of your spending, earnings, and savings, and make informed decisions about your financial future. With its sleek and user-friendly interface, PINEXT is the perfect solution for anyone looking to take control of their finances.

One of the standout features of PINEXT is its powerful archive system. All of your transactions are stored in one convenient place, allowing you to easily review your spending history and make informed decisions about your future finances. Whether you're looking to track your monthly expenses or simply monitor your spending habits, PINEXT has you covered.

Another key feature of PINEXT is its ability to automatically track your monthly budgets. With this feature, you can set and monitor your budget, and PINEXT will automatically adjust for any subscriptions you are subscribed to. This means that you can always stay on top of your finances, no matter how many monthly subscriptions you have.

Additionally, PINEXT allows you to manually input your transactions, so you always have an accurate and up-to-date picture of your financial situation. Whether you're tracking your income or your expenses, PINEXT makes it easy to see where your money is going and how much you have left over.

Overall, PINEXT is the perfect solution for anyone looking to take control of their finances. With its powerful archive system, automatic budget tracking, and user-friendly interface, PINEXT makes it easy to manage your money and stay on top of your finances. So why wait? Download PINEXT today and start taking control of your finances!""",
                  style: regularTextStyle.copyWith(
                    color: customBlackColor.withOpacity(.75),
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorder),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Dismiss',
                style: boldTextStyle.copyWith(
                  color: customBlackColor.withOpacity(
                    .8,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          actionsPadding: dialogButtonPadding,
        );
      },
    );
  }
}
