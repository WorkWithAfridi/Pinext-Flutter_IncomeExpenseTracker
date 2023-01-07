# Pinext - Personal Income Expense Tracker

## A full-stack personal expense tracker using Bloc, Firebase and Flutter.

A full-stack Personal Income Expense tracker made with Flutter BLoC and Firebase, where users can sign in using email and password and can upload their money source as Cards and track their daily, weekly, monthly and yearly income and expenses. Users can also download a report of their expenses directly from the app as a pdf file or .csv file.

## Promotional Images

<p align="center">
<img src="https://github.com/WorkWithAfridi/Pinext-PersonalIncomeExpenseTrackingApp/blob/master/assets/promotional_images/promo_img_1.png" width="360" height="640">
<img src="https://github.com/WorkWithAfridi/Pinext-PersonalIncomeExpenseTrackingApp/blob/master/assets/promotional_images/promo_img_2.png" width="360" height="640">
</p>

<p align="center">
<img src="https://github.com/WorkWithAfridi/Pinext-PersonalIncomeExpenseTrackingApp/blob/master/assets/promotional_images/promo_img_3.png" width="360" height="640">
<img src="https://github.com/WorkWithAfridi/Pinext-PersonalIncomeExpenseTrackingApp/blob/master/assets/promotional_images/promo_img_4.png" width="360" height="640">
</p>

## Stack

- Framework: Flutter
- Statemanagement: BLoC
- Database: Cloud Firebase
- User authentication: Firebase Authentication using Gmail and password

## Firebase Firestore Architecture Structure

- Users { contains user details and stats. }
    - Cards { contains card details and stats. }
    - Transactions { contains transaction details. }
        - Year
            - Month
                - Date
    - Goals { contains users goals and milestones. }
- AppData { contains app version data. }

## Want to contribute to the project? 

Just send in your pull req. and I'll for sure have a look into it. :)

## How to install the app on your physical device

Download the source code and compile the apk using Flutter CLI or Android Studio. Or  just HMU at Khondakarafridi35@gmail.com :)

## APKs for Android

APKs can be found: [here](https://drive.google.com/drive/folders/1Z-fPUf9SbRhjLuHZsv87LCJxbRI3bJQT?usp=sharing)
