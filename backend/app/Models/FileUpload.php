<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FileUpload extends Model
{
    protected $table = 'file_uploads';
    protected $fillable = [
        'filename', 'original_name', 'file_path', 'file_size', 'mime_type', 'category', 'uploaded_by', 'is_public', 'download_count', 'virus_scan_status', 'uploaded_at'
    ];
    public $timestamps = false;
}
