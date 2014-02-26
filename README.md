# NAME

Authen::SASL::Perl::NTLM - NTLM authentication plugin for Authen::SASL::Perl

# VERSION

version 0.001

# SYNOPSIS

    use Authen::SASL qw(Perl);

    $sasl = Authen::SASL->new(
        mechanism => 'NTLM',
        callback  => {
            user => $username, # or "$domain\\$username"
            pass => $password,
        },
    );

    $client = $sasl->client_new(...);
    $client->client_start;
    $client->client_step;

# DESCRIPTION

This module is a plugin for the [Authen::SASL](https://metacpan.org/module/Authen::SASL) framework that implements the
client procedures to do NTLM authentication.

# CALLBACK

The callbacks used are:

## Client

- user

    The username to be used for authentication. The domain may optionally be
    specified as part of the `user` string in the format `"$domain\\$username"`.

- pass

    The user's password to be used for authentication.

# SEE ALSO

[Authen::SASL](https://metacpan.org/module/Authen::SASL), [Authen::SASL::Perl](https://metacpan.org/module/Authen::SASL::Perl).

# AUTHOR

Steven Lee <stevenwh.lee@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Lee.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
