package Authen::SASL::Perl::NTLM;
# ABSTRACT: NTLM authentication plugin for Authen::SASL::Perl

use strict;
use warnings;

use Authen::NTLM ();
use MIME::Base64 ();

use parent qw(Authen::SASL::Perl);

sub mechanism { return 'NTLM' }

sub client_start {
    my ($self) = @_;

    ## no critic (RegularExpressions)
    my @user = split /\\/, $self->_call('user');
    my ( $domain, $user ) = @user > 1 ? @user : ( undef, $user[0] );

    $self->{ntlm} = Authen::NTLM->new(
        host     => $self->host,
        domain   => $domain,
        user     => $user,
        password => $self->_call('pass'),
    );

    return q{};
}

sub client_step {
    my ( $self, $string ) = @_;
    #<<<
    return
        MIME::Base64::decode_base64(
            $self->{ntlm}->challenge(
                # $string must be undef for challenge()
                # to generate a type 1 message
                $string
                  ? MIME::Base64::encode_base64($string)
                  : undef
            )
        );
    #>>>
}

1;

=head1 SYNOPSIS

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

=head1 DESCRIPTION

This module is a plugin for the Authen::SASL framework that implements the
client procedures to do NTLM authentication.

=head1 CALLBACK

The callbacks used are:

=head2 Client

=for :list
= user
The username to be used for authentication. The domain may optionally be
specified as part of the C<user> string in the format C<"$domain\\$username">.
= pass
The user's password to be used for authentication.

=for Pod::Coverage
mechanism
client_start
client_step
server_start
server_step

=cut
