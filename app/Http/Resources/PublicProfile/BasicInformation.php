<?php

namespace App\Http\Resources\PublicProfile;

use App\Http\Resources\Profile\OnBehalfResource;
use App\Models\OnBehalf;
use Illuminate\Http\Resources\Json\JsonResource;
use Carbon\Carbon;



class BasicInformation extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {

        $age = !empty($this->member?->birthday) ? Carbon::parse($this->member->birthday)->age : 0;
        return [
            'first_name'     => $this->first_name, // Sanket: Fixed typo from firs_name
            'middle_name'    => $this->middle_name ?? '', // Sanket: Added missing field
            'last_name'      => $this->last_name,
            'code'           => $this->code,
            'age'            => $age,
            'religion_id'    => $this->spiritual_backgrounds?->religion_id ?? '',
            'religion'       => $this->spiritual_backgrounds?->religion?->name ?? '',
            'caste_id'       => $this->spiritual_backgrounds?->caste_id ?? '',
            'caste'          => $this->spiritual_backgrounds?->caste?->name ?? '',
            'sub_caste_id'   => $this->spiritual_backgrounds?->sub_caste_id ?? '',
            'date_of_birth'  => !empty($this->member?->birthday) ? Carbon::parse($this->member->birthday)->format('Y-m-d') : '',
            'onbehalf'       => new OnBehalfResource(OnBehalf::find($this->member?->on_behalves_id)),
            'no_of_children' => $this->member?->children ?? '',
            'gender'         => ($this->member?->gender ?? 1) == 1 ? "Male" : "Female",
            'phone'          => $this->phone ?? "",
            'mobile2'        => $this->mobile2 ?? '',
            'maritial_status'=> $this->member?->marital_status ? $this->member->marital_status->name : '',
            'photo'          => show_profile_picture($this) ? uploaded_asset($this->photo) : static_asset('assets/img/avatar-place.png'),
            // Sanket: Newly added 44-field profile columns for basic info
            'about'          => $this->member?->introduction ?? '',
            'bio'            => $this->member?->introduction ?? '',
            'annual_income'  => $this->career?->first()?->income ?? '',
            'height'         => $this->physical_attributes?->height ?? '',
            'weight'         => $this->physical_attributes?->weight ?? '',
            'complexion'     => $this->physical_attributes?->complexion ?? '',
            'blood_group'    => $this->physical_attributes?->blood_group ?? '',
            'disability'     => $this->physical_attributes?->disability ?? '',
            'diet'           => $this->lifestyles?->diet ?? '',
            'manglik'        => $this->spiritual_backgrounds?->manglik ?? '',
        ];
    }
}
