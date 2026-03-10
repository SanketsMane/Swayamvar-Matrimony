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
            'first_name'     => $this->first_name,
            'middle_name'    => $this->middle_name,
            'last_name'      => $this->last_name,
            'surname'        => $this->last_name, // Alias for last_name
            'code'           => $this->code,
            'age'            => $age,
            'religion_id'    => $this->spiritual_backgrounds?->religion_id ? (int)$this->spiritual_backgrounds->religion_id : '',
            'religion'       => $this->spiritual_backgrounds->religion->name ?? '',
            'caste_id'       => $this->spiritual_backgrounds?->caste_id ? (int)$this->spiritual_backgrounds->caste_id : '',
            'caste'          => $this->spiritual_backgrounds->caste->name ?? '',
            'sub_caste_id'   => $this->spiritual_backgrounds?->sub_caste_id ? (int)$this->spiritual_backgrounds->sub_caste_id : '',
            'date_of_birth'  => !empty($this->member?->birthday) ? Carbon::parse($this->member->birthday)->format('Y-m-d') : '',
            'onbehalf'       => new OnBehalfResource(OnBehalf::find($this->member->on_behalves_id)),
            'no_of_children' => $this->member->children ?? '',
            'gender'         => ($this->member->gender ?? 1) == 1 ? "Male" : "Female",
            'phone'          => $this->phone ?? "",
            'mobile2'        => $this->mobile2 ?? "",
            'maritial_status'=> $this->member->marital_status ? $this->member->marital_status->name : '',
            'photo'          => show_profile_picture($this) ? uploaded_asset($this->photo) : static_asset('assets/img/avatar-place.png'),
            'gov_id_type'    => $this->gov_id_type,
            'gov_id_number'  => $this->gov_id_number,
            // Sanket: Newly added 44-field profile columns for basic info
            'about'          => $this->member->about ?? '',
            'bio'            => $this->member->bio ?? '',
            'annual_income'  => $this->member->annual_income ?? '',
            'height'         => $this->physical_attributes?->height ?? '',
            'weight'         => $this->physical_attributes?->weight ?? '',
            'complexion'     => $this->physical_attributes?->complexion ?? '',
            'blood_group'    => $this->physical_attributes?->blood_group ?? '',
            'disability'     => $this->physical_attributes?->disability ? 1 : 0,
            'diet'           => $this->lifestyles?->diet ?? '',
            'manglik'        => $this->spiritual_backgrounds?->manglik ? 1 : 0,
        ];
    }
}
