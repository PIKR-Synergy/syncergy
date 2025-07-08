import { Router } from 'express';
import authRouter from './auth.js';
import usersRouter from './users.js';
import dashboardRouter from './dashboard.js';
import pengurusRouter from './pengurus.js';
import rapatRouter from './rapat.js';
import konselingRouter from './konseling.js';
import kegiatanRouter from './kegiatan.js';

const router = Router();

router.use('/auth', authRouter);
router.use('/users', usersRouter);
router.use('/dashboard', dashboardRouter);
router.use('/pengurus', pengurusRouter);
router.use('/rapat', rapatRouter);
router.use('/konseling', konselingRouter);
router.use('/kegiatan', kegiatanRouter);

export default router;
