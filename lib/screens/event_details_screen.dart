import 'package:event_hub/models/event_card.dart';
import 'package:event_hub/widgets/backHeader_widget.dart';
import 'package:event_hub/widgets/customtTextField.dart';
import 'package:event_hub/widgets/event_details_widget.dart';
import 'package:event_hub/widgets/weather_widget.dart';
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
  late TextEditingController _dateTimeController;
  late TextEditingController _spotsController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _locationController = TextEditingController(text: widget.event.location);
    _dateTimeController = TextEditingController(
      text: "${widget.event.date} ${widget.event.time}",
    );
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
    _dateTimeController.dispose();
    _spotsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // funk za prikaz popupa
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // kor mora da klikne na dugme
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
            "Događaj je uspešno izmenjen!",
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
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
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
    final bool showAsDisabled = widget.isGuest && !widget.isEditing;
    final Color buttonColor = showAsDisabled
        ? Colors.grey.shade400
        : const Color(0xFF2B8CBF);
    final Color textColor = showAsDisabled
        ? Colors.grey.shade700
        : Colors.white;

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
                 //kat
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: widget.event.getCategoryColor(
                          widget.event.category,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.event.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Edit forma ili Prikaz info
                    widget.isEditing
                        ? _buildEditFields()
                        : _buildInfoDisplay(widget.event),

                    const SizedBox(height: 25),
                    const WeatherWidget(),
                    const SizedBox(height: 30),

                    // OPIS
                    const Text(
                      "O događaju",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    widget.isEditing
                        ? CustomTextField(
                            width: double.infinity,
                            hintText: "Unesite opis događaja...",
                            controller: _descriptionController,
                            maxLines: 5,
                          )
                        : Text(
                            widget.event.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),

                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: showAsDisabled
                          ? null
                          : () {
                              if (widget.isEditing) {
                                _showSuccessDialog();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Uspešno ste se prijavili!"),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        disabledBackgroundColor: Colors.grey.shade400,
                        minimumSize: const Size(double.infinity, 56),
                        elevation: showAsDisabled ? 0 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        widget.isEditing
                            ? "SAČUVAJ IZMENE"
                            : (widget.isGuest
                                  ? "ULOGUJTE SE DA SE PRIDRUŽITE"
                                  : "PRIDRUŽI SE DOGAĐAJU"),
                        style: TextStyle(
                          color: textColor,
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

  Widget _buildEditFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        _editLabel("Datum i vreme"),
        CustomTextField(
          width: double.infinity,
          hintText: "Npr. 25. Decembar, 18:00h",
          controller: _dateTimeController,
        ),
        const SizedBox(height: 16),
        _editLabel("Ukupan broj mesta"),
        CustomTextField(
          width: double.infinity,
          hintText: "Broj mesta",
          controller: _spotsController,
        ),
      ],
    );
  }

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
