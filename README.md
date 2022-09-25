# Pinext

## A full-stack personal expense tracker using Bloc, Firebase and Flutter.

A full-stack Personal Income Expense tracker made with Flutter BLoC and Firebase, where users can sign in using email and password and can upload their money source as Cards and track their daily, weekly, monthly and yearly income and expenses. Users can also download a report of their expenses directly from the app as a pdf file or .csv file.

* User Authentication using Firebase Authentication.
* Backend using Firebase Cloud Firestore.
* State management using BLoC.

## Demo video and in-app screenshots

<!-- * [Demo Video](paste video link here) -->

![Demo Image](https://github.com/llKYOTOll/Pinext-PersonalIncomeExpenseTrackingApp/blob/master/assets/promotional_images/Screenshot%202022-09-25%20093843.png?raw=true)

## How to install the app on your physical device

Download the source code and compile the apk using Flutter CLI or Android Studio. Or  just HMU at Khondakarafridi35@gmail.com :)

## Want to contribute to the project? 

Just send in your pull req. and I'll for sure have a look into it. :)

## APKs

** APKs to be uploaded at a later date!

## Firebase Firestore Architecture Structure

- users { contains user details and stats. }
    - Cards { contains card details and stats. }
    - Transactions { contains transaction details. }
        - Year
            - Month
                - Date


