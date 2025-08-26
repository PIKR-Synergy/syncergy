<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\BukuTamu;
use Illuminate\Support\Facades\DB;

class BukuTamuController extends Controller
{
    // GET /api/buku-tamu
    public function index()
    {
        $tamu = BukuTamu::orderByDesc('tanggal')->get();
        return response()->json([
            'success' => true,
            'data' => $tamu,
            'message' => 'List buku tamu.'
        ]);
    }

    // POST /api/buku-tamu
    public function store(Request $request)
    {
        $validated = $request->validate([
            'tanggal' => 'required|date',
            'nama' => 'required|string',
            'jabatan' => 'nullable|string',
            'instansi' => 'nullable|string',
            'email' => 'nullable|email',
            'telepon' => 'nullable|string',
            'tujuan' => 'nullable|string',
            'ttd_path' => 'nullable|string',
            'waktu_kunjungan' => 'nullable',
            'waktu_selesai' => 'nullable',
            'status' => 'nullable|string',
            'dilayani_oleh' => 'nullable|exists:users,user_id',
        ]);
        $tamu = BukuTamu::create($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $validated['dilayani_oleh'] ?? null,
            'action' => 'INSERT',
            'table_name' => 'buku_tamu',
            'record_id' => $tamu->id,
            'new_values' => json_encode($tamu->toArray()),
            'description' => 'Buku tamu ditambahkan',
            'severity' => 'medium',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $tamu,
            'message' => 'Buku tamu created.'
        ], 201);
    }
}
