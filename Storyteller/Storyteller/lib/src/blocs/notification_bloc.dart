import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/models/notification_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = NotificationsBloc();

class NotificationsBloc {
  final repository = Repository();
  final notificationFetcher = PublishSubject<NotificationModel>();
  final userFetcherStatus = PublishSubject<MessageModel>();

  Observable<NotificationModel> get allNotifications =>
      notificationFetcher.stream;

  dispose() async {
    await notificationFetcher.drain();
    notificationFetcher.close();
    userFetcherStatus.close();
  }

  fetchAllNotifications() async {
    NotificationModel userModel = await repository.fetchAllNotifications();
    notificationFetcher.sink.add(userModel);
  }

  unFollowUser(int userid) async {
    MessageModel userModel = await repository.unFollowUser(userid);
    userFetcherStatus.sink.add(userModel);
  }

  followUser(int userid) async {
    MessageModel userModel = await repository.followUser(userid);
    userFetcherStatus.sink.add(userModel);
  }

  readNotifications() async {
    MessageModel userModel = await repository.readNotifications();
    userFetcherStatus.sink.add(userModel);
  }
}
