import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

class CardHandler {
  factory CardHandler() => _cardServices;
  CardHandler._internal();
  static final CardHandler _cardServices = CardHandler._internal();

  List<PinextCardModel>? userCards;

  Future<void> getUserCards() async {
    userCards = [];
    final QuerySnapshot cardData =
        await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(UserHandler().currentUser.userId).collection('pinext_cards').get();
    for (var i = 0; i < cardData.docs.length; i++) {
      final cardModel = PinextCardModel.fromMap(cardData.docs[i].data()! as Map<String, dynamic>);
      userCards!.add(cardModel);
    }
  }

  Future<PinextCardModel> getCardData(String cardId) async {
    PinextCardModel cardModel;
    try {
      if (userCards!.isEmpty) {
        // cardModel = await getCard(cardId);
        await Future.delayed(const Duration(seconds: 1));
      }
      //  else {
      cardModel = userCards!.firstWhere((element) => element.cardId == cardId);
      // }
    } catch (err) {
      cardModel = PinextCardModel(
        cardId: '000',
        title: 'CARD DEL',
        description: 'This card has been deleted by the user and can no longer be accessed!',
        balance: 0000,
        color: 'Light Blue',
        lastTransactionData: DateTime.now().toString(),
      );
    }
    return cardModel;
  }

  Future addCard({
    required PinextCardModel pinextCardModel,
    required bool duringSignIn,
  }) async {
    if (duringSignIn) {
      return FirebaseServices()
          .firebaseFirestore
          .collection('pinext_users')
          .doc(FirebaseServices().getUserId())
          .collection('pinext_cards')
          .doc(pinextCardModel.cardId)
          .set(pinextCardModel.toMap());
    } else {
      final user = UserHandler().currentUser;
      final adjustedNetBalance = double.parse(user.netBalance) + double.parse(pinextCardModel.balance.toString());
      await FirebaseServices().firebaseFirestore.collection(USERS_DIRECTORY).doc(FirebaseServices().getUserId()).update({
        'netBalance': adjustedNetBalance.toString(),
      });

      await FirebaseServices()
          .firebaseFirestore
          .collection('pinext_users')
          .doc(FirebaseServices().getUserId())
          .collection('pinext_cards')
          .doc(pinextCardModel.cardId)
          .set(pinextCardModel.toMap());
    }
  }

  Future<void> removeCard(PinextCardModel pinextCardModel) async {
    final user = await UserHandler().getCurrentUser();
    final adjustedNetBalance = double.parse(user.netBalance) - double.parse(pinextCardModel.balance.toString());
    await UserHandler().updateNetBalance(adjustedNetBalance.toString());
    await FirebaseServices()
        .firebaseFirestore
        .collection(USERS_DIRECTORY)
        .doc(FirebaseServices().getUserId())
        .collection(CARDS_DIRECTORY)
        .doc(pinextCardModel.cardId)
        .delete();
    return;
  }

  void editCard(PinextCardModel pinextCardModel) {}

  Future<PinextCardModel> getCard(String cardId) async {
    PinextCardModel pinextCardModel;
    final DocumentSnapshot cardSnapshot =
        await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).collection('pinext_cards').doc(cardId).get();
    pinextCardModel = PinextCardModel.fromMap(cardSnapshot.data()! as Map<String, dynamic>);
    return pinextCardModel;
  }

  Future<String> updateCard(PinextCardModel newVersion) async {
    try {
      DocumentSnapshot userDocument = await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(UserHandler().currentUser.userId)
          .collection(CARDS_DIRECTORY)
          .doc(newVersion.cardId)
          .get();
      var currentVersion = PinextCardModel.fromMap(userDocument.data()! as Map<String, dynamic>);

      final currentNetBalance = double.parse(UserHandler().currentUser.netBalance);
      double adjustedNetBalance;
      if (currentVersion.balance > newVersion.balance) {
        final toBeAdjustedBalance = currentVersion.balance - newVersion.balance;
        adjustedNetBalance = currentNetBalance - toBeAdjustedBalance;
      } else {
        //  (currentVersion.balance < newVersion.balance)
        final toBeAdjustedBalance = newVersion.balance - currentVersion.balance;
        adjustedNetBalance = currentNetBalance + toBeAdjustedBalance;
      }
      await UserHandler().updateNetBalance(adjustedNetBalance.toString());
      await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(UserHandler().currentUser.userId)
          .collection(CARDS_DIRECTORY)
          .doc(newVersion.cardId)
          .update(newVersion.toMap());

      userDocument = await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(UserHandler().currentUser.userId)
          .collection(CARDS_DIRECTORY)
          .doc(newVersion.cardId)
          .get();
      currentVersion = PinextCardModel.fromMap(userDocument.data()! as Map<String, dynamic>);
      return 'Success';
    } on FirebaseException catch (err) {
      return err.message.toString();
    } catch (err) {
      return 'Snap, an error occurred! Please try again later.';
    }
  }
}
