use Test::More;
BEGIN { plan tests => 5 };

use Astro::NED::Query::NearPosition;
ok(1); # If we made it this far, we're ok.

my ( $req, $res );

eval {
      $req = Astro::NED::Query::NearPosition->new;
};
ok( ! $@, "new" );

eval { 
     $req->reset;
};
ok( ! $@, "reset" );

$req->RA('16h28m37.0s');
$req->Dec('+39d31m28s');

$req->Radius( 5 );
$req->ObjTypeInclude( 'ANY' );
$req->IncObjType( 'GClusters' => 1 );

eval {
     $res = $req->query;
};
ok( !$@, "query" );

#$_->dump foreach $res->objects;

ok( $res->nobjects > 0 && ($res->objects)[0]->Name eq 'ABELL 2199',
"query result" );

