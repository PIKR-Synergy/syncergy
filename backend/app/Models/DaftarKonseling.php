<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DaftarKonseling extends Model
{
    protected $table = 'daftar_konseling';
    protected $fillable = [
        'tanggal_daftar', 'tanggal_konseling', 'waktu_konseling', 'konselor_id', 'pendaftar_id', 'nama_pendaftar', 'kontak_pendaftar', 'jenis_konseling', 'topik_konseling', 'lokasi', 'status', 'prioritas', 'alasan_penolakan', 'keterangan'
    ];
    public $timestamps = true;
}
