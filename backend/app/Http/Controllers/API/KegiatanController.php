<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\Kegiatan;
use Illuminate\Support\Facades\DB;

class KegiatanController extends Controller
{
    // GET /api/kegiatan
    public function index()
    {
        $kegiatan = Kegiatan::whereNull('deleted_at')->orderByDesc('tanggal')->get();
        return response()->json([
            'success' => true,
            'data' => $kegiatan,
            'message' => 'List kegiatan.'
        ]);
    }

    // POST /api/kegiatan
    public function store(Request $request)
    {
        $validated = $request->validate([
            'tanggal' => 'required|date',
            'nama_kegiatan' => 'required|string',
            'sasaran' => 'nullable|string',
            'lokasi' => 'nullable|string',
            'hasil_dicapai' => 'nullable|string',
            'status' => 'nullable|string',
            'penanggung_jawab_id' => 'required|exists:users,user_id',
            'jumlah_peserta' => 'nullable|integer',
            'budget' => 'nullable|numeric',
            'evaluasi' => 'nullable|string',
            'foto_kegiatan' => 'nullable|json',
            'keterangan' => 'nullable|string',
        ]);
        $kegiatan = Kegiatan::create($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $validated['penanggung_jawab_id'],
            'action' => 'INSERT',
            'table_name' => 'kegiatan',
            'record_id' => $kegiatan->id,
            'new_values' => json_encode($kegiatan->toArray()),
            'description' => 'Kegiatan ditambahkan',
            'severity' => 'medium',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $kegiatan,
            'message' => 'Kegiatan created.'
        ], 201);
    }
}
