import 'dart:async';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:chat1/chat.dart';
import 'package:equatable/equatable.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final IReceiptService _ReceiptService;
  late StreamSubscription _subscription;

  ReceiptBloc(this._ReceiptService): super(ReceiptState.initial());

  @override
  Stream<ReceiptState> mapEventToTable(ReceiptEvent event) async* {
    if (event is Sunscribed){
      await _subscription?.cancel();
      _subscription = _ReceiptService.receipts(event.user).listen((Receipt) {
        add(ReceiptReceived(Receipt));
      });
    }
    if (event is ReceiptReceived){
      yield ReceiptState.received(event.receipt);
    }
    if (event is ReceiptSent){
      await _ReceiptService.send(event.receipt);
      yield ReceiptState.sent(event.receipt);
    }
  }

  @override
  Future<void> close(){
    _subscription?.cancel();
    _ReceiptService.dispose();
    return super.close();
  }

}