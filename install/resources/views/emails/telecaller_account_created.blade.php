<!DOCTYPE html>
<html>
<head>
    <title>Telecaller Account Created</title>
</head>
<body>
    <h3>{{translate('Hello')}} {{$user->first_name}},</h3>
    <p>{{translate('Your telecaller account has been created successfully.')}}</p>
    <p>
        <strong>{{translate('Login URL')}}:</strong> {{$url}}<br>
        <strong>{{translate('Email')}}:</strong> {{$user->email}}<br>
        <strong>{{translate('Password')}}:</strong> {{$password}}
    </p>
    <p>{{translate('Please login and change your password for security.')}}</p>
    <p>{{translate('Regards')}},<br>{{get_setting('website_name')}}</p>
</body>
</html>
