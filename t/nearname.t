use Test::More;
BEGIN { plan tests => 6 };
use Astro::NED::Query::NearName;
ok(1); # If we made it this far, we're ok.

my ( $req, $res );

eval {
      $req = Astro::NED::Query::NearName->new;
};
ok( ! $@, "new" );

eval { 
     $req->reset;
};
ok( ! $@, "reset" )
    or diag $@;

my $object = 'Abell 2166';
$req->ObjName( $object );
ok( $req->ObjName eq $object, "ObjName" );

$req->Radius( 5 );
$req->ObjTypeInclude( 'ANY' );
$req->IncObjType( 'GClusters' => 1 );

eval {
     $res = $req->query;
};
ok( !$@, "query" ) 
    or diag( $@ );

#$_->dump foreach $res->objects;

ok( $res->nobjects > 0 && ($res->objects)[0]->Name eq 'ABELL 2166',
"   query result" );

