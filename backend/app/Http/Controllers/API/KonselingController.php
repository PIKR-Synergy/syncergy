<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class KonselingController extends Controller
{
    // GET /api/konseling
    public function index() {
        // ...fetch all konseling sessions...
    }
    // PUT /api/konseling/{id}
    public function update(Request $request, $id) {
        // ...update konseling session...
    }
}
