import 'package:flutter/material.dart';
import 'package:medgis_app/view/settings/widgets/button_section_description.dart';

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "B. Button",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const ButtonSectionDescription(),
        Text(
          "1. Add Patient",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "As the name suggests, this button has the function of displaying a form for adding new patients."),
        const Text(""),
        Text(
          "2. Add Medical Record",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "Likewise, this button corresponds to the text on the button itself, which means that this button functions to add medical records to a patient."),
        const Text(""),
        Text(
          "3. Edit Patient Data",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "This icon will appear in the section that displays complete patient data and data from each patient can be changed by pressing this icon which will later provide access to change patient data depending on the data selected."),
        const Text(""),
        Text(
          "4. Information Window",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "This is an icon that when pressed will bring up an information window like the current display, which contains things you need to know about this application."),
        const Text(""),
        Text(
          "5. Back",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "This icon is responsible for returning the display to its previous appearance."),
        const Text(""),
        Text(
          "6. Export",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "This icon will export the data from that row of patients into a pdf file."),
        const Text(""),
        Text(
          "7. Delete Data Patient/Medical Record",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "Like the icon used, of course this icon functions to delete patient data or medical record data according to where this icon is pressed, in the patient table or in the medical record table which is in the details of each patient."),
        const Text(""),
        Text(
          "8. Close",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "This red X icon has the function of closing the pop-up window (as shown now), and has the function of closing the application (on the icon that is always on the top right of the screen)."),
        const Text(""),
        const Text(""),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
