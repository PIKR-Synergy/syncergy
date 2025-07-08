import express from 'express';
import pool from '../db.js';
import bcrypt from 'bcrypt';
import crypto from 'crypto';

const router = express.Router();

// Login endpoint
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ message: 'Username dan password wajib diisi.' });
  try {
    const [rows] = await pool.query('SELECT * FROM users WHERE username = ? AND deleted_at IS NULL', [username]);
    if (!rows.length) return res.status(401).json({ message: 'Username atau password salah.' });
    const user = rows[0];
    if (!user.is_active) return res.status(403).json({ message: 'Akun tidak aktif.' });
    const match = await bcrypt.compare(password, user.password_hash);
    if (!match) return res.status(401).json({ message: 'Username atau password salah.' });
    // Generate session token (simple random string)
    const sessionId = crypto.randomBytes(32).toString('hex');
    const expiresAt = new Date(Date.now() + 1000 * 60 * 60 * 24); // 24 jam
    await pool.query('DELETE FROM user_sessions WHERE user_id = ? AND expires_at < NOW()', [user.user_id]);
    await pool.query('INSERT INTO user_sessions (id, user_id, ip_address, user_agent, expires_at) VALUES (?, ?, ?, ?, ?)', [
      sessionId, user.user_id, req.ip, req.headers['user-agent'] || '', expiresAt
    ]);
    res.json({ token: sessionId, user: { user_id: user.user_id, name: user.name, role: user.role } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Terjadi kesalahan server.' });
  }
});

// Register endpoint (admin only, for demo)
router.post('/register', async (req, res) => {
  const { name, username, password, role, email } = req.body;
  if (!name || !username || !password || !role) return res.status(400).json({ message: 'Data wajib diisi.' });
  try {
    const hash = await bcrypt.hash(password, 10);
    await pool.query('INSERT INTO users (name, username, password_hash, role, email) VALUES (?, ?, ?, ?, ?)', [
      name, username, hash, role, email
    ]);
    res.json({ message: 'User berhasil didaftarkan.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Gagal mendaftar user.' });
  }
});

export default router;
