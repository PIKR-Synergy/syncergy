import { Router } from 'express';
import authRouter from './auth.js';

const router = Router();

router.use('/auth', authRouter);
// router.use('/users', usersRouter); // next: user management
// router.use('/dashboard', dashboardRouter); // next: dashboard

export default router;
