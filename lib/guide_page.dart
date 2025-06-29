// lib/guide_page.dart

import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cara Penggunaan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Selamat Datang di UnFollowCheck!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aplikasi ini 100% aman karena bekerja offline tanpa meminta password Anda. Ikuti 3 langkah mudah di bawah ini untuk memulai.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Divider(height: 32),

          // --- Langkah 1 ---
          _buildStep(
            context: context,
            step: '1',
            title: 'Unduh Data dari Instagram',
            content: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.white70),
                children: [
                  const TextSpan(text: 'Ini adalah langkah terpenting. Instagram memungkinkan Anda mengunduh data Anda sendiri secara resmi.\n\n'),
                  const TextSpan(text: 'A. Buka Instagram (aplikasi atau web), masuk ke Profil Anda lalu buka menu '),
                  const TextSpan(text: 'Pengaturan dan privasi → Pusat Akun.\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: 'B. Pilih '),
                  const TextSpan(text: 'Informasi dan izin Anda → Unduh informasi Anda.\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: 'C. Tekan "Minta unduhan", pilih profil Anda, lalu pilih tipe informasi '),
                  const TextSpan(text: '"Beberapa informasi Anda".\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: 'D. Di daftar yang muncul, centang HANYA bagian '),
                  const TextSpan(text: '"Pengikut dan diikuti".\n', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
                  const TextSpan(text: 'E. Di bagian bawah, pastikan Format adalah '),
                  const TextSpan(text: 'JSON', style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' dan Rentang tanggal adalah '),
                  const TextSpan(text: 'Semua.', style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: '\nF. Kirim permintaan dan tunggu email dari Instagram. Setelah itu, unduh file .zip yang mereka berikan.'),
                ],
              ),
            ),
          ),
          
          // --- Langkah 2 ---
          _buildStep(
            context: context,
            step: '2',
            title: 'Analisis di Aplikasi UnFollowCheck',
            content: const Text(
              'A. Buka kembali aplikasi ini.\n'
              'B. Tekan tombol "Pilih & Analisis File .ZIP".\n'
              'C. Pilih file .zip yang baru saja Anda unduh dari email.\n'
              'D. Biarkan aplikasi memproses data Anda sejenak.',
              style: TextStyle(fontSize: 15, height: 1.5, color: Colors.white70),
            ),
          ),

          // --- Langkah 3 ---
          _buildStep(
            context: context,
            step: '3',
            title: 'Lihat Hasil Analisis Anda',
            content: const Text(
              'A. Anda akan melihat ringkasan jumlah Following, Followers, dan yang terpenting, jumlah akun yang "Tidak Follow Balik".\n'
              'B. Gunakan Tab di bawah untuk melihat daftar lengkap dari setiap kategori.\n'
              'C. Gunakan kotak pencarian untuk menemukan nama pengguna spesifik dengan cepat.',
              style: TextStyle(fontSize: 15, height: 1.5, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat tampilan setiap langkah menjadi konsisten
  Widget _buildStep({
    required BuildContext context,
    required String step,
    required String title,
    required Widget content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Text(
              step,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }
}