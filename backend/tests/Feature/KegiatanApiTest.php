<?php
namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\Kegiatan;
use App\Models\User;

class KegiatanApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_list_kegiatan()
    {
        $user = User::factory()->create(['role' => 'kominfo']);
        Kegiatan::create([
            'tanggal' => now(),
            'nama_kegiatan' => 'Sosialisasi',
            'penanggung_jawab_id' => $user->user_id
        ]);
        $response = $this->get('/api/kegiatan');
        $response->assertStatus(200)
                 ->assertJsonStructure(['success', 'data', 'message'])
                 ->assertJsonFragment(['nama_kegiatan' => 'Sosialisasi']);
    }

    public function test_can_create_kegiatan()
    {
        $user = User::factory()->create(['role' => 'kominfo']);
        $payload = [
            'tanggal' => now(),
            'nama_kegiatan' => 'Pelatihan',
            'penanggung_jawab_id' => $user->user_id
        ];
        $response = $this->post('/api/kegiatan', $payload);
        $response->assertStatus(201)
                 ->assertJsonStructure(['success', 'data', 'message'])
                 ->assertJsonFragment(['nama_kegiatan' => 'Pelatihan']);
    }
}
