import jwt from 'jsonwebtoken';
import db from '../db.js';

const sessionMiddleware = async (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No token provided' });
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    // Simpan session ke user_sessions
    await db.query('INSERT INTO user_sessions (user_id, token, ip_address, user_agent) VALUES (?, ?, ?, ?)', [decoded.id, token, req.ip, req.headers['user-agent']]);
    next();
  } catch (err) {
    res.status(401).json({ error: 'Invalid token' });
  }
};

export default sessionMiddleware;
