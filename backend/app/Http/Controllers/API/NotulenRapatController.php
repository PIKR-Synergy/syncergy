<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\NotulenRapat;
use Illuminate\Support\Facades\DB;

class NotulenRapatController extends Controller
{
    // POST /api/notulen
    public function store(Request $request)
    {
        $validated = $request->validate([
            'rapat_id' => 'required|exists:rapat,id',
            'tanggal' => 'required|date',
            'waktu' => 'required',
            'tempat' => 'nullable|string',
            'jumlah_peserta' => 'nullable|integer',
            'materi' => 'nullable|string',
            'isi_notulen' => 'required|string',
            'keterangan' => 'nullable|string',
            'notulis_id' => 'required|exists:users,user_id',
            'status' => 'nullable|string',
            'approved_by' => 'nullable|exists:users,user_id',
            'approved_at' => 'nullable|date',
            'dokumentasi' => 'nullable|string',
        ]);
        $notulen = NotulenRapat::create($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $validated['notulis_id'],
            'action' => 'INSERT',
            'table_name' => 'notulen_rapat',
            'record_id' => $notulen->id,
            'new_values' => json_encode($notulen->toArray()),
            'description' => 'Notulen rapat ditambahkan',
            'severity' => 'medium',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $notulen,
            'message' => 'Notulen created.'
        ], 201);
    }
}
