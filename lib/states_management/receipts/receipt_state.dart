part of "receipt_bloc.dart";
abstract class ReceiptState extends Equatable {
  const ReceiptState();
  factory ReceiptState.initial()=> ReceiptInitial();
  factory ReceiptState.sent(Receipt Receipt)=> ReceiptSentSuccess(Receipt);
  factory ReceiptState.received(Receipt Receipt)=> ReceiptSentSuccess(Receipt);



  @override
  List<Object> get props => [];

}
class ReceiptInitial extends ReceiptState {

}

class ReceiptSentSuccess extends ReceiptState {
  final Receipt _Receipt;
  const ReceiptSentSuccess(this._Receipt);
  @override
  List<Object> get props => [_Receipt];
}

class ReceiptReceivedSuccess extends ReceiptState {
  final Receipt _Receipt;
  const ReceiptReceivedSuccess(this._Receipt);
  @override
  List<Object> get props => [_Receipt];
}