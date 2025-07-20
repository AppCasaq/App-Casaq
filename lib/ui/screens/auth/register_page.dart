import 'registerlocatore_page.dart';
import 'registerstudente_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                  "Chi Sei?",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: size.width * 0.6,
                        height: size.height * 0.1,
                        child: ElevatedButton.icon(
                          icon: FaIcon(
                            FontAwesomeIcons.graduationCap,
                            size: 30,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          label: Text(
                            'Studente',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterStudentePage()),
                          ),
                          style: buttonStyle,
                        ),
                      ),
                      const SizedBox(height: 100),
                      SizedBox(
                        width: size.width * 0.6,
                        height: size.height * 0.1,
                        child: ElevatedButton.icon(
                          icon: Icon(
                            Icons.work,
                            size: 30,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          label: Text(
                            'Locatore',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterLocatorePage()),
                          ),
                          style: buttonStyle,
                        ),
                      ),
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
}
