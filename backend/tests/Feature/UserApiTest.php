<?php
namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\User;

class UserApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_list_users()
    {
        User::factory()->create(['name' => 'Test User', 'email' => 'test@example.com', 'password' => bcrypt('password')]);
        $response = $this->get('/api/users');
        $response->assertStatus(200)
                 ->assertJsonStructure([
                     'success', 'data', 'message'
                 ])
                 ->assertJsonFragment(['name' => 'Test User']);
    }

    public function test_can_create_user()
    {
        $payload = [
            'name' => 'New User',
            'username' => 'newuser',
            'password_hash' => bcrypt('password'),
            'role' => 'admin',
            'email' => 'newuser@example.com'
        ];
        $response = $this->post('/api/users', $payload);
        $response->assertStatus(201)
                 ->assertJsonStructure([
                     'success', 'data', 'message'
                 ])
                 ->assertJsonFragment(['name' => 'New User']);
    }
}
