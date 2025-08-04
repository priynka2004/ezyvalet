import 'package:flutter/material.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Staff',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Staff',
                  hintStyle: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9C854A),
                  fontWeight: FontWeight.w500,
                ),
                  border: InputBorder.none,
                  icon: Icon(Icons.search,  color: Color(0xFF9C854A),),
                ),
              ),
            ),
          ),
          Expanded(child: _buildStaffList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFFC107), // Yellow
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Staff',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStaffList() {
    final staff = [
      {'name': 'Ethan Harper', 'id': '123456'},
      {'name': 'Sophia Bennett', 'id': '789012'},
      {'name': 'Liam Carter', 'id': '345678'},
      {'name': 'Olivia Davis', 'id': '901234'},
      {'name': 'Noah Evans', 'id': '567890'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: staff.length,
      itemBuilder: (context, index) {
        final member = staff[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: AssetImage('assets/images/images.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('ID: ${member['id']!}',  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9C854A),
                      fontWeight: FontWeight.w500,
                    ),),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
