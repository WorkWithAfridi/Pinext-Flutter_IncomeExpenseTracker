import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/services/firebase_services.dart';

class CardHandler {
  CardHandler._internal();
  static final CardHandler _cardServices = CardHandler._internal();
  factory CardHandler() => _cardServices;

  addCard(PinextCardModel pinextCardModel) async {
    return await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_cards')
        .doc(pinextCardModel.cardId)
        .set(pinextCardModel.toMap());
  }

  removeCard(PinextCardModel pinextCardModel) {
    //Removing card
    //Adjust netBalance
    //
  }

  editCard(PinextCardModel pinextCardModel) {}

  getCard(String cardId) async {
    PinextCardModel pinextCardModel;
    DocumentSnapshot cardSnapshot = await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_cards')
        .doc(cardId)
        .get();
    pinextCardModel =
        PinextCardModel.fromMap(cardSnapshot.data() as Map<String, dynamic>);
    return pinextCardModel;
  }
}
