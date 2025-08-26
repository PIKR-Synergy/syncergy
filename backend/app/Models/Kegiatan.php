<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kegiatan extends Model
{
    protected $table = 'kegiatan';
    protected $fillable = [
        'tanggal', 'nama_kegiatan', 'sasaran', 'lokasi', 'hasil_dicapai', 'status', 'penanggung_jawab_id', 'jumlah_peserta', 'budget', 'evaluasi', 'foto_kegiatan', 'keterangan'
    ];
    public $timestamps = true;
}
