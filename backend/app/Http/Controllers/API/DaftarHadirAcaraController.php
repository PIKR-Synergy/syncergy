<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\DaftarHadirAcara;
use Illuminate\Support\Facades\DB;

class DaftarHadirAcaraController extends Controller
{
    // GET /api/daftar-hadir-acara
    public function index()
    {
        $daftar = DaftarHadirAcara::orderByDesc('tanggal')->get();
        return response()->json([
            'success' => true,
            'data' => $daftar,
            'message' => 'List daftar hadir acara.'
        ]);
    }

    // POST /api/daftar-hadir-acara
    public function store(Request $request)
    {
        $validated = $request->validate([
            'tanggal' => 'required|date',
            'nama_acara' => 'required|string',
            'user_id' => 'nullable|exists:users,user_id',
            'nik' => 'nullable|string',
            'nama_peserta' => 'required|string',
            'status' => 'required|string',
            'alamat' => 'nullable|string',
            'ttd_path' => 'nullable|string',
            'waktu_hadir' => 'nullable|date',
            'catatan' => 'nullable|string',
        ]);
        $daftar = DaftarHadirAcara::create($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $validated['user_id'] ?? null,
            'action' => 'INSERT',
            'table_name' => 'daftar_hadir_acara',
            'record_id' => $daftar->id,
            'new_values' => json_encode($daftar->toArray()),
            'description' => 'Daftar hadir acara ditambahkan',
            'severity' => 'medium',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $daftar,
            'message' => 'Daftar hadir acara created.'
        ], 201);
    }
}
