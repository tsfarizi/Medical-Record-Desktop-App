import 'package:flutter/material.dart';
import 'package:medgis_app/view/home/widgets/chart.dart';

class DataVisualizationSection extends StatelessWidget {
  const DataVisualizationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "C. Data Visualization",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Padding(
            padding: EdgeInsets.all(25),
            child: Card(
              child: Chart(
                  totalPatients: 100, malePatients: 63, femalePatients: 37),
            )),
        const Text(
            'Bagian yang terdaapat pada halaman utama aplikasi ini bertanggung jawab untuk menggambarkan data yang di miliki yang yaitu jumlah pasien dan juga jumlah pasien dari masing masing gender, dan bagian ini juga dapat di gunakan untuk mengambarkan data pada suatu tanggal dengan menggunakan search bar.'),
        const Text(""),
        const Text(""),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Text(
            "Komponen ini di sebut sebagai search bar yang berfungsi untuk mencari dan juga memfilter data yang di miliki. Komponen ini bisa memfilter berdasar data apa saja yang ada pada tabel, dan ketika sedang melakukan filtering komponen visualisasi data akan merespon yang menjadikan data yang di gambarkan hanyalah data dengan kriteria yang sesuai dengan karakter yang di ketikan di search bar ini.")
      ],
    );
  }
}
