import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../domain/models/post_model.dart';
import '../../viewmodels/post_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CreatePostPage extends StatefulWidget {
  static const String routeName = '/createAd';

  final PostModel? postToEdit;
  const CreatePostPage({super.key, this.postToEdit});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _rentController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedRoomType;
  String? _selectedLocation;
  String? _selectedStudentType;
  String? _selectedGender;

  final List<String> _roomTypes = ['Singola', 'Doppia', 'Multipla'];
  final List<String> _locations = ['Centro', 'Coppito', 'Scoppito'];
  final List<String> _studentTypes = ['Tutti','Accademia Guardia di Finanza',"Università degli Studi dell'Aquila",'Accademia di Belle Arti','Conservatorio',];
  final List<String> _genders = ['Entrambi', 'Uomo', 'Donna'];

  final PostViewModel _postViewModel = PostViewModel();

  List<XFile>? _selectedImages;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.postToEdit != null) {
      final post = widget.postToEdit!;
      _rentController.text = post.rent.toString();
      _descriptionController.text = post.description;
      _selectedRoomType = post.roomType;
      _selectedLocation = post.location;
      _selectedStudentType = post.requiredStudent;
      _selectedGender = post.requiredGender;
    }
  }

  @override
  void dispose() {
    _rentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images;
      });
    }
  }

  Future<String?> _uploadImage(XFile image, String postId) async {
    final ref = FirebaseStorage.instance.ref().child('post_images/$postId/${DateTime.now().millisecondsSinceEpoch}_${image.name}');
    final uploadTask = ref.putData(await image.readAsBytes());
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() { _isUploading = true; });
    String? imageUrl;
    String postId = '';
    try {
      if (widget.postToEdit != null) {
        // MODIFICA POST
        postId = widget.postToEdit!.id;
        final updateData = {
          'rent': int.tryParse(_rentController.text) ?? 0,
          'roomType': _selectedRoomType ?? '',
          'location': _selectedLocation ?? '',
          'requiredStudent': _selectedStudentType ?? '',
          'requiredGender': _selectedGender ?? '',
          'description': _descriptionController.text.trim(),
        };
        if (_selectedImages != null && _selectedImages!.isNotEmpty) {
          imageUrl = await _uploadImage(_selectedImages!.first, postId);
          updateData['imageUrl'] = imageUrl as Object;
        }
        await _postViewModel.updatePost(postId, updateData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Annuncio aggiornato correttamente')),
        );
        Navigator.of(context).pop();
      } else {
        // CREAZIONE POST
        final post = PostModel(
          id: '',
          rent: int.tryParse(_rentController.text) ?? 0,
          roomType: _selectedRoomType ?? '',
          location: _selectedLocation ?? '',
          requiredStudent: _selectedStudentType ?? '',
          requiredGender: _selectedGender ?? '',
          description: _descriptionController.text.trim(),
          userId: user.uid,
          createdAt: DateTime.now(),
          imageUrl: null,
        );
        postId = await _postViewModel.addPost(post);
        if (_selectedImages != null && _selectedImages!.isNotEmpty) {
          imageUrl = await _uploadImage(_selectedImages!.first, postId);
          await _postViewModel.updatePost(postId, {'imageUrl': imageUrl});
        }
        await _postViewModel.updatePost(postId, {'userId': user.uid});
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userDoc.update({
          'postIds': FieldValue.arrayUnion([postId])
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Annuncio creato correttamente')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: $e')),
      );
    } finally {
      setState(() { _isUploading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Theme.of(context).colorScheme.onSurface,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.postToEdit != null ? 'Modifica annuncio' : 'Nuovo annuncio',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _rentController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Canone mensile',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Inserisci il canone mensile'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedRoomType,
                            items: _roomTypes
                                .map((type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    )).toList(),
                            onChanged: (val) => setState(() => _selectedRoomType = val),
                            decoration: const InputDecoration(
                              labelText: 'Tipologia',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null
                                ? 'Seleziona una tipologia'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedLocation,
                            items: _locations
                                .map((loc) => DropdownMenuItem(
                                      value: loc,
                                      child: Text(loc),
                                    )).toList(),
                            onChanged: (val) => setState(() => _selectedLocation = val),
                            decoration: const InputDecoration(
                              labelText: 'Località',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null
                                ? 'Seleziona una località'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedStudentType,
                            items: _studentTypes
                                .map((stud) => DropdownMenuItem(
                                      value: stud,
                                      child: Text(stud),
                                    )).toList(),
                            onChanged: (val) => setState(() => _selectedStudentType = val),
                            decoration: const InputDecoration(
                              labelText: 'Studenti richiesti',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null
                                ? 'Seleziona il tipo di studenti'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            items: _genders
                                .map((g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(g),
                                    )).toList(),
                            onChanged: (val) => setState(() => _selectedGender = val),
                            decoration: const InputDecoration(
                              labelText: 'Genere richiesto',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null
                                ? 'Seleziona il genere'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 6,
                            decoration: const InputDecoration(
                              labelText: 'Descrizione',
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci una descrizione';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _pickImages,
                            icon: const Icon(Icons.image_outlined),
                            label: const Text('Aggiungi immagini'),
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              minimumSize: const Size.fromHeight(48),
                            ),
                          ),
                          if (_selectedImages != null && _selectedImages!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SizedBox(
                                height: 80,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedImages!.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                                  itemBuilder: (context, idx) => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_selectedImages![idx].path),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isUploading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              elevation: 2,
                            ),
                            child: Text(
                              widget.postToEdit != null ? 'Salva modifiche' : 'Crea annuncio',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
