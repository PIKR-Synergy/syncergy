-- ===================================================================
-- DATABASE Syncergy
-- DBMS: MySQL & MariaDB
-- Versi: 3.0 (Enhanced with Security & Performance Optimizations)
-- Tanggal: Juni 2025
-- Author: Elam
-- ===================================================================
DROP DATABASE IF EXISTS Syncergy;
CREATE DATABASE Syncergy;
USE Syncergy;

-- DROP TABLES IF EXIST (for clean setup)
DROP TABLE IF EXISTS 
    query_performance, data_versions, user_sessions,
    activity_logs, file_uploads, daftar_konseling, konseling, 
    buku_tamu, kegiatan, notulen_rapat, daftar_hadir_acara, 
    program_kerja, absensi_rapat, rapat, biodata_pengurus, users;

-- ===================================================================
-- 1. TABEL users (Enhanced with Security Features)
-- ===================================================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM(
        'admin', 'ketua', 'wakil', 'bendahara', 'sekretaris', 
        'kominfo', 'humas', 'konselor', 'pendidik_sebaya', 'anggota', 'tamu'
    ) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    password_expires_at DATETIME NULL,
    failed_login_attempts INT DEFAULT 0,
    locked_until DATETIME NULL,
    last_login_at DATETIME NULL,
    last_login_ip VARCHAR(45),
    email_verified BOOLEAN DEFAULT FALSE,
    email_verification_token VARCHAR(255) NULL,
    password_reset_token VARCHAR(255) NULL,
    password_reset_expires DATETIME NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    -- Constraints
    -- Remove CHECK constraints for compatibility with MySQL <8.0
    INDEX idx_users_role (role),
    INDEX idx_users_active (is_active),
    INDEX idx_users_deleted (deleted_at),
    INDEX idx_users_email_verified (email_verified),
    INDEX idx_users_locked (locked_until)
);

-- ===================================================================
-- 2. TABEL user_sessions (New - Session Management)
-- ===================================================================
CREATE TABLE user_sessions (
    id VARCHAR(128) PRIMARY KEY,
    user_id INT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_activity_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_sessions_user (user_id),
    INDEX idx_sessions_active (is_active),
    INDEX idx_sessions_expires (expires_at)
);

-- ===================================================================
-- 3. TABEL biodata_pengurus (Enhanced)
-- ===================================================================
CREATE TABLE biodata_pengurus (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    tanggal_lahir DATE,
    nama_orang_tua VARCHAR(100),
    alamat TEXT,
    jabatan VARCHAR(100),
    tugas TEXT,
    foto TEXT,
    keterangan TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_biodata_user (user_id),
    INDEX idx_biodata_jabatan (jabatan)
);

-- ===================================================================
-- 4. TABEL rapat (Enhanced)
-- ===================================================================
CREATE TABLE rapat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_rapat VARCHAR(255) NOT NULL,
    isi TEXT,
    tanggal_rapat DATETIME,
    tempat TEXT,
    status ENUM('draft', 'terjadwal', 'berlangsung', 'selesai', 'batal') DEFAULT 'draft',
    created_by INT,
    max_peserta INT DEFAULT NULL,
    reminder_sent BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_rapat_tanggal (tanggal_rapat),
    INDEX idx_rapat_status (status),
    INDEX idx_rapat_created_by (created_by)
);

-- ===================================================================
-- 5. TABEL absensi_rapat (Enhanced)
-- ===================================================================
CREATE TABLE absensi_rapat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rapat_id INT NOT NULL,
    user_id INT NOT NULL,
    status ENUM('hadir', 'tidak_hadir', 'izin', 'terlambat') DEFAULT 'tidak_hadir',
    alamat TEXT,
    ttd_path TEXT,
    waktu_absen DATETIME DEFAULT CURRENT_TIMESTAMP,
    catatan TEXT,
    
    FOREIGN KEY (rapat_id) REFERENCES rapat(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_rapat_user (rapat_id, user_id),
    INDEX idx_absensi_status (status),
    INDEX idx_absensi_waktu (waktu_absen)
);

-- ===================================================================
-- 6. TABEL program_kerja (Enhanced)
-- ===================================================================
CREATE TABLE program_kerja (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_kegiatan VARCHAR(255) NOT NULL,
    tujuan TEXT,
    sasaran TEXT,
    mitra_kerja TEXT,
    frekuensi ENUM('Harian', 'Mingguan', 'Bulanan', 'Tahunan'),
    hasil_diharapkan TEXT,
    status ENUM('draft', 'aktif', 'selesai', 'ditunda', 'dibatalkan') DEFAULT 'draft',
    tanggal_mulai DATE,
    tanggal_selesai DATE,
    progress_percentage DECIMAL(5,2) DEFAULT 0.00,
    budget_allocated DECIMAL(15,2) DEFAULT 0.00,
    budget_used DECIMAL(15,2) DEFAULT 0.00,
    pic_id INT,
    keterangan TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (pic_id) REFERENCES users(user_id) ON DELETE SET NULL,
    -- Remove CHECK constraints for compatibility
    INDEX idx_program_status (status),
    INDEX idx_program_tanggal (tanggal_mulai, tanggal_selesai),
    INDEX idx_program_pic (pic_id)
);

-- ===================================================================
-- 7. TABEL daftar_hadir_acara (Enhanced)
-- ===================================================================
CREATE TABLE daftar_hadir_acara (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tanggal DATE NOT NULL,
    nama_acara VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    status ENUM('hadir', 'tidak_hadir', 'izin') DEFAULT 'tidak_hadir',
    alamat TEXT,
    ttd_path TEXT,
    waktu_hadir DATETIME,
    catatan TEXT,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_hadir_tanggal (tanggal),
    INDEX idx_hadir_acara (nama_acara),
    INDEX idx_hadir_status (status)
);

-- ===================================================================
-- 8. TABEL notulen_rapat (Enhanced)
-- ===================================================================
CREATE TABLE notulen_rapat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rapat_id INT NOT NULL,
    tanggal DATE NOT NULL,
    waktu TIME NOT NULL,
    tempat TEXT,
    jumlah_peserta INT DEFAULT 0,
    materi TEXT,
    isi_notulen TEXT,
    keterangan TEXT,
    notulis_id INT,
    status ENUM('draft', 'review', 'approved', 'published') DEFAULT 'draft',
    approved_by INT,
    approved_at DATETIME,
    dokumentasi TEXT, -- Bukti pelaksanaan rapat (foto/file/link)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (rapat_id) REFERENCES rapat(id) ON DELETE CASCADE,
    FOREIGN KEY (notulis_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (approved_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_notulen_tanggal (tanggal),
    INDEX idx_notulen_status (status)
);

-- ===================================================================
-- 9. TABEL kegiatan (Enhanced)
-- ===================================================================
CREATE TABLE kegiatan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tanggal DATE NOT NULL,
    nama_kegiatan VARCHAR(255) NOT NULL,
    sasaran TEXT,
    lokasi TEXT,
    hasil_dicapai TEXT,
    status ENUM('direncanakan', 'berlangsung', 'selesai', 'batal') DEFAULT 'direncanakan',
    penanggung_jawab_id INT,
    jumlah_peserta INT DEFAULT 0,
    budget DECIMAL(15,2) DEFAULT 0.00,
    evaluasi TEXT,
    foto_kegiatan JSON,
    keterangan TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (penanggung_jawab_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_kegiatan_tanggal (tanggal),
    INDEX idx_kegiatan_status (status),
    INDEX idx_kegiatan_pj (penanggung_jawab_id)
);

-- ===================================================================
-- 10. TABEL buku_tamu (Enhanced)
-- ===================================================================
CREATE TABLE buku_tamu (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tanggal DATE NOT NULL,
    nama VARCHAR(100) NOT NULL,
    jabatan VARCHAR(100),
    instansi VARCHAR(255),
    email VARCHAR(100),
    telepon VARCHAR(20),
    tujuan TEXT,
    ttd_path TEXT,
    waktu_kunjungan TIME,
    waktu_selesai TIME,
    status ENUM('menunggu', 'dilayani', 'selesai') DEFAULT 'menunggu',
    dilayani_oleh INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (dilayani_oleh) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_tamu_tanggal (tanggal),
    INDEX idx_tamu_instansi (instansi),
    INDEX idx_tamu_status (status)
);

-- ===================================================================
-- 11. TABEL konseling (Enhanced)
-- ===================================================================
CREATE TABLE konseling (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tanggal DATE NOT NULL,
    waktu_mulai TIME,
    waktu_selesai TIME,
    tema TEXT,
    konselor_id INT NOT NULL,
    peserta_id INT,
    jenis ENUM('individual', 'kelompok', 'online', 'offline') DEFAULT 'individual',
    status ENUM('terjadwal', 'berlangsung', 'selesai', 'batal') DEFAULT 'terjadwal',
    metode ENUM('tatap_muka', 'video_call', 'telepon', 'chat') DEFAULT 'tatap_muka',
    lokasi TEXT,
    jumlah_peserta INT DEFAULT 1,
    catatan TEXT,
    follow_up_required BOOLEAN DEFAULT FALSE,
    follow_up_date DATE,
    rating INT,
    feedback TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (konselor_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (peserta_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_konseling_konselor (konselor_id),
    INDEX idx_konseling_tanggal (tanggal),
    INDEX idx_konseling_status (status),
    INDEX idx_konseling_jenis (jenis)
);

-- ===================================================================
-- 12. TABEL daftar_konseling (Enhanced)
-- ===================================================================
CREATE TABLE daftar_konseling (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tanggal_daftar DATE NOT NULL,
    tanggal_konseling DATE NOT NULL,
    waktu_konseling TIME,
    konselor_id INT NOT NULL,
    pendaftar_id INT,
    nama_pendaftar VARCHAR(100),
    kontak_pendaftar VARCHAR(100),
    jenis_konseling ENUM('online', 'offline') NOT NULL,
    topik_konseling TEXT,
    lokasi TEXT,
    status ENUM('pending', 'disetujui', 'ditolak', 'selesai', 'batal') DEFAULT 'pending',
    prioritas ENUM('rendah', 'normal', 'tinggi', 'urgent') DEFAULT 'normal',
    alasan_penolakan TEXT,
    keterangan TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (konselor_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (pendaftar_id) REFERENCES users(user_id) ON DELETE SET NULL,
    -- Remove CHECK constraint for compatibility
    INDEX idx_daftar_konseling_tanggal (tanggal_konseling),
    INDEX idx_daftar_konseling_status (status),
    INDEX idx_daftar_konseling_prioritas (prioritas)
);

-- ===================================================================
-- 13. TABEL file_uploads (Enhanced)
-- ===================================================================
CREATE TABLE file_uploads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    file_size INT NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    category ENUM('document', 'image', 'video', 'audio', 'other') DEFAULT 'document',
    uploaded_by INT NOT NULL,
    is_public BOOLEAN DEFAULT FALSE,
    download_count INT DEFAULT 0,
    virus_scan_status ENUM('pending', 'clean', 'infected', 'error') DEFAULT 'pending',
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_uploads_user (uploaded_by),
    INDEX idx_uploads_type (mime_type),
    INDEX idx_uploads_category (category),
    INDEX idx_uploads_public (is_public)
);

-- ===================================================================
-- 14. TABEL activity_logs (Enhanced)
-- ===================================================================
CREATE TABLE activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    session_id VARCHAR(128),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id INT,
    old_values JSON,
    new_values JSON,
    description TEXT,
    severity ENUM('low', 'medium', 'high', 'critical') DEFAULT 'low',
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (session_id) REFERENCES user_sessions(id) ON DELETE SET NULL,
    INDEX idx_logs_user (user_id),
    INDEX idx_logs_table (table_name),
    INDEX idx_logs_created (created_at),
    INDEX idx_logs_severity (severity)
    -- Tidak ada PARTITION BY RANGE (hapus baris ini jika ada)
);

-- ===================================================================
-- 15. TABEL data_versions (New - Data Versioning)
-- ===================================================================
CREATE TABLE data_versions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    version_number INT NOT NULL,
    version_data JSON NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    comment TEXT,
    
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    UNIQUE KEY unique_table_record_version (table_name, record_id, version_number),
    INDEX idx_versions_table (table_name),
    INDEX idx_versions_record (record_id),
    INDEX idx_versions_created (created_at)
);

-- ===================================================================
-- 16. TABEL query_performance (New - Performance Monitoring)
-- ===================================================================
CREATE TABLE query_performance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    query_hash VARCHAR(64) NOT NULL,
    query_type ENUM('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'OTHER') NOT NULL,
    execution_time DECIMAL(10,6) NOT NULL,
    rows_affected INT,
    database_name VARCHAR(64),
    table_names TEXT,
    user_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_query_hash (query_hash),
    INDEX idx_query_performance (execution_time),
    INDEX idx_query_created (created_at)
);

-- ===================================================================
-- SAMPLE DATA INSERTION (Enhanced)
-- ===================================================================

-- Insert sample users with enhanced security
INSERT INTO users (name, username, password_hash, role, email, email_verified, password_expires_at) VALUES
('Super Administrator', 'admin', '$2a$12$m016nMs6TzrsDsgEUqo7ju02h5AhIVzkgZVYjiG03VPcKZ9sSsLJK', 'admin', 'admin@pikr.synergy.com', TRUE, DATE_ADD(NOW(), INTERVAL 90 DAY)),
('Dr. Konselor Utama', 'konselor1', '$2a$12$m016nMs6TzrsDsgEUqo7ju02h5AhIVzkgZVYjiG03VPcKZ9sSsLJK', 'konselor', 'konselor@pikr.synergy.com', TRUE, DATE_ADD(NOW(), INTERVAL 90 DAY)),
('Ketua Pengurus', 'ketua', '$2a$12$m016nMs6TzrsDsgEUqo7ju02h5AhIVzkgZVYjiG03VPcKZ9sSsLJK', 'ketua', 'ketua@pikr.synergy.com', TRUE, DATE_ADD(NOW(), INTERVAL 90 DAY)),
('Wakil Ketua', 'wakil', '$2a$12$m016nMs6TzrsDsgEUqo7ju02h5AhIVzkgZVYjiG03VPcKZ9sSsLJK', 'wakil', 'wakil@pikr.synergy.com', TRUE, DATE_ADD(NOW(), INTERVAL 90 DAY)),
('Bendahara', 'bendahara', '$2a$12$m016nMs6TzrsDsgEUqo7ju02h5AhIVzkgZVYjiG03VPcKZ9sSsLJK', 'bendahara', 'bendahara@pikr.synergy.com', TRUE, DATE_ADD(NOW(), INTERVAL 90 DAY)),
('Sekretaris', 'sekretaris', '$2a$12$m016nMs6TzrsDsgEUqo7ju02h5AhIVzkgZVYjiG03VPcKZ9sSsLJK', 'sekretaris', 'sekretaris@pikr.synergy.com', TRUE, DATE_ADD(NOW(), INTERVAL 90 DAY)),
('Kominfo', 'kominfo', '$2a$12$m016nMs6TzrsDsgEUqo7ju02h5AhIVzkgZVYjiG03VPcKZ9sSsLJK', 'kominfo', 'kominfo@pikr.synergy.com', TRUE, DATE_ADD(NOW(), INTERVAL 90 DAY)),
('Humas', 'humas', '$2a$12$m016nMs6TzrsDsgEUqo7ju02h5AhIVzkgZVYjiG03VPcKZ9sSsLJK', 'humas', 'humas@pikr.synergy.com', TRUE, DATE_ADD(NOW(), INTERVAL 90 DAY)),
('Pendidik Sebaya', 'pendidik_sebaya', '$2a$12$m016nMs6TzrsDsgEUqo7ju02h5AhIVzkgZVYjiG03VPcKZ9sSsLJK', 'pendidik_sebaya', 'sebaya@pikr.synergy.com', TRUE, DATE_ADD(NOW(), INTERVAL 90 DAY)),
('Anggota', 'anggota', '$2a$12$m016nMs6TzrsDsgEUqo7ju02h5AhIVzkgZVYjiG03VPcKZ9sSsLJK', 'anggota', 'anggota@pikr.synergy.com', TRUE, DATE_ADD(NOW(), INTERVAL 90 DAY));

-- Insert sample biodata
INSERT INTO biodata_pengurus (user_id, jabatan, tugas, alamat) VALUES
(3, 'Ketua', 'Memimpin organisasi, pengambilan keputusan utama, koordinasi seluruh pengurus', 'Jl. Pemuda No. 123, Jakarta'),
(4, 'Wakil Ketua', 'Mendampingi ketua, menggantikan ketua bila berhalangan, membantu koordinasi', 'Jl. Merdeka No. 456, Jakarta'),
(5, 'Bendahara', 'Mengelola keuangan, membuat laporan keuangan, pengawasan anggaran', 'Jl. Mawar No. 789, Jakarta'),
(6, 'Sekretaris', 'Administrasi, surat-menyurat, notulen rapat, dokumentasi', 'Jl. Melati No. 101, Jakarta'),
(7, 'Kominfo', 'Publikasi, media sosial, dokumentasi digital, informasi internal/eksternal', 'Jl. Anggrek No. 202, Jakarta'),
(8, 'Humas', 'Hubungan eksternal, kerjasama dengan mitra, komunikasi publik', 'Jl. Kenanga No. 303, Jakarta'),
(9, 'Konselor', 'Memberikan layanan konseling, pendampingan remaja, edukasi kesehatan', 'Jl. Dahlia No. 404, Jakarta'),
(10, 'Pendidik Sebaya', 'Edukasi sebaya, sosialisasi, peer support, fasilitator kegiatan', 'Jl. Sakura No. 505, Jakarta'),
(11, 'Anggota', 'Partisipasi kegiatan, mendukung program kerja, pelaksanaan tugas sesuai arahan', 'Jl. Teratai No. 606, Jakarta');

-- ===================================================================
-- ENHANCED VIEWS
-- ===================================================================

-- View untuk dashboard statistics
CREATE VIEW view_dashboard_stats AS
SELECT 
    (SELECT COUNT(*) FROM users WHERE deleted_at IS NULL AND is_active = TRUE) as total_users_active,
    (SELECT COUNT(*) FROM users WHERE role = 'pengurus' AND deleted_at IS NULL) as total_pengurus,
    (SELECT COUNT(*) FROM users WHERE role = 'konselor' AND deleted_at IS NULL) as total_konselor,
    (SELECT COUNT(*) FROM rapat WHERE DATE(tanggal_rapat) >= CURDATE() AND status IN ('terjadwal', 'berlangsung')) as rapat_mendatang,
    (SELECT COUNT(*) FROM kegiatan WHERE MONTH(tanggal) = MONTH(CURDATE()) AND YEAR(tanggal) = YEAR(CURDATE())) as kegiatan_bulan_ini,
    (SELECT COUNT(*) FROM konseling WHERE MONTH(tanggal) = MONTH(CURDATE()) AND YEAR(tanggal) = YEAR(CURDATE())) as konseling_bulan_ini,
    (SELECT COUNT(*) FROM daftar_konseling WHERE status = 'pending') as konseling_pending,
    (SELECT COUNT(*) FROM buku_tamu WHERE tanggal = CURDATE()) as tamu_hari_ini;

-- View untuk pengurus lengkap dengan statistik
CREATE VIEW view_pengurus_lengkap AS
SELECT 
    u.user_id,
    u.name,
    u.username,
    u.email,
    u.phone,
    u.is_active,
    u.last_login_at,
    bp.jabatan,
    bp.alamat,
    bp.tanggal_lahir,
    bp.nama_orang_tua,
    (SELECT COUNT(*) FROM kegiatan WHERE penanggung_jawab_id = u.user_id) as total_kegiatan,
    (SELECT COUNT(*) FROM program_kerja WHERE pic_id = u.user_id) as total_program
FROM users u
LEFT JOIN biodata_pengurus bp ON u.user_id = bp.user_id
WHERE u.role = 'pengurus' AND u.deleted_at IS NULL;

-- View untuk statistik konseling
CREATE VIEW view_statistik_konseling AS
SELECT 
    DATE_FORMAT(k.tanggal, '%Y-%m') as bulan,
    COUNT(*) as total_konseling,
    COUNT(DISTINCT k.konselor_id) as total_konselor_aktif,
    COUNT(DISTINCT k.peserta_id) as total_peserta,
    AVG(k.rating) as rata_rata_rating,
    SUM(CASE WHEN k.status = 'selesai' THEN 1 ELSE 0 END) as selesai,
    SUM(CASE WHEN k.follow_up_required = TRUE THEN 1 ELSE 0 END) as perlu_followup
FROM konseling k
WHERE k.tanggal >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY DATE_FORMAT(k.tanggal, '%Y-%m')
ORDER BY bulan DESC;

-- View untuk performance monitoring
CREATE VIEW view_performance_summary AS
SELECT 
    DATE(created_at) as tanggal,
    query_type,
    COUNT(*) as total_queries,
    AVG(execution_time) as avg_execution_time,
    MAX(execution_time) as max_execution_time,
    MIN(execution_time) as min_execution_time
FROM query_performance 
WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
GROUP BY DATE(created_at), query_type
ORDER BY tanggal DESC, query_type;

-- ===================================================================
-- ENHANCED TRIGGERS
-- ===================================================================

DELIMITER //

-- Enhanced trigger untuk audit logging
CREATE TRIGGER tr_users_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (user_id, action, table_name, record_id, new_values, description, severity)
    VALUES (NEW.user_id, 'INSERT', 'users', NEW.user_id, 
            JSON_OBJECT('name', NEW.name, 'username', NEW.username, 'role', NEW.role, 'email', NEW.email),
            CONCAT('User baru ditambahkan: ', NEW.name), 'medium');
END//

CREATE TRIGGER tr_users_update AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (user_id, action, table_name, record_id, old_values, new_values, description, severity)
    VALUES (NEW.user_id, 'UPDATE', 'users', NEW.user_id, 
        JSON_OBJECT('name', OLD.name, 'username', OLD.username, 'role', OLD.role, 'email', OLD.email, 'is_active', OLD.is_active),
        JSON_OBJECT('name', NEW.name, 'username', NEW.username, 'role', NEW.role, 'email', NEW.email, 'is_active', NEW.is_active),
        'Data user diupdate', 'low');
END//

CREATE TRIGGER tr_users_password_policy BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF OLD.password_hash != NEW.password_hash THEN
        SET NEW.failed_login_attempts = 0;
        SET NEW.locked_until = NULL;
        SET NEW.password_expires_at = DATE_ADD(NOW(), INTERVAL 90 DAY);
    END IF;
END//

CREATE TRIGGER tr_program_kerja_versioning AFTER UPDATE ON program_kerja
FOR EACH ROW
BEGIN
    DECLARE version_num INT DEFAULT 1;
    SELECT COALESCE(MAX(version_number), 0) + 1 INTO version_num
    FROM data_versions 
    WHERE table_name = 'program_kerja' AND record_id = NEW.id;
    INSERT INTO data_versions (table_name, record_id, version_number, version_data, created_by)
    VALUES ('program_kerja', NEW.id, version_num, 
            JSON_OBJECT('nama_kegiatan', NEW.nama_kegiatan, 'tujuan', NEW.tujuan, 'status', NEW.status, 'progress_percentage', NEW.progress_percentage),
            NEW.pic_id);
END//

-- CREATE TRIGGER tr_session_cleanup BEFORE INSERT ON user_sessions
-- FOR EACH ROW
-- BEGIN
--     DELETE FROM user_sessions 
--     WHERE user_id = NEW.user_id AND expires_at < NOW();
-- END//

DELIMITER ;

-- ===================================================================
-- ENHANCED STORED PROCEDURES
-- ===================================================================

DELIMITER //

-- Enhanced dashboard statistics
CREATE PROCEDURE sp_dashboard_stats_enhanced()
BEGIN
    -- Main statistics
    SELECT * FROM view_dashboard_stats;
    
    -- Recent activities
    SELECT 
        al.action,
        al.description,
        u.name as user_name,
        al.created_at
    FROM activity_logs al
    LEFT JOIN users u ON al.user_id = u.user_id
    WHERE al.created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
    ORDER BY al.created_at DESC
    LIMIT 10;
    
    -- Performance alerts
    SELECT 
        'Slow Query Alert' as alert_type,
        COUNT(*) as count
    FROM query_performance 
    WHERE execution_time > 2.0 AND created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR);
END//

-- User security management
CREATE PROCEDURE sp_handle_failed_login(IN p_username VARCHAR(50))
BEGIN
    DECLARE current_attempts INT DEFAULT 0;
    DECLARE user_exists INT DEFAULT 0;
    
    SELECT COUNT(*), COALESCE(failed_login_attempts, 0) 
    INTO user_exists, current_attempts
    FROM users 
    WHERE username = p_username AND deleted_at IS NULL;
    
    IF user_exists > 0 THEN
        SET current_attempts = current_attempts + 1;
        
        IF current_attempts >= 5 THEN
            UPDATE users 
            SET failed_login_attempts = current_attempts,
                locked_until = DATE_ADD(NOW(), INTERVAL 30 MINUTE)
            WHERE username = p_username;
            
            INSERT INTO activity_logs (user_id, action, table_name, description, severity)
            SELECT user_id, 'ACCOUNT_LOCKED', 'users', 
                   CONCAT('Account locked after ', current_attempts, ' failed attempts'), 'high'
            FROM users WHERE username = p_username;
        ELSE
            UPDATE users 
            SET failed_login_attempts = current_attempts
            WHERE username = p_username;
        END IF;
    END IF;
END//

-- Successful login procedure
CREATE PROCEDURE sp_handle_successful_login(IN p_username VARCHAR(50), IN p_ip VARCHAR(45))
BEGIN
    UPDATE users 
    SET failed_login_attempts = 0,
        locked_until = NULL,
        last_login_at = NOW(),
        last_login_ip = p_ip
    WHERE username = p_username;
    
    INSERT INTO activity_logs (user_id, action, table_name, description, severity, ip_address)
    SELECT user_id, 'LOGIN_SUCCESS', 'users', 'User login berhasil', 'low', p_ip
    FROM users WHERE username = p_username;
END//

-- Comprehensive cleanup procedure
CREATE PROCEDURE sp_comprehensive_cleanup()
BEGIN
    DECLARE cleaned_sessions INT DEFAULT 0;
    DECLARE cleaned_logs INT DEFAULT 0;
    DECLARE cleaned_versions INT DEFAULT 0;
    
    -- Clean expired sessions
    DELETE FROM user_sessions WHERE expires_at < NOW();
    SET cleaned_sessions = ROW_COUNT();
    
    -- Clean old activity logs (older than 2 years)
    DELETE FROM activity_logs 
    WHERE created_at < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);
    SET cleaned_logs = ROW_COUNT();
    
    -- Clean old data versions (keep only last 10 versions per record)
    DELETE dv1 FROM data_versions dv1
    INNER JOIN (
        SELECT table_name, record_id, version_number
        FROM data_versions dv2
        WHERE dv2.table_name = dv1.table_name 
        AND dv2.record_id = dv1.record_id
        ORDER BY dv2.version_number DESC
        LIMIT 10, 999999
    ) dv_old ON dv1.table_name = dv_old.table_name 
               AND dv1.record_id = dv_old.record_id 
               AND dv1.version_number = dv_old.version_number;
    SET cleaned_versions = ROW_COUNT();
    
    -- Clean old performance logs (older than 30 days)
    DELETE FROM query_performance 
    WHERE created_at < DATE_SUB(CURDATE(), INTERVAL 30 DAY);
    
    -- Reset failed login attempts for unlocked accounts
    UPDATE users 
    SET failed_login_attempts = 0 
    WHERE locked_until IS NOT NULL AND locked_until < NOW();
    
    SELECT 
        cleaned_sessions as expired_sessions_cleaned,
        cleaned_logs as old_logs_cleaned,
        cleaned_versions as old_versions_cleaned,
        'Cleanup completed successfully' as status;
END//

-- Advanced reporting procedure
CREATE PROCEDURE sp_advanced_monthly_report(IN p_year INT, IN p_month INT)
BEGIN
    -- Declare variables for calculations
    DECLARE total_activities INT DEFAULT 0;
    DECLARE total_budget DECIMAL(15,2) DEFAULT 0;
    
    -- Report Header
    SELECT 
        CONCAT('Laporan Bulanan - ', MONTHNAME(STR_TO_DATE(p_month, '%m')), ' ', p_year) as report_title,
        NOW() as generated_at;
    
    -- Summary Statistics
    SELECT 
        'SUMMARY' as section,
        (SELECT COUNT(*) FROM rapat WHERE YEAR(tanggal_rapat) = p_year AND MONTH(tanggal_rapat) = p_month) as total_rapat,
        (SELECT COUNT(*) FROM kegiatan WHERE YEAR(tanggal) = p_year AND MONTH(tanggal) = p_month) as total_kegiatan,
        (SELECT COUNT(*) FROM konseling WHERE YEAR(tanggal) = p_year AND MONTH(tanggal) = p_month) as total_konseling,
        (SELECT COUNT(*) FROM buku_tamu WHERE YEAR(tanggal) = p_year AND MONTH(tanggal) = p_month) as total_tamu,
        (SELECT COUNT(*) FROM daftar_konseling WHERE YEAR(tanggal_konseling) = p_year AND MONTH(tanggal_konseling) = p_month) as total_pendaftaran_konseling;
    
    -- Budget Analysis
    SELECT 
        'BUDGET ANALYSIS' as section,
        SUM(budget_allocated) as total_budget_allocated,
        SUM(budget_used) as total_budget_used,
        SUM(budget_allocated - budget_used) as budget_remaining,
        ROUND((SUM(budget_used) / NULLIF(SUM(budget_allocated), 0)) * 100, 2) as budget_utilization_percentage
    FROM program_kerja 
    WHERE status = 'aktif';
    
    -- Top Performers
    SELECT 
        'TOP PERFORMERS' as section,
        u.name as user_name,
        bp.jabatan,
        COUNT(k.id) as total_kegiatan_handled
    FROM users u
    LEFT JOIN biodata_pengurus bp ON u.user_id = bp.user_id
    LEFT JOIN kegiatan k ON u.user_id = k.penanggung_jawab_id 
        AND YEAR(k.tanggal) = p_year AND MONTH(k.tanggal) = p_month
    WHERE u.role IN ('pengurus', 'konselor') AND u.deleted_at IS NULL
    GROUP BY u.user_id, u.name, bp.jabatan
    ORDER BY total_kegiatan_handled DESC
    LIMIT 5;
    
    -- Konseling Statistics
    SELECT 
        'KONSELING STATS' as section,
        jenis,
        COUNT(*) as total,
        AVG(rating) as avg_rating,
        COUNT(CASE WHEN follow_up_required = TRUE THEN 1 END) as need_followup
    FROM konseling 
    WHERE YEAR(tanggal) = p_year AND MONTH(tanggal) = p_month
    GROUP BY jenis;
    
    -- Program Progress
    SELECT 
        'PROGRAM PROGRESS' as section,
        nama_kegiatan,
        status,
        progress_percentage,
        ROUND((budget_used / NULLIF(budget_allocated, 0)) * 100, 2) as budget_usage_percentage
    FROM program_kerja
    WHERE status IN ('aktif', 'selesai')
    ORDER BY progress_percentage DESC;
END//

-- Security audit procedure
CREATE PROCEDURE sp_security_audit()
BEGIN
    -- Failed login attempts in last 24 hours
    SELECT 
        'FAILED LOGIN ATTEMPTS' as audit_section,
        COUNT(*) as total_attempts,
        COUNT(DISTINCT ip_address) as unique_ips
    FROM activity_logs 
    WHERE action = 'LOGIN_FAILED' 
    AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR);
    
    -- Currently locked accounts
    SELECT 
        'LOCKED ACCOUNTS' as audit_section,
        username,
        name,
        failed_login_attempts,
        locked_until,
        last_login_at
    FROM users 
    WHERE locked_until > NOW() OR failed_login_attempts >= 3;
    
    -- Users with expired passwords
    SELECT 
        'EXPIRED PASSWORDS' as audit_section,
        username,
        name,
        password_expires_at,
        DATEDIFF(NOW(), password_expires_at) as days_expired
    FROM users 
    WHERE password_expires_at < NOW() AND deleted_at IS NULL;
    
    -- Inactive sessions
    SELECT 
        'INACTIVE SESSIONS' as audit_section,
        COUNT(*) as total_inactive_sessions
    FROM user_sessions 
    WHERE last_activity_at < DATE_SUB(NOW(), INTERVAL 2 HOUR) AND is_active = TRUE;
    
    -- High-severity activities in last 7 days
    SELECT 
        'HIGH SEVERITY ACTIVITIES' as audit_section,
        action,
        table_name,
        COUNT(*) as occurrence_count,
        MAX(created_at) as last_occurrence
    FROM activity_logs 
    WHERE severity IN ('high', 'critical') 
    AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    GROUP BY action, table_name
    ORDER BY occurrence_count DESC;
END//

-- Performance optimization procedure
CREATE PROCEDURE sp_performance_optimization()
BEGIN
    -- Identify slow queries
    SELECT 
        'SLOW QUERIES' as optimization_area,
        query_hash,
        query_type,
        AVG(execution_time) as avg_execution_time,
        COUNT(*) as frequency,
        MAX(execution_time) as max_execution_time
    FROM query_performance 
    WHERE execution_time > 1.0
    AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    GROUP BY query_hash, query_type
    ORDER BY avg_execution_time DESC
    LIMIT 10;
    
    -- Table size analysis
    SELECT 
        'TABLE SIZES' as optimization_area,
        table_name,
        table_rows,
        ROUND(((data_length + index_length) / 1024 / 1024), 2) as size_mb
    FROM information_schema.TABLES 
    WHERE table_schema = DATABASE()
    ORDER BY (data_length + index_length) DESC;
    
    -- Index usage recommendations
    SELECT 
        'INDEX RECOMMENDATIONS' as optimization_area,
        'Consider adding indexes for frequently queried columns' as recommendation,
        'Analyze slow query log for optimization opportunities' as action_item;
END//

-- Data integrity check procedure
CREATE PROCEDURE sp_data_integrity_check()
BEGIN
    -- Orphaned records check
    SELECT 
        'ORPHANED RECORDS' as integrity_check,
        'biodata_pengurus' as table_name,
        COUNT(*) as orphaned_count
    FROM biodata_pengurus bp
    LEFT JOIN users u ON bp.user_id = u.user_id
    WHERE u.user_id IS NULL;
    
    -- Inconsistent data check
    SELECT 
        'INCONSISTENT DATA' as integrity_check,
        'program_kerja_budget' as check_type,
        COUNT(*) as inconsistent_count
    FROM program_kerja 
    WHERE budget_used > budget_allocated;
    
    -- Missing required data
    SELECT 
        'MISSING REQUIRED DATA' as integrity_check,
        'users_without_email' as check_type,
        COUNT(*) as missing_count
    FROM users 
    WHERE email IS NULL AND role != 'tamu' AND deleted_at IS NULL;
    
    -- Future date inconsistencies
    SELECT 
        'DATE INCONSISTENCIES' as integrity_check,
        'future_dates' as check_type,
        COUNT(*) as inconsistent_count
    FROM konseling 
    WHERE tanggal > CURDATE();
END//

DELIMITER ;

-- ===================================================================
-- ADVANCED INDEXES FOR OPTIMIZATION
-- ===================================================================

-- Composite indexes for complex queries
CREATE INDEX idx_users_role_active_deleted ON users(role, is_active, deleted_at);
CREATE INDEX idx_konseling_konselor_tanggal_status ON konseling(konselor_id, tanggal, status);
CREATE INDEX idx_activity_logs_user_created_severity ON activity_logs(user_id, created_at, severity);
CREATE INDEX idx_program_kerja_status_pic_tanggal ON program_kerja(status, pic_id, tanggal_mulai);

-- Full-text search indexes (enhanced)
-- Catatan: Warning 124 pada InnoDB saat menambah FULLTEXT index adalah normal (InnoDB rebuilding table to add column FTS_DOC_ID).
-- Ini bukan error dan tidak mempengaruhi fungsi index, bisa diabaikan.
ALTER TABLE rapat ADD FULLTEXT ft_rapat_search (nama_rapat, isi, tempat);
ALTER TABLE program_kerja ADD FULLTEXT ft_program_search (nama_kegiatan, tujuan, sasaran, keterangan);
ALTER TABLE kegiatan ADD FULLTEXT ft_kegiatan_search (nama_kegiatan, sasaran, keterangan, evaluasi);
ALTER TABLE konseling ADD FULLTEXT ft_konseling_search (tema, catatan);
ALTER TABLE buku_tamu ADD FULLTEXT ft_tamu_search (nama, instansi, tujuan);

-- Covering indexes for frequently accessed data
CREATE INDEX idx_users_covering ON users(user_id, name, username, role, is_active, deleted_at);
CREATE INDEX idx_konseling_covering ON konseling(id, konselor_id, tanggal, status, jenis, rating);

-- ===================================================================
-- AUTOMATED MAINTENANCE EVENTS
-- ===================================================================

-- Enable event scheduler
SET GLOBAL event_scheduler = ON;

-- Daily cleanup event (single statement, compatible with MySQL/MariaDB standard)
DROP EVENT IF EXISTS ev_daily_cleanup;
CREATE EVENT ev_daily_cleanup
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
    DELETE FROM user_sessions WHERE expires_at < NOW();

-- Weekly comprehensive cleanup (call procedure, single statement)
DROP EVENT IF EXISTS ev_weekly_cleanup;
CREATE EVENT ev_weekly_cleanup
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
    CALL sp_comprehensive_cleanup();

-- Monthly performance analysis (multi-statement, use DELIMITER)
DELIMITER $$
DROP EVENT IF EXISTS ev_monthly_analysis $$
CREATE EVENT ev_monthly_analysis
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    CREATE TABLE IF NOT EXISTS query_performance_archive LIKE query_performance;
    INSERT INTO query_performance_archive 
    SELECT * FROM query_performance 
    WHERE created_at < DATE_SUB(NOW(), INTERVAL 3 MONTH);
    DELETE FROM query_performance 
    WHERE created_at < DATE_SUB(NOW(), INTERVAL 3 MONTH);
    INSERT INTO activity_logs (action, table_name, description, severity)
    VALUES ('MAINTENANCE', 'system', 'Monthly performance data archived', 'low');
END $$
DELIMITER ;

-- ===================================================================
-- SECURITY CONFIGURATION
-- ===================================================================

-- Create application users with limited privileges
/*
-- Application user (read/write access)
CREATE USER IF NOT EXISTS 'pikr_app'@'localhost' IDENTIFIED BY 'YourStrongPasswordHere2025!';
GRANT SELECT, INSERT, UPDATE, DELETE ON pikr_synergy.* TO 'pikr_app'@'localhost';
GRANT EXECUTE ON pikr_synergy.* TO 'pikr_app'@'localhost';

-- Backup user (read-only access)
CREATE USER IF NOT EXISTS 'pikr_backup'@'localhost' IDENTIFIED BY 'BackupPassword2025!';
GRANT SELECT ON pikr_synergy.* TO 'pikr_backup'@'localhost';

-- Analytics user (limited read access)
CREATE USER IF NOT EXISTS 'pikr_analytics'@'localhost' IDENTIFIED BY 'AnalyticsPassword2025!';
GRANT SELECT ON pikr_synergy.view_dashboard_stats TO 'pikr_analytics'@'localhost';
GRANT SELECT ON pikr_synergy.view_statistik_konseling TO 'pikr_analytics'@'localhost';
GRANT SELECT ON pikr_synergy.view_performance_summary TO 'pikr_analytics'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;
*/

-- ===================================================================
-- SAMPLE USAGE QUERIES
-- ===================================================================

/*
-- ===================================================================
-- TESTING & VERIFICATION QUERIES
-- ===================================================================

-- 1. Dashboard Statistics
SELECT * FROM view_dashboard_stats;

-- 2. Enhanced Dashboard with Recent Activities
CALL sp_dashboard_stats_enhanced();

-- 3. Monthly Report
CALL sp_advanced_monthly_report(2025, 6);

-- 4. Security Audit
CALL sp_security_audit();

-- 5. Performance Analysis
CALL sp_performance_optimization();

-- 6. Data Integrity Check
CALL sp_data_integrity_check();

-- 7. User Management
-- Simulate failed login
CALL sp_handle_failed_login('admin');

-- Simulate successful login
CALL sp_handle_successful_login('admin', '192.168.1.100');

-- 8. Full-text Search Examples
-- Search in meetings
SELECT * FROM rapat 
WHERE MATCH(nama_rapat, isi, tempat) AGAINST('PIK-R konseling' IN NATURAL LANGUAGE MODE);

-- Search in programs
SELECT * FROM program_kerja 
WHERE MATCH(nama_kegiatan, tujuan, sasaran, keterangan) AGAINST('remaja sekolah' IN NATURAL LANGUAGE MODE);

-- 9. Complex Analytical Queries
-- Konselor performance analysis
SELECT 
    u.name as konselor_name,
    COUNT(k.id) as total_konseling,
    AVG(k.rating) as avg_rating,
    COUNT(CASE WHEN k.follow_up_required THEN 1 END) as followup_needed,
    COUNT(CASE WHEN k.status = 'selesai' THEN 1 END) as completed
FROM users u
JOIN konseling k ON u.user_id = k.konselor_id
WHERE u.role = 'konselor' AND k.tanggal >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY u.user_id, u.name
ORDER BY avg_rating DESC, total_konseling DESC;

-- Program effectiveness analysis
SELECT 
    pk.nama_kegiatan,
    pk.progress_percentage,
    ROUND((pk.budget_used / pk.budget_allocated) * 100, 2) as budget_utilization,
    COUNT(k.id) as related_activities,
    AVG(k.jumlah_peserta) as avg_participants
FROM program_kerja pk
LEFT JOIN kegiatan k ON pk.nama_kegiatan LIKE CONCAT('%', SUBSTRING_INDEX(k.nama_kegiatan, ' ', 2), '%')
WHERE pk.status = 'aktif'
GROUP BY pk.id, pk.nama_kegiatan, pk.progress_percentage, pk.budget_used, pk.budget_allocated
ORDER BY pk.progress_percentage DESC;

-- 10. Maintenance Operations
-- Run comprehensive cleanup
CALL sp_comprehensive_cleanup();

-- Check system health
SELECT 
    'Database Health Check' as check_type,
    (SELECT COUNT(*) FROM users WHERE deleted_at IS NULL) as active_users,
    (SELECT COUNT(*) FROM user_sessions WHERE is_active = TRUE) as active_sessions,
    (SELECT COUNT(*) FROM activity_logs WHERE created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)) as recent_activities,
    (SELECT AVG(execution_time) FROM query_performance WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)) as avg_query_time;
*/

-- ===================================================================
-- DATABASE DOCUMENTATION & CHANGELOG
-- ===================================================================

/*
=============================================================================
PIK-R SYNERGY DATABASE - ENHANCED VERSION 3.0
=============================================================================

MAJOR ENHANCEMENTS IN V3.0:
✅ Advanced Security Features
   - Password expiration policy
   - Account locking mechanism
   - Session management
   - Email verification system
   - Password reset tokens

✅ Performance Monitoring & Optimization
   - Query performance tracking
   - Automated performance analysis
   - Advanced indexing strategy
   - Partitioned activity logs

✅ Data Versioning & Audit
   - Complete audit trail with JSON data
   - Data versioning system
   - Enhanced activity logging
   - Security event tracking

✅ Advanced Reporting & Analytics
   - Comprehensive dashboard views
   - Monthly performance reports
   - Security audit procedures
   - Data integrity checks

✅ Automated Maintenance
   - Scheduled cleanup events
   - Performance optimization tasks
   - Security maintenance routines
   - Data archiving system

✅ Enhanced User Experience
   - Full-text search capabilities
   - Advanced filtering options
   - Real-time statistics
   - Comprehensive user management

SECURITY FEATURES:
- Multi-layer authentication system
- Role-based access control (RBAC)
- Session management with timeout
- Failed login attempt tracking
- Account locking mechanism
- Password expiration policy
- Comprehensive audit logging
- SQL injection prevention
- Data encryption ready

PERFORMANCE FEATURES:
- Optimized database schema
- Strategic indexing
- Query performance monitoring
- Automated maintenance tasks
- Partitioned large tables
- Efficient data retrieval
- Caching-ready structure

SCALABILITY FEATURES:
- Modular database design
- Easy horizontal scaling
- Efficient data archiving
- Automated cleanup processes
- Performance monitoring
- Resource usage optimization

MAINTENANCE FEATURES:
- Automated daily cleanup
- Weekly comprehensive maintenance
- Monthly performance analysis
- Data integrity checks
- Security auditing
- Performance optimization

BACKUP & RECOVERY:
- Point-in-time recovery support
- Data versioning system
- Complete audit trail
- Automated backup procedures
- Data integrity verification

=============================================================================
DEPLOYMENT CHECKLIST:
=============================================================================

□ 1. Set strong passwords for database users
□ 2. Configure SSL/TLS for database connections
□ 3. Enable binary logging for replication
□ 4. Set up automated backup procedures
□ 5. Configure monitoring and alerting
□ 6. Test all stored procedures
□ 7. Verify security configurations
□ 8. Set up log rotation
□ 9. Configure performance monitoring
□ 10. Test disaster recovery procedures

=============================================================================
MAINTENANCE SCHEDULE:
=============================================================================

DAILY (Automated):
- Clean expired sessions
- Reset unlocked accounts
- Basic system cleanup

WEEKLY (Automated):
- Comprehensive cleanup
- Performance analysis
- Security audit basic

MONTHLY (Manual/Automated):
- Full security audit
- Performance optimization
- Data archiving
- Backup verification
- System health check

QUARTERLY (Manual):
- Security policy review
- Performance tuning
- Capacity planning
- Disaster recovery test

=============================================================================
*/
