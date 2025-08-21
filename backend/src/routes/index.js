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
import absensiRapatRouter from './absensiRapat.js';
import notulenRapatRouter from './notulenRapat.js';
import daftarHadirAcaraRouter from './daftarHadirAcara.js';
import bukuTamuRouter from './bukuTamu.js';
import daftarKonselingRouter from './daftarKonseling.js';

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
router.use('/absensi-rapat', absensiRapatRouter);
router.use('/notulen-rapat', notulenRapatRouter);
router.use('/daftar-hadir-acara', daftarHadirAcaraRouter);
router.use('/buku-tamu', bukuTamuRouter);
router.use('/daftar-konseling', daftarKonselingRouter);

export default router;
