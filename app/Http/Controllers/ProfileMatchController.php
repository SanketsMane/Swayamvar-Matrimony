<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ProfileMatch;
use App\Models\Member;
use App\Models\PhysicalAttribute;
use App\Models\SpiritualBackground;
use App\Models\Education;
use App\Models\Career;
use App\Models\Address;
use App\Models\Lifestyle;
use App\Models\User;

class ProfileMatchController extends Controller
{

    public function match_profiles($user = '')
    {
      if(empty($user))
      {
        $users = User::where('user_type','member')
                        ->where('blocked', 0)
                        ->where('approved', 1)
                        ->where('deactivated',0)->get();
      }
      else {
        $users = User::where('id', $user)->get();
      }

      foreach ($users as $user) {
        $matches_attributes     = 0;
        $match_percentage       = 0;
        $partner_expectations   = $user->partner_expectations;

        $expected_residence_country  = $partner_expectations->residence_country_id ?? '';
        $expected_min_height         = $partner_expectations->height ?? '';
        $expected_max_weight         = $partner_expectations->weight ?? '';
        $expected_marital_status     = $partner_expectations->marital_status_id ?? '';

        $expected_religion           = $partner_expectations->religion ?? '';
        $expected_caste              = $partner_expectations->caste_id ?? '';
        $expected_sub_caste_id       = $partner_expectations->sub_caste_id ?? '';

        $expected_language           = $partner_expectations->language_id ?? '';

        $expected_education          = $partner_expectations->education ?? '';
        $expected_profession         = $partner_expectations->profession ?? '';

        $expected_smoking_condition  = $partner_expectations->smoking_acceptable ?? '';
        $expected_drinking_condition = $partner_expectations->drinking_acceptable ?? '';
        $expected_diet_condition     = $partner_expectations->diet ?? '';

        $expected_state              = $partner_expectations->preferred_state_id ?? '';
        $expected_country            = $partner_expectations->preferred_country_id ?? '';

        $expected_family_value       = $partner_expectations->family_value_id ?? '';

        $partners = User::where('user_type','member')
                        ->where('id', '!=', $user->id)
                        ->where('blocked', 0)
                        ->where('approved', 1)
                        ->where('deactivated',0)->get();

        $user_ids = Member::where('gender', '!=', $user->member->gender)->pluck('user_id')->toArray();
        if(count($user_ids) >0){
            $partners = $partners->WhereIn('id', $user_ids);
        }

        foreach ($partners as $partner) {

          if($expected_residence_country) {
              if(Address::where('user_id', $partner->id)->where('country_id', $expected_residence_country)->where('type', 'present')->count() > 0){
                $matches_attributes++;
              }
          }

          // Match by minimum height
          if($expected_min_height) {
              if(PhysicalAttribute::where('user_id', $partner->id)->where('height', '>=', $expected_min_height)->count() > 0 ){
                $matches_attributes++;
              }
          }

          // Match by Maximum Weight
          if($expected_max_weight) {
              if(PhysicalAttribute::where('user_id', $partner->id)->where('weight', '<=', $expected_max_weight)->count() > 0){
                $matches_attributes++;
              }
          }

          if($expected_marital_status){
              if(Member::where('user_id', $partner->id)->where('marital_status_id', $expected_marital_status)->count() > 0){
                $matches_attributes++;
              }
          }

          if($expected_language){
            if(Member::where('user_id', $partner->id)->where('mothere_tongue', $expected_language)->count() > 0){
              $matches_attributes++;
            }
          }

          // Match by religion religion
          $match_by_religion = false;
          $match_by_cast = false;
          if($expected_sub_caste_id){
              if(SpiritualBackground::where('user_id', $partner->id)->where('sub_caste_id', $expected_sub_caste_id)->count() > 0 ){
                $matches_attributes+= 3;
              }
              else {
                $match_by_religion = true;
                $match_by_cast = true;
              }
          }

          if($match_by_cast && $expected_caste) {
              if(SpiritualBackground::where('user_id', $partner->id)->where('caste_id', $expected_caste)->count() > 0 ){
                $matches_attributes+=2;
                $match_by_religion = false;
              }
              else {
                $match_by_religion = true;
              }
          }

          if($match_by_religion && $expected_religion) {
              if(SpiritualBackground::where('user_id', $partner->id)->where('religion_id', $expected_religion)->count() > 0){
                $matches_attributes++;
              }
          }

          if($expected_education){
              if(Education::where('user_id', $partner->id)->where('degree', 'like', '%'.$expected_education.'%')->where('present',1)->count() > 0 ){
                $matches_attributes++;
              }
          }

          if($expected_profession){
              if(Career::where('user_id', $partner->id)->where('designation', 'like', '%'.$expected_profession.'%')->where('present',1)->count() > 0 ){
                $matches_attributes++;
              }
          }

          if($expected_smoking_condition){
              if($expected_smoking_condition == "dose_not_matter"){
                $matches_attributes++;
              }
              elseif(Lifestyle::where('user_id', $partner->id)->where('smoke',$expected_smoking_condition)->count() > 0 ){
                $matches_attributes++;
              }
          }

          if($expected_drinking_condition){
              if($expected_drinking_condition == "dose_not_matter"){
                $matches_attributes++;
              }
              elseif(Lifestyle::where('user_id', $partner->id)->where('drink',$expected_drinking_condition)->count() > 0 ){
                $matches_attributes++;
              }
          }

          if($expected_diet_condition){
              if($expected_diet_condition == "dose_not_matter"){
                $matches_attributes++;
              }
              elseif(Lifestyle::where('user_id', $partner->id)->where('diet',$expected_diet_condition)->count() > 0 ){
                $matches_attributes++;
              }
          }

          // Match by Preferred Country
          $match_by_country = false;
          if($expected_state) {
              if(Address::where('user_id', $partner->id)->where('state_id', $expected_state)->where('type', 'permanent')->count() > 0){
                $matches_attributes+=2;
              }
              else {
                $match_by_country = true;
              }
          }

          if($match_by_country && $expected_country) {
              if(Address::where('user_id', $partner->id)->where('country_id', $expected_state)->where('type', 'permanent')->count() > 0){
                $matches_attributes++;
              }
          }

          if($expected_family_value){
            if(SpiritualBackground::where('user_id', $partner->id)->where('family_value_id', $expected_family_value)->count() > 0 ){
              $matches_attributes++;
            }
          }

          if($matches_attributes > 0){
            $match_percentage = round(($matches_attributes/16)*100);
          }
          
          $profile_match = ProfileMatch::firstOrNew(['user_id' => $user->id, 'match_id' => $partner->id]);
          $profile_match->match_percentage  = $match_percentage;
          $profile_match->save();

          $matches_attributes     = 0;
          $match_percentage       = 0;

        }
      }
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
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
        //
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
        //
    }

    public function migrate_profiles(Request $request){
    }
}
