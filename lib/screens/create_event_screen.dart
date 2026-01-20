import 'package:event_hub/widgets/backHeader_widget.dart';
import 'package:event_hub/widgets/customtTextField.dart';
import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController =
      TextEditingController(); // Dodao poseban kontroler za vreme
  final TextEditingController descController = TextEditingController();
  final TextEditingController spotsController = TextEditingController();

  String? selectedCategory;
  final List<String> categories = [
    'Tehnologija',
    'Muzika',
    'Sport',
    'Edukacija',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kreiraj događaj",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Osnovne informacije",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 30),
                    const Text(
                      "Dodatne informacije",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(),
                    const SizedBox(height: 20),
                    _buildSpotsField(),
                    const SizedBox(height: 40),

                    // --- POPRAVLJENO DUGME ---
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Događaj je uspešno kreiran!"),
                            backgroundColor: Color(0xFF2B8CBF),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B8CBF),
                        minimumSize: const Size(double.infinity, 56),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "KREIRAJ DOGAĐAJ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotsField() {
    return CustomTextField(
      controller: spotsController,
      hintText: "Broj slobodnih mesta",
      width: double.infinity,
    );
  }

  Widget _buildLargeDescriptionField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFADD8E6)),
      ),
      child: TextField(
        controller: descController,
        maxLines: 6,
        decoration: InputDecoration(
          hintText: "Unesite detaljan opis...",
          hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      width: double.infinity,
      height: 55, // Malo povećana visina da se slaže sa CustomTextField
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFADD8E6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          hint: Text(
            "Kategorija",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2B8CBF)),
          items: categories
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(c, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: (val) => setState(() => selectedCategory = val),
        ),
      ),
    );
  }
}
