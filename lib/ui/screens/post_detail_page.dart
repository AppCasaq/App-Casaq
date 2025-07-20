import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/user_model.dart';
import '../viewmodels/post_viewmodel.dart';
import 'conversations_page.dart';
import 'locatore/createpost_page.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;
  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final PostViewModel _postViewModel = PostViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Dettagli annuncio', style: TextStyle(fontSize: 24, color: Color(0xFF122F89), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('posts').doc(widget.postId).get(),
        builder: (context, postSnap) {
          if (!postSnap.hasData || !postSnap.data!.exists) {
            return const Center(child: Text('Annuncio non trovato'));
          }
          final post = PostModel.fromDocument(postSnap.data!);
          if (post == null) return const Center(child: Text('Errore caricamento annuncio'));
          if (post.userId.isEmpty) {
            return const Center(child: Text('Impossibile trovare il locatore.'));
          }
          final currentUser = FirebaseAuth.instance.currentUser;
          return FutureBuilder<DocumentSnapshot>(
            future: currentUser != null ? FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get() : null,
            builder: (context, studSnap) {
              String? incompatReason;
              if (studSnap.hasData && studSnap.data != null && studSnap.data!.exists) {
                final studData = studSnap.data!.data() as Map<String, dynamic>;
                final userGender = studData['gender'] ?? '';
                final userInfo = studData['info'] ?? '';
                bool genderOk = post.requiredGender == 'Entrambi' || post.requiredGender == userGender;
                bool infoOk = post.requiredStudent == 'Tutti' || post.requiredStudent == userInfo;
                if (!genderOk && !infoOk) {
                  incompatReason = 'Annuncio rivolto a studenti di altri enti e di altro genere';
                } else if (!genderOk) {
                  incompatReason = 'Annuncio rivolto ad un genere diverso';
                } else if (!infoOk) {
                  incompatReason = 'Annuncio rivolto a studenti di altri enti';
                }
              }
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(post.userId).get(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData || !userSnap.data!.exists) {
                    return Center(child: Text('Locatore non trovato'));
                  }
                  final locatore = UserModel.fromDocument(userSnap.data!);
                  if (locatore == null) {
                    return Center(child: Text('Locatore non trovato'));
                  }
                  final isLocatore = currentUser != null && currentUser.uid == post.userId;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildImageSection(post, incompatReason, isLocatore),
                        _buildContentSection(context, post, locatore, isLocatore, incompatReason),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildImageSection(PostModel post, [String? incompatReason, bool isLocatore = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: post.imageUrl != null && post.imageUrl!.isNotEmpty
                ? Image.network(
                    post.imageUrl!,
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 280,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image, size: 80)),
                  ),
          ),
          if (incompatReason != null && !isLocatore)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                color: Colors.red.withOpacity(0.85),
                child: Text(
                  incompatReason,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, PostModel post, UserModel locatore, bool isLocatore, [String? incompatReason]) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(thickness: 1),
          _buildSectionTitle(context, 'Requisiti richiesti'),
          const SizedBox(height: 8),
          _buildInfoRow('Genere', post.requiredGender),
          _buildInfoRow('Ente', post.requiredStudent),
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          _buildSectionTitle(context, 'Informazioni'),
          const SizedBox(height: 8),
          Text(
            post.description.isNotEmpty
                ? post.description
                : 'Nessuna descrizione disponibile.',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Località', post.location),
          _buildInfoRow('Tipologia stanza', post.roomType),
          const Divider(thickness: 1),
          const SizedBox(height: 12),
          _buildOwnerSection(locatore, post),
          const SizedBox(height: 16),
          if (!isLocatore) _buildContactButton(context, locatore),
          if (!isLocatore && incompatReason != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Questo annuncio non è compatibile con il tuo profilo. Il locatore potrebbe non essere interessato',
                style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          if (isLocatore) _buildEditDeleteRow(context, post),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Color(0xFF122F89)
          ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Color(0xFF122F89))),
        ],
      ),
    );
  }

  Widget _buildOwnerSection(UserModel locatore, PostModel post) {
    final gender = locatore.gender;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage('assets/images/icona_$gender.png'),
              ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${locatore.name} ${locatore.surname}', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(locatore.type),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Canone', style: TextStyle(fontSize: 14)),
            Text('€${post.rent}', style: const TextStyle(fontSize: 24, color: Color(0xFF122F89), fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildContactButton(BuildContext context, UserModel locatore) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ConversationsPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Contatta ora',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold)
          ),
      ),
    );
  }

  Widget _buildEditDeleteRow(BuildContext context, PostModel post) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreatePostPage(postToEdit: post),
                      ),
                    );
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                  ),
                  child: Text(
                    "Modifica",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
                  onPressed: () async {
                    await _postViewModel.deletePost(post.id);
                    await FirebaseFirestore.instance.collection('users').doc(post.userId).update({
                      'postIds': FieldValue.arrayRemove([post.id])
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                  ),
                  child: Text(
                    "Elimina",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
        ),
      ],
    );
  }
} 