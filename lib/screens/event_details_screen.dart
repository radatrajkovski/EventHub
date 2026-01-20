import 'package:event_hub/models/event_card.dart';
import 'package:event_hub/widgets/backHeader_widget.dart';
import 'package:event_hub/widgets/customtTextField.dart'; // Proveri da li je malo 't' u nazivu fajla
import 'package:event_hub/widgets/event_details_widget.dart';
import 'package:event_hub/widgets/weather_widget.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. FIKSNO ZAGLAVLJE (Strelica nazad)
            const BackHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. KATEGORIJA (Mali badge u uglu)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: event.getCategoryColor(event.category),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        event.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. DINAMIČKI SADRŽAJ (Prikaz ili Edit forma)
                    if (isEditing)
                      _buildEditFields(event)
                    else
                      _buildInfoDisplay(event),

                    const SizedBox(height: 25),
                    const WeatherWidget(),
                    const SizedBox(height: 30),

                    // 4. OPIS (Takođe se menja u edit modu)
                    const Text(
                      "O događaju",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    isEditing
                        ? CustomTextField(
                            width: double.infinity,
                            hintText: "Unesite opis događaja...",
                            controller: TextEditingController(
                              text: event.description,
                            ),
                            // Ako tvoj CustomTextField podržava maxLines, ovde bi išlo to
                          )
                        : Text(
                            event.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),

                    const SizedBox(height: 40),

                    // 5. GLAVNO DUGME
                    ElevatedButton(
                      onPressed: () {
                        if (isEditing) {
                          // Simulacija čuvanja
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Izmene su sačuvane!"),
                            ),
                          );
                        } else {
                          if (!isGuest) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Uspešno ste se prijavili!"),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B8CBF),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        isEditing
                            ? "SAČUVAJ IZMENE"
                            : (isGuest
                                  ? "ULOGUJTE SE DA SE PRIDRUŽITE"
                                  : "PRIDRUŽI SE DOGAĐAJU"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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
  }

  // POMOĆNI WIDGET ZA PRIKAZ (Običan tekst)
  Widget _buildInfoDisplay(EventModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
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
        EventInfoTile(
          icon: Icons.people_outline,
          label: "Slobodna mesta",
          value: "${event.freeSpots} mesta",
        ),
      ],
    );
  }

  // POMOĆNI WIDGET ZA EDIT (Tvoja Custom polja)
  Widget _buildEditFields(EventModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _editLabel("Naziv događaja"),
        CustomTextField(
          width: double.infinity,
          hintText: "Naziv",
          controller: TextEditingController(text: event.title),
        ),
        const SizedBox(height: 16),

        _editLabel("Lokacija"),
        CustomTextField(
          width: double.infinity,
          hintText: "Lokacija",
          controller: TextEditingController(text: event.location),
        ),
        const SizedBox(height: 16),

        _editLabel("Datum i vreme"),
        CustomTextField(
          width: double.infinity,
          hintText: "Npr. 25. Decembar, 18:00h",
          controller: TextEditingController(
            text: "${event.date} ${event.time}",
          ),
        ),
        const SizedBox(height: 16),

        _editLabel("Ukupan broj mesta"),
        CustomTextField(
          width: double.infinity,
          hintText: "Broj mesta",
          controller: TextEditingController(text: event.spots.toString()),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // Mali pomoćni widget za labelu iznad polja
  Widget _editLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }
}
