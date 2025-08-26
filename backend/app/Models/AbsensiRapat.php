<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AbsensiRapat extends Model
{
    protected $table = 'absensi_rapat';
    protected $fillable = [
        'rapat_id', 'user_id', 'status', 'alamat', 'ttd_path', 'waktu_absen', 'catatan'
    ];
    public $timestamps = false;
}
