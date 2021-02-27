import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/image_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = SearchMainBloc();

class SearchMainBloc {
  final repository = Repository();
  final photoFetcherSearch = PublishSubject<ImageModel>();
  final photoFetcherStatusSearch = PublishSubject<MessageModel>();

  Observable<ImageModel> get allPhotos => photoFetcherSearch.stream;

  dispose() async {
    await photoFetcherSearch.drain();
    photoFetcherSearch.close();
    photoFetcherStatusSearch.close();
  }

  fetchPhoto(String postSearch) async {
    ImageModel imageModel = await repository.fetchPhoto(postSearch);
    photoFetcherSearch.sink.add(imageModel);
  }

  unlikepost(int photoid) async {
    MessageModel imageModel = await repository.unlikePhoto(photoid);
    photoFetcherStatusSearch.sink.add(imageModel);
  }

  likepost(int photoid) async {
    MessageModel imageModel = await repository.likePhoto(photoid);
    photoFetcherStatusSearch.sink.add(imageModel);
  }
}
