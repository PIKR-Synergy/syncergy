import db from '../db.js';

const auditMiddleware = async (req, res, next) => {
  // Log hanya untuk metode POST, PUT, DELETE
  if (['POST', 'PUT', 'DELETE'].includes(req.method)) {
    const userId = req.user?.id || null;
    const endpoint = req.originalUrl;
    const action = req.method;
    const ip = req.ip;
    await db.query('INSERT INTO activity_logs (user_id, endpoint, action, ip_address) VALUES (?, ?, ?, ?)', [userId, endpoint, action, ip]);
  }
  next();
};

export default auditMiddleware;
