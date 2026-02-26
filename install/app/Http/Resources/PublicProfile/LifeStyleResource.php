<?php

namespace App\Http\Resources\PublicProfile;

use Illuminate\Http\Resources\Json\JsonResource;

class LifeStyleResource extends JsonResource
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
            'diet'               => $this->diet,
            'drink'              => $this->drink,
            'smoke'              => $this->smoke,
            'living_with'        => $this->living_with,
            // Sanket: Newly added 44-field profile columns for lifestyle
            'physical_activity'  => $this->physical_activity,
            'own_a_car'          => $this->own_a_car,
            'own_a_house'        => $this->own_a_house,
            'open_to_relocate'   => $this->open_to_relocate,
            'language'           => $this->language,
        ];
    }
}
