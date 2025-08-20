import express from 'express';
import db from '../db.js';
const router = express.Router();

// GET all program kerja
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM program_kerja WHERE deleted_at IS NULL');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET program kerja by id
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM program_kerja WHERE id = ? AND deleted_at IS NULL', [req.params.id]);
    if (rows.length === 0) return res.status(404).json({ error: 'Not found' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST new program kerja
router.post('/', async (req, res) => {
  try {
    const { nama, deskripsi, tanggal_mulai, tanggal_selesai } = req.body;
    const [result] = await db.query('INSERT INTO program_kerja (nama, deskripsi, tanggal_mulai, tanggal_selesai) VALUES (?, ?, ?, ?)', [nama, deskripsi, tanggal_mulai, tanggal_selesai]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT update program kerja
router.put('/:id', async (req, res) => {
  try {
    const { nama, deskripsi, tanggal_mulai, tanggal_selesai } = req.body;
    await db.query('UPDATE program_kerja SET nama = ?, deskripsi = ?, tanggal_mulai = ?, tanggal_selesai = ? WHERE id = ? AND deleted_at IS NULL', [nama, deskripsi, tanggal_mulai, tanggal_selesai, req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE soft delete program kerja
router.delete('/:id', async (req, res) => {
  try {
    await db.query('UPDATE program_kerja SET deleted_at = NOW() WHERE id = ?', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
