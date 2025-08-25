<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    // GET /api/report/monthly
    public function monthly(Request $request) {
        // ...fetch monthly report...
    }
    // GET /api/security-audit
    public function securityAudit() {
        // ...fetch security audit...
    }
}
