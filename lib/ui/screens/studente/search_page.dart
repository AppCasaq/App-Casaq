import '../conversations_page.dart';
import 'favorites_page.dart';
import '../userprofile_page.dart';
import '../post_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../domain/models/post_model.dart';
import '../../viewmodels/post_viewmodel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final PostViewModel _postViewModel = PostViewModel();

  // Filtri
  String? _selectedLocation = '';
  String? _selectedRoomType = '';
  int? _minPrice;
  int? _maxPrice;

  bool _sortByPrice = false;

  final List<String> _allLocations = ['Centro', 'Coppito', 'Scoppito'];
  final List<String> _allRoomTypes = ['Singola', 'Doppia', 'Multipla'];

  void _openFilterModal(List<PostModel> posts) async {
    final minPriceController = TextEditingController(text: _minPrice?.toString() ?? '');
    final maxPriceController = TextEditingController(text: _maxPrice?.toString() ?? '');
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24, right: 24, top: 24),
          child: StatefulBuilder(
            builder: (context, setModalState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Filtra risultati', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  items: [DropdownMenuItem(value: '', child: Text('Tutte le località'))] +
                    _allLocations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                  onChanged: (val) => setModalState(() => _selectedLocation = val ?? ''),
                  decoration: const InputDecoration(labelText: 'Località'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedRoomType,
                  items: [DropdownMenuItem(value: '', child: Text('Tutte le tipologie'))] +
                    _allRoomTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (val) => setModalState(() => _selectedRoomType = val ?? ''),
                  decoration: const InputDecoration(labelText: 'Tipologia stanza'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Prezzo minimo'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: maxPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Prezzo massimo'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedLocation = '';
                          _selectedRoomType = '';
                          _minPrice = null;
                          _maxPrice = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Azzera filtri'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _minPrice = int.tryParse(minPriceController.text);
                          _maxPrice = int.tryParse(maxPriceController.text);
                        },);
                        Navigator.pop(context);
                      },
                      child: const Text('Applica'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                                  'Scopri le novità',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [backAvatar],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<List<PostModel>>(
                            stream: _postViewModel.postsStream,
                            builder: (context, postSnap) {
                              if (postSnap.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final posts = postSnap.data!;
                              final userData = userSnap.data!.data() as Map<String, dynamic>;
                              final userGender = userData['gender'] ?? '';
                              final userInfo = userData['info'] ?? '';

                              List<PostModel> compatiblePosts = [];
                              List<Map<String, dynamic>> incompatiblePosts = [];
                              for (final post in posts) {
                                // FILTRI
                                if ((_selectedLocation != null && _selectedLocation != '' && post.location != _selectedLocation) ||
                                    (_selectedRoomType != null && _selectedRoomType != '' && post.roomType != _selectedRoomType) ||
                                    (_minPrice != null && post.rent < _minPrice!) ||
                                    (_maxPrice != null && post.rent > _maxPrice!)) {
                                  continue;
                                }
                                // COMPATIBILITÀ
                                bool genderOk = post.requiredGender == 'Entrambi' || post.requiredGender == userGender;
                                bool infoOk = post.requiredStudent == 'Tutti' || post.requiredStudent == userInfo;
                                if (genderOk && infoOk) {
                                  compatiblePosts.add(post);
                                } else {
                                  String incompatReason = '';
                                  if (!genderOk && !infoOk) {
                                    incompatReason = 'Annuncio rivolto a studenti di altri enti e di altro genere';
                                  } else if (!genderOk) {
                                    incompatReason = 'Annuncio rivolto ad un genere diverso';
                                  } else {
                                    incompatReason = 'Annuncio rivolto a studenti di altri enti';
                                  }
                                  incompatiblePosts.add({'post': post, 'reason': incompatReason});
                                }
                              }
                              if (_sortByPrice) {
                                compatiblePosts.sort((a, b) => a.rent.compareTo(b.rent));
                                incompatiblePosts.sort((a, b) => (a['post'] as PostModel).rent.compareTo((b['post'] as PostModel).rent));
                              }
                              return SingleChildScrollView(
                                padding: const EdgeInsets.only(bottom: 72),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StickyHeader(
                                      header: Container(
                                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                        color: Theme.of(context).colorScheme.surface,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => _openFilterModal(posts),
                                                child: Container(
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(width: 8),
                                                      Icon(Icons.search, color: Theme.of(context).hintColor),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: _buildActiveFiltersSummary(),
                                                      ),
                                                      if (_selectedLocation != '' || _selectedRoomType != '' || _minPrice != null || _maxPrice != null)
                                                        IconButton(
                                                          icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.secondary),
                                                          onPressed: () {
                                                            setState(() {
                                                              _selectedLocation = '';
                                                              _selectedRoomType = '';
                                                              _minPrice = null;
                                                              _maxPrice = null;
                                                            });
                                                          },
                                                          tooltip: 'Azzera filtri',
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: Icon(Icons.tune_rounded),
                                              onPressed: () {
                                                setState(() {
                                                  _sortByPrice = !_sortByPrice;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(_sortByPrice
                                                      ? 'Annunci ordinati per prezzo crescente'
                                                      : 'Ordinamento per prezzo disattivato'),
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: (compatiblePosts.isEmpty && incompatiblePosts.isEmpty)
                                            ? Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 32),
                                                  child: Text(
                                                    'Nessun risultato trovato',
                                                    style: Theme.of(context).textTheme.bodyLarge,
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ...compatiblePosts.map((post) {
                                                    final postIds = (userData['postIds'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
                                                    final isLiked = postIds.contains(post.id);
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
                                                            final user = FirebaseAuth.instance.currentUser;
                                                            if (user == null) return;
                                                            final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
                                                            if (isLiked) {
                                                              await userDoc.update({
                                                                'postIds': FieldValue.arrayRemove([post.id])
                                                              });
                                                            } else {
                                                              await userDoc.update({
                                                                'postIds': FieldValue.arrayUnion([post.id])
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                  if (incompatiblePosts.isNotEmpty) ...[
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                      child: Center(
                                                        child: Text(
                                                          'Annunci non compatibili con il tuo profilo',
                                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                color: Colors.red,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    ...incompatiblePosts.map((entry) {
                                                      final post = entry['post'] as PostModel;
                                                      final reason = entry['reason'] as String;
                                                      final postIds = (userData['postIds'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
                                                      final isLiked = postIds.contains(post.id);
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
                                                              final user = FirebaseAuth.instance.currentUser;
                                                              if (user == null) return;
                                                              final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
                                                              if (isLiked) {
                                                                await userDoc.update({
                                                                  'postIds': FieldValue.arrayRemove([post.id])
                                                                });
                                                              } else {
                                                                await userDoc.update({
                                                                  'postIds': FieldValue.arrayUnion([post.id])
                                                                });
                                                              }
                                                            },
                                                            incompatibilityBanner: reason,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ]
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  color: Theme.of(context).colorScheme.surface,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed:() => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => FavoritesPage()),
                        )
                      ),
                      IconButton(
                        icon: Icon(Icons.message_outlined),
                        onPressed:() => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ConversationsPage()),
                        )
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFiltersSummary() {
    List<String> filters = [];
    if (_selectedLocation != null && _selectedLocation != '') filters.add(_selectedLocation!);
    if (_selectedRoomType != null && _selectedRoomType != '') filters.add(_selectedRoomType!);
    if (_minPrice != null) filters.add('Min €$_minPrice');
    if (_maxPrice != null) filters.add('Max €$_maxPrice');
    if (filters.isEmpty) return Text('Cerca (filtri)', style: TextStyle(color: Theme.of(context).hintColor));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(f, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        )).toList(),
      ),
    );
  }
}

class ListingCard extends StatelessWidget {
  final String imageUrl;
  final String location;
  final String roomType;
  final String price;
  final String postId;
  final bool isLiked;
  final VoidCallback onFavorite;
  final String? incompatibilityBanner;

  const ListingCard({super.key, 
    required this.imageUrl,
    required this.location,
    required this.roomType,
    required this.price,
    required this.postId,
    required this.isLiked,
    required this.onFavorite,
    this.incompatibilityBanner,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 7,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.grey[300]),
                ),
                if (incompatibilityBanner != null) Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    color: Colors.red.withOpacity(0.85),
                    child: Text(
                      incompatibilityBanner!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: IconButton(
                      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: Theme.of(context).colorScheme.secondary),
                      onPressed: onFavorite,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 20, color: Colors.grey[700]),
                    const SizedBox(width: 4),
                    Text(location, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.bed_rounded, size: 24, color: Colors.grey[700]),
                    const SizedBox(width: 4),
                    Text(roomType, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    )),
                  ],
                ),
                Text('€ $price', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}