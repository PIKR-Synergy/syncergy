import express from 'express';
import db from '../db.js';
import sessionMiddleware from '../middleware/session.js';
import auditMiddleware from '../middleware/audit.js';

const router = express.Router();
router.use(sessionMiddleware);

// GET notulen rapat by rapat_id
router.get('/:rapat_id', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM notulen_rapat WHERE rapat_id = ?', [req.params.rapat_id]);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST notulen rapat
router.post('/', auditMiddleware, async (req, res) => {
  const { rapat_id, tanggal, waktu, tempat, jumlah_peserta, materi, isi_notulen, keterangan, notulis_id, status, approved_by, approved_at, dokumentasi } = req.body;
  try {
    await db.query('INSERT INTO notulen_rapat (rapat_id, tanggal, waktu, tempat, jumlah_peserta, materi, isi_notulen, keterangan, notulis_id, status, approved_by, approved_at, dokumentasi) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [rapat_id, tanggal, waktu, tempat, jumlah_peserta, materi, isi_notulen, keterangan, notulis_id, status, approved_by, approved_at, dokumentasi]);
    res.json({ message: 'Notulen berhasil ditambahkan.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
