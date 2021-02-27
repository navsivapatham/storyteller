import 'package:Storyteller/src/models/conversation_model.dart' as conversation;
import 'package:Storyteller/src/models/image_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/models/notification_model.dart';
import 'package:Storyteller/src/models/user_model.dart';

import 'story_teller_api_provider.dart';

class Repository {
  final storyTellerApiProvider = StoryTellerApiProvider();

  Future<ImageModel> fetchAllPhoto() => storyTellerApiProvider.fetchPhotoList();

  Future<ImageModel> fetchPhoto(String postSearch) =>
      storyTellerApiProvider.fetchList(postSearch);

  Future<UserModel> fetchUserLoginState() => storyTellerApiProvider.fetchUser();
  Future<MessageModel> resetLogin(String email) =>
      storyTellerApiProvider.resetUser(email);

  Future<MessageModel> userSignup(User user) =>
      storyTellerApiProvider.signupUser(user);

  Future<UserModel> loginUserLogin(String username, String password) =>
      storyTellerApiProvider.loginUserLogin(username, password);

  Future<MessageModel> unlikePhoto(int userid) =>
      storyTellerApiProvider.unlikePhoto(userid);

  Future<MessageModel> destroyPhoto(int userid) =>
      storyTellerApiProvider.destroyPhoto(userid);

  Future<MessageModel> likePhoto(int userid) =>
      storyTellerApiProvider.likePhoto(userid);

  Future<UserModel> likesPhoto(int userid) =>
      storyTellerApiProvider.likesPhoto(userid);

  Future<UserModel> fetchAllUsers(String userSearch) =>
      storyTellerApiProvider.fetchAllUsers(userSearch);

  Future<MessageModel> unFollowUser(int userid) =>
      storyTellerApiProvider.unFollowUser(userid);

  Future<MessageModel> followUser(int userid) =>
      storyTellerApiProvider.followUser(userid);

  Future<UserModel> getUser(int userid) =>
      storyTellerApiProvider.getUser(userid);

  Future<ImageModel> fetchUserPhotos(int userid) =>
      storyTellerApiProvider.fetchUserPhotos(userid);

  Future<MessageModel> userEdit(User user) =>
      storyTellerApiProvider.userEdit(user);

  Future<NotificationModel> fetchAllNotifications() =>
      storyTellerApiProvider.fetchAllNotifications();

  Future<MessageModel> saveImage(Data image) =>
      storyTellerApiProvider.saveImage(image);

  Future<conversation.ConversationModel> fetchUserConversation(
          toUsernameController) =>
      storyTellerApiProvider.fetchUserConversations(toUsernameController);

  Future<MessageModel> saveConversation(conversation.Data conversation) =>
      storyTellerApiProvider.saveConversation(conversation);

  Future<conversation.ConversationModel> fetchUserConversationList(
          toUsernameController) =>
      storyTellerApiProvider.fetchUserConversationsList(toUsernameController);

  Future<MessageModel> readNotifications() =>
      storyTellerApiProvider.readNotifications();
}
