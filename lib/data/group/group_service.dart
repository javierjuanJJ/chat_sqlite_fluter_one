import 'dart:async';

import 'package:chat1/chat.dart';
import 'package:flutter/cupertino.dart';

import '../../models/message_group.dart';

abstract class IGroupService {
  Future<MessageGroup> create(MessageGroup group);

  Stream<MessageGroup> groups({required User me});

  dispose();
}

class MessageGroupService implements IGroupService {
  final Connection _connection;
  final RethinkDb r;

  final _controller = StreamController<MessageGroup>.broadcast();
  late StreamSubscription _changeFeed;

  MessageGroupService(this.r, this._connection);

  @override
  Future<MessageGroup> create(MessageGroup group) async {
    Map record = await r
        .table('message_groups')
        .insert(group.toJson(), {'return_changes': true}).run(_connection);

    return MessageGroup.fromJson(record['changes'].first['new_val']);
  }

  @override
  dispose() {
    _changeFeed?.cancel();
    _controller?.close();
  }

  @override
  Stream<MessageGroup> groups({required User me}) {
    _startReceivingGriups(me);
    return _controller.stream;
  }

  void _startReceivingGriups(User me) {
    _changeFeed = r.table('message_groups').filter((group) => group('members')
        .contains(me.id)
        .and(group('created_by').ne(me.id).and(group
            .hasFields('received_by')
            .not()
            .or(group('received_by').contains(me.id).not())))
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {

          event.forEach((feedData) {
            if(feedData['new_val'] == null){
              return;
            }
            final group = _groupFromFeed(feedData);
            _controller.sink.add(group);
            _updateWhenReceivedGroupCreated(group, me);
          }).catchError((err) => print(err)).onError((error, stackTrace) => print(error));

    })) as StreamSubscription;
  }

  MessageGroup _groupFromFeed(feedData) {
    var data = feedData['new_val'];
    return MessageGroup.fromJson(data);
  }

  void _updateWhenReceivedGroupCreated(MessageGroup group, User user) async {
    Map updatedRecord = (await r.table('message_groups').get(group.id).update(
        (group) => r.branch(group.hasFields('received_by'), {
          'received_by' : group('received_by').append(user.id)
        }, {
          'received_by': [user.id]
        }),
      {'return_changes': 'always'}).run(_connection)
    ) as Map;
    _removeGroupWhenDeliverredToAll(updatedRecord['changes'][0]);
  }

  void _removeGroupWhenDeliverredToAll(Map map) {
    final List members = map['new_val']['members'];
    final List alreadyReceived = map['new_val']['received_by'];
    final String id = map['new_val']['id'];

    if (members.length > alreadyReceived.length){
      return;
    }
    r.table('message_groups').get(id).delete({'return_changes':false}).run(_connection);
  }
}
