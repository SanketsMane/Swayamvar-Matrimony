<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Schema;
use Illuminate\Pagination\Paginator;

class AppServiceProvider extends ServiceProvider
{
  /**
   * Bootstrap any application services.
   *
   * @return void
   */
  public function boot()
  {
      Schema::defaultStringLength(191);
      Paginator::useBootstrap();

      // Sanket: Morph map for telecalling leads to support polymorphism
      \Illuminate\Database\Eloquent\Relations\Relation::morphMap([
          'active_lead' => 'App\Models\ActiveLead',
          'inactive_lead' => 'App\Models\InactiveLead',
      ]);
  }

  /**
   * Register any application services.
   *
   * @return void
   */
  public function register()
  {
    //
  }
}
