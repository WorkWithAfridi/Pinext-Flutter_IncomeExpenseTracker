import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/shared/widgets/custom_loader.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/country_data/country_data.dart';

class SelectRegionScreen extends StatelessWidget {
  SelectRegionScreen({
    super.key,
    required this.isUpdateUserRegion,
  });
  bool isUpdateUserRegion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: customBlackColor,
          ),
        ),
        title: Text(
          'Select Region',
          style: regularTextStyle,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: CountryHandler().countryList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (isUpdateUserRegion) {
                                context.read<RegionCubit>().updateRegion(CountryHandler().countryList[index]).then((value) {
                                  GetCustomSnackbar(
                                    title: 'Region updated!',
                                    message: 'Your currency is now set as ${CountryHandler().countryList[index].currency}.',
                                    snackbarType: SnackbarType.info,
                                    context: context,
                                  );
                                  Navigator.pop(context);
                                });
                              } else {
                                context.read<RegionCubit>().selectRegion(CountryHandler().countryList[index]);

                                GetCustomSnackbar(
                                  title: 'Region updated!',
                                  message: 'Your currency is now set as ${CountryHandler().countryList[index].currency}.',
                                  snackbarType: SnackbarType.info,
                                  context: context,
                                );
                                Navigator.pop(context);
                                // UserHandler().currentUser.currencySymbol = CountryHandler().countryList[index].symbol;
                              }
                            },
                            child: Container(
                              height: 50,
                              width: getWidth(context),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(defaultBorder),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding,
                              ),
                              child: BlocBuilder<RegionCubit, RegionState>(
                                builder: (context, state) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        CountryHandler().countryList[index].name,
                                        style: regularTextStyle.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                      if (state.countryData.name == CountryHandler().countryList[index].name)
                                        const Icon(
                                          Icons.check,
                                          color: primaryColor,
                                        )
                                      else
                                        const SizedBox.shrink()
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const Divider()
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: kToolbarHeight,
                  )
                ],
              ),
            ),
          ),
          BlocBuilder<RegionCubit, RegionState>(
            builder: (context, state) {
              return state.isLoading
                  ? const CustomLoader(
                      title: 'Loading...',
                    )
                  : const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
