<?php

namespace App\Http\Resources\PublicProfile;

use Illuminate\Http\Resources\Json\JsonResource;

class FamilyInformation extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'father'            => $this->father,
            'mother'            => $this->mother,
            'sibling'           => $this->sibling,
            // Sanket: Newly added 44-field profile columns for family section
            'father_occupation' => $this->father_occupation,
            'mother_occupation' => $this->mother_occupation,
            'family_income'     => $this->family_income,
            'family_status'     => $this->family_status,
            'family_type'       => $this->family_type,
            'family_value'      => $this->family_value,
            'is_nri'            => $this->is_nri,
            'nri_country'       => $this->nri_country,
        ];
    }
}
