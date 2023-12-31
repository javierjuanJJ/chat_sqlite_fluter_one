import 'package:chat1/chat.dart';
import 'package:chat2/data/datasource/datasource_contract.dart';
import 'package:chat2/data/datasource/sqflite_datasource.dart';
import 'package:chat2/data/factories/db_factory.dart';
import 'package:chat2/data/services/image_uploader.dart';
import 'package:chat2/states_management/home/chats_cubit.dart';
import 'package:chat2/states_management/home/group_cubit.dart';
import 'package:chat2/states_management/home/home_cubit.dart';
import 'package:chat2/states_management/message/message_bloc.dart';
import 'package:chat2/states_management/message_group/message_group_bloc.dart';
import 'package:chat2/states_management/message_thread/message_thread_cubit.dart';
import 'package:chat2/states_management/onboarding/onboarding_cubit.dart';
import 'package:chat2/states_management/onboarding/profile_image_cubit.dart';
import 'package:chat2/states_management/receipts/receipt_bloc.dart';
import 'package:chat2/states_management/typing/typing_bloc.dart';
import 'package:chat2/ui/pages/home/home/home.dart';
import 'package:chat2/ui/pages/home/home_router.dart';
import 'package:chat2/ui/pages/message_thread/message_thread.dart';
import 'package:chat2/ui/pages/onboarding/on_boarding.dart';
import 'package:chat2/ui/pages/onboarding/on_boarding_router.dart';
import 'package:chat2/ui/pages/widgets/home/create_group.dart';
import 'package:chat2/viewmodels/chat_view_model.dart';
import 'package:chat2/viewmodels/chats_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'cache/local_cache.dart';
import 'data/group/group_service.dart';
import 'models/chat.dart';

class CompositionRoot{
  static late RethinkDb _r;
  static late Connection _connection;
  static late IUserService _userService;
  static late Database _db;
  static late IMessageService _messageService;
  static late IDatasource _datasource;
  static late ILocalCache _localCache;
  static late MessageBloc _messageBloc;
  static late TypingNotificationBloc _typingNotificationBloc;
  static late ITypingNotification _typingNotification;
  static late ChatsCubit chatsCubit;
  static late Chats_View_Model _viewModel;

  static late IGroupService _groupService;
  static late MessageGroupBloc _messageGroupBloc;
  static late IHomeRouter _homeRouter;

  static Widget start(){
    final user = _localCache.fetch('USER');
    return user.isEmpty ? composeOnBoardingUI() : composeHomeUi(User.fromJson(user));
  }


  static configure() async {
    _r = RethinkDb();
    _connection = await _r.connect(host: '127.0.0.1', port: 28015);
    _userService = UserService(_r, _connection);
    _messageService = MessageService(_r, _connection);
    _db = await LocalDatabaseFactory().createDatabase();
    _datasource = SqlfliteDatasource(_db);
    final sp = await SharedPreferences.getInstance();
    _localCache = LocalCache(sp);
    _messageBloc = MessageBloc(_messageService);
    _typingNotificationBloc = TypingNotificationBloc(_typingNotification);

    _viewModel = Chats_View_Model(_datasource, _userService);
    chatsCubit = ChatsCubit(_viewModel);

    _groupService = MessageGroupService(_r,_connection);
    _messageGroupBloc= MessageGroupBloc(_groupService);

    _homeRouter = HomeRouter(
      showMessageThread: composeMessageThreadUi,
      showCreateGroup: composeGroupUi
    );

  }

  static Widget composeOnBoardingUI(){
    ImageUploader imageUploader = ImageUploader('http://' + '127.0.0.1' + ':3000/uploads');
    OnBoardingCubit onBoardingCubit = OnBoardingCubit(_userService, imageUploader, _localCache);
    ProfileImageCubit imageCubit = ProfileImageCubit();
    IOnBoardingRouter router = OnBoardingRouter(composeHomeUi);

    return MultiBlocProvider(
      providers:[
        BlocProvider(create: (BuildContext context) => onBoardingCubit),
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: OnBoarding(router),
    );
  }

  static Widget composeHomeUi(User me){
    HomeCubit homeCubit = HomeCubit(_userService, _localCache);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => homeCubit),
      BlocProvider(create: (BuildContext context) => _messageBloc),
      BlocProvider(create: (BuildContext context) => _typingNotificationBloc),
      BlocProvider(create: (BuildContext context) => chatsCubit),
      BlocProvider(create: (BuildContext context) => _messageGroupBloc)
    ], child: Home(_viewModel, _homeRouter, me));
  }

  static Widget composeMessageThreadUi(List<User> receivers,User user,Chat chat){
    Chat_View_Model viewModel = Chat_View_Model(_datasource,_userService);
    MessageThreadCubit messageThreadCubit = MessageThreadCubit(viewModel);
    IReceiptService receiptService = ReceiptService(_r, _connection);
    ReceiptBloc receiptBloc = ReceiptBloc(receiptService);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => messageThreadCubit),
      BlocProvider(create: (BuildContext context) => receiptBloc),

    ], child: MessageThread(
      receivers, user, _messageBloc, chatsCubit, _typingNotificationBloc, chat
    ));
  }

  static Widget composeGroupUi(List<User> activeUsers, User me){
    GroupCubit groupCubit = GroupCubit();
    MessageGroupBloc messageGroupBloc = MessageGroupBloc(_groupService);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => groupCubit),
      BlocProvider(create: (BuildContext context) => _messageGroupBloc),
    ], child: CreateGroup(
      activeUsers , me, chatsCubit, _homeRouter
    ));
  }

}