use Test::More;
BEGIN { plan tests => 6 };
use Astro::NED::Query::ByName;
ok(1); # If we made it this far, we're ok.

my ( $req, $res );

eval {
      $req = Astro::NED::Query::ByName->new;
};
ok( ! $@, "new" )
    or diag $@;

eval { 
     $req->reset;
};
ok( ! $@, "reset" )
    or diag $@;

my $object = 'Abell 2166';
$req->ObjName( $object );
ok( $req->ObjName eq $object, "ObjName" );

eval {
     $res = $req->query;
};
ok( !$@, "query" )
     or diag( $@ );

ok( 1 == $res->nobjects && ($res->objects)[0]->Name eq 'ABELL 2166',
"query result" );

#$_->dump foreach $res->objects;
