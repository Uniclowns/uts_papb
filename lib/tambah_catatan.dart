import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uts_papb/providers.dart';

class TambahCatatan extends ConsumerStatefulWidget {
  const TambahCatatan({super.key});

  @override
  _TambahCatatanState createState() => _TambahCatatanState();
}

class _TambahCatatanState extends ConsumerState<TambahCatatan> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _jumlahUangController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = ['Pemasukkan', 'Pengeluaran'];

  @override
  void dispose() {
    _judulController.dispose();
    _jumlahUangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catatanKeuanganNotifier = ref.watch(catatanKeuanganProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan Finansial'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextField(
                  controller: _judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Catatan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategory,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _jumlahUangController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Uang',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final judul = _judulController.text;
                    final kategori = _selectedCategory;
                    final jumlahUang =
                        int.tryParse(_jumlahUangController.text) ?? 0;

                    if (judul.isNotEmpty &&
                        kategori != null &&
                        jumlahUang > 0) {
                      catatanKeuanganNotifier.tambahCatatan(CatatanKeuangan(
                        judul: judul,
                        kategori: kategori,
                        jumlahUang: jumlahUang,
                      ));

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Catatan berhasil disimpan')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Harap isi semua kolom')),
                      );
                    }
                  },
                  child: const Text('Simpan Catatan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
