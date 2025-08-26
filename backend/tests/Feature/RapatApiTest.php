<?php
namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\Rapat;
use App\Models\User;

class RapatApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_list_rapat()
    {
        $user = User::factory()->create(['role' => 'sekretaris']);
        Rapat::create([
            'nama_rapat' => 'Rapat Bulanan',
            'isi' => 'Agenda bulanan',
            'tanggal_rapat' => now(),
            'created_by' => $user->user_id
        ]);
        $response = $this->get('/api/rapat');
        $response->assertStatus(200)
                 ->assertJsonStructure(['success', 'data', 'message'])
                 ->assertJsonFragment(['nama_rapat' => 'Rapat Bulanan']);
    }

    public function test_can_create_rapat()
    {
        $user = User::factory()->create(['role' => 'sekretaris']);
        $payload = [
            'nama_rapat' => 'Rapat Tahunan',
            'isi' => 'Agenda tahunan',
            'tanggal_rapat' => now(),
            'created_by' => $user->user_id
        ];
        $response = $this->post('/api/rapat', $payload);
        $response->assertStatus(201)
                 ->assertJsonStructure(['success', 'data', 'message'])
                 ->assertJsonFragment(['nama_rapat' => 'Rapat Tahunan']);
    }
}
