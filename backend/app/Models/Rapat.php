<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rapat extends Model
{
    protected $table = 'rapat';
    protected $fillable = [
        'nama_rapat', 'isi', 'tanggal_rapat', 'tempat', 'status', 'created_by', 'max_peserta', 'reminder_sent'
    ];
    public $timestamps = true;
}
