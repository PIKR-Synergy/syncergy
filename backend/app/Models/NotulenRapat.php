<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class NotulenRapat extends Model
{
    protected $table = 'notulen_rapat';
    protected $fillable = [
        'rapat_id', 'tanggal', 'waktu', 'tempat', 'jumlah_peserta', 'materi', 'isi_notulen', 'keterangan', 'notulis_id', 'status', 'approved_by', 'approved_at', 'dokumentasi'
    ];
    public $timestamps = true;
}
