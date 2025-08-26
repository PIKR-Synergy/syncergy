<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\ProgramKerja;
use Illuminate\Support\Facades\DB;

class ProgramKerjaController extends Controller
{
    // GET /api/program-kerja
    public function index()
    {
        $programs = ProgramKerja::whereNull('deleted_at')->orderByDesc('tanggal_mulai')->get();
        return response()->json([
            'success' => true,
            'data' => $programs,
            'message' => 'List program kerja.'
        ]);
    }

    // POST /api/program-kerja
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_kegiatan' => 'required|string',
            'tujuan' => 'nullable|string',
            'sasaran' => 'nullable|string',
            'mitra_kerja' => 'nullable|string',
            'frekuensi' => 'nullable|string',
            'hasil_diharapkan' => 'nullable|string',
            'status' => 'nullable|string',
            'tanggal_mulai' => 'nullable|date',
            'tanggal_selesai' => 'nullable|date',
            'progress_percentage' => 'nullable|numeric',
            'budget_allocated' => 'nullable|numeric',
            'budget_used' => 'nullable|numeric',
            'pic_id' => 'required|exists:users,user_id',
            'keterangan' => 'nullable|string',
        ]);
        $program = ProgramKerja::create($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $validated['pic_id'],
            'action' => 'INSERT',
            'table_name' => 'program_kerja',
            'record_id' => $program->id,
            'new_values' => json_encode($program->toArray()),
            'description' => 'Program kerja ditambahkan',
            'severity' => 'medium',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $program,
            'message' => 'Program kerja created.'
        ], 201);
    }

    // PUT /api/program-kerja/{id}
    public function update(Request $request, $id)
    {
        $program = ProgramKerja::find($id);
        if (!$program) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Program kerja not found.'
            ], 404);
        }
        $old = $program->toArray();
        $validated = $request->validate([
            'nama_kegiatan' => 'sometimes|string',
            'tujuan' => 'nullable|string',
            'sasaran' => 'nullable|string',
            'mitra_kerja' => 'nullable|string',
            'frekuensi' => 'nullable|string',
            'hasil_diharapkan' => 'nullable|string',
            'status' => 'nullable|string',
            'tanggal_mulai' => 'nullable|date',
            'tanggal_selesai' => 'nullable|date',
            'progress_percentage' => 'nullable|numeric',
            'budget_allocated' => 'nullable|numeric',
            'budget_used' => 'nullable|numeric',
            'pic_id' => 'nullable|exists:users,user_id',
            'keterangan' => 'nullable|string',
        ]);
        $program->update($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $program->pic_id,
            'action' => 'UPDATE',
            'table_name' => 'program_kerja',
            'record_id' => $program->id,
            'old_values' => json_encode($old),
            'new_values' => json_encode($program->toArray()),
            'description' => 'Program kerja diupdate',
            'severity' => 'low',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $program,
            'message' => 'Program kerja updated.'
        ]);
    }
}
