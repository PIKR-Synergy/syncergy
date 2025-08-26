<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\BiodataPengurus;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class BiodataPengurusController extends Controller
{
    // GET /api/biodata/{user_id}
    public function show($user_id)
    {
        $biodata = BiodataPengurus::where('user_id', $user_id)->first();
        if (!$biodata) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Biodata not found.'
            ], 404);
        }
        return response()->json([
            'success' => true,
            'data' => $biodata,
            'message' => 'Biodata retrieved.'
        ]);
    }

    // POST /api/biodata
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,user_id',
            'jabatan' => 'required|string',
            'tugas' => 'required|string',
            'alamat' => 'nullable|string',
            'tanggal_lahir' => 'nullable|date',
            'nama_orang_tua' => 'nullable|string',
            'foto' => 'nullable|string',
            'keterangan' => 'nullable|string',
        ]);
        $biodata = BiodataPengurus::create($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $request->user_id,
            'action' => 'INSERT',
            'table_name' => 'biodata_pengurus',
            'record_id' => $biodata->id,
            'new_values' => json_encode($biodata->toArray()),
            'description' => 'Biodata pengurus ditambahkan',
            'severity' => 'medium',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $biodata,
            'message' => 'Biodata created.'
        ], 201);
    }

    // PUT /api/biodata/{user_id}
    public function update(Request $request, $user_id)
    {
        $biodata = BiodataPengurus::where('user_id', $user_id)->first();
        if (!$biodata) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Biodata not found.'
            ], 404);
        }
        $old = $biodata->toArray();
        $validated = $request->validate([
            'jabatan' => 'sometimes|string',
            'tugas' => 'sometimes|string',
            'alamat' => 'nullable|string',
            'tanggal_lahir' => 'nullable|date',
            'nama_orang_tua' => 'nullable|string',
            'foto' => 'nullable|string',
            'keterangan' => 'nullable|string',
        ]);
        $biodata->update($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $user_id,
            'action' => 'UPDATE',
            'table_name' => 'biodata_pengurus',
            'record_id' => $biodata->id,
            'old_values' => json_encode($old),
            'new_values' => json_encode($biodata->toArray()),
            'description' => 'Biodata pengurus diupdate',
            'severity' => 'low',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $biodata,
            'message' => 'Biodata updated.'
        ]);
    }
}
