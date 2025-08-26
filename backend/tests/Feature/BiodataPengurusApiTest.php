<?php
namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\BiodataPengurus;
use App\Models\User;

class BiodataPengurusApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_show_biodata_pengurus()
    {
        $user = User::factory()->create(['role' => 'ketua']);
        $biodata = BiodataPengurus::create([
            'user_id' => $user->user_id,
            'jabatan' => 'Ketua',
            'tugas' => 'Memimpin organisasi',
            'alamat' => 'Jl. Pemuda',
        ]);
        $response = $this->get('/api/biodata/' . $user->user_id);
        $response->assertStatus(200)
                 ->assertJsonStructure(['success', 'data', 'message'])
                 ->assertJsonFragment(['jabatan' => 'Ketua']);
    }

    public function test_can_create_biodata_pengurus()
    {
        $user = User::factory()->create(['role' => 'bendahara']);
        $payload = [
            'user_id' => $user->user_id,
            'jabatan' => 'Bendahara',
            'tugas' => 'Mengelola keuangan',
            'alamat' => 'Jl. Mawar',
        ];
        $response = $this->post('/api/biodata', $payload);
        $response->assertStatus(201)
                 ->assertJsonStructure(['success', 'data', 'message'])
                 ->assertJsonFragment(['jabatan' => 'Bendahara']);
    }
}
