# SejutaStay Hotel Booking Database — AOL Database Technology (COMP6799001)

Proyek kelompok AOL (Assessment of Learning) mata kuliah **Database Technology** —
perancangan dan normalisasi database pemesanan hotel **SejutaStay** dari bentuk
tidak normal (UNF) sampai **Third Normal Form (3NF)**, untuk sektor industri
**Tourism & Hospitality**, diimplementasikan secara fisik di **MySQL**.

## Anggota Kelompok

| No. | Nama | NIM |
|-----|------|-----|
| 1 | Daniel Steffen Kurniawan | 2602071171 |
| 2 | Edvardo Khong | 2602177171 |

Semester / Tahun Akademik: **4 / 2025–2026**

## File yang Dikumpulkan — folder `Submission/` (ditandai "(sub)")

Folder **`Submission/`** berisi versi FINAL yang siap dikumpulkan:

| File | Isi |
|------|-----|
| **`(sub) SejutaStay_Report.docx`** | Laporan lengkap Bab 1–5 (kasus, data UNF, anomali & FD, normalisasi step-by-step, ERD + kesimpulan) |
| **`(sub) SejutaStay_Presentation.pptx`** | Slide presentasi 8 menit **berbahasa Indonesia** — dilengkapi **speaker notes naskah baca bahasa pemula + alokasi waktu** di setiap slide |
| **`(sub) SejutaStay_Database.sql`** | Export database MySQL: 8 tabel 3NF, minimal 5 baris per tabel, query verifikasi — **sudah diuji jalan tanpa error** |

File pendukung (tidak wajib dikumpulkan, untuk persiapan presentasi):

- **`Naskah_Presentasi_8_Menit.docx`** — naskah baca lengkap per slide dengan **bahasa pemula** (tinggal dibaca di depan kelas), pembagian presenter, dan tips.
- File-file di root repo (`SejutaStay_Report_Revised_Final.docx`, `SejutaStay_Presentation.pptx`, `SejutaStay_Database.sql`) adalah versi kerja sebelumnya dan tetap dipertahankan sebagai arsip.

## Kesesuaian dengan Soal (`AOL Database Technology (COMP6799001).docx`)

| Ketentuan Soal | Jawaban / Lokasi |
|----------------|------------------|
| Sektor industri: Tourism & Hospitality | Kasus jaringan hotel SejutaStay |
| Identification of performance problem | Report **Bab 1** — 5 masalah + 1 solusi final (normalisasi sampai 3NF) |
| Sample data dalam bentuk Un-normal | Report **Bab 2** — 7 reservasi, 18 atribut, repeating groups ditandai |
| > 4 entitas | 6 entitas: Guest, Hotel, RoomType, Room, Service, Booking (+2 tabel junction) |
| Anomali & functional dependencies | Report **Bab 3** — 3 anomali dengan contoh nyata, 6 FD, + rencana penyelesaian terperinci |
| Normalisasi step-by-step UNF → 3NF | Report **Bab 4** — UNF → 1NF (3 tabel) → 2NF (5 tabel) → 3NF (8 tabel) |
| ERD hasil refinement + kesimpulan | Report **Bab 5** — ERD Crow's Foot, 8 tabel, kesimpulan |
| File .sql, minimal 5 baris per tabel | `(sub) SejutaStay_Database.sql` — semua tabel ≥ 5 baris (terverifikasi) |
| Presentasi 8 menit | PPT 15 slide + speaker notes berwaktu + `Naskah_Presentasi_8_Menit.docx` |

## Cara Menjalankan File SQL

```bash
mysql -u root -p < "Submission/(sub) SejutaStay_Database.sql"
```

Atau melalui **phpMyAdmin**: menu *Import* → pilih file `.sql` → *Go*.
Script akan membuat database `sejutastay`, 8 tabel 3NF dengan constraint
PK/FK/UNIQUE/CHECK, mengisi data sampel, lalu menjalankan query verifikasi
(JOIN detail booking, total biaya layanan, hitung baris per tabel, dan
pengecekan kualitas data kamar-vs-hotel yang harus menghasilkan 0 baris).

## Hasil Verifikasi (sudah diuji di MySQL/MariaDB)

| Tabel | Jumlah Baris |
|-------|--------------|
| Guest | 6 |
| Hotel | 5 |
| RoomType | 5 |
| Service | 5 |
| Room | 9 |
| Booking | 7 |
| BookingRoom | 9 |
| BookingService | 12 |

Semua query verifikasi berjalan tanpa error, dan query kualitas data
mengembalikan 0 baris (setiap kamar yang dibooking terbukti milik hotel
yang sesuai dengan booking-nya).
