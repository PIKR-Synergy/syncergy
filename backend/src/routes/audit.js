import express from 'express';
import db from '../db.js';
const router = express.Router();

// GET all activity logs
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM activity_logs ORDER BY created_at DESC');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET log by id
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM activity_logs WHERE id = ?', [req.params.id]);
    if (rows.length === 0) return res.status(404).json({ error: 'Not found' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
