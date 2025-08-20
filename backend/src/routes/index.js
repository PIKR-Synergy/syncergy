import { Router } from 'express';
import authRouter from './auth.js';
import usersRouter from './users.js';
import dashboardRouter from './dashboard.js';
import pengurusRouter from './pengurus.js';
import rapatRouter from './rapat.js';
import konselingRouter from './konseling.js';
import kegiatanRouter from './kegiatan.js';
import programKerjaRouter from './programKerja.js';
import tamuRouter from './tamu.js';
import fileUploadRouter from './fileUpload.js';
import auditRouter from './audit.js';

const router = Router();

router.use('/auth', authRouter);
router.use('/users', usersRouter);
router.use('/dashboard', dashboardRouter);
router.use('/pengurus', pengurusRouter);
router.use('/rapat', rapatRouter);
router.use('/konseling', konselingRouter);
router.use('/kegiatan', kegiatanRouter);
router.use('/program-kerja', programKerjaRouter);
router.use('/tamu', tamuRouter);
router.use('/file-upload', fileUploadRouter);
router.use('/audit', auditRouter);

export default router;
