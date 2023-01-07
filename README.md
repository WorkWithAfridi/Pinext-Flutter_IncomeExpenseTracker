# Pinext - Personal Income Expense Tracker

## A full-stack personal expense tracker using Bloc, Firebase and Flutter.

PINEXT is a personal income expense tracking app that allows individuals to track their income and expenses on their mobile phones. The app includes a backend system for storing and organizing financial data, as well as user authentication to ensure that only authorized users can access the information. The app also offers a range of features to help users manage their finances, such as the ability to input and categorize income and expenses, set budgets and financial goals, and receive alerts when their montly budgets are running low. It also provide useful insights and analysis, such as budgeting advice and generating reports, to help users understand their financial situation and make more informed decisions

In other words PINEXT can be a valuable tool for individuals looking to better understand their financial situation and make more informed decisions about how to save and spend their money.

## Promotional Images

<p align="center">
<img src="https://github.com/WorkWithAfridi/Pinext-PersonalIncomeExpenseTrackingApp/blob/master/assets/promotional_images/promo_img_1.png" width="360" height="665">
<img src="https://github.com/WorkWithAfridi/Pinext-PersonalIncomeExpenseTrackingApp/blob/master/assets/promotional_images/promo_img_2.png" width="360" height="665">
</p>
<p align="center">
<img src="https://github.com/WorkWithAfridi/Pinext-PersonalIncomeExpenseTrackingApp/blob/master/assets/promotional_images/promo_img_3.png" width="360" height="665">
<img src="https://github.com/WorkWithAfridi/Pinext-PersonalIncomeExpenseTrackingApp/blob/master/assets/promotional_images/promo_img_4.png" width="360" height="665">
</p>

## Stack

- Framework: Flutter
- State Management: BLoC
- Platform: Android, iOS, WEB
- Database: Cloud Firebase
- User authentication: Firebase Authentication - Email & Password or via Google Authentication

## Firebase Firestore Architecture Structure

- Users { contains user details and stats. }
    - Cards { contains card details and stats. }
    - Transactions { contains transaction details. }
        - Year
            - Month
                - Date
    - Goals { contains users goals and milestones. }
- AppData { contains app version data. }
