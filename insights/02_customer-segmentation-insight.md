# Customer Segmentation — Insight & Rationale

Dokumentasi ini menjelaskan **temuan (insight)** dari halaman Customer Segmentation, serta **alasan pemilihan tiap chart**.

---

## Insight / Temuan dari Halaman Ini

### 1. Distribusi RFM Segment (dari Bar Chart "Customer Count by RFM Segment")

| Segment | Jumlah Customer |
|---|---|
| Lost / Churned | 23.014 |
| Loyal Customers | 20.595 |
| Others | 20.315 |
| Champions | 17.064 |
| New Customers | 9.948 |
| At Risk (High Value) | 9.060 |

- Kelompok **Lost/Churned** adalah segmen terbesar (23% dari total) — menandakan ada porsi customer signifikan yang sudah lama tidak bertransaksi
- **Champions** (17.064) dan **At Risk High Value** (9.060) jika digabung = **26.124 customer bernilai tinggi** yang perlu diprioritaskan strategi retensinya

### 2. Validasi Logika RFM (dari Bar Chart "Average Spending by RFM Segment")

Rata-rata spending naik-turun **sesuai urutan logis**: Champions tertinggi (~38K) → At Risk High Value (~37K) → Loyal (~32K) → Others (~23K) → Lost/Churned & New Customers terendah (~19K).

**Ini membuktikan bahwa perhitungan RFM valid** — semakin "tinggi kelas" segmennya, semakin besar juga rata-rata pengeluarannya, sesuai definisi RFM itu sendiri.

### 3. Temuan Utama: `original_segment` Tidak Valid (dari Matrix Mismatch Analysis)

Ini **insight paling penting** di seluruh project. Proporsi distribusi `rfm_segment` **hampir identik** di semua baris `original_segment` — baik itu "Churn Risk", "Premium Shopper", "Deal Seeker", dst, semuanya punya sebaran yang mirip ke 6 kategori RFM.

**Contoh konkret:** 47,1% customer berlabel "Churn Risk" ternyata masuk kategori Champions / Loyal Customers / At Risk (High Value) berdasarkan RFM — bukan benar-benar berisiko churn.

**Kesimpulan:** label `original_segment` di dataset **tidak berkorelasi dengan perilaku transaksi aktual**, kemungkinan besar di-generate secara acak. Ini alasan kenapa RFM Analysis (dihitung dari data transaksi asli) lebih dapat dipercaya sebagai dasar strategi bisnis dibanding label yang sudah tersedia.

### 4. Pola Sebaran Customer (dari Scatter Chart "Recency vs Monetary")

- Customer dengan `recency_days` rendah (baru transaksi) dan `monetary` tinggi cenderung berwarna **Champions/At Risk High Value** — sesuai definisi
- Customer dengan `recency_days` tinggi (lama tidak transaksi) didominasi warna **Lost/Churned**
- Sebaran ini **membentuk pola visual yang konsisten**, memperkuat validitas segmentasi RFM secara keseluruhan

### 5. Profil Top Spender (dari Table "Top 10 Customers")

Top 10 customer dengan spending tertinggi datang dari `original_segment` yang **beragam** — bukan cuma dari "Premium Shopper" atau "High Value" — semakin menegaskan bahwa label lama tidak bisa dijadikan acuan untuk mengidentifikasi customer bernilai tinggi.

---

## Kenapa Pakai Chart Ini? (Rationale)

### Card — untuk Highlight 1 Segment Kunci
**Alasan:** Sama seperti di Executive Summary, Card dipakai untuk menonjolkan **1 angka penting** (jumlah Champions) yang layak jadi perhatian utama pembaca dashboard sejak awal.

### Bar Chart (Horizontal) — untuk Customer Count & Average Spending per Segment
**Alasan:** Ada **6 kategori segment** yang perlu dibandingkan nilainya — Bar Chart adalah cara paling efisien untuk perbandingan antar kategori diskrit. Horizontal dipilih karena label segment (`At Risk (High Value)`, dll) cukup panjang.

**Kenapa dipisah jadi 2 chart (Count & Average), bukan digabung?** Karena keduanya punya skala dan makna berbeda — "jumlah customer" dan "rata-rata spending" tidak sepadan untuk digabung dalam 1 sumbu Y tanpa membingungkan pembaca.

### Matrix — untuk Perbandingan 2 Dimensi (Original vs RFM Segment)
**Alasan:** Matrix adalah pilihan tepat ketika kita perlu melihat **hubungan antara 2 variabel kategorikal sekaligus** (`original_segment` × `rfm_segment`) dalam bentuk tabel silang (cross-tabulation). Ini memungkinkan pembaca melihat pola mismatch secara langsung — sesuatu yang tidak bisa ditunjukkan oleh Bar Chart maupun Line Chart.

**Kenapa bukan Bar Chart bertumpuk (Stacked Bar)?** Stacked Bar bisa dipakai sebagai alternatif, tapi dengan 6×6 kombinasi kategori, Matrix jauh lebih ringkas dan mudah dibaca sebagai tabel angka pasti, dibanding menafsirkan tinggi-rendahnya segmen warna dalam bar yang bertumpuk.

### Scatter Chart — untuk Melihat Sebaran Individual Customer
**Alasan:** RFM pada dasarnya adalah **hasil pemetaan dari 2 variabel kontinu** (recency & monetary) ke dalam kategori diskrit. Scatter Chart adalah satu-satunya jenis chart yang bisa menunjukkan **posisi setiap customer secara individual** dalam ruang 2 dimensi tersebut, sekaligus memvalidasi secara visual apakah pengelompokan warna (segment) memang membentuk pola yang masuk akal (mengelompok), bukan tersebar acak.

**Kenapa bukan Bar Chart atau Histogram?** Bar Chart/Histogram akan mengagregasi data dan menghilangkan detail individual — padahal justru detail individual (tiap titik = 1 customer) inilah yang membuktikan validitas RFM secara visual.

### Table — untuk Detail Top Customer
**Alasan:** Ketika kebutuhan pembaca adalah **melihat detail baris demi baris** (nama, lokasi, kedua jenis segment, angka spending) untuk sejumlah kecil data (10 baris), Table adalah pilihan paling langsung — tidak ada jenis chart visual yang lebih efisien untuk menampilkan data granular seperti ini.

---

## Prinsip Umum di Balik Layout Halaman Ini

1. **Card di kiri atas** → tetap mempertahankan pola "angka penting duluan" seperti di Executive Summary
2. **2 Bar Chart bersisian** → memudahkan perbandingan cepat "jumlah" vs "kualitas" tiap segment tanpa harus scroll
3. **Matrix diletakkan di posisi tengah/menonjol** → karena ini insight paling penting di seluruh halaman, sengaja diberi ruang visual besar
4. **Scatter dan Table di bagian bawah** → berfungsi sebagai bukti pendukung (supporting evidence) dari insight utama yang sudah disampaikan Matrix di atasnya
