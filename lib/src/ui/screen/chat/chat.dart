import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        width: 200,
        backgroundColor: Colors.blue,
        elevation: 1,
        child: Center(child: Text('data'),),
      ),
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Messages", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.blueAccent, size: 30),
            onPressed: () {_scaffoldKey.currentState?.openEndDrawer();},
          ),
          SizedBox(width: 100,)
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search messages...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Horizontal Stories/Active Users
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 8,
              itemBuilder: (context, index) => _buildStoryItem(index),
            ),
          ),

          const Divider(height: 30, indent: 20, endIndent: 20),

          // Chat List
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) => _buildChatTile(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                child: const Icon(Icons.person, color: Colors.blueAccent),
              ),
              if (index % 2 == 0) // Mock "Online" status
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          const Text("User Name", style: TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildChatTile(int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: const CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=chat'), // Placeholder
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Alex Johnson", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text("12:45 PM", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Hey! Are we still meeting for coffee later today?",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            if (index == 0) // Mock unread count
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                child: const Text("2", style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}