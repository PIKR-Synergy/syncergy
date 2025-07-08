import express from 'express';
import pool from '../db.js';

const router = express.Router();

// Endpoint statistik ringkas dashboard
router.get('/', async (req, res) => {
  try {
    const [[userCount]] = await pool.query('SELECT COUNT(*) as total FROM users WHERE deleted_at IS NULL');
    const [[rapatCount]] = await pool.query('SELECT COUNT(*) as total FROM rapat');
    const [[kegiatanCount]] = await pool.query('SELECT COUNT(*) as total FROM kegiatan');
    const [[konselingCount]] = await pool.query('SELECT COUNT(*) as total FROM konseling');
    res.json({
      users: userCount.total,
      rapat: rapatCount.total,
      kegiatan: kegiatanCount.total,
      konseling: konselingCount.total
    });
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil statistik dashboard.' });
  }
});

export default router;
