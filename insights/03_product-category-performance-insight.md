# Product & Category Performance — Insight & Rationale

Dokumentasi ini menjelaskan **temuan (insight)** dari halaman Product & Category Performance, serta **alasan pemilihan tiap chart**.

---

## Insight / Temuan dari Halaman Ini

### 1. Distribusi Revenue Antar Kategori Nyaris Merata (dari Bar Chart "Total Revenue by Category")

| Kategori | Total Revenue |
|---|---|
| Sports & Outdoors | 461,7M |
| Furniture | 459,5M |
| Electronics | 458,7M |
| Home Appliances | 458,0M |
| Groceries | 456,6M |
| Clothing | 456,3M |

Selisih antara kategori tertinggi (Sports & Outdoors) dan terendah (Clothing) **hanya sekitar 5,4M dari total ~458M rata-rata per kategori** (~1,2% selisih). Ini menunjukkan **tidak ada kategori yang secara signifikan mendominasi** penjualan — keenam kategori berkontribusi hampir setara terhadap total revenue perusahaan.

**Implikasi bisnis:** Tidak ada dasar kuat untuk merekomendasikan "fokus ke 1 kategori" berdasarkan data ini — strategi portofolio produk yang merata tampaknya sudah cukup seimbang (atau, mengingat sifat data sintetis, distribusi ini memang di-generate secara uniform).

### 2. Semua Kategori Bergerak Bersamaan Secara Musiman (dari Line Chart "Monthly Revenue Trend by Category")

Enam garis kategori pada line chart **saling bertumpuk sempurna** membentuk 1 pola pergerakan tunggal — naik dari Januari, puncak di sekitar September-Oktober, turun tajam di Desember.

**Ini insight penting:** pola musiman yang ditemukan di Executive Summary **bukan disebabkan oleh 1-2 kategori tertentu**, melainkan bersifat **makro/menyeluruh** — mempengaruhi seluruh kategori produk secara proporsional dan bersamaan. Ini mengindikasikan bahwa penyebab musiman kemungkinan berasal dari faktor eksternal yang mempengaruhi total volume transaksi (misal traffic pelanggan keseluruhan), bukan preferensi terhadap kategori produk tertentu.

### 3. Kombinasi Kategori × Store Type Juga Merata (dari Matrix)

Tidak ditemukan kombinasi tertentu (misal "Electronics di Supermarkets") yang menonjol jauh dari kombinasi lainnya — nilai di setiap sel matrix tersebar cukup merata mengikuti proporsi total masing-masing kategori dan store type.

**Kesimpulan gabungan:** Baik dilihat dari sisi kategori saja, waktu, maupun kombinasi dengan tipe toko, dataset ini secara konsisten menunjukkan pola **uniform/merata** — bukan pola bisnis yang timpang seperti biasanya ditemukan pada data ritel riil (di mana biasanya ada produk "bintang" yang mendominasi penjualan).

---

## Kenapa Pakai Chart Ini? (Rationale)

### Bar Chart (Horizontal) — untuk Total Revenue by Category
**Alasan:** Sama seperti alasan di Executive Summary — Bar Chart adalah pilihan terbaik untuk membandingkan nilai antar kategori diskrit yang jumlahnya sedikit (6 kategori). Perbedaan panjang bar langsung menunjukkan mana yang lebih tinggi/rendah, meskipun dalam kasus ini perbedaannya memang tipis — dan justru itulah yang ingin ditunjukkan (distribusi merata).

### Line Chart — untuk Monthly Revenue Trend by Category
**Alasan:** Selain karena ini data time series (alasan yang sama seperti di Executive Summary), penggunaan **Legend berdasarkan kategori** membuat 1 chart bisa menampilkan **6 tren sekaligus** untuk dibandingkan langsung satu sama lain. Ini jauh lebih efisien dibanding membuat 6 chart terpisah untuk tiap kategori.

**Kenapa hasilnya bermanfaat meski garis-garis saling bertumpuk?** Justru fenomena "garis bertumpuk jadi satu" adalah insight itu sendiri — ini bukti visual langsung bahwa pola musiman bersifat seragam di semua kategori. Chart lain seperti bar chart bertumpuk per bulan akan lebih sulit menunjukkan hal ini secara sejelas line chart.

### Matrix — untuk Category × Store Type
**Alasan:** Sama seperti penggunaan Matrix di halaman Customer Segmentation — ketika perlu melihat hubungan antara **2 variabel kategorikal sekaligus** (kategori produk × tipe toko), Matrix adalah cara paling ringkas untuk menampilkan seluruh kombinasi nilai dalam format tabel silang, lengkap dengan baris dan kolom Total untuk validasi cepat.

**Kenapa bukan Stacked Bar Chart?** Dengan 6 kategori × 3 store type = 18 kombinasi, Stacked Bar Chart akan membuat warna-warna kecil yang sulit dibandingkan secara presisi. Matrix memberikan angka pasti yang bisa langsung dibaca dan dibandingkan.

### Table — untuk Category Performance Summary
**Alasan:** Table dipilih untuk menampilkan **beberapa metrik sekaligus per kategori** (jumlah transaksi, total revenue, rata-rata transaksi) dalam format yang presisi dan mudah di-scan baris demi baris — cocok untuk kebutuhan "ringkasan angka lengkap" yang tidak memerlukan interpretasi visual tambahan seperti bar/line chart.

---

## Prinsip Umum di Balik Layout Halaman Ini

1. **Bar Chart dan Line Chart disandingkan di baris atas** → memberikan 2 sudut pandang berbeda (statis vs time series) terhadap data kategori yang sama, sehingga pembaca bisa langsung membandingkan "kategori mana yang unggul" dan "bagaimana pola waktu-nya" tanpa harus berpindah halaman
2. **Matrix diletakkan di tengah** → sebagai jembatan antara analisis kategori (atas) dan detail lengkap (tabel di bawah), menambahkan 1 dimensi baru (store type) untuk analisis lebih dalam
3. **Table di bagian bawah** → berfungsi sebagai rekap angka pasti untuk semua chart di atasnya, memudahkan pembaca yang ingin mengecek angka spesifik tanpa harus hover ke chart
