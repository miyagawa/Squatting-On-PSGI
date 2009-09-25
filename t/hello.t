use lib "t/lib";
use Test::More;
use Test::Requires qw(Plack::Loader LWP::UserAgent);
use Test::TCP;

use Hello 'On::PSGI';
my $app = sub { Hello->psgi(@_) };

test_tcp(
    client => sub {
        my $port = shift;
        my $ua = LWP::UserAgent->new;
        my $res = $ua->get("http://127.0.0.1:$port/?name=bar");
        like $res->content, qr/Your name: bar/;
        $res = $ua->get("http://127.0.0.1:$port/?name=baz");
        like $res->content, qr/Your name: baz/;
    },
    server => sub {
        my $port = shift;
        Plack::Loader->auto(port => $port)->run($app);
    },
);

done_testing;
