use strict;
use warnings;

use Test::More;

use Authen::SASL qw(Perl);
use MIME::Base64 qw(decode_base64);
use Authen::NTLM;

use constant {
    HOST   => 'localhost',
    DOMAIN => 'domain',
    USER   => 'user',
    PASS   => 'pass',
};

ntlm_reset();
ntlm_host(HOST);
ntlm_user(USER);
ntlm_password(PASS);

my $challenge =
  'TlRMTVNTUAACAAAABAAEADAAAAAFggEAQUJDREVGR0gAAAAAAAAAAAAAAAAAAAAA';
my $msg1 = ntlm();
my $msg2 = ntlm($challenge);

use_ok('Authen::SASL::Perl::NTLM');

my $sasl = new_ok(
    'Authen::SASL', [
        mechanism => 'NTLM',
        callback  => {
            user => USER,
            pass => PASS,
        },
    ]
);

my $conn = $sasl->client_new( 'ldap', 'localhost' );

isa_ok( $conn, 'Authen::SASL::Perl::NTLM' );

is( $conn->mechanism, 'NTLM', 'conn mechanism' );

is( $conn->client_start, q{}, 'client_start' );

ok( $msg1, 'initial message has a response' );

is( $conn->client_step(''), decode_base64($msg1), 'initial message' );

is( $conn->client_step( decode_base64($challenge) ),
    decode_base64($msg2), 'challenge response' );

done_testing;
