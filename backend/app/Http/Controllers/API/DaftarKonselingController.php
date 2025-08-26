<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\DaftarKonseling;
use Illuminate\Support\Facades\DB;

class DaftarKonselingController extends Controller
{
    // GET /api/daftar-konseling
    public function index()
    {
        $daftar = DaftarKonseling::orderByDesc('tanggal_daftar')->get();
        return response()->json([
            'success' => true,
            'data' => $daftar,
            'message' => 'List daftar konseling.'
        ]);
    }

    // POST /api/daftar-konseling
    public function store(Request $request)
    {
        $validated = $request->validate([
            'tanggal_daftar' => 'required|date',
            'tanggal_konseling' => 'required|date',
            'waktu_konseling' => 'nullable',
            'konselor_id' => 'required|exists:users,user_id',
            'pendaftar_id' => 'nullable|exists:users,user_id',
            'nama_pendaftar' => 'required|string',
            'kontak_pendaftar' => 'nullable|string',
            'jenis_konseling' => 'required|string',
            'topik_konseling' => 'nullable|string',
            'lokasi' => 'nullable|string',
            'status' => 'nullable|string',
            'prioritas' => 'nullable|string',
            'alasan_penolakan' => 'nullable|string',
            'keterangan' => 'nullable|string',
        ]);
        $daftar = DaftarKonseling::create($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $validated['konselor_id'],
            'action' => 'INSERT',
            'table_name' => 'daftar_konseling',
            'record_id' => $daftar->id,
            'new_values' => json_encode($daftar->toArray()),
            'description' => 'Daftar konseling ditambahkan',
            'severity' => 'medium',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $daftar,
            'message' => 'Daftar konseling created.'
        ], 201);
    }

    // PUT /api/daftar-konseling/{id}
    public function update(Request $request, $id)
    {
        $daftar = DaftarKonseling::find($id);
        if (!$daftar) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Daftar konseling not found.'
            ], 404);
        }
        $old = $daftar->toArray();
        $validated = $request->validate([
            'status' => 'required|string',
            'alasan_penolakan' => 'nullable|string',
            'keterangan' => 'nullable|string',
        ]);
        $daftar->update($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $daftar->konselor_id,
            'action' => 'UPDATE',
            'table_name' => 'daftar_konseling',
            'record_id' => $daftar->id,
            'old_values' => json_encode($old),
            'new_values' => json_encode($daftar->toArray()),
            'description' => 'Status daftar konseling diupdate',
            'severity' => 'low',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $daftar,
            'message' => 'Status daftar konseling updated.'
        ]);
    }
}
