<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\Konseling;
use Illuminate\Support\Facades\DB;

class KonselingController extends Controller
{
    // GET /api/konseling
    public function index()
    {
        $konseling = Konseling::orderByDesc('tanggal')->get();
        return response()->json([
            'success' => true,
            'data' => $konseling,
            'message' => 'List konseling sessions.'
        ]);
    }

    // PUT /api/konseling/{id}
    public function update(Request $request, $id)
    {
        $konseling = Konseling::find($id);
        if (!$konseling) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Konseling session not found.'
            ], 404);
        }
        $old = $konseling->toArray();
        $validated = $request->validate([
            'status' => 'required|string',
            'catatan' => 'nullable|string',
            'follow_up_required' => 'nullable|boolean',
            'follow_up_date' => 'nullable|date',
            'rating' => 'nullable|integer',
            'feedback' => 'nullable|string',
        ]);
        $konseling->update($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $konseling->konselor_id,
            'action' => 'UPDATE',
            'table_name' => 'konseling',
            'record_id' => $konseling->id,
            'old_values' => json_encode($old),
            'new_values' => json_encode($konseling->toArray()),
            'description' => 'Konseling session diupdate',
            'severity' => 'low',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $konseling,
            'message' => 'Konseling session updated.'
        ]);
    }
}
