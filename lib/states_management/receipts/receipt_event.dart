part of "receipt_bloc.dart";

abstract class ReceiptEvent extends Equatable{
  const ReceiptEvent();

  factory ReceiptEvent.onSunscibed(User user) => Sunscribed(user);
  factory ReceiptEvent.onReceiptSent(Receipt Receipt) => ReceiptSent(Receipt);

  @override
  List<Object> get props => [];
}

class Sunscribed extends ReceiptEvent {
  final User user;
  const Sunscribed(this.user);
  @override
  List<Object> get props => [user];
}

class ReceiptSent extends ReceiptEvent {
  final Receipt receipt;
  const ReceiptSent(this.receipt);
  @override
  List<Object> get props => [receipt];
}

class ReceiptReceived extends ReceiptEvent {
  final Receipt receipt;
  const ReceiptReceived(this.receipt);
  @override
  List<Object> get props => [receipt];
}