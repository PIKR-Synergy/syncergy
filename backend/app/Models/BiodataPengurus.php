<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BiodataPengurus extends Model
{
    protected $table = 'biodata_pengurus';
    protected $fillable = [
        'user_id', 'tanggal_lahir', 'nama_orang_tua', 'alamat', 'jabatan', 'tugas', 'foto', 'keterangan'
    ];
    public $timestamps = true;
}
