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
  // Kontroleri za tekstualna polja
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController spotsController = TextEditingController();

  // Promenljive za kategoriju (VAŽNO: selectedCategory mora biti null na početku da bi hint radio)
  String? selectedCategory;
  String? selectedCategoryColor;
  bool _isLoading = false;

  // FUNKCIJA ZA SNIMANJE U BAZU
  Future<void> _handleCreateEvent() async {
    if (nameController.text.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Popunite naziv i izaberite kategoriju!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

      // Automatsko kreiranje kolekcije 'events' i upis dokumenta
      await FirebaseFirestore.instance.collection('events').add({
        'title': nameController.text.trim(),
        'description': descController.text.trim(),
        'location': locationController.text.trim(),
        'date': dateController.text.trim(),
        'time': timeController.text.trim(),
        'category': selectedCategory, // Ime (npr. MUZIKA)
        'categoryColor':
            selectedCategoryColor ?? "0xFF2B8CBF", // Boja iz kategorije
        'spots': int.tryParse(spotsController.text) ?? 0,
        'freeSpots': int.tryParse(spotsController.text) ?? 0,
        'creatorId': uid,
        'participants': [], // Prazna lista za početak
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showSuccessPopup();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Greška pri čuvanju: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // WIDGET ZA DROPDOWN KOJI RADI SA HINTOM
  Widget _buildDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: LinearProgressIndicator());
        }

        var docs = snapshot.data!.docs;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFADD8E6)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text(
                "Izaberi kategoriju",
              ), // Hint se vidi kad je value == null
              value: selectedCategory,
              items: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final String name = data['name'] ?? "";
                final String color = data['color'] ?? "0xFF2B8CBF";

                return DropdownMenuItem<String>(
                  value: name,
                  // onTap se dešava pre onChanged - idealno da "uhvatimo" boju
                  onTap: () {
                    selectedCategoryColor = color;
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(int.parse(color)),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
            ),
          ),
        );
      },
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
                      hintText: "Lokacija (npr. Novi Sad)",
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
                      hintText: "Ukupan broj mesta",
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

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("USPEH! 🎉", textAlign: TextAlign.center),
        content: const Text("Vaš događaj je sada javan i vidljiv svima."),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      const MainNavigationScreen(isGuest: false),
                ),
                (route) => false,
              ),
              child: const Text(
                "NASTAVI",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
