<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\Rapat;
use Illuminate\Support\Facades\DB;

class RapatController extends Controller
{
    // GET /api/rapat
    public function index()
    {
        $rapat = Rapat::whereNull('deleted_at')->orderByDesc('tanggal_rapat')->get();
        return response()->json([
            'success' => true,
            'data' => $rapat,
            'message' => 'List rapat.'
        ]);
    }

    // POST /api/rapat
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_rapat' => 'required|string',
            'isi' => 'nullable|string',
            'tanggal_rapat' => 'required|date',
            'tempat' => 'nullable|string',
            'status' => 'nullable|string',
            'created_by' => 'required|exists:users,user_id',
            'max_peserta' => 'nullable|integer',
            'reminder_sent' => 'nullable|boolean',
        ]);
        $rapat = Rapat::create($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $request->created_by,
            'action' => 'INSERT',
            'table_name' => 'rapat',
            'record_id' => $rapat->id,
            'new_values' => json_encode($rapat->toArray()),
            'description' => 'Rapat ditambahkan',
            'severity' => 'medium',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $rapat,
            'message' => 'Rapat created.'
        ], 201);
    }
}
