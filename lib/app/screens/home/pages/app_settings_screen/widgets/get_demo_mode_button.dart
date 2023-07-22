import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/widgets/get_settings_button_with_icon.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';

class GetDemoModeButton extends StatelessWidget {
  const GetDemoModeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, DemoState>(
      builder: (context, state) {
        return GetSettingsButtonWithIcon(
          onTapFunction: () async {
            var status = '';
            if (state is DemoEnabledState) {
              context.read<DemoBloc>().add(DisableDemoModeEvent());
              status = 'disabled';
            } else {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Presentation Mode',
                      style: boldTextStyle.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text(
                            'Enabling Presentation Mode entails a temporary substitution of all your data with a template, facilitating the presentation or demonstration of the application to prospective users. It is possible to disable Presentation Mode at any given time through this menu. Given the aforementioned information, would you like to proceed with this action?',
                            style: regularTextStyle,
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
                          status = '';
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Enable',
                          style: boldTextStyle.copyWith(
                            color: customBlackColor.withOpacity(
                              .8,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          status = 'enabled';
                          context.read<DemoBloc>().add(EnableDemoModeEvent());
                        },
                      ),
                    ],
                    actionsPadding: dialogButtonPadding,
                  );
                },
              );
            }
            if (status != '') {
              showToast(
                title: 'DEMO-MODE',
                message: 'Presentation mode has been $status.',
                snackbarType: SnackbarType.info,
                context: context,
              );
            }
          },
          label: state is DemoEnabledState ? 'Disable presentation mode' : 'Enable presentation mode',
          icon: state is DemoEnabledState ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
          iconSize: 18,
        );
      },
    );
  }
}
