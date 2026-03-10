<?php

namespace App\Http\Resources\PublicProfile;

use App\Models\Country;
use Illuminate\Http\Resources\Json\JsonResource;

class ResidenceInformation extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $birth_country_obj = $this->birth_country_id ? Country::find($this->birth_country_id) : null;
        $birth_country = $birth_country_obj ? $birth_country_obj->name : null;

        $recidency_country_obj = $this->recidency_country_id ? Country::find($this->recidency_country_id) : null;
        $recidency_country = $recidency_country_obj ? $recidency_country_obj->name : null;

        $growup_country_obj = $this->growup_country_id ? Country::find($this->growup_country_id) : null;
        $growup_country = $growup_country_obj ? $growup_country_obj->name : null;
        return [
            'birth_country' => $birth_country,
            'recidency_country' => $recidency_country,
            'growup_country' => $growup_country,
            'immigration_status' => $this->immigration_status,
        ];
    }
}
