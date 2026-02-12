import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_hub/models/event_card.dart';
import 'package:event_hub/widgets/backHeader_widget.dart';
import 'package:event_hub/widgets/customtTextField.dart';
import 'package:event_hub/widgets/event_details_widget.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;
  final bool isGuest;
  final bool isEditing;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.isGuest,
    this.isEditing = false,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _spotsController;
  late TextEditingController _descriptionController;
  bool _isLoadingCategories = true;
  List<String> _categoryNames = [];
  String? _selectedCategory;
  Map<String, Color> _categoryColorMap = {};
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _titleController = TextEditingController(text: widget.event.title);
    _locationController = TextEditingController(text: widget.event.location);
    _dateController = TextEditingController(text: widget.event.date);
    _timeController = TextEditingController(text: widget.event.time);
    _spotsController = TextEditingController(
      text: widget.event.spots.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.event.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _spotsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchWeather(String location) async {
    try {
      final parts = location.split(',');
      final city = parts.length > 1 ? parts.last.trim() : parts.first.trim();
      final encodedCity = Uri.encodeComponent(city);
      const apiKey = 'e67ca10c5442e532eb31621f7ae5aee1';
      final url =
          'https://api.openweathermap.org/data/2.5/weather?q=$encodedCity&appid=$apiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Grad nije pronađen');
      }
    } catch (e) {
      throw Exception('Problem sa konekcijom');
    }
  }

  Future<void> _handleJoin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _isJoining = true);
    DocumentReference eventRef = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(eventRef);
        if (!snapshot.exists) return;

        int currentFree = snapshot['freeSpots'] ?? 0;
        List participants = snapshot['participants'] ?? [];

        if (participants.contains(user.uid)) throw "Već ste prijavljeni!";
        if (currentFree <= 0) throw "Nema više slobodnih mesta.";

        transaction.update(eventRef, {
          'freeSpots': currentFree - 1,
          'participants': FieldValue.arrayUnion([user.uid]),
        });
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Uspešno ste se prijavili! 🎉")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("JEJ! 🎉", textAlign: TextAlign.center),
        content: const Text(
          "Događaj je uspešno izmenjen!",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateEvent() async {
    setState(() => _isJoining = true);
    try {
      int zauzetaMesta = widget.event.spots - widget.event.freeSpots;
      int noviUkupniBroj =
          int.tryParse(_spotsController.text) ?? widget.event.spots;
      int novaSlobodnaMesta = noviUkupniBroj - zauzetaMesta;

      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .update({
            'title': _titleController.text,
            'location': _locationController.text,
            'date': _dateController.text,
            'time': _timeController.text,
            'description': _descriptionController.text,
            'spots': noviUkupniBroj,
            'freeSpots': novaSlobodnaMesta < 0 ? 0 : novaSlobodnaMesta,
          });

      _showSuccessDialog();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Greška pri čuvanju: $e")));
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final bool actualIsGuest = widget.isGuest || user == null;
    final bool isCreator = !actualIsGuest && user.uid == widget.event.creatorId;
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .snapshots(),
      builder: (context, snapshot) {
        int liveFreeSpots = widget.event.freeSpots;
        List participants = [];

        if (snapshot.hasData && snapshot.data!.exists) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          liveFreeSpots = data['freeSpots'] ?? 0;
          participants = data['participants'] ?? [];
        }

        final bool isAlreadyJoined = participants.contains(currentUserId);
        final bool isFull = liveFreeSpots <= 0;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                const BackHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategoryBadge(),
                        const SizedBox(height: 16),

                        widget.isEditing
                            ? _buildEditFields()
                            : _buildInfoDisplay(
                                widget.event,
                                liveFreeSpots,
                                isCreator,
                              ),

                        const SizedBox(height: 25),
                        _buildWeatherSection(widget.event.location),
                        const SizedBox(height: 30),
                        const Text(
                          "O događaju",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDescriptionSection(),
                        const SizedBox(height: 40),

                        if (!isCreator)
                          ElevatedButton(
                            onPressed:
                                (widget.isGuest ||
                                    isFull ||
                                    isAlreadyJoined ||
                                    _isJoining)
                                ? null
                                : _handleJoin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isAlreadyJoined
                                  ? Colors.green
                                  : (widget.isGuest || isFull
                                        ? Colors.grey.shade400
                                        : const Color(0xFF2B8CBF)),
                              disabledBackgroundColor: Colors.grey.shade300,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isJoining
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    widget.isGuest
                                        ? "PRIJAVITE SE ZA UČEŠĆE"
                                        : (isAlreadyJoined
                                              ? "PRIJAVLJENI STE"
                                              : (isFull
                                                    ? "POPUNJENO"
                                                    : "PRIDRUŽI SE DOGAĐAJU")),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),

                        if (isCreator && !widget.isEditing)
                          const Center(
                            child: Text(
                              "Vi ste organizator ovog događaja",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),

                        if (widget.isEditing)
                          ElevatedButton(
                            onPressed: _updateEvent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B8CBF),
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "SAČUVAJ IZMENE",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherSection(String location) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchWeather(location),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text("Greška: ${snapshot.error}");
        }
        final temp = snapshot.data!['main']['temp'].round();
        final desc = snapshot.data!['weather'][0]['description'];
        final icon = snapshot.data!['weather'][0]['icon'];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Image.network(
                "https://openweathermap.org/img/wn/$icon@2x.png",
                width: 45,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Trenutno: $temp°C",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    desc[0].toUpperCase() + desc.substring(1),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryBadge() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('categories')
          .where('name', isEqualTo: widget.event.category)
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        Color categoryColor = Colors.grey;

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          var data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          String hexColor = data['color'] ?? "0xFF2B8CBF";

          try {
            categoryColor = Color(
              int.parse(hexColor.replaceAll('0x', ''), radix: 16),
            );
          } catch (e) {
            categoryColor = const Color(0xFF2B8CBF);
          }
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: categoryColor, width: 1),
          ),
          child: Text(
            widget.event.category.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: categoryColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoDisplay(EventModel event, int free, bool isCreator) {
    int taken = event.spots - free;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 25),
        EventInfoTile(
          icon: Icons.calendar_today_outlined,
          label: "Datum",
          value: event.date,
        ),
        EventInfoTile(
          icon: Icons.access_time,
          label: "Vreme",
          value: event.time,
        ),
        EventInfoTile(
          icon: Icons.location_on_outlined,
          label: "Lokacija",
          value: event.location,
        ),
        isCreator
            ? EventInfoTile(
                icon: Icons.analytics_outlined,
                label: "Popunjenost (Admin)",
                value: "$taken / ${event.spots} prijavljenih",
              )
            : EventInfoTile(
                icon: Icons.people_outline,
                label: "Slobodna mesta",
                value: "$free mesta",
              ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return widget.isEditing
        ? CustomTextField(
            width: double.infinity,
            hintText: "Opis",
            controller: _descriptionController,
            maxLines: 5,
          )
        : Text(
            widget.event.description,
            style: const TextStyle(fontSize: 15, height: 1.6),
          );
  }

  Widget _buildEditFields() {
    return Column(
      children: [
        _editLabel("Naziv događaja"),
        CustomTextField(
          width: double.infinity,
          hintText: "Naziv",
          controller: _titleController,
        ),
        const SizedBox(height: 16),
        _editLabel("Lokacija"),
        CustomTextField(
          width: double.infinity,
          hintText: "Lokacija",
          controller: _locationController,
        ),
        const SizedBox(height: 16),
        _editLabel("Ukupan broj mesta"),
        CustomTextField(
          width: double.infinity,
          hintText: "Broj mesta",
          controller: _spotsController,
        ),
        const SizedBox(height: 16),
        _editLabel("Datum"),
        CustomTextField(
          width: double.infinity,
          hintText: "Datum",
          controller: _dateController,
        ),
        const SizedBox(height: 16),
        _editLabel("Vreme"),
        CustomTextField(
          width: double.infinity,
          hintText: "Vreme",
          controller: _timeController,
        ),
      ],
    );
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .get();

      Map<String, Color> tempColors = {};
      List<String> tempNames = [];

      for (var doc in snapshot.docs) {
        final name = doc['name'] as String;
        tempNames.add(name);

        String hexColor = doc.data().containsKey('color')
            ? doc['color']
            : "0xFF2B8CBF";
        tempColors[name] = _parseColor(hexColor);
      }

      if (mounted) {
        setState(() {
          _categoryNames = tempNames;
          _categoryColorMap = tempColors;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      debugPrint("Greška pri učitavanju: $e");
      if (mounted) setState(() => _isLoadingCategories = false);
    }
  }

  Widget _editLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    ),
  );
}

Color _parseColor(String hexString) {
  try {
    String cleanedHex = hexString
        .replaceAll('0x', '')
        .replaceAll('#', '')
        .trim();

    if (cleanedHex.length == 6) {
      cleanedHex = 'FF$cleanedHex';
    }

    return Color(int.parse(cleanedHex, radix: 16));
  } catch (e) {
    return const Color(0xFF2B8CBF);
  }
}
