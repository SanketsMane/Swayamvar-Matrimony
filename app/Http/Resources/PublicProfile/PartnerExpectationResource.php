<?php

namespace App\Http\Resources\PublicProfile;

use App\Models\Caste;
use App\Models\Country;
use App\Models\FamilyValue;
use App\Models\Language;
use App\Models\MaritalStatus;
use App\Models\MemberLanguage;
use App\Models\Religion;
use App\Models\State;
use App\Models\SubCaste;
use Illuminate\Http\Resources\Json\JsonResource;

class PartnerExpectationResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $residence_country = Country::where('id', $this->residence_country_id)->first();
        $preferred_country = Country::where('id', $this->preferred_country_id)->first();
        $preferred_state = State::where('id', $this->preferred_state_id)->first();
        $religion = Religion::find($this->religion_id);
        $caste = Caste::find($this->caste_id);
        $sub_caste = SubCaste::find($this->sub_caste_id);
        $family_value = FamilyValue::find($this->family_value_id);
        $marital_status = MaritalStatus::find($this->marital_status_id);
        $language = MemberLanguage::find($this->language_id);
        return [
            'general' => $this->general,
            'height' => $this->height,
            'weight' => $this->weight,
            'marital_status_id' => $this->marital_status_id ? (int)$this->marital_status_id : null,
            'marital_status' => $marital_status ? $marital_status->name : null,
            'children_acceptable' => $this->children_acceptable ? 1 : 0,
            'residence_country_id' => $this->residence_country_id ? (int)$this->residence_country_id : null,
            'residence_country' => $residence_country ? $residence_country->name : '',
            'religion_id' =>  $this->religion_id ? (int)$this->religion_id : null,
            'religion' => $religion ? $religion->name : '',
            'caste_id' =>  $this->caste_id ? (int)$this->caste_id : null,
            'caste' => $caste ? $caste->name : '',
            'sub_caste_id' => $this->sub_caste_id ? (int)$this->sub_caste_id : null,
            'sub_caste' => $sub_caste ? $sub_caste->name : '',
            'education' => $this->education,
            'expected_education' => $this->education, // Alias for expected_education
            'profession' => $this->profession,
            'smoking_acceptable' => $this->smoking_acceptable ? 1 : 0,
            'drinking_acceptable' => $this->drinking_acceptable ? 1 : 0,
            'diet' => ($this->diet),
            'body_type' => $this->body_type,
            'personal_value' => $this->personal_value,
            'manglik' => $this->manglik ? 1 : 0,
            'partner_manglik' => $this->manglik ? 1 : 0, // Alias for partner_manglik
            'language_id' => $this->language_id ? (int)$this->language_id : null,
            'language' => $language ? $language->name : null,
            'family_value_id' => $this->family_value_id ? (int)$this->family_value_id : null,
            'family_value' => $family_value ? $family_value->name : '',
            'preferred_country_id' => $this->preferred_country_id ? (int)$this->preferred_country_id : null,
            'preferred_country' => $preferred_country ? $preferred_country->name : '',
            'preferred_state_id' => $this->preferred_state_id ? (int)$this->preferred_state_id : null,
            'preferred_state' => $preferred_state ? $preferred_state->name : '',
            'complexion' => $this->complexion,
            // Sanket: Newly added 44-field profile columns
            'expected_income' => $this->income,
            'divorce_accepted' => $this->divorce_accepted ? 1 : 0,
            'intercaste_accepted' => $this->intercaste_accepted ? 1 : 0,
            'partner_intercaste' => $this->intercaste_accepted ? 1 : 0, // Alias for partner_intercaste
        ];
    }
}
