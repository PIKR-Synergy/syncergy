<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Konseling extends Model
{
    protected $table = 'konseling';
    protected $fillable = [
        'tanggal', 'waktu_mulai', 'waktu_selesai', 'tema', 'konselor_id', 'peserta_id', 'jenis', 'status', 'metode', 'lokasi', 'jumlah_peserta', 'catatan', 'follow_up_required', 'follow_up_date', 'rating', 'feedback'
    ];
    public $timestamps = true;
}
