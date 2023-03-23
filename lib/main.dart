import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/theme.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/archive_cubit/user_statistics_cubit/user_statistics_cubit.dart';
import 'package:pinext/app/bloc/cards_and_balances_cubit/cards_and_balances_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/signup_cubit/signin_cubit_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Pinext());
}

class Pinext extends StatelessWidget {
  const Pinext({super.key});

  @override
  Widget build(BuildContext context) {
    // Last update on 5th March 2023
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SigninCubit(),
        ),
        BlocProvider(
          create: (context) => CardsAndBalancesCubit(),
        ),
        BlocProvider(
          create: (context) => UserBloc(),
        ),
        BlocProvider(
          create: (context) => DemoBloc(),
        ),
        BlocProvider(
          create: (context) => UserStatisticsCubit(),
        ),
        BlocProvider(
          create: (context) => ArchiveCubit(),
        ),
        // BlocProvider(
        //   create: (context) => ArchiveSearchCubit(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: ROUTECONTROLLER.routeController,
        initialRoute: ROUTES.getSplashRoute,
        theme: PinextTheme.lightTheme,
      ),
    );
  }
}

// Assuming you have a collection named "users" and each document in that collection has a unique UID, and you want to allow users to only read, write, and edit collections or documents that are subcollections or documents of the document with the user's UID, you can use the following Firebase security rules:


// rules_version = '2';
// service cloud.firestore {
//   match /databases/{database}/documents {
  
//     // Allow users to read and write their own documents
//     match /users/{uid} {
//       allow read, write: if request.auth.uid == uid;
//     }
    
//     // Allow users to read, write, and edit subcollections or documents of their own document
//     match /users/{uid}/{document=**} {
//       allow read, write, update, delete: if request.auth.uid == uid;
//     }
    
//   }
// }


// In this rule, the first match statement specifies that users can only read and write their own document in the "users" collection.

// The second match statement specifies that users can also read, write, update, and delete any subcollection or document of their own document in the "users" collection. The {document=**} part of the match statement captures any subcollection or document path after the user's UID. The update and delete permissions are included to allow users to modify any data they have created within their own document.

// By using this rule, users will be restricted to only accessing data that belongs to them, as well as any data that is contained within their own document.



// No rule
// rules_version = '2';
// service cloud.firestore {
//   match /databases/{database}/documents {
//     match /{document=**} {
//       allow read, write;
//     }
//   }
// }