import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/models/event_card.dart';
import 'package:event_hub/screens/login_screen.dart';
import 'package:event_hub/widgets/event_card.dart';
import 'package:flutter/material.dart';

class EventsFeedScreen extends StatefulWidget {
  final bool isGuest;
  const EventsFeedScreen({super.key, required this.isGuest});

  @override
  State<EventsFeedScreen> createState() => _EventsFeedScreenState();
}

class _EventsFeedScreenState extends State<EventsFeedScreen> {

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  Map<String, Color> _categoryColors = {};
  bool _isCategoriesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryColors();
  }

  
  Future<void> _loadCategoryColors() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .get();
      Map<String, Color> tempColors = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final String name = data['name'] ?? "";
        final String hexColor = data['color'] ?? "0xFF2B8CBF";
        tempColors[name] = _parseColor(hexColor);
      }
      if (mounted) {
        setState(() {
          _categoryColors = tempColors;
          _isCategoriesLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Greška pri učitavanju kategorija: $e");
      if (mounted) setState(() => _isCategoriesLoading = false);
    }
  }

  Color _parseColor(String hexString) {
    try {
      String cleanedHex = hexString
          .replaceAll('0x', '')
          .replaceAll('#', '')
          .trim();
      return Color(int.parse(cleanedHex, radix: 16));
    } catch (e) {
      return const Color(0xFF2B8CBF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/logo2.png',
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 35),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Otkrijte događaje",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Pretražite događaje...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF2B8CBF),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = "");
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isCategoriesLoading
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('events')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return const Center(child: Text("Greška!"));
                        if (!snapshot.hasData)
                          return const Center(
                            child: CircularProgressIndicator(),
                          );

                        // FILTRIRANJE LISTE NA OSNOVU PRETRAGE
                        final allDocs = snapshot.data!.docs;
                        final filteredDocs = allDocs.where((doc) {
                          final title = doc['title'].toString().toLowerCase();
                          return title.contains(_searchQuery);
                        }).toList();

                        if (filteredDocs.isEmpty) {
                          return const Center(
                            child: Text("Nema pronađenih događaja."),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredDocs.length,
                          itemBuilder: (context, index) {
                            final data =
                                filteredDocs[index].data()
                                    as Map<String, dynamic>;
                            final event = EventModel.fromFirestore(
                              data,
                              filteredDocs[index].id,
                            );

                            // Uzimamo boju iz naše mape
                            final color =
                                _categoryColors[event.category] ??
                                const Color(0xFF2B8CBF);

                            return Column(
                              children: [
                                if (index == 0 && widget.isGuest) ...[
                                  _buildGuestBanner(context),
                                  const SizedBox(height: 20),
                                ],
                                // Prosledi boju kartici da ona ne bi morala da je traži
                                EventCard(
                                  event: event,
                                  isGuest: widget.isGuest,
                                  // categoryColor: color, // Ako dodaš ovo polje u EventCard
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFB3E5FC)),
      ),
      child: Column(
        children: [
          const Text(
            "Prijavite se kako biste mogli da se pridružite događajima.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF2B8CBF), fontSize: 13),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B8CBF),
            ),
            child: const Text(
              "Prijavi se",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
