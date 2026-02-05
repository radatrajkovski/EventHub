import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_hub/screens/main_screen.dart';
import 'package:event_hub/widgets/customtTextField.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController spotsController = TextEditingController();

  String? selectedCategory;
  final List<String> categories = [
    'Tehnologija',
    'Muzika',
    'Sport',
    'Edukacija',
  ];
  bool _isLoading = false;

  // FUNKCIJA ZA SNIMANJE U BAZU
  Future<void> _handleCreateEvent() async {
    if (nameController.text.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Popunite naziv i kategoriju!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // PREUZIMANJE UID-a TRENUTNOG KORISNIKA
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

      await FirebaseFirestore.instance.collection('events').add({
        'title': nameController.text.trim(),
        'description': descController.text.trim(),
        'location': locationController.text.trim(),
        'date': dateController.text.trim(),
        'time': timeController.text.trim(),
        'category': selectedCategory!.toUpperCase(),
        'spots': int.tryParse(spotsController.text) ?? 0,
        'freeSpots': int.tryParse(spotsController.text) ?? 0,
        'creatorId': uid, // Povezujemo događaj sa korisnikom
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showSuccessPopup();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Greška: ${e.toString()}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("JEJ! 🎉", textAlign: TextAlign.center),
        content: const Text(
          "Događaj je uspešno kreiran!",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MainNavigationScreen(isGuest: false),
                ),
                (route) => false,
              ),
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kreiraj događaj",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      hintText: "Naziv događaja",
                      controller: nameController,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 20),
                    _buildLargeDescriptionField(),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: "Lokacija",
                      controller: locationController,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: "Datum",
                            controller: dateController,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            hintText: "Vreme",
                            controller: timeController,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: "Broj mesta",
                      controller: spotsController,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _handleCreateEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B8CBF),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "KREIRAJ DOGAĐAJ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Tvoji pomoćni widgeti (_buildLargeDescriptionField, _buildDropdown) idu ovde...
  Widget _buildLargeDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFADD8E6)),
      ),
      child: TextField(
        controller: descController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: "Opis događaja...",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFADD8E6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          hint: const Text("Izaberi kategoriju"),
          isExpanded: true,
          items: categories
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (val) => setState(() => selectedCategory = val),
        ),
      ),
    );
  }
}
