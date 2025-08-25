<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class BiodataPengurusController extends Controller
{
    // GET /api/biodata/{user_id}
    public function show($user_id) {
        // ...fetch biodata...
    }
    // POST /api/biodata
    public function store(Request $request) {
        // ...create biodata...
    }
    // PUT /api/biodata/{user_id}
    public function update(Request $request, $user_id) {
        // ...update biodata...
    }
}
