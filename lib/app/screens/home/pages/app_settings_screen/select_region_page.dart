import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/country_data/country_data.dart';

class SelectRegionScreen extends StatelessWidget {
  const SelectRegionScreen({super.key});

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
      body: SingleChildScrollView(
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
                          context.read<RegionCubit>().selectRegion(CountryHandler().countryList[index]);
                          // UserHandler().currentUser.currencySymbol = CountryHandler().countryList[index].symbol;
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
                                    CountryHandler().countryList[index].currency,
                                    style: regularTextStyle.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (state.countryData.symbol == CountryHandler().countryList[index].symbol)
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
    );
  }
}
