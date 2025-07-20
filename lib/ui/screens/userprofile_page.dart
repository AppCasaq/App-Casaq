import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/user_model.dart';
import '../../ui/viewmodels/user_viewmodel.dart';
import 'home_page.dart';

class UserProfilePage extends StatelessWidget {
  final UserViewModel _userViewModel = UserViewModel();
  UserProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await _userViewModel.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profilo',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: StreamBuilder<UserModel?>(
          stream: _userViewModel.currentUserStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text('Nessun dato disponibile', style: Theme.of(context).textTheme.bodyLarge),
              );
            }
            final data = snapshot.data!;
            return Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/images/icona_${data.gender}.png"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${data.name} ${data.surname}',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  data.type,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(icon: Icons.logout, label: 'Log Out', onPressed: () => _logout(context),),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26, offset: Offset(0, -2))],
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text('Impostazioni', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16),
                        _SettingTile(icon: Icons.info_outlined, title: 'Info', fieldKey: 'info', currentValue: data.info, uid: data.uid),
                        _SettingTile(icon: Icons.email_outlined,title: 'Email', fieldKey: 'email', currentValue: FirebaseAuth.instance.currentUser?.email ?? '', uid: data.uid),
                        _SettingTile(icon: Icons.lock_outline, title: 'Password', fieldKey: 'password', currentValue: '********', uid: data.uid),
                        _SettingTile(icon: Icons.person_outline, title: 'Nome', fieldKey: 'name', currentValue: data.name, uid: data.uid),
                        _SettingTile(icon: Icons.person_outline, title: 'Cognome', fieldKey: 'surname', currentValue: data.surname, uid: data.uid),
                        const SizedBox(height: 24),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: 'Hai bisogno di assistenza?\nContatta ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [TextSpan(text: 'casaq.app@gmail.com', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary))],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String uid,
    String fieldKey,
    String title,
    String currentValue) {
    final formKey = GlobalKey<FormState>();
    String newValue = currentValue;
    List<String> type= ["errore","errore","errore"];
    if(currentValue=="Locatore"||currentValue=="Agenzia"||currentValue=="Proprietario"){
      type= ['Locatore', 'Proprietario', 'Agenzia'];
    }else if(currentValue=="Università degli Studi dell'Aquila"||currentValue=="Accademia di Belle Arti"||currentValue=="Accademia Guardia di Finanza"||currentValue=="Conservatorio Casella"){
      type= ["Università degli Studi dell'Aquila", "Accademia di Belle Arti", "Accademia Guardia di Finanza", "Conservatorio Casella"];
    }
    String passwordForReauth = '';
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Modifica $title'),
        content: Form(
          key: formKey,
          child: 
              fieldKey =='info'
                ? DropdownButtonFormField<String>(
                  value: currentValue.isNotEmpty ? currentValue : null,
                  items: type
                    .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                    .toList(),
                  onChanged: (val) => newValue = val ?? currentValue,
                  validator: (val) => val == null || val.isEmpty ? 'Seleziona un ente' : null,
                )
              : fieldKey == 'password'
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Nuova Password'),
                          onChanged: (val) => newValue = val,
                          validator: (val) => val != null && val.length >= 6 ? null : 'Min 6 caratteri',
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Conferma Password'),
                          validator: (val) => val == newValue ? null : 'Le password non corrispondono',
                        ),
                      ],
                    )
                  : fieldKey == 'email'
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: controller,
                              decoration: InputDecoration(labelText: 'Nuova Email'),
                              onChanged: (val) => newValue = val.trim(),
                              validator: (val) => val != null && RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(val) ? null : 'Email non valida',
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(labelText: 'Password'),
                              onChanged: (val) => passwordForReauth = val,
                              validator: (val) => val != null && val.isNotEmpty ? null : 'Inserisci password',
                            ),
                          ],
                        )
                      : TextFormField(
                          controller: controller,
                          decoration: InputDecoration(labelText: title),
                          onChanged: (val) => newValue = val.trim(),
                          validator: (val) {
                            if ((fieldKey == 'name' || fieldKey == 'surname') && (val == null || val.length < 2)) return 'Minimo 2 lettere';
                            if ((fieldKey == 'name' || fieldKey == 'surname') && RegExp(r"[0-9]").hasMatch(val!)) return 'Non permettere numeri';
                            return null;
                          },
                        ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Annulla')),
          TextButton(
            onPressed: () async {
              if (formKey.currentState?.validate() != true) return;
              Navigator.of(ctx).pop();
              final user = FirebaseAuth.instance.currentUser;
              try {
                if (fieldKey == 'email' && user != null) {
                    final cred = EmailAuthProvider.credential(email: user.email!, password: passwordForReauth);
                    await user.reauthenticateWithCredential(cred);
                    await user.verifyBeforeUpdateEmail(newValue);
                    await user.reload();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Controlla la tua email per continuare')));
                } else if (fieldKey == 'password' && user != null) {
                  await user.updatePassword(newValue);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password aggiornata')));
                } else if (fieldKey == 'info') {
                  await FirebaseFirestore.instance.collection('users').doc(uid).update({'info': newValue});
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Info aggiornata')));
                } else {
                  await FirebaseFirestore.instance.collection('users').doc(uid).update({fieldKey: newValue});
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title aggiornato')));
                }
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore: ${e.code}')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore: ${e.toString()}')));
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(icon: Icon(icon, size: 28), onPressed: onPressed, color: Theme.of(context).colorScheme.onPrimary),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String fieldKey;
  final String currentValue;
  final String uid;
  const _SettingTile({required this.icon, required this.title, required this.fieldKey, required this.currentValue, required this.uid});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currentValue, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
          IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => UserProfilePage()._showEditDialog(context, uid, fieldKey, title, currentValue)),
        ],
      ),
    );
  }
}