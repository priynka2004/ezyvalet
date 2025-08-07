import 'package:flutter/material.dart';

class HomeTasksScreen extends StatefulWidget {
  const HomeTasksScreen({super.key});

  @override
  State<HomeTasksScreen> createState() => _HomeTasksScreenState();
}

class _HomeTasksScreenState extends State<HomeTasksScreen> {
  int selectedTabIndex = 0; // 0 => Drop-offs, 1 => Pick-ups
  int bottomIndex = 0;

  final sampleData = [
    {'name': 'Ethan Harper', 'vehicle': 'Toyota Camry'},
    {'name': 'Olivia Bennett', 'vehicle': 'Honda Civic'},
    {'name': 'Noah Carter', 'vehicle': 'Ford Focus'},
    {'name': 'Isabella Foster', 'vehicle': 'Chevrolet Cruze'},
    {'name': 'Liam Murphy', 'vehicle': 'Nissan Altima'},
  ];

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFBF8F3);
    final accent = const Color(0xFF7B563C);
    final lightCard = const Color(0xFFF6F3EE);
    final muted = Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'EzyValet',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Search
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: muted),
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                ),
              ),

              // Tabs
              Row(
                children: [
                  _tabButton('Drop-offs', 0, selectedTabIndex, accent),
                  const SizedBox(width: 12),
                  _tabButton('Pick-ups', 1, selectedTabIndex, accent),
                ],
              ),

              const SizedBox(height: 12),

              // Section title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedTabIndex == 0 ? 'Drop-offs' : 'Pick-ups',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24, top: 6),
                  itemCount: sampleData.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = sampleData[index];
                    return _taskRow(
                      name: item['name']!,
                      vehicle: item['vehicle']!,
                      lightCard: lightCard,
                      accent: accent,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _tabButton(String label, int idx, int selected, Color accent) {
    final isSelected = idx == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTabIndex = idx),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black87 : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // underline
            Container(
              height: 3,
              width: 48,
              decoration: BoxDecoration(
                color: isSelected ? accent : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskRow({
    required String name,
    required String vehicle,
    required Color lightCard,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // subtle shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // left: avatar placeholder
          CircleAvatar(
            radius: 22,
            backgroundColor: lightCard,
            child: Text(name.split(' ').map((e) => e[0]).take(2).join(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),

          // middle: name + vehicle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(vehicle,
                    style: TextStyle(fontSize: 13, color: accent.withOpacity(0.95))),
              ],
            ),
          ),

          // right: completed pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F1EA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Completed',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B5A49)),
            ),
          ),
        ],
      ),
    );
  }
}
