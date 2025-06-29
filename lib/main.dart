import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'instagram_analyzer_service.dart';
import 'result_page.dart';
import 'guide_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => InstagramAnalyzerService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnFollowCheck',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A233A),
        cardColor: const Color(0xFF253354),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF253354),
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
          brightness: Brightness.dark,
          accentColor: Colors.lightBlueAccent,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final analyzer = context.watch<InstagramAnalyzerService>();
    final analyzerReader = context.read<InstagramAnalyzerService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('UnFollowCheck'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GuidePage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.shield_outlined, size: 80, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 20),
              Text(
                'Analisis Follower Secara Aman',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              const Text(
                'Aplikasi ini tidak meminta password dan bekerja 100% offline di perangkat Anda. Data Anda tetap aman.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 40),
              
              ElevatedButton.icon(
                icon: const Icon(Icons.file_upload),
                label: const Text('Pilih & Analisis File .ZIP'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.black,
                ),
                onPressed: analyzer.isLoading
                    ? null
                    : () async {
                        final success = await analyzerReader.pickAndProcessZipFile();
                        if (success && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ResultPage()),
                          );
                        }
                      },
              ),
              const SizedBox(height: 20),

              if (analyzer.isLoading)
                Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(analyzer.statusMessage, style: const TextStyle(color: Colors.white70)),
                  ],
                )
              else
                if (analyzer.statusMessage.toLowerCase().contains('error'))
                  Text(
                    analyzer.statusMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  )
            ],
          ),
        ),
      ),
    );
  }
}