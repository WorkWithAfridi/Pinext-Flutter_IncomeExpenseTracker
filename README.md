# Pinext - Personal Income Expense Tracker

Meet PINEXT, the ultimate personal expense tracker that makes managing your finances a breeze. PINEXT is designed to help you stay on top of your spending, earnings, and savings, and make informed decisions about your financial future. With its sleek and user-friendly interface, PINEXT is the perfect solution for anyone looking to take control of their finances.

One of the standout features of PINEXT is its powerful archive system. All of your transactions are stored in one convenient place, allowing you to easily review your spending history and make informed decisions about your future finances. Whether you're looking to track your monthly expenses or simply monitor your spending habits, PINEXT has you covered.

Another key feature of PINEXT is its ability to automatically track your monthly budgets. With this feature, you can set and monitor your budget, and PINEXT will automatically adjust for any subscriptions you are subscribed to. This means that you can always stay on top of your finances, no matter how many monthly subscriptions you have.

Additionally, PINEXT allows you to manually input your transactions, so you always have an accurate and up-to-date picture of your financial situation. Whether you're tracking your income or your expenses, PINEXT makes it easy to see where your money is going and how much you have left over.

Overall, PINEXT is the perfect solution for anyone looking to take control of their finances. With its powerful archive system, automatic budget tracking, and user-friendly interface, PINEXT makes it easy to manage your money and stay on top of your finances. So why wait? Download PINEXT today and start taking control of your finances!

## In App Screenshots

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
