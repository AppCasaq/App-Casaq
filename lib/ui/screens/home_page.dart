import 'auth/register_page.dart';
import 'auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/Castello_Home.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/Logo_banner.png',
              width: MediaQuery.of(context).size.width * 0.8,
              height: 120,
              fit: BoxFit.contain,
            ),
            for (final _btn in [
              _AuthBtnData(
                text: 'Registrati',
                icon: FontAwesomeIcons.userPlus,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
              ),
              _AuthBtnData(
                text: 'Accedi con email',
                icon: Icons.email_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                ),
              ),
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton.icon(
                  icon: FaIcon(_btn.icon),
                  label: Text(_btn.text),
                  onPressed: _btn.onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.7, MediaQuery.of(context).size.height * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AuthBtnData {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  
  const _AuthBtnData({
    required this.text,
    required this.icon,
    required this.onPressed,
  });
}