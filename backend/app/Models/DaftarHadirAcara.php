<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DaftarHadirAcara extends Model
{
    protected $table = 'daftar_hadir_acara';
    protected $fillable = [
        'tanggal', 'nama_acara', 'user_id', 'nik', 'nama_peserta', 'status', 'alamat', 'ttd_path', 'waktu_hadir', 'catatan'
    ];
    public $timestamps = false;
}
