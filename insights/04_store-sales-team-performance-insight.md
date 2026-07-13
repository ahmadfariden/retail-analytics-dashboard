# Store & Sales Team Performance — Insight & Rationale

Dokumentasi ini menjelaskan **temuan (insight)** dari halaman Store & Sales Team Performance, serta **alasan pemilihan tiap chart**.

---

## Insight / Temuan dari Halaman Ini

### 1. Top 10 Store Relatif Kompetitif, Tidak Ada yang Mendominasi Jauh (dari Bar Chart "Top 10 Stores by Revenue")

Revenue 10 toko teratas (NeoStore, ActiveLife, QuickCart, dst) berada di rentang yang **berdekatan** — tidak ada 1 toko yang jauh melampaui yang lain. Ini konsisten dengan temuan sebelumnya di Executive Summary bahwa distribusi revenue antar **store type** juga hampir merata.

**Implikasi bisnis:** Tidak ditemukan "toko bintang" tunggal yang bisa dijadikan studi kasus best practice — performa toko cenderung merata di seluruh jaringan, bukan didorong oleh beberapa toko unggulan saja.

### 2. Role Salesperson Tidak Mempengaruhi Revenue Secara Signifikan (dari Bar Chart "Average Revenue by Salesperson Role")

Rata-rata revenue per orang **nyaris identik** di keempat role: Manager, Salesperson, Senior Salesperson, dan Sales Associate — semuanya berkisar di angka yang sama (selisih hanya ribuan dari total jutaan).

**Ini temuan penting:** secara intuisi bisnis, biasanya role yang lebih senior (Manager, Senior Salesperson) diharapkan menghasilkan revenue lebih tinggi karena pengalaman atau ditempatkan di toko strategis. Namun data ini **tidak menunjukkan pola tersebut** — konsisten dengan temuan kita di tahap Data Transformation bahwa atribut kategorikal (role, segment, dll) cenderung tidak berkorelasi dengan hasil penjualan pada dataset ini.

### 3. Top Salesperson Individual Didominasi Peran yang Beragam (dari Table "Top 10 Salespersons by Revenue")

Dari 10 salesperson dengan revenue tertinggi, terlihat kombinasi role yang bervariasi: Sales Associate, Salesperson, Manager, dan Senior Salesperson **sama-sama muncul** di daftar top 10 — bukan didominasi 1 role tertentu saja. Ini memperkuat insight #2: performa individual lebih dipengaruhi faktor lain (kemungkinan random pada dataset sintetis ini) dibanding jabatan/role.

### 4. Manager Toko Tersebar di Berbagai Lokasi dan Tipe Toko (dari Table "Store Details by Manager")

Tabel ini menunjukkan bahwa manager-manager toko top tidak terkonsentrasi di 1 lokasi atau 1 tipe toko saja — tersebar di berbagai kota (Denver, Fort Worth, Colorado Springs, Austin, dst) dan tipe toko (Supermarkets, Small Stores, Large Malls). Ini menjadi referensi lengkap untuk **audit/pelacakan individual** toko dan manager yang bertanggung jawab, meskipun tidak menunjukkan pola performa geografis tertentu.

---

## Kenapa Pakai Chart Ini? (Rationale)

### Bar Chart (Horizontal) — untuk Top 10 Stores by Revenue
**Alasan:** Sama seperti prinsip di halaman-halaman sebelumnya, Bar Chart adalah cara paling efisien untuk membandingkan nilai antar entitas diskrit (dalam hal ini, nama toko). Horizontal dipilih karena nama toko dan filter Top 10 membuat daftar cukup panjang untuk dibaca dengan nyaman dalam orientasi horizontal dibanding vertical.

**Kenapa perlu filter Top N = 10, bukan menampilkan semua 500 toko?** Menampilkan seluruh 500 toko dalam 1 bar chart akan membuat visual tidak terbaca (bar terlalu tipis/padat) dan kehilangan fokus. Top N membantu pembaca langsung melihat "siapa yang terbaik" tanpa harus menyaring data yang tidak relevan secara visual.

### Bar Chart (Horizontal) — untuk Average Revenue by Salesperson Role
**Alasan:** Dengan hanya 4 kategori role, Bar Chart memungkinkan perbandingan cepat dan langsung antar role — cocok untuk menjawab pertanyaan sederhana "role mana yang secara rata-rata menghasilkan revenue lebih besar?"

**Kenapa pakai Average, bukan Sum?** Karena jumlah orang di tiap role berbeda-beda (Manager: 500 orang, Sales Associate: 528 orang, dst), menggunakan Sum akan bias terhadap role dengan jumlah orang lebih banyak. Average memberikan perbandingan yang adil "per individu", bukan "per kelompok".

### Table — untuk Top 10 Salespersons by Revenue
**Alasan:** Ketika kebutuhan pembaca adalah melihat **detail individual** (nama, role, jumlah transaksi, total revenue, rata-rata transaksi) untuk sejumlah kecil entitas (10 orang), Table adalah pilihan paling langsung dan presisi — tidak ada chart visual yang bisa menampilkan 5 metrik sekaligus per baris data seefisien Table.

### Table — untuk Store Details by Manager
**Alasan:** Tabel ini berfungsi sebagai **data referensi lengkap** (store, tipe, lokasi, nama manager, revenue) yang perlu ditampilkan secara utuh untuk keperluan audit atau pelacakan individual — bukan untuk visualisasi pola, melainkan untuk pencarian dan verifikasi detail spesifik. Table adalah satu-satunya jenis visual yang cocok untuk kebutuhan referensi seperti ini.

---

## Prinsip Umum di Balik Layout Halaman Ini

1. **2 Bar Chart di baris atas** → memberikan gambaran cepat dari 2 sudut pandang berbeda: performa toko (entitas fisik) dan performa berdasarkan role (struktur organisasi)
2. **2 Table di baris bawah** → melengkapi bar chart di atasnya dengan detail individual yang lebih granular — bar chart menjawab "siapa/apa yang terbaik", table menjawab "siapa persisnya dan berapa detail angkanya"
3. **Filter Top N dipakai konsisten** di visual store dan salesperson → menjaga fokus pembaca pada entitas berkinerja terbaik, tanpa membanjiri dashboard dengan seluruh 500 toko atau 2.000 salesperson sekaligus
