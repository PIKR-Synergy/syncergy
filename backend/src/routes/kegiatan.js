import express from 'express';
import pool from '../db.js';

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM kegiatan');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data kegiatan.' });
  }
});

// Ambil detail kegiatan
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM kegiatan WHERE id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ message: 'Kegiatan tidak ditemukan.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil detail kegiatan.' });
  }
});

// Tambah kegiatan
router.post('/', async (req, res) => {
  const { nama_kegiatan, deskripsi, tanggal, tempat, status } = req.body;
  try {
    await pool.query('INSERT INTO kegiatan (nama_kegiatan, deskripsi, tanggal, tempat, status) VALUES (?, ?, ?, ?, ?)', [nama_kegiatan, deskripsi, tanggal, tempat, status]);
    res.json({ message: 'Kegiatan berhasil ditambahkan.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menambah kegiatan.' });
  }
});

// Update kegiatan
router.put('/:id', async (req, res) => {
  const { nama_kegiatan, deskripsi, tanggal, tempat, status } = req.body;
  try {
    await pool.query('UPDATE kegiatan SET nama_kegiatan=?, deskripsi=?, tanggal=?, tempat=?, status=? WHERE id=?', [nama_kegiatan, deskripsi, tanggal, tempat, status, req.params.id]);
    res.json({ message: 'Kegiatan berhasil diupdate.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal update kegiatan.' });
  }
});

// Hapus kegiatan
router.delete('/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM kegiatan WHERE id=?', [req.params.id]);
    res.json({ message: 'Kegiatan berhasil dihapus.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menghapus kegiatan.' });
  }
});



// Ambil semua kegiatan (exclude soft deleted)
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT k.*, u.name as penanggung_jawab_name FROM kegiatan k LEFT JOIN users u ON k.penanggung_jawab_id = u.user_id WHERE k.deleted_at IS NULL');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data kegiatan.' });
  }
});

// Ambil detail kegiatan
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT k.*, u.name as penanggung_jawab_name FROM kegiatan k LEFT JOIN users u ON k.penanggung_jawab_id = u.user_id WHERE k.id = ? AND k.deleted_at IS NULL', [req.params.id]);
    if (!rows.length) return res.status(404).json({ message: 'Kegiatan tidak ditemukan.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil detail kegiatan.' });
  }
});

// Tambah kegiatan
router.post('/', async (req, res) => {
  const { nama_kegiatan, sasaran, penanggung_jawab_id, status, keterangan } = req.body;
  try {
    await pool.query('INSERT INTO kegiatan (nama_kegiatan, sasaran, penanggung_jawab_id, status, keterangan, created_at) VALUES (?, ?, ?, ?, ?, NOW())', [nama_kegiatan, sasaran, penanggung_jawab_id, status, keterangan]);
    res.json({ message: 'Kegiatan berhasil ditambahkan.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menambah kegiatan.' });
  }
});

// Update kegiatan
router.put('/:id', async (req, res) => {
  const { nama_kegiatan, sasaran, penanggung_jawab_id, status, keterangan } = req.body;
  try {
    await pool.query('UPDATE kegiatan SET nama_kegiatan=?, sasaran=?, penanggung_jawab_id=?, status=?, keterangan=?, updated_at=NOW() WHERE id=? AND deleted_at IS NULL', [nama_kegiatan, sasaran, penanggung_jawab_id, status, keterangan, req.params.id]);
    res.json({ message: 'Kegiatan berhasil diupdate.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal update kegiatan.' });
  }
});

// Soft delete kegiatan
router.delete('/:id', async (req, res) => {
  try {
    await pool.query('UPDATE kegiatan SET deleted_at=NOW() WHERE id=?', [req.params.id]);
    res.json({ message: 'Kegiatan berhasil dihapus.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menghapus kegiatan.' });
  }
});

export default router;
