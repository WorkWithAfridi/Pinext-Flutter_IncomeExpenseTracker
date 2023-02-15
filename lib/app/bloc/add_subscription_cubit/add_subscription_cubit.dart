import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_subscription_state.dart';

class AddSubscriptionCubit extends Cubit<AddSubscriptionState> {
  AddSubscriptionCubit()
      : super(
          AddSubscriptionInitial(
            amount: '000',
            title: "",
            description: "",
            automaticallyPayActivated: false,
            selectedCardNo: "",
          ),
        );

  selectCard(String selectedCardNo) {
    emit(
      AddSubscriptionInitial(
        selectedCardNo: selectedCardNo,
        title: state.title,
        description: state.description,
        amount: state.amount,
        automaticallyPayActivated: state.automaticallyPayActivated,
      ),
    );
  }

  toogleAutomaticallyPaySwitch(bool value) {
    emit(
      AddSubscriptionInitial(
        selectedCardNo: state.selectedCardNo,
        title: state.title,
        description: state.description,
        amount: state.amount,
        automaticallyPayActivated: value,
      ),
    );
  }
}
