<div style="max-height: 400px; overflow-y: auto;">
    <table class="table aiz-table">
        <thead>
            <tr>
                <th width="50px">
                    <div class="aiz-checkbox-inline">
                        <label class="aiz-checkbox">
                            <input type="checkbox" onclick="selectAllLeads(this)">
                            <span></span>
                        </label>
                    </div>
                </th>
                <th>{{translate('Name')}}</th>
                <th>{{translate('Mobile')}}</th>
                <th>{{translate('City')}}</th>
            </tr>
        </thead>
        <tbody>
            @forelse($leads as $lead)
                <tr>
                    <td>
                        <div class="aiz-checkbox-inline">
                            <label class="aiz-checkbox">
                                <input type="checkbox" name="lead_ids[]" value="{{$lead->id}}">
                                <span></span>
                            </label>
                        </div>
                    </td>
                    <td>{{$lead->name}}</td>
                    <td>{{$lead->mobile}}</td>
                    <td>{{$lead->city}}</td>
                </tr>
            @empty
                <tr>
                    <td colspan="4" class="text-center">{{translate('No unassigned leads found')}}</td>
                </tr>
            @endforelse
        </tbody>
    </table>
</div>
