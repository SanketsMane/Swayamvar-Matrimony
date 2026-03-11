<?php

namespace App\Http\Resources\PublicProfile;

use App\Models\City;
use App\Models\Country;
use App\Models\State;
use Illuminate\Http\Resources\Json\JsonResource;

class PresentAddress extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $country = Country::find($this->country_id);
        $state = State::find($this->state_id);
        $city = City::find($this->city_id);
        return [
            'country_id' => $this->country_id ? (int)$this->country_id : null,
            'country'=> $country ? $country->name : '',
            'state_id' => $this->state_id ? (int)$this->state_id : null,
            'state'=> $state ? $state->name : '',
            'city_id' => $this->city_id ? (int)$this->city_id : null,
            'city'=> $city ? $city->name : '',
            'postal_code'=> $this->postal_code,
            'gov_id_type' => $this->user ? $this->user->gov_id_type : '',
            'gov_id_number' => $this->user ? $this->user->gov_id_number : '',
        ];
    }
}
