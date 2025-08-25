<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class UserSessionController extends Controller
{
    // GET /api/sessions
    public function index() {
        // ...fetch all sessions...
    }
    // DELETE /api/sessions/{id}
    public function destroy($id) {
        // ...delete session...
    }
}
