import '../../data/repositories/post_repository.dart';
import '../../domain/models/post_model.dart';

class PostViewModel {
  final PostRepository _postRepository = PostRepository();

  Stream<List<PostModel>> get postsStream => _postRepository.streamPosts();

  Future<String> addPost(PostModel post) => _postRepository.addPost(post);

  Future<void> updatePost(String id, Map<String, dynamic> data) =>
      _postRepository.updatePost(id, data);

  Future<void> deletePost(String id) => _postRepository.deletePost(id);

  Future<List<PostModel>> getPostsByIds(List<String> ids) => _postRepository.getPostsByIds(ids);
} 