import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider untuk menyimpan total pemasukkan dan pengeluaran
final totalPemasukkanProvider = StateProvider<int>((ref) => 0);
final totalPengeluaranProvider = StateProvider<int>((ref) => 0);

// Provider untuk menyimpan catatan keuangan
final catatanKeuanganProvider =
    StateNotifierProvider<CatatanKeuanganNotifier, List<CatatanKeuangan>>(
  (ref) => CatatanKeuanganNotifier(ref),
);

// Notifier untuk mengelola catatan keuangan
class CatatanKeuanganNotifier extends StateNotifier<List<CatatanKeuangan>> {
  final Ref ref; // Menambahkan Ref untuk mengakses provider lain

  CatatanKeuanganNotifier(this.ref) : super([]);

  void tambahCatatan(CatatanKeuangan catatan) {
    state = [...state, catatan];

    // Update pemasukkan atau pengeluaran berdasarkan kategori
    if (catatan.kategori == 'Pemasukkan') {
      final totalPemasukkan = ref.read(totalPemasukkanProvider.notifier);
      totalPemasukkan.state += catatan.jumlahUang;
    } else if (catatan.kategori == 'Pengeluaran') {
      final totalPengeluaran = ref.read(totalPengeluaranProvider.notifier);
      totalPengeluaran.state += catatan.jumlahUang;
    }
  }

  // Hapus catatan keuangan berdasarkan indeks
  void hapusCatatan(int index) {
    final catatan = state[index];

    // Cek kategori dan update total pemasukkan/pengeluaran
    if (catatan.kategori == 'Pemasukkan') {
      ref.read(totalPemasukkanProvider.notifier).state -= catatan.jumlahUang;
    } else if (catatan.kategori == 'Pengeluaran') {
      ref.read(totalPengeluaranProvider.notifier).state -= catatan.jumlahUang;
    }

    // Hapus catatan dari list
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i]
    ];
  }
}

// Model untuk catatan keuangan
class CatatanKeuangan {
  final String judul;
  final String kategori;
  final int jumlahUang;

  CatatanKeuangan({
    required this.judul,
    required this.kategori,
    required this.jumlahUang,
  });
}
