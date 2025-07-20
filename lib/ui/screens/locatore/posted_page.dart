import 'package:casaq/ui/screens/conversations_page.dart';
import 'package:casaq/ui/screens/locatore/createpost_page.dart';
import 'package:casaq/ui/screens/studente/search_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/models/post_model.dart';
import '../../viewmodels/post_viewmodel.dart';
import '../post_detail_page.dart';
import '../userprofile_page.dart';

class PostedPage extends StatefulWidget {
  const PostedPage({super.key});

  @override
  _PostedPageState createState() => _PostedPageState();
}

class _PostedPageState extends State<PostedPage> {
  final PostViewModel _postViewModel = PostViewModel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
                builder: (context, userSnap) {
                  Widget avatar;
                  if (userSnap.connectionState == ConnectionState.waiting) {
                    avatar = const CircleAvatar(radius: 26, child: CircularProgressIndicator());
                  } else if (!userSnap.hasData || !userSnap.data!.exists) {
                    avatar = const CircleAvatar(radius: 26, backgroundImage: AssetImage('assets/images/default.png'));
                  } else {
                    final userData = userSnap.data!.data() as Map<String, dynamic>;
                    final gender = userData['gender'] ?? 'default';
                    avatar = CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage('assets/images/icona_$gender.png'),
                    );
                  }
                  final backAvatar = GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => UserProfilePage()),
                    ),
                    child: avatar,
                  );
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                'Tuoi annunci',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [backAvatar], // Rimosso IconButton delle notifiche
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _buildFavoritesList(userSnap, context, uid),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Positioned navigation bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                color: theme.colorScheme.surface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed:() => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CreatePostPage()),
                      )
                    ),
                    IconButton(
                      icon: Icon(Icons.message_outlined),
                      onPressed:() => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ConversationsPage()),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(AsyncSnapshot<DocumentSnapshot> userSnap, BuildContext context, String? uid) {
    if (uid == null) {
      return const Center(child: Text('Utente non autenticato'));
    }
    if (!userSnap.hasData || !userSnap.data!.exists) {
      return const Center(child: Text('Nessun dato disponibile'));
    }
    final userData = userSnap.data!.data() as Map<String, dynamic>;
    final postIds = (userData['postIds'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
    return FutureBuilder<List<PostModel>>(
      future: _postViewModel.getPostsByIds(postIds),
      builder: (context, postSnap) {
        if (postSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = postSnap.data ?? [];
        if (posts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                'Nessun risultato trovato',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 72),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final isLiked = postIds.contains(post.id);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(postId: post.id),
                    ),
                  );
                },
                child: ListingCard(
                  imageUrl: post.imageUrl ?? '',
                  location: post.location,
                  roomType: post.roomType,
                  price: post.rent.toString(),
                  postId: post.id,
                  isLiked: isLiked,
                  onFavorite: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Per rimuovere un annuncio devi eliminarlo")),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}