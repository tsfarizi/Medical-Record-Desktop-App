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
            "Sesuai dengan namanya tombol ini memiliki fungsi akan memunculkan formulir untuk menambahkan pasien baru"),
        const Text(""),
        Text(
          "2. Add Medical Record",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "Begitu juga dengan tombol ini yang sesuai dengan teks yang tertera pada tombolnya itu sendiri, yaitu berarti tombol ini berfungsi untuk menambahkan rekam medis pada seorang pasien"),
        const Text(""),
        Text(
          "3. Edit Patient Data",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "Ikon ini akan muncul pada bagian yang menampilkan data lengkap pasien dan data dari setiap pasiennya dapat di ubah dengan cara menekan ikon ini yang nantinya akan memberikan akses, untuk mengubah data pasien bergantung pada data apa yang di pilih."),
        const Text(""),
        Text(
          "4. Information Window",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "Ini adalah ikon yang ketika di tekan maka akan memunculkan jendela informasi seperti tampilan saat ini, yang berisi hal - hal yang perlu di ketahui dari aplikasi ini"),
        const Text(""),
        Text(
          "5. Back",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "Ikon ini yang memiliki tanggung jawab untuk membuat tampilan kembali ketampilan sebelumnya"),
        const Text(""),
        Text(
          "6. Export",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "Ikon ini akan melakukan export data dari dari pasien baris tersebut ke dalam file pdf."),
        const Text(""),
        Text(
          "7. Delete Data Patient/Medical Record",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "Seperti ikon yang di gunakan, tentu ikon ini berfungsi untuk menghapus data pasien ataupun data rekam medis sesuai di mana icon ini ditekan, di tabel pasien atau di tabel rekam medis yang berada di detail setiap pasien."),
        const Text(""),
        Text(
          "8. Close",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text(
            "Ikon X merah ini memiliki fungsi yaitu unutk menutup jendela muncul(Seperti tampilan sekarang), serta memiliki fungsi untuk menutup aplikasi(pada ikon yang selalu ada di kanan atas layar)"),
        const Text(""),
        const Text(""),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
