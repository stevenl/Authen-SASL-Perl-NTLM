package Authen::SASL::Perl::NTLM;
# ABSTRACT: NTLM authentication plugin for Authen::SASL::Perl

use strict;
use warnings;

use Authen::NTLM ();
use Carp         ();
use MIME::Base64 ();

use parent qw(Authen::SASL::Perl);

sub mechanism { return 'NTLM' }

sub client_start {
    my ($self) = @_;

    Authen::NTLM::ntlm_reset();
    Authen::NTLM::ntlm_host( $self->host );
    Authen::NTLM::ntlm_user( $self->_call('user') );
    Authen::NTLM::ntlm_password( $self->_call('pass') );

    return q{};
}

sub client_step {
    my ( $self, $string ) = @_;
    $string = Authen::NTLM::ntlm( MIME::Base64::encode_base64($string) );
    return MIME::Base64::decode_base64($string);
}

sub server_start {
    my ( $self, $response, $user_cb ) = @_;
    $user_cb ||= sub { };

    Carp::confess 'server_start not implemented';
}

sub server_step {
    my ( $self, $response, $user_cb ) = @_;
    $user_cb ||= sub { };

    Carp::confess 'server_step not implemented';
}

1;

=head1 SYNOPSIS

    use Authen::SASL qw(Perl);

    $sasl = Authen::SASL->new(
        mechanism => 'NTLM',
        callback  => {
            user => $username,
            pass => $password,
        },
    );

    $client = $sasl->client_new(...);
    $client->client_start;
    $client->client_step;

=head1 CALLBACK

The callbacks used are:

=head2 Client

=for :list
= user
The username to be used for authentication.
= pass
The user's password to be used for authentication.

=for Pod::Coverage
mechanism
client_start
client_step
server_start
server_step

=cut
