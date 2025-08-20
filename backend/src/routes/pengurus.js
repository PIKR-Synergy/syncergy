import express from 'express';
import pool from '../db.js';
import sessionMiddleware from '../middleware/session.js';
import auditMiddleware from '../middleware/audit.js';

const router = express.Router();
router.use(sessionMiddleware);

// Ambil semua biodata pengurus (exclude soft deleted user & pengurus)
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT b.id, b.user_id, u.name, b.tanggal_lahir, b.nama_orang_tua, b.alamat, b.jabatan, b.tugas, b.foto, b.keterangan, b.created_at, b.updated_at
       FROM biodata_pengurus b
       JOIN users u ON b.user_id = u.user_id
       WHERE u.deleted_at IS NULL AND b.deleted_at IS NULL`
    );
    res.json(rows);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data pengurus.' });
  }
});

// Ambil detail pengurus
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT b.id, b.user_id, u.name, b.tanggal_lahir, b.nama_orang_tua, b.alamat, b.jabatan, b.tugas, b.foto, b.keterangan, b.created_at, b.updated_at
       FROM biodata_pengurus b
       JOIN users u ON b.user_id = u.user_id
       WHERE b.id = ? AND u.deleted_at IS NULL AND b.deleted_at IS NULL`,
      [req.params.id]
    );
    if (!rows.length) return res.status(404).json({ message: 'Pengurus tidak ditemukan.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil detail pengurus.' });
  }
});

// Tambah biodata pengurus
router.post('/', auditMiddleware, async (req, res) => {
  const { user_id, tanggal_lahir, nama_orang_tua, alamat, jabatan, tugas, foto, keterangan } = req.body;
  try {
    await pool.query(
      'INSERT INTO biodata_pengurus (user_id, tanggal_lahir, nama_orang_tua, alamat, jabatan, tugas, foto, keterangan, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())',
      [user_id, tanggal_lahir, nama_orang_tua, alamat, jabatan, tugas, foto, keterangan]
    );
    res.json({ message: 'Biodata pengurus berhasil ditambahkan.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menambah biodata pengurus.' });
  }
});

// Update biodata pengurus
router.put('/:id', auditMiddleware, async (req, res) => {
  const { tanggal_lahir, nama_orang_tua, alamat, jabatan, tugas, foto, keterangan } = req.body;
  try {
    await pool.query(
      'UPDATE biodata_pengurus SET tanggal_lahir=?, nama_orang_tua=?, alamat=?, jabatan=?, tugas=?, foto=?, keterangan=?, updated_at=NOW() WHERE id=? AND deleted_at IS NULL',
      [tanggal_lahir, nama_orang_tua, alamat, jabatan, tugas, foto, keterangan, req.params.id]
    );
    res.json({ message: 'Biodata pengurus berhasil diupdate.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal update biodata pengurus.' });
  }
});

// Hapus biodata pengurus (soft delete)
router.delete('/:id', auditMiddleware, async (req, res) => {
  try {
    await pool.query('UPDATE biodata_pengurus SET deleted_at=NOW() WHERE id=? AND deleted_at IS NULL', [req.params.id]);
    res.json({ message: 'Biodata pengurus berhasil dihapus.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menghapus biodata pengurus.' });
  }
});

export default router;
    if (!rows.length) return res.status(404).json({ message: 'Pengurus tidak ditemukan.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil detail pengurus.' });
  }
});

// Tambah biodata pengurus
router.post('/', async (req, res) => {
  const { user_id, tanggal_lahir, nama_orang_tua, alamat, jabatan, tugas, foto, keterangan } = req.body;
  try {
    await pool.query('INSERT INTO biodata_pengurus (user_id, tanggal_lahir, nama_orang_tua, alamat, jabatan, tugas, foto, keterangan, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())', [user_id, tanggal_lahir, nama_orang_tua, alamat, jabatan, tugas, foto, keterangan]);
    res.json({ message: 'Biodata pengurus berhasil ditambahkan.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menambah biodata pengurus.' });
  }
});

// Update biodata pengurus
router.put('/:id', async (req, res) => {
  const { tanggal_lahir, nama_orang_tua, alamat, jabatan, tugas, foto, keterangan } = req.body;
  try {
    await pool.query('UPDATE biodata_pengurus SET tanggal_lahir=?, nama_orang_tua=?, alamat=?, jabatan=?, tugas=?, foto=?, keterangan=?, updated_at=NOW() WHERE id=?', [tanggal_lahir, nama_orang_tua, alamat, jabatan, tugas, foto, keterangan, req.params.id]);
    res.json({ message: 'Biodata pengurus berhasil diupdate.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal update biodata pengurus.' });
  }
});

// Hapus biodata pengurus (soft delete)
router.delete('/:id', async (req, res) => {
  try {
    await pool.query('UPDATE biodata_pengurus SET deleted_at=NOW() WHERE id=?', [req.params.id]);
    res.json({ message: 'Biodata pengurus berhasil dihapus.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menghapus biodata pengurus.' });
  }
});

export default router;
