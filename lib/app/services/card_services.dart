import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/services/firebase_services.dart';

class CardServices {
  CardServices._internal();
  static final CardServices _cardServices = CardServices._internal();
  factory CardServices() => _cardServices;

  addCard(PinextCardModel pinextCardModel) async {
    return await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_cards')
        .doc(pinextCardModel.cardId)
        .set(pinextCardModel.toMap());
  }

  removeCard(PinextCardModel pinextCardModel){

  }



}
