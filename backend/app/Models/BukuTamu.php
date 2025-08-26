<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BukuTamu extends Model
{
    protected $table = 'buku_tamu';
    protected $fillable = [
        'tanggal', 'nama', 'jabatan', 'instansi', 'email', 'telepon', 'tujuan', 'ttd_path', 'waktu_kunjungan', 'waktu_selesai', 'status', 'dilayani_oleh'
    ];
    public $timestamps = false;
}
