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

Pinext is a cross-platform mobile application that allows users to create, save and share their favorite pins. The app is built using Flutter framework for Frontend, BLoC for state management, and Firebase for backend services such as database and user authentication. The app is available on Android, iOS, and Web platforms.

Flutter
Flutter is a mobile app development framework that is used to build high-performance, high-fidelity, apps for iOS, Android, and the web. It uses a reactive-style programming model and a widget-based UI design. Flutter has its own set of widgets and design patterns, which enables the creation of visually stunning user interfaces. The framework also provides a rich set of libraries and tools that make development easier and faster.

BLoC
BLoC (Business Logic Component) is a state management pattern for Flutter applications. It separates the business logic and the UI layer of the app. It helps to manage the app's state in a more predictable and scalable way. BLoC provides a clear separation of concerns, making the code more modular and easier to maintain.

Platform
The Pinext app is available on multiple platforms such as Android, iOS, and Web. Flutter enables the creation of apps that run natively on all these platforms. This means that developers can build an app once and deploy it to all platforms without the need to write separate code for each platform.

Firebase
Firebase is a cloud-based platform that provides a set of backend services to mobile and web apps. The Pinext app uses Firebase as its backend service provider for database and user authentication. Firebase provides a scalable, secure, and reliable solution for storing and retrieving data in real-time.

Cloud Firebase
The Pinext app uses Cloud Firebase as its database. Cloud Firebase is a NoSQL cloud-based database that stores data in JSON format. It provides real-time data synchronization across all clients connected to the database. The Pinext app uses Cloud Firebase to store user-generated pins and other related data.

Firebase Authentication
Firebase Authentication is a service provided by Firebase that enables user authentication for mobile and web apps. The Pinext app uses Firebase Authentication to authenticate users using either email and password or via Google Authentication. Firebase Authentication provides a secure and scalable solution for user authentication and authorization.

Conclusion
The Pinext app is a cross-platform mobile application that is built using Flutter, BLoC, and Firebase. Flutter provides a modern UI framework, BLoC provides a scalable state management solution, and Firebase provides a cloud-based backend service. With these technologies, the Pinext app is a high-performance, high-fidelity app that provides an excellent user experience on Android, iOS, and Web platforms.

## Firebase Firestore Architecture Structure

The Firebase database for the Pinext app is designed to store user data, card data, transaction data, goals, and app version data. The database is organized into several collections and subcollections, each with its own set of documents and fields. This document aims to provide a comprehensive guide to the database structure for the Pinext app.

Users Collection
The Users collection is used to store user details and statistics. This collection contains a document for each registered user, and each document has several fields that store user data such as username, email, profile picture, etc. Additionally, this collection also stores user statistics such as the number of pins, likes, and followers the user has.

Cards Collection
The Cards collection is used to store card details and statistics. This collection contains a document for each card created by users, and each document has several fields that store card data such as the image URL, title, description, and tags. Additionally, this collection also stores card statistics such as the number of views, likes, and saves the card has.

Transactions Collection
The Transactions collection is used to store transaction details such as user purchases, subscriptions, and other financial transactions. This collection is organized into a hierarchical structure based on the date of the transaction. Each transaction is stored in a document under the appropriate year, month, and date subcollection.

Goals Collection
The Goals collection is used to store user goals and milestones. This collection contains a document for each user, and each document has several fields that store user goals such as the goal title, description, deadline, and progress status. Additionally, this collection also stores milestone data for each goal.

AppData Collection
The AppData collection is used to store app version data. This collection contains a single document that stores the current version of the app. This document has several fields that store the app version number, release date, and update details.

Conclusion
The Firebase database for the Pinext app is designed to store user data, card data, transaction data, goals, and app version data. Each collection and subcollection has its own set of documents and fields that store specific data. By organizing the data in this way, the app can efficiently store and retrieve data, providing a seamless user experience.

## Contribution - Pinext is now OPEN SOURCE!!

Contributing to Pinext is a fantastic way to get involved and help us make this project even better. To contribute, follow these steps:

Fork the Repository: Start by forking our project's repository to your GitHub account. This will create a copy of the project under your account.

Clone the Repository: Next, clone the forked repository to your local machine using the git clone command.

Set Up the Database: To get the project running locally, you'll need to set up the database configuration files: google-services.json for Android and GoogleServices-Info.plist for iOS. Please use your own Firebase project and credentials to create these files. This ensures that your contributions won't interfere with the project's existing database.

Make Your Changes: Now you can start making the changes you want to contribute to the project. Ensure that your changes follow our coding guidelines and best practices.

Commit and Push: After making the necessary changes, commit your code and push it to your forked repository on GitHub.

Create a Pull Request: Go to the original project's repository and click on the "New Pull Request" button. GitHub will guide you through the process of creating a pull request from your fork. Be sure to provide a clear and concise description of your changes.

Review and Merge: Once your pull request is created, I will review the changes. If everything looks good, I will merge the pull request into the production branch. If any additional changes are needed, I'll provide feedback in the pull request discussion.

By following these steps, you'll be actively contributing to Pinext and helping us improve it for everyone. Thank you for your valuable contributions!