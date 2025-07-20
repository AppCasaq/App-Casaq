import 'package:casaq/ui/screens/studente/search_page.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../viewmodels/user_viewmodel.dart';
import 'login_page.dart';


class RegisterStudentePage extends StatefulWidget {
  const RegisterStudentePage({super.key});

  @override
  State<RegisterStudentePage> createState() => _RegisterStudentePageState();
}

class _RegisterStudentePageState extends State<RegisterStudentePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final _dataNascitaMask = MaskTextInputFormatter(mask: '##/##/####');
  String? _selectedGender;
  String? _selectedEnte;
  String _errorMessage = '';
  final UserViewModel _userViewModel = UserViewModel();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final user = await _userViewModel.registerUser(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        birth: _birthDateController.text.trim(),
        gender: _selectedGender ?? '',
        info: _selectedEnte ?? '',
        type: "Studente",
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Errore durante la registrazione: \\${e.toString()}');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Registrati come Studente",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextFormField(
                    controller: _nameController,
                    label: 'Nome',
                    validator: (value) =>
                        value!.isEmpty ? 'Inserisci il nome' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _surnameController,
                    label: 'Cognome',
                    validator: (value) =>
                        value!.isEmpty ? 'Inserisci il cognome' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _emailController,
                    label: 'Email',
                    validator: (value) =>
                        value!.contains('@') ? null : 'Email non valida',
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: (value) => value!.length >= 6
                        ? null
                        : 'Minimo 6 caratteri richiesti',
                  ),
                  const SizedBox(height: 20),
                  _buildGenderDropdown(),
                  const SizedBox(height: 20),
                  _buildEnteDropdown(),
                  const SizedBox(height: 20),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error
                      ),
                    ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Registrati",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      ),
                      child: Text("Hai già un account? Accedi", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  InputDecoration _inputDecoration(String label, [String? hint]) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12))),
    ).applyDefaults(Theme.of(context).inputDecorationTheme);
  }
  
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: _inputDecoration(label),
      validator: validator,
    );
  }
  Widget _buildDateField() {
    return TextFormField(
      controller: _birthDateController,
      decoration: _inputDecoration("Data di nascita","GG/MM/AAAA"),
      inputFormatters: [_dataNascitaMask],
      keyboardType: TextInputType.datetime,
      validator: (value) => _validateDate(value!),
    );
  }
  String? _validateDate(String value) {
    if (value.isEmpty) return 'Inserisci la data di nascita';
    if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
      return 'Formato data non valido';
    }
    return null;
  }
  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      items: const ['Uomo', 'Donna']
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (value) => setState(() => _selectedGender = value),
      decoration: _inputDecoration("Genere"),
      validator: (value) =>
          value == null ? 'Seleziona il tuo genere' : null,
    );
  }
  Widget _buildEnteDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedEnte,
      items: const ["Università degli Studi dell'Aquila", "Accademia di Belle Arti", "Accademia Guardia di Finanza", "Conservatorio Casella"]
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (value) => setState(() => _selectedEnte = value),
      decoration: _inputDecoration("Ente"),
      validator: (value) =>
          value == null ? "Seleziona l'ente" : null,
    );
  }
}