<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class CareerResource extends JsonResource
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
            'id' => $this->id ? $this->id : '',
            'designation' => $this->designation ? $this->designation : '',
            'company' => $this->company ? $this->company : '',
            'start' => $this->start ? $this->start : '',
            'end' => $this->end ? $this->end : '',
            'present' => $this->present == 1 ? true : false,
            // Sanket: Newly added 44-field profile columns
            'income' => $this->income ?? '',
            'annual_income' => $this->income ?? '', // Alias for frontend
            'occupation_details' => $this->occupation_details ?? '',
        ];
    }
}
