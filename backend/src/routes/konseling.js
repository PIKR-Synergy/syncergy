import express from 'express';
import pool from '../db.js';
import sessionMiddleware from '../middleware/session.js';
import auditMiddleware from '../middleware/audit.js';

const router = express.Router();
router.use(sessionMiddleware);

// Ambil semua konseling (exclude soft deleted)
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT k.*, u.name as konselor_name FROM konseling k LEFT JOIN users u ON k.konselor_id = u.user_id WHERE k.deleted_at IS NULL'
    );
    res.json(rows);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data konseling.' });
  }
});

// Ambil detail konseling
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT k.*, u.name as konselor_name FROM konseling k LEFT JOIN users u ON k.konselor_id = u.user_id WHERE k.id = ? AND k.deleted_at IS NULL',
      [req.params.id]
    );
    if (!rows.length) return res.status(404).json({ message: 'Konseling tidak ditemukan.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil detail konseling.' });
  }
});

// Tambah konseling
router.post('/', auditMiddleware, async (req, res) => {
  const {
    tanggal,
    waktu_mulai,
    waktu_selesai,
    tema,
    konselor_id,
    peserta_id,
    jenis,
    status,
    metode,
    lokasi,
    jumlah_peserta,
    catatan,
    follow_up_required,
    follow_up_date,
    rating,
    feedback
  } = req.body;
  try {
    await pool.query(
      `INSERT INTO konseling (
        tanggal, waktu_mulai, waktu_selesai, tema, konselor_id, peserta_id, jenis, status, metode, lokasi, jumlah_peserta, catatan, follow_up_required, follow_up_date, rating, feedback, created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())`,
      [
        tanggal,
        waktu_mulai,
        waktu_selesai,
        tema,
        konselor_id,
        peserta_id,
        jenis,
        status,
        metode,
        lokasi,
        jumlah_peserta,
        catatan,
        follow_up_required,
        follow_up_date,
        rating,
        feedback
      ]
    );
    res.json({ message: 'Konseling berhasil ditambahkan.' });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Gagal menambah konseling.' });
  }
});

// Update konseling
router.put('/:id', auditMiddleware, async (req, res) => {
  const {
    tanggal,
    waktu_mulai,
    waktu_selesai,
    tema,
    konselor_id,
    peserta_id,
    jenis,
    status,
    metode,
    lokasi,
    jumlah_peserta,
    catatan,
    follow_up_required,
    follow_up_date,
    rating,
    feedback
  } = req.body;
  try {
    await pool.query(
      `UPDATE konseling SET tanggal=?, waktu_mulai=?, waktu_selesai=?, tema=?, konselor_id=?, peserta_id=?, jenis=?, status=?, metode=?, lokasi=?, jumlah_peserta=?, catatan=?, follow_up_required=?, follow_up_date=?, rating=?, feedback=?, updated_at=NOW() WHERE id=? AND deleted_at IS NULL`,
      [
        tanggal,
        waktu_mulai,
        waktu_selesai,
        tema,
        konselor_id,
        peserta_id,
        jenis,
        status,
        metode,
        lokasi,
        jumlah_peserta,
        catatan,
        follow_up_required,
        follow_up_date,
        rating,
        feedback,
        req.params.id
      ]
    );
    res.json({ message: 'Konseling berhasil diupdate.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal update konseling.' });
  }
});

// Soft delete konseling
router.delete('/:id', auditMiddleware, async (req, res) => {
  try {
    await pool.query('UPDATE konseling SET deleted_at=NOW() WHERE id=? AND deleted_at IS NULL', [req.params.id]);
    res.json({ message: 'Konseling berhasil dihapus.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menghapus konseling.' });
  }
});

export default router;