import express from 'express';
import pool from '../db.js';

const router = express.Router();

// Ambil semua rapat
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM rapat');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data rapat.' });
  }
});

// Ambil detail rapat
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM rapat WHERE id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ message: 'Rapat tidak ditemukan.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil detail rapat.' });
  }
});

// Tambah rapat
router.post('/', async (req, res) => {
  const { nama_rapat, isi, tanggal_rapat, tempat, status } = req.body;
  try {
    await pool.query('INSERT INTO rapat (nama_rapat, isi, tanggal_rapat, tempat, status) VALUES (?, ?, ?, ?, ?)', [nama_rapat, isi, tanggal_rapat, tempat, status]);
    res.json({ message: 'Rapat berhasil ditambahkan.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menambah rapat.' });
  }
});

// Update rapat
router.put('/:id', async (req, res) => {
  const { nama_rapat, isi, tanggal_rapat, tempat, status } = req.body;
  try {
    await pool.query('UPDATE rapat SET nama_rapat=?, isi=?, tanggal_rapat=?, tempat=?, status=? WHERE id=?', [nama_rapat, isi, tanggal_rapat, tempat, status, req.params.id]);
    res.json({ message: 'Rapat berhasil diupdate.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal update rapat.' });
  }
});

// Hapus rapat
router.delete('/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM rapat WHERE id=?', [req.params.id]);
    res.json({ message: 'Rapat berhasil dihapus.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menghapus rapat.' });
  }
});

export default router;
