import 'package:flutter/material.dart';
import '../widgets/primaryBtn_widget.dart';
import '../widgets/customtTextField.dart'; // Koristi tvoj postojeći widget

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController locationController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kreiraj događaj", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Osnovne informacije", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // Naslov
            const Text("Naziv događaja"),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: "npr. Tech Innovation Summit",
              controller: titleController,
            ),
            
            const SizedBox(height: 20),
            
            // Lokacija
            const Text("Lokacija"),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: "npr. Mite Ružića 2, Novi Sad",
              controller: locationController,
            ),
            
            const SizedBox(height: 20),
            
            // Opis
            const Text("Opis događaja"),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Opišite šta će se dešavati...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Dugme za kreiranje
            Center(
              child: PrimaryButton(
                text: "Objavi događaj",
                onPressed: () {
                  print("Događaj kreiran: ${titleController.text}");
                  // Ovde bi išla logika za čuvanje
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Događaj je uspešno objavljen!")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}