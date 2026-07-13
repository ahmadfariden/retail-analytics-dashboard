# Executive Summary — Insight & Rationale

Dokumentasi ini menjelaskan **temuan (insight)** dari halaman Executive Summary, serta **alasan pemilihan tiap chart** — kenapa chart tersebut yang dipakai, bukan jenis lain.

---

## Insight / Temuan dari Halaman Ini

### 1. Baseline Bisnis (dari 4 KPI Cards)
- **Total Revenue: ~3 Miliar** dari **1 juta transaksi**, dengan rata-rata nilai transaksi **~2.751**
- **99.996 dari 100.000 customer** pernah bertransaksi (99,996% aktif) — sangat tinggi, menandakan hampir seluruh basis customer sudah tersentuh penjualan
- Angka ini jadi **baseline pembanding** untuk semua analisis di halaman-halaman berikutnya (misal: seberapa besar kontribusi 1 kategori terhadap total 3 Miliar ini)

### 2. Pola Musiman yang Jelas (dari Monthly Revenue Trend)
- Revenue **naik bertahap dari Januari ke September**, mencapai puncak di sekitar **September–Oktober**, lalu **turun tajam di November–Desember**
- Pola ini konsisten dan cukup jelas — bukan noise acak, karena tren naik-turunnya smooth dan bertahap, bukan naik-turun tiba-tiba per bulan
- **Implikasi bisnis:** kalau ini data riil, perusahaan bisa gunakan pola ini untuk perencanaan stok, staffing, dan budget marketing menjelang periode puncak (Q3)
- **Catatan:** Desember yang justru turun tajam agak *counter-intuitive* dibanding pola ritel riil pada umumnya (biasanya ramai jelang holiday) — ini layak dicatat sebagai keterbatasan data sintetis

### 3. Distribusi Kategori & Store Type Nyaris Merata (dari 2 Bar Chart)
- Semua 6 kategori produk berkontribusi **hampir sama rata** (~16-17% masing-masing), tidak ada kategori yang mendominasi
- Ketiga store type (Supermarkets, Small Stores, Large Malls) juga selisihnya tipis
- **Implikasi:** performa bisnis di level agregat ini **tidak bisa dipakai untuk rekomendasi "fokus ke kategori/toko tertentu"** — karena semuanya setara. Insight yang lebih tajam soal kategori/toko baru muncul kalau dipecah lebih dalam (per bulan, per segmen customer, dll) di halaman-halaman berikutnya

---

## Kenapa Pakai Chart Ini? (Rationale)

### Card — untuk KPI Utama
**Alasan:** Card dipilih karena tujuannya cuma menampilkan **1 angka tunggal** yang harus langsung terbaca dalam sepersekian detik, tanpa perlu interpretasi visual tambahan. Ini prinsip dasar Executive Summary — orang yang buka dashboard pertama kali harus langsung tahu angka besar (revenue, transaksi, dst) tanpa harus membaca chart dulu.

**Kenapa bukan Table?** Table cocok untuk banyak baris data, tapi untuk 1 angka ringkasan, Table justru memperlambat pembacaan karena mata harus mencari kolom & barisnya dulu.

### Line Chart — untuk Trend Bulanan
**Alasan:** Line Chart adalah pilihan standar untuk data **time series** (data yang berurutan berdasarkan waktu). Garis yang menyambung antar titik membuat mata langsung menangkap **arah tren** (naik/turun) dan **pola musiman**, yang merupakan tujuan utama visual ini.

**Kenapa bukan Bar Chart untuk data bulanan?** Bar Chart bisa saja dipakai, tapi Line Chart lebih unggul untuk **12 titik data berurutan** karena kontinuitas garis menekankan pergerakan/tren, sementara Bar Chart lebih menekankan **perbandingan nilai per kategori** yang tidak selalu berurutan.

### Bar Chart (Horizontal) — untuk Revenue per Kategori & Store Type
**Alasan:** Bar Chart adalah pilihan terbaik untuk **membandingkan nilai antar kategori** yang jumlahnya sedikit (6 kategori, 3 store type). Panjang bar yang berbeda langsung menunjukkan mana yang lebih tinggi/rendah tanpa perlu membaca angka satu per satu.

**Kenapa Horizontal, bukan Vertical (Column)?** Karena label kategori (`Sports & Outdoors`, `Home Appliances`, dll) cukup panjang — Horizontal Bar Chart membuat label lebih mudah dibaca penuh dibanding Vertical Bar Chart yang label-nya harus dimiringkan atau terpotong.

**Kenapa bukan Pie Chart?** Pie Chart sering dihindari dalam praktik BI modern karena mata manusia kurang akurat membandingkan **sudut/luas area**, apalagi kalau nilainya berdekatan (seperti kasus kategori kita yang hampir merata 16-17%) — perbedaan kecil jadi sulit terlihat di Pie Chart, padahal jelas terlihat di Bar Chart.

---

## Prinsip Umum di Balik Layout Halaman Ini

1. **Card di baris paling atas** → informasi paling penting harus terlihat pertama kali, tanpa perlu scroll
2. **Line chart lebih lebar dari bar chart** → karena trend waktu adalah insight utama halaman ini, sehingga diberi ruang visual paling besar
3. **Urutan top-to-bottom mengikuti tingkat kepentingan**: ringkasan angka → tren waktu → breakdown kategori — ini pola umum storytelling dashboard, dari yang paling general ke yang lebih detail
