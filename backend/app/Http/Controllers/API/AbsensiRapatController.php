<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\AbsensiRapat;
use Illuminate\Support\Facades\DB;

class AbsensiRapatController extends Controller
{
    // POST /api/rapat/{id}/absensi
    public function store(Request $request, $id)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,user_id',
            'status' => 'required|string',
            'alamat' => 'nullable|string',
            'ttd_path' => 'nullable|string',
            'catatan' => 'nullable|string',
        ]);
        $validated['rapat_id'] = $id;
        $validated['waktu_absen'] = now();
        $absensi = AbsensiRapat::create($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $validated['user_id'],
            'action' => 'INSERT',
            'table_name' => 'absensi_rapat',
            'record_id' => $absensi->id,
            'new_values' => json_encode($absensi->toArray()),
            'description' => 'Absensi rapat ditambahkan',
            'severity' => 'medium',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $absensi,
            'message' => 'Absensi created.'
        ], 201);
    }
}
