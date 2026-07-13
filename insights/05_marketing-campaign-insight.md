# Marketing Campaign — Insight & Rationale

Dokumentasi ini menjelaskan **temuan (insight)** dari halaman Marketing Campaign, serta **alasan pemilihan tiap chart**.

---

## Insight / Temuan dari Halaman Ini

### 1. Campaign dengan Revenue Tertinggi ≠ Campaign dengan ROI Tertinggi (dari 2 Bar Chart)

Bandingkan daftar **"Top 10 Campaigns by Revenue"** dan **"Top 10 Campaigns by ROI Ratio"** — isinya **hampir sama sekali berbeda**:

- Top by Revenue: Winter Clearance Carnival, New Arrival Showcase, Seasonal Surprise Box, dst.
- Top by ROI: Green Weekend Deals, Instant Gratification Sale, New Arrival Showcase, dst.

Hanya sedikit campaign yang muncul di kedua daftar. Ini bukti awal bahwa **kedua metrik ini mengukur hal yang berbeda** — Revenue mengukur "seberapa besar hasil penjualan", sementara ROI mengukur "seberapa efisien budget yang dikeluarkan" — dan keduanya tidak selalu berjalan beriringan.

### 2. Revenue Tidak Berkorelasi dengan Besar Budget (dari Scatter Chart "Campaign Budget vs Revenue") — INSIGHT UTAMA

Titik-titik pada scatter chart tersebar **flat secara horizontal** di rentang 54M–56M revenue, **terlepas dari besar budget** (dari 0.2M hingga 1.0M). Tidak ada tren naik dari kiri ke kanan — artinya campaign dengan budget 1 juta menghasilkan revenue yang **kurang lebih sama** dengan campaign berbudget 200 ribu.

**Kesimpulan kritis:** ROI Ratio yang tinggi pada beberapa campaign (lihat Insight #1) **bukan disebabkan oleh campaign tersebut lebih efektif menghasilkan penjualan**, melainkan murni karena **pembagi (budget) yang kecil**. Ini adalah temuan analitis paling penting di halaman ini, karena membantah kesimpulan naif yang sering diambil dalam praktik bisnis: *"campaign dengan ROI tertinggi = campaign terbaik"*.

**Rekomendasi bisnis:** Evaluasi campaign sebaiknya tidak hanya mengandalkan ROI Ratio, karena metrik ini bisa menyesatkan ketika budget antar campaign bervariasi jauh. Revenue absolut dan `net_gain` (revenue dikurangi budget) memberikan gambaran yang lebih adil untuk membandingkan dampak nyata tiap campaign.

### 3. Rata-rata ROI Keseluruhan (dari Card "Average ROI Across Campaigns")

Rata-rata ROI di seluruh campaign adalah **127** — namun berdasarkan Insight #2, angka ini sebagian besar dipengaruhi oleh variasi budget, bukan variasi efektivitas campaign. Angka ini sebaiknya dibaca sebagai *"rata-rata rasio revenue terhadap budget"*, bukan *"rata-rata efektivitas campaign"*.

### 4. Net Gain Relatif Merata di Semua Campaign (dari Table "Campaign Performance Summary")

Melihat kolom `net_gain` di tabel, nilainya berkisar **53–55 juta** di hampir semua campaign — jauh lebih konsisten dibanding `roi_ratio` yang bervariasi drastis (58 hingga 521). Ini memperkuat kesimpulan bahwa **dampak riil (net gain) tiap campaign relatif setara**, sementara ROI Ratio yang terlihat "mencolok" pada beberapa campaign murni adalah artefak matematis dari budget yang kecil.

---

## Kenapa Pakai Chart Ini? (Rationale)

### Card — untuk Average ROI Across Campaigns
**Alasan:** Konsisten dengan prinsip di halaman-halaman sebelumnya — Card dipakai untuk highlight 1 angka ringkasan penting di awal halaman.

### Bar Chart (Horizontal) — untuk Top 10 Campaigns by Revenue & by ROI Ratio
**Alasan:** Dua Bar Chart terpisah (bukan digabung) dipilih secara sengaja untuk **memungkinkan perbandingan langsung** antara dua metrik yang berbeda maknanya. Jika digabung dalam 1 chart, pembaca akan kesulitan membedakan urutan mana yang berdasarkan Revenue dan mana yang berdasarkan ROI. Dengan memisahkannya, pembaca bisa langsung melihat bahwa **daftar campaign di kedua chart berbeda** — ini justru bagian dari cara chart ini menyampaikan insight.

### Scatter Chart — untuk Campaign Budget vs Revenue
**Alasan:** Scatter Chart adalah pilihan tepat untuk menguji **ada tidaknya hubungan (korelasi)** antara dua variabel numerik kontinu (`campaign_budget` dan `total_revenue`). Pola sebaran titik (naik, turun, atau flat) langsung menjawab pertanyaan "apakah budget besar menghasilkan revenue besar?" — sesuatu yang tidak bisa dijawab semudah ini oleh Bar Chart maupun Table.

**Kenapa bukan Bar Chart untuk membandingkan budget dan revenue?** Bar Chart cocok untuk membandingkan 1 metrik antar kategori, tapi tidak dirancang untuk menunjukkan **hubungan/korelasi** antara 2 metrik numerik sekaligus. Scatter Chart secara spesifik dirancang untuk tujuan ini.

### Table — untuk Campaign Performance Summary
**Alasan:** Table digunakan untuk menampilkan **seluruh metrik penting** (budget, revenue, ROI ratio, net gain) dalam satu tempat secara presisi per campaign — memungkinkan pembaca melakukan pengecekan detail atau perbandingan manual antar campaign yang tidak tercakup dalam Top 10 di chart lain.

---

## Prinsip Umum di Balik Layout Halaman Ini

1. **Card di kiri atas** → tetap mengikuti pola "angka ringkasan utama duluan" seperti di semua halaman lain
2. **2 Bar Chart bersisian (Revenue vs ROI)** → sengaja diletakkan berdampingan agar pembaca bisa langsung membandingkan secara visual bahwa kedua daftar Top 10 tersebut berbeda, memicu pertanyaan "kenapa bisa beda?" yang kemudian dijawab oleh scatter chart di sampingnya
3. **Scatter Chart diberi ruang lebih besar di sisi kanan atas** → karena inilah insight paling penting dan paling "membuka mata" di seluruh halaman ini, sehingga diberi porsi visual yang menonjol
4. **Table di bagian bawah sebagai penutup** → merangkum seluruh angka pendukung untuk insight-insight yang sudah disampaikan chart-chart di atasnya, sekaligus menjadi rujukan detail bagi pembaca yang ingin verifikasi angka pasti
