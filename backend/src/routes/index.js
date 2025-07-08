import { Router } from 'express';
import authRouter from './auth.js';
import usersRouter from './users.js';

const router = Router();

router.use('/auth', authRouter);

import dashboardRouter from './dashboard.js';
router.use('/users', usersRouter);
router.use('/dashboard', dashboardRouter);

export default router;
