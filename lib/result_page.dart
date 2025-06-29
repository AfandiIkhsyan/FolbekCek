import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'instagram_analyzer_service.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageSate();
}

class _ResultPageSate extends State<ResultPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analyzer = context.read<InstagramAnalyzerService>();

    final notFollowingBack = analyzer.notFollowingBack
        .where((user) => user.toLowerCase().contains(_searchQuery))
        .toList();
    final following = analyzer.following
        .where((user) => user.toLowerCase().contains(_searchQuery))
        .toList();
    final followers = analyzer.followers
        .where((user) => user.toLowerCase().contains(_searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Analisis'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildStatCard('Mengikuti', analyzer.following.length, Colors.blue)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard('Pengikut', analyzer.followers.length, Colors.pink)),
              ],
            ),
            const SizedBox(height: 10),
            _buildStatCard('Tidak Follow Balik', analyzer.notFollowingBack.length, Colors.amber, isHighlighted: true),
            const SizedBox(height: 20),

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari username...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 10),

            TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: [
                Tab(text: 'Tidak Follow Balik (${notFollowingBack.length})'),
                Tab(text: 'Mengikuti (${following.length})'),
                Tab(text: 'Pengikut (${followers.length})'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildResultList(notFollowingBack),
                  _buildResultList(following),
                  _buildResultList(followers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int value, Color color, {bool isHighlighted = false}) {
    return Card(
      color: isHighlighted ? color.withOpacity(0.3) : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isHighlighted ? color : Colors.transparent, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultList(List<String> users) {
    if (users.isEmpty) {
      return const Center(child: Text('Tidak ada data yang cocok.'));
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(user[0].toUpperCase()),
          ),
          title: Text(user),
        );
      },
    );
  }
}