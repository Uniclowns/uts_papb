import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uts_papb/providers.dart';
import 'package:uts_papb/tambah_catatan.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalPemasukkan = ref.watch(totalPemasukkanProvider);
    final totalPengeluaran = ref.watch(totalPengeluaranProvider);
    final catatanKeuangan = ref.watch(catatanKeuanganProvider);
    final hapusCatatan = ref.read(catatanKeuanganProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Keuangan'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text('Total Pemasukkan : Rp$totalPemasukkan'),
              SizedBox(height: 20),
              Text('Total Pengeluaran : Rp$totalPengeluaran'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TambahCatatan();
                  }));
                },
                child: Text('Tambah Catatan Finansial'),
              ),
              // Tampilkan catatan keuangan
              Expanded(
                child: ListView.builder(
                  itemCount: catatanKeuangan.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(catatanKeuangan[index].kategori),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rp${catatanKeuangan[index].jumlahUang}'),
                          Text(catatanKeuangan[index].judul),
                        ],
                      ),
                      leading: Text(
                        '💰',
                        textScaleFactor: 3,
                      ),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Tampilkan dialog konfirmasi
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Konfirmasi'),
                                    content: Text(
                                        'Apakah Anda yakin ingin menghapus?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Tutup dialog
                                        },
                                        child: Text('Tidak'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Hapus catatan jika pengguna memilih "Ya"
                                          hapusCatatan.hapusCatatan(index);
                                          Navigator.of(context)
                                              .pop(); // Tutup dialog
                                        },
                                        child: Text('Ya'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
