use Test::More;
BEGIN { plan tests => 8 };

use Astro::NED::Query::CoordExtinct;
ok(1); # If we made it this far, we're ok.

my ( $req, $res );

eval {
      $req = Astro::NED::Query::CoordExtinct->new;
};
ok( ! $@, "new" );

eval { 
     $req->reset;
};
ok( ! $@, "reset" );

our ( $RA, $Dec, $PA ) = ( 12, 0, 35 );

$req->RA( $RA );
ok( $req->RA eq $RA, "set RA" );

$req->Dec( $Dec );
ok( $req->Dec eq $Dec, "set Dec" );

$req->PA( 35 );
ok( $req->PA eq $PA, "set PA" );

eval {
     $res = $req->query;
};

ok( !$@, "submit query" ) or diag( $@ );

ok( eq_hash( { $res->data },
         {
          'J' => '0.021',
          'K' => '0.009',
          'Lon' => '-0.27839900',
          'B' => '0.102',
          'V' => '0.078',
          'H' => '0.014',
          'L\'' => '0.004',
          'PA' => '34.998447',
          'I' => '0.046',
          'R' => '0.063',
          'EB-V' => '1',
          'Lat' => '180.64065840',
          'Dec' => '-0.27839900',
          'U' => '0.129',
          'RA' => '180.64065840'
        } ), "check query" );


