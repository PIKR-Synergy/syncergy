<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class UserController extends Controller
{
    // GET /api/users
    public function index() {
        // ...fetch all users...
    }
    // POST /api/users
    public function store(Request $request) {
        // ...create user...
    }
    // PUT /api/users/{id}
    public function update(Request $request, $id) {
        // ...update user...
    }
    // DELETE /api/users/{id}
    public function destroy($id) {
        // ...soft delete user...
    }
}
