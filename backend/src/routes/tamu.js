import express from 'express';
import db from '../db.js';
const router = express.Router();

// GET all tamu
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM tamu WHERE deleted_at IS NULL');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET tamu by id
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM tamu WHERE id = ? AND deleted_at IS NULL', [req.params.id]);
    if (rows.length === 0) return res.status(404).json({ error: 'Not found' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST new tamu
router.post('/', async (req, res) => {
  try {
    const { nama, instansi, keperluan, tanggal } = req.body;
    const [result] = await db.query('INSERT INTO tamu (nama, instansi, keperluan, tanggal) VALUES (?, ?, ?, ?)', [nama, instansi, keperluan, tanggal]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT update tamu
router.put('/:id', async (req, res) => {
  try {
    const { nama, instansi, keperluan, tanggal } = req.body;
    await db.query('UPDATE tamu SET nama = ?, instansi = ?, keperluan = ?, tanggal = ? WHERE id = ? AND deleted_at IS NULL', [nama, instansi, keperluan, tanggal, req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE soft delete tamu
router.delete('/:id', async (req, res) => {
  try {
    await db.query('UPDATE tamu SET deleted_at = NOW() WHERE id = ?', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
