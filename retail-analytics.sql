-- ================================================================
-- RETAIL ANALYTICS PROJECT — FULL SQL SOURCE
-- Database: DuckDB (retail_analytics.duckdb)
-- Mencakup: Data Collection, Profiling, Cleaning, Transformation, 
--           EDA, dan Analytical Dataset Creation (Step 2-8)
-- ================================================================


-- ================================================================
-- STEP 2: DATA COLLECTION
-- ================================================================

-- Load seluruh CSV dari dataset Retail Store Star Schema (Kaggle)
CREATE TABLE dim_products AS 
SELECT * FROM read_csv_auto('RetailStoreStarSchemaDataset/dim_products.csv');

CREATE TABLE dim_customers AS 
SELECT * FROM read_csv_auto('RetailStoreStarSchemaDataset/dim_customers.csv');

CREATE TABLE dim_stores AS 
SELECT * FROM read_csv_auto('RetailStoreStarSchemaDataset/dim_stores.csv');

CREATE TABLE dim_salespersons AS 
SELECT * FROM read_csv_auto('RetailStoreStarSchemaDataset/dim_salespersons.csv');

CREATE TABLE dim_campaigns AS 
SELECT * FROM read_csv_auto('RetailStoreStarSchemaDataset/dim_campaigns.csv');

CREATE TABLE dim_dates AS 
SELECT * FROM read_csv_auto('RetailStoreStarSchemaDataset/dim_dates.csv');

CREATE TABLE fact_sales_normalized AS 
SELECT * FROM read_csv_auto('RetailStoreStarSchemaDataset/fact_sales_normalized.csv');

CREATE TABLE fact_sales_denormalized AS 
SELECT * FROM read_csv_auto('RetailStoreStarSchemaDataset/fact_sales_denormalized.csv');

-- Verifikasi semua tabel berhasil dimuat
SHOW TABLES;


-- ================================================================
-- STEP 3: DATA PROFILING / DATA QUALITY ASSESSMENT
-- ================================================================

-- 3.1 Referential integrity — cek orphan record di semua relasi FK
-- Hasil: 0 orphan di semua relasi, data bersih untuk di-JOIN
SELECT 
    (SELECT COUNT(*) FROM fact_sales_normalized f LEFT JOIN dim_customers c ON f.customer_sk = c.customer_sk WHERE c.customer_sk IS NULL) AS orphan_customer,
    (SELECT COUNT(*) FROM fact_sales_normalized f LEFT JOIN dim_products p ON f.product_sk = p.product_sk WHERE p.product_sk IS NULL) AS orphan_product,
    (SELECT COUNT(*) FROM fact_sales_normalized f LEFT JOIN dim_stores s ON f.store_sk = s.store_sk WHERE s.store_sk IS NULL) AS orphan_store,
    (SELECT COUNT(*) FROM fact_sales_normalized f LEFT JOIN dim_salespersons sp ON f.salesperson_sk = sp.salesperson_sk WHERE sp.salesperson_sk IS NULL) AS orphan_salesperson,
    (SELECT COUNT(*) FROM fact_sales_normalized f LEFT JOIN dim_campaigns cp ON f.campaign_sk = cp.campaign_sk WHERE cp.campaign_sk IS NULL) AS orphan_campaign;

-- 3.2 Missing values check
-- Hasil: 0 NULL di semua kolom, semua tabel
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(product_id) AS null_product_id,
    COUNT(*) - COUNT(product_name) AS null_product_name,
    COUNT(*) - COUNT(category) AS null_category,
    COUNT(*) - COUNT(brand) AS null_brand,
    COUNT(*) - COUNT(origin_location) AS null_origin
FROM dim_products;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(customer_id) AS null_id,
    COUNT(*) - COUNT(email) AS null_email,
    COUNT(*) - COUNT(residential_location) AS null_location,
    COUNT(*) - COUNT(customer_segment) AS null_segment
FROM dim_customers;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(customer_sk) AS null_customer,
    COUNT(*) - COUNT(product_sk) AS null_product,
    COUNT(*) - COUNT(store_sk) AS null_store,
    COUNT(*) - COUNT(salesperson_sk) AS null_salesperson,
    COUNT(*) - COUNT(campaign_sk) AS null_campaign,
    COUNT(*) - COUNT(total_amount) AS null_amount,
    COUNT(*) - COUNT(sales_date) AS null_date
FROM fact_sales_normalized;

-- 3.3 Duplicate check
-- Hasil: tidak ada duplikat, total rows = unique count di semua tabel
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT sales_id) AS unique_sales_id FROM fact_sales_normalized;
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT customer_id) AS unique_customer_id FROM dim_customers;
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT product_id) AS unique_product_id FROM dim_products;

-- 3.4 Outlier check pada total_amount
-- Hasil: range 500-4999.98, tidak ada transaksi negatif/nol
SELECT 
    MIN(total_amount) AS min_amount,
    MAX(total_amount) AS max_amount,
    AVG(total_amount) AS avg_amount,
    MEDIAN(total_amount) AS median_amount,
    COUNT(*) FILTER (WHERE total_amount <= 0) AS transaksi_negatif_atau_nol
FROM fact_sales_normalized;

-- 3.5 Date range check
-- Hasil: 2024-01-02 s/d 2024-12-26, sesuai ekspektasi 1 tahun penuh
SELECT MIN(sales_date) AS tanggal_awal, MAX(sales_date) AS tanggal_akhir FROM fact_sales_normalized;


-- ================================================================
-- STEP 4: DATA CLEANING
-- Berdasarkan hasil profiling di Step 3, tidak ditemukan masalah 
-- kualitas data (0 NULL, 0 duplikat, 0 orphan, 0 outlier negatif).
-- Cleaning check: PASSED, tidak ada aksi cleaning yang diperlukan.
-- ================================================================


-- ================================================================
-- STEP 5: DATA MODELING
-- Struktur star schema sudah given dari sumber data (1 fact table 
-- + 6 dimension table), dihubungkan lewat surrogate key (_sk).
-- Diagram ERD didokumentasikan terpisah di data-modeling.md
-- ================================================================


-- ================================================================
-- STEP 6: DATA TRANSFORMATION
-- ================================================================

-- 6.1 KPI dasar — baseline keseluruhan
SELECT 
    COUNT(*) AS total_transaksi,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_transaksi,
    COUNT(DISTINCT customer_sk) AS total_customer_aktif,
    COUNT(DISTINCT product_sk) AS total_produk_terjual,
    COUNT(DISTINCT store_sk) AS total_toko_aktif
FROM fact_sales_normalized;

-- 6.2 Revenue per bulan (trend)
SELECT 
    strftime(sales_date, '%Y-%m') AS bulan,
    COUNT(*) AS jumlah_transaksi,
    SUM(total_amount) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_transaksi
FROM fact_sales_normalized
GROUP BY bulan
ORDER BY bulan;

-- 6.3 Revenue per kategori produk
SELECT 
    p.category,
    COUNT(*) AS jumlah_transaksi,
    SUM(f.total_amount) AS total_revenue,
    ROUND(AVG(f.total_amount), 2) AS avg_transaksi,
    ROUND(100.0 * SUM(f.total_amount) / SUM(SUM(f.total_amount)) OVER (), 2) AS persen_kontribusi
FROM fact_sales_normalized f
JOIN dim_products p ON f.product_sk = p.product_sk
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 6.4 Revenue per store type
SELECT 
    s.store_type,
    COUNT(*) AS jumlah_transaksi,
    SUM(f.total_amount) AS total_revenue,
    ROUND(AVG(f.total_amount), 2) AS avg_transaksi
FROM fact_sales_normalized f
JOIN dim_stores s ON f.store_sk = s.store_sk
GROUP BY s.store_type
ORDER BY total_revenue DESC;

-- 6.5 Top 10 customer by spending
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nama,
    c.residential_location,
    c.customer_segment,
    COUNT(*) AS jumlah_transaksi,
    SUM(f.total_amount) AS total_spending
FROM fact_sales_normalized f
JOIN dim_customers c ON f.customer_sk = c.customer_sk
GROUP BY c.customer_id, c.first_name, c.last_name, c.residential_location, c.customer_segment
ORDER BY total_spending DESC
LIMIT 10;

-- 6.6 RFM Analysis
-- a. Hitung R, F, M mentah per customer
CREATE TABLE rfm_base AS
SELECT 
    c.customer_id,
    c.customer_segment AS existing_segment,
    DATE_DIFF('day', MAX(f.sales_date), (SELECT MAX(sales_date) FROM fact_sales_normalized) + INTERVAL 1 DAY) AS recency_days,
    COUNT(*) AS frequency,
    SUM(f.total_amount) AS monetary
FROM fact_sales_normalized f
JOIN dim_customers c ON f.customer_sk = c.customer_sk
GROUP BY c.customer_id, c.customer_segment;

-- b. Skoring RFM (quintile 1-5 pakai NTILE)
CREATE TABLE rfm_scored AS
SELECT 
    customer_id,
    existing_segment,
    recency_days,
    frequency,
    monetary,
    6 - NTILE(5) OVER (ORDER BY recency_days) AS r_score,
    NTILE(5) OVER (ORDER BY frequency) AS f_score,
    NTILE(5) OVER (ORDER BY monetary) AS m_score
FROM rfm_base;

-- c. Klasifikasi RFM segment final
CREATE TABLE rfm_final AS
SELECT 
    *,
    (r_score + f_score + m_score) AS rfm_total,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN 'At Risk (High Value)'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost / Churned'
        ELSE 'Others'
    END AS rfm_segment
FROM rfm_scored;

-- d. Distribusi RFM segment
SELECT rfm_segment, COUNT(*) AS jumlah_customer, ROUND(AVG(monetary),2) AS avg_spending
FROM rfm_final
GROUP BY rfm_segment
ORDER BY jumlah_customer DESC;

-- e. Validasi: bandingkan existing_segment vs rfm_segment
SELECT 
    existing_segment,
    rfm_segment,
    COUNT(*) AS jumlah_customer
FROM rfm_final
GROUP BY existing_segment, rfm_segment
ORDER BY existing_segment, jumlah_customer DESC;

-- f. Fokus pada segment "Churn Risk" — cek berapa persen yang sebenarnya masih bernilai tinggi
-- Insight: 47.1% customer berlabel "Churn Risk" ternyata Champions/Loyal/At Risk High Value
SELECT 
    existing_segment,
    COUNT(*) AS total,
    COUNT(*) FILTER (WHERE rfm_segment IN ('Champions', 'Loyal Customers', 'At Risk (High Value)')) AS ternyata_masih_bagus,
    ROUND(100.0 * COUNT(*) FILTER (WHERE rfm_segment IN ('Champions', 'Loyal Customers', 'At Risk (High Value)')) / COUNT(*), 1) AS persen_meleset
FROM rfm_final
WHERE existing_segment = 'Churn Risk'
GROUP BY existing_segment;

-- 6.7 Campaign Effectiveness
CREATE TABLE campaign_performance AS
SELECT 
    cp.campaign_id,
    cp.campaign_name,
    cp.campaign_budget,
    COUNT(f.sales_sk) AS jumlah_transaksi,
    SUM(f.total_amount) AS total_revenue,
    ROUND(SUM(f.total_amount) / cp.campaign_budget, 2) AS roi_ratio,
    ROUND(SUM(f.total_amount) - cp.campaign_budget, 2) AS net_gain
FROM dim_campaigns cp
LEFT JOIN fact_sales_normalized f ON cp.campaign_sk = f.campaign_sk
GROUP BY cp.campaign_id, cp.campaign_name, cp.campaign_budget
ORDER BY roi_ratio DESC;

-- Top 5 & bottom 5 ROI
SELECT * FROM campaign_performance ORDER BY roi_ratio DESC LIMIT 5;
SELECT * FROM campaign_performance ORDER BY roi_ratio ASC LIMIT 5;

-- Ringkasan ROI keseluruhan
-- Insight: revenue antar campaign seragam (~55jt) terlepas dari besar budget
SELECT 
    ROUND(AVG(roi_ratio), 2) AS avg_roi,
    MIN(roi_ratio) AS min_roi,
    MAX(roi_ratio) AS max_roi,
    ROUND(STDDEV(roi_ratio), 2) AS std_roi
FROM campaign_performance;

-- 6.8 Salesperson Performance
CREATE TABLE salesperson_performance AS
SELECT 
    sp.salesperson_id,
    sp.salesperson_name,
    sp.salesperson_role,
    COUNT(f.sales_sk) AS jumlah_transaksi,
    SUM(f.total_amount) AS total_revenue,
    ROUND(AVG(f.total_amount), 2) AS avg_transaksi
FROM dim_salespersons sp
LEFT JOIN fact_sales_normalized f ON sp.salesperson_sk = f.salesperson_sk
GROUP BY sp.salesperson_id, sp.salesperson_name, sp.salesperson_role;

-- Rata-rata performa per role
-- Insight: revenue nyaris identik di semua role — role tidak berpengaruh signifikan
SELECT 
    salesperson_role,
    COUNT(*) AS jumlah_salesperson,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_orang,
    ROUND(AVG(avg_transaksi), 2) AS avg_nilai_transaksi
FROM salesperson_performance
GROUP BY salesperson_role
ORDER BY avg_revenue_per_orang DESC;

-- 6.9 Store Performance (dengan Manager)
SELECT 
    st.store_id,
    st.store_name,
    st.store_type,
    st.store_location,
    sp.salesperson_name AS manager_name,
    COUNT(f.sales_sk) AS jumlah_transaksi,
    SUM(f.total_amount) AS total_revenue
FROM dim_stores st
JOIN dim_salespersons sp ON st.store_manager_sk = sp.salesperson_sk
LEFT JOIN fact_sales_normalized f ON st.store_sk = f.store_sk
GROUP BY st.store_id, st.store_name, st.store_type, st.store_location, sp.salesperson_name
ORDER BY total_revenue DESC
LIMIT 10;


-- ================================================================
-- STEP 7: EXPLORATORY DATA ANALYSIS (EDA)
-- ================================================================

-- 7.1 Pola transaksi per hari dalam seminggu
-- Hasil: distribusi hampir rata di semua hari, tidak ada pola mingguan signifikan
SELECT 
    dayname(sales_date) AS hari,
    strftime(sales_date, '%w') AS urutan_hari,
    COUNT(*) AS jumlah_transaksi,
    SUM(total_amount) AS total_revenue
FROM fact_sales_normalized
GROUP BY hari, urutan_hari
ORDER BY urutan_hari;

-- 7.2 Pola transaksi per jam (0-23)
-- Hasil: distribusi hampir rata 24 jam, tidak ada jam favorit
SELECT 
    EXTRACT(HOUR FROM sales_date) AS jam,
    COUNT(*) AS jumlah_transaksi,
    SUM(total_amount) AS total_revenue
FROM fact_sales_normalized
GROUP BY jam
ORDER BY jam;

-- 7.3 RFM segment dikelompokkan per kota
-- Hasil: proporsi RFM segment mirip di semua kota, lokasi tidak berpengaruh signifikan
SELECT 
    c.residential_location,
    r.rfm_segment,
    COUNT(*) AS jumlah_customer,
    ROUND(AVG(r.monetary), 2) AS avg_spending
FROM rfm_final r
JOIN dim_customers c ON r.customer_id = c.customer_id
GROUP BY c.residential_location, r.rfm_segment
ORDER BY c.residential_location, jumlah_customer DESC;

-- 7.4 Revenue per bulan dipecah per kategori produk
-- Hasil: semua kategori naik-turun bareng mengikuti pola bulanan yang sama
SELECT 
    strftime(f.sales_date, '%Y-%m') AS bulan,
    p.category,
    SUM(f.total_amount) AS total_revenue
FROM fact_sales_normalized f
JOIN dim_products p ON f.product_sk = p.product_sk
GROUP BY bulan, p.category
ORDER BY bulan, p.category;

-- 7.5 Hubungan antara frequency dan rata-rata monetary
-- Hasil: hubungan hampir linear, konfirmasi perhitungan RFM solid
SELECT 
    frequency,
    COUNT(*) AS jumlah_customer,
    ROUND(AVG(monetary), 2) AS avg_monetary
FROM rfm_base
GROUP BY frequency
ORDER BY frequency;


-- ================================================================
-- STEP 8: ANALYTICAL DATASET CREATION
-- Tujuan: bikin tabel final siap pakai di Power BI tanpa 
-- transformasi tambahan di sisi BI tool
-- ================================================================

-- 8.1 Tabel gabungan data customer + hasil RFM
-- Dipakai untuk: dashboard Customer Segmentation
CREATE TABLE analytical_customer AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.residential_location,
    c.customer_segment AS original_segment,
    r.recency_days,
    r.frequency,
    r.monetary,
    r.r_score,
    r.f_score,
    r.m_score,
    r.rfm_segment
FROM dim_customers c
JOIN rfm_final r ON c.customer_id = r.customer_id;

-- 8.2 Tabel ringkasan penjualan bulanan per kategori & tipe toko
-- Dipakai untuk: dashboard Trend & Product Performance
-- Catatan: bulan pakai DATE_TRUNC (bukan strftime) agar Power BI 
-- membaca kolom sebagai Date, bukan Text — supaya sort kronologis otomatis
CREATE TABLE analytical_monthly_sales AS
SELECT 
    DATE_TRUNC('month', f.sales_date) AS bulan,
    p.category,
    s.store_type,
    COUNT(*) AS jumlah_transaksi,
    SUM(f.total_amount) AS total_revenue,
    ROUND(AVG(f.total_amount), 2) AS avg_transaksi
FROM fact_sales_normalized f
JOIN dim_products p ON f.product_sk = p.product_sk
JOIN dim_stores s ON f.store_sk = s.store_sk
GROUP BY bulan, p.category, s.store_type;

-- 8.3 Tabel performa toko lengkap dengan nama manager
-- Dipakai untuk: dashboard Store Performance
CREATE TABLE analytical_store_performance AS
SELECT 
    st.store_id,
    st.store_name,
    st.store_type,
    st.store_location,
    sp.salesperson_name AS manager_name,
    COUNT(f.sales_sk) AS jumlah_transaksi,
    SUM(f.total_amount) AS total_revenue,
    ROUND(AVG(f.total_amount), 2) AS avg_transaksi
FROM dim_stores st
JOIN dim_salespersons sp ON st.store_manager_sk = sp.salesperson_sk
LEFT JOIN fact_sales_normalized f ON st.store_sk = f.store_sk
GROUP BY st.store_id, st.store_name, st.store_type, st.store_location, sp.salesperson_name;

-- 8.4 Export semua tabel analytical ke CSV
-- Catatan: folder "export" harus sudah ada sebelum query ini dijalankan
COPY analytical_customer TO 'export/analytical_customer.csv' (HEADER, DELIMITER ',');
COPY analytical_monthly_sales TO 'export/analytical_monthly_sales.csv' (HEADER, DELIMITER ',');
COPY analytical_store_performance TO 'export/analytical_store_performance.csv' (HEADER, DELIMITER ',');
COPY campaign_performance TO 'export/campaign_performance.csv' (HEADER, DELIMITER ',');
COPY salesperson_performance TO 'export/salesperson_performance.csv' (HEADER, DELIMITER ',');
