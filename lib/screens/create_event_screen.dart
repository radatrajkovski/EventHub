import 'package:event_hub/screens/main_screen.dart';
import 'package:event_hub/widgets/customtTextField.dart';
import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  // 1. KONTROLERI ZA INPUT POLJA
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController spotsController = TextEditingController();

  // 2. KATEGORIJE
  String? selectedCategory;
  final List<String> categories = [
    'Tehnologija',
    'Muzika',
    'Sport',
    'Edukacija',
  ];

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    dateController.dispose();
    timeController.dispose();
    descController.dispose();
    spotsController.dispose();
    super.dispose();
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "JEJ! 🎉",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Događaj je uspešno kreiran!",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B8CBF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          MainNavigationScreen(isGuest: false),
                    ),
                    (route) =>
                        false, 
                  );
               
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //const BackHeader(),
            const SizedBox(height: 20),
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

                    // Naziv događaja
                    CustomTextField(
                      hintText: "Naziv događaja",
                      controller: nameController,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 20),

                   //Vece polje za opis
                    _buildLargeDescriptionField(),

                    const SizedBox(height: 20),

                    // Lokacija
                    CustomTextField(
                      hintText: "Lokacija",
                      controller: locationController,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 20),

                    //Datum i Vreme
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

                    // Kategorija Dropdown
                    _buildDropdown(),

                    const SizedBox(height: 20),

                    // Broj mesta
                    CustomTextField(
                      hintText: "Broj slobodnih mesta",
                      controller: spotsController,
                      width: double.infinity,
                                       ),

                    const SizedBox(height: 40),

                    // GLAVNO DUGME
                    ElevatedButton(
                      onPressed: () {
               
                        _showSuccessPopup();
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

  Widget _buildLargeDescriptionField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFADD8E6),
        ), 
      ),
      child: TextField(
        controller: descController,
        maxLines: 6,
        minLines: 4,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: "Unesite detaljan opis događaja...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      width: double.infinity,
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFADD8E6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          hint: Text(
            "Izaberi kategoriju",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2B8CBF)),
          items: categories
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(c, style: const TextStyle(fontSize: 15)),
                ),
              )
              .toList(),
          onChanged: (val) {
            setState(() {
              selectedCategory = val;
            });
          },
        ),
      ),
    );
  }
}
