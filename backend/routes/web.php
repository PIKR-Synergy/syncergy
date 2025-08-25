<?php

use Illuminate\Support\Facades\Route;


// API routes
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\UserSessionController;
use App\Http\Controllers\API\BiodataPengurusController;
use App\Http\Controllers\API\RapatController;
use App\Http\Controllers\API\AbsensiRapatController;
use App\Http\Controllers\API\NotulenRapatController;
use App\Http\Controllers\API\ProgramKerjaController;
use App\Http\Controllers\API\KegiatanController;
use App\Http\Controllers\API\DaftarHadirAcaraController;
use App\Http\Controllers\API\BukuTamuController;
use App\Http\Controllers\API\FileUploadController;
use App\Http\Controllers\API\DaftarKonselingController;
use App\Http\Controllers\API\KonselingController;
use App\Http\Controllers\API\AuditLogController;
use App\Http\Controllers\API\DataVersionController;
use App\Http\Controllers\API\QueryPerformanceController;
use App\Http\Controllers\API\ReportController;

Route::get('/', function () {
    return view('welcome');
});

// User
Route::get('/api/users', [UserController::class, 'index']);
Route::post('/api/users', [UserController::class, 'store']);
Route::put('/api/users/{id}', [UserController::class, 'update']);
Route::delete('/api/users/{id}', [UserController::class, 'destroy']);

// User Sessions
Route::get('/api/sessions', [UserSessionController::class, 'index']);
Route::delete('/api/sessions/{id}', [UserSessionController::class, 'destroy']);

// Biodata Pengurus
Route::get('/api/biodata/{user_id}', [BiodataPengurusController::class, 'show']);
Route::post('/api/biodata', [BiodataPengurusController::class, 'store']);
Route::put('/api/biodata/{user_id}', [BiodataPengurusController::class, 'update']);

// Rapat
Route::get('/api/rapat', [RapatController::class, 'index']);
Route::post('/api/rapat', [RapatController::class, 'store']);

// Absensi Rapat
Route::post('/api/rapat/{id}/absensi', [AbsensiRapatController::class, 'store']);

// Notulen Rapat
Route::post('/api/notulen', [NotulenRapatController::class, 'store']);

// Program Kerja
Route::get('/api/program-kerja', [ProgramKerjaController::class, 'index']);
Route::post('/api/program-kerja', [ProgramKerjaController::class, 'store']);
Route::put('/api/program-kerja/{id}', [ProgramKerjaController::class, 'update']);

// Kegiatan
Route::get('/api/kegiatan', [KegiatanController::class, 'index']);
Route::post('/api/kegiatan', [KegiatanController::class, 'store']);

// Daftar Hadir Acara
Route::get('/api/daftar-hadir-acara', [DaftarHadirAcaraController::class, 'index']);
Route::post('/api/daftar-hadir-acara', [DaftarHadirAcaraController::class, 'store']);

// Buku Tamu
Route::get('/api/buku-tamu', [BukuTamuController::class, 'index']);
Route::post('/api/buku-tamu', [BukuTamuController::class, 'store']);

// File Uploads
Route::get('/api/file-uploads', [FileUploadController::class, 'index']);
Route::post('/api/file-uploads', [FileUploadController::class, 'store']);

// Daftar Konseling
Route::get('/api/daftar-konseling', [DaftarKonselingController::class, 'index']);
Route::post('/api/daftar-konseling', [DaftarKonselingController::class, 'store']);
Route::put('/api/daftar-konseling/{id}', [DaftarKonselingController::class, 'update']);

// Konseling
Route::get('/api/konseling', [KonselingController::class, 'index']);
Route::put('/api/konseling/{id}', [KonselingController::class, 'update']);

// Audit Log
Route::get('/api/activity-logs', [AuditLogController::class, 'index']);

// Data Version
Route::get('/api/data-versions', [DataVersionController::class, 'index']);

// Query Performance
Route::get('/api/performance', [QueryPerformanceController::class, 'index']);

// Reports
Route::get('/api/report/monthly', [ReportController::class, 'monthly']);
Route::get('/api/security-audit', [ReportController::class, 'securityAudit']);
