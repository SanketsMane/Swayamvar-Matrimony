<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ReportedUser;
use App\Models\User;
use Auth;

class ReportedUserController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:view_reported_profile'])->only('index', 'reported_members');
        $this->middleware(['permission:delete_profile_report'])->only('destroy');
        $this->middleware(['permission:block_member'])->only('ban_user');
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $reports = ReportedUser::latest()->paginate(10);
        return view('admin.members.reported_members', compact('reports'));
    }

    public function reported_members($id)
    {
        $reports = ReportedUser::latest()->paginate(10);
        return view('admin.members.reported_members', compact('reports'));
    }

    public function ban_user(Request $request)
    {
        $user = User::findOrFail($request->user_id);
        $user->blocked = 1;
        if($user->save()){
            flash(translate('Member Banned successfully'))->success();
            return back();
        }
        flash(translate('Something went wrong'))->error();
        return back();
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $reported_user = new ReportedUser;
        $reported_user->user_id = $request->member_id;
        $reported_user->report_type = $request->report_type;
        $reported_user->reason = $request->reason;
        $reported_user->reported_by = Auth::user()->id;
        if($reported_user->save()){
            flash(translate('Reported successfully'))->success();
            return back();
        }
        flash(translate('Something went wrong'))->error();
        return back();
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
      if(ReportedUser::destroy($id)){
          flash(translate('Report deleted successfully'))->success();
          return redirect()->route('reported_members','all');
      }
      else {
          flash(translate('Sorry! Something went wrong.'))->error();
          return back();
      }
    }
}
