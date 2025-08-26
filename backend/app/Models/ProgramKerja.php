<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProgramKerja extends Model
{
    protected $table = 'program_kerja';
    protected $fillable = [
        'nama_kegiatan', 'tujuan', 'sasaran', 'mitra_kerja', 'frekuensi', 'hasil_diharapkan', 'status', 'tanggal_mulai', 'tanggal_selesai', 'progress_percentage', 'budget_allocated', 'budget_used', 'pic_id', 'keterangan'
    ];
    public $timestamps = true;
}
