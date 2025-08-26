<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


use App\Models\FileUpload;
use Illuminate\Support\Facades\DB;

class FileUploadController extends Controller
{
    // GET /api/file-uploads
    public function index()
    {
        $files = FileUpload::orderByDesc('uploaded_at')->get();
        return response()->json([
            'success' => true,
            'data' => $files,
            'message' => 'List file uploads.'
        ]);
    }

    // POST /api/file-uploads
    public function store(Request $request)
    {
        $validated = $request->validate([
            'filename' => 'required|string',
            'original_name' => 'required|string',
            'file_path' => 'required|string',
            'file_size' => 'required|integer',
            'mime_type' => 'required|string',
            'category' => 'nullable|string',
            'uploaded_by' => 'required|exists:users,user_id',
            'is_public' => 'nullable|boolean',
            'download_count' => 'nullable|integer',
            'virus_scan_status' => 'nullable|string',
            'uploaded_at' => 'nullable|date',
        ]);
        $file = FileUpload::create($validated);
        // Audit log
        DB::table('activity_logs')->insert([
            'user_id' => $validated['uploaded_by'],
            'action' => 'INSERT',
            'table_name' => 'file_uploads',
            'record_id' => $file->id,
            'new_values' => json_encode($file->toArray()),
            'description' => 'File diupload',
            'severity' => 'medium',
            'created_at' => now()
        ]);
        return response()->json([
            'success' => true,
            'data' => $file,
            'message' => 'File uploaded.'
        ], 201);
    }
}
