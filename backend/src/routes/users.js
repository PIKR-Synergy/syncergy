import express from 'express';
import pool from '../db.js';

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT user_id, name, username, role, email, phone, is_active, created_at, updated_at FROM users WHERE deleted_at IS NULL');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data user.' });
  }
});

// Ambil detail user
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT user_id, name, username, role, email, phone, is_active, created_at, updated_at FROM users WHERE user_id = ? AND deleted_at IS NULL', [req.params.id]);
    if (!rows.length) return res.status(404).json({ message: 'User tidak ditemukan.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil detail user.' });
  }
});

// Update user (tanpa password)
router.put('/:id', async (req, res) => {
  const { name, role, email, phone, is_active } = req.body;
  try {
    await pool.query('UPDATE users SET name=?, role=?, email=?, phone=?, is_active=? WHERE user_id=? AND deleted_at IS NULL', [name, role, email, phone, is_active, req.params.id]);
    res.json({ message: 'User berhasil diupdate.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal update user.' });
  }
});

// Soft delete user
router.delete('/:id', async (req, res) => {
  try {
    await pool.query('UPDATE users SET deleted_at=NOW() WHERE user_id=?', [req.params.id]);
    res.json({ message: 'User berhasil dihapus.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menghapus user.' });
  }
});



// Ambil semua user (tanpa password hash, exclude soft deleted)
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT user_id, name, username, role, email, phone, is_active, email_verified, password_expires_at, created_at, updated_at FROM users WHERE deleted_at IS NULL');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data user.' });
  }
});

// Ambil detail user
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT user_id, name, username, role, email, phone, is_active, email_verified, password_expires_at, created_at, updated_at FROM users WHERE user_id = ? AND deleted_at IS NULL', [req.params.id]);
    if (!rows.length) return res.status(404).json({ message: 'User tidak ditemukan.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil detail user.' });
  }
});

// Update user (tanpa password)
router.put('/:id', async (req, res) => {
  const { name, role, email, phone, is_active } = req.body;
  try {
    await pool.query('UPDATE users SET name=?, role=?, email=?, phone=?, is_active=?, updated_at=NOW() WHERE user_id=? AND deleted_at IS NULL', [name, role, email, phone, is_active, req.params.id]);
    res.json({ message: 'User berhasil diupdate.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal update user.' });
  }
});

// Soft delete user
router.delete('/:id', async (req, res) => {
  try {
    await pool.query('UPDATE users SET deleted_at=NOW() WHERE user_id=?', [req.params.id]);
    res.json({ message: 'User berhasil dihapus.' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal menghapus user.' });
  }
});

export default router;
