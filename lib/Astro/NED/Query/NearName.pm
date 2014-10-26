package Astro::NED::Query::NearName;

use 5.006;
use strict;
use warnings;

use base qw/ Astro::NED::Query::Objects Class::Accessor /;

our $VERSION = '0.01';

our %Field = qw{
		ObjName		objname
		Radius		radius
		CoordSys	out_csys
		Equinox		out_equinox
		Sort		obj_sort
		Format		of
		ZVBreaker	zv_breaker
		ListLimit	list_limit
		ImageStamp	img_stamp
		ZConstraint	z_constraint
		ZValue1		z_value1
		ZValue2		z_value2
		ZUnit		z_unit
		ObjTypeInclude  ot_include
		NamePrefixOp    nmp_op
	      };

our %Option;

__PACKAGE__->mk_accessors( keys %Field,
			   keys %Option,
			   keys %Astro::NED::Query::Option,
			 );

__PACKAGE__->mkMultipleAccessor ( qw/ IncObjType ExcObjType NamePrefix / );

sub _init
{
  $_[0]->{_ua}->follow( qr/near name/i );
  $_[0]->setupMultiple( 'option', IncObjType => qr/^in_objtypes\d+$/ );
  $_[0]->setupMultiple( 'option', ExcObjType => qr/^ex_objtypes\d+$/ );
  $_[0]->setupMultiple( 'option', NamePrefix => qr/^name_prefix\d+$/ );
}


1;
__END__

=head1 NAME

Astro::NED::Query::NearName - query NED for objects near a specified object

=head1 SYNOPSIS

  use Astro::NED::Query::NearName;

  $req = Astro::NED::Query::NearName->new( Field => value, ... );

  $req->Field( $value );

  # for fields which take multiple values
  $req->Field( $value1 => $state );
  $req->Field( $value2 => $state );

  $objs = $req->query;

=head1 DESCRIPTION

This class queries NED using the "Objects Near Name" interface.  It is
a subclass of B<Astro::NED::Query>, and thus shares all of its
methods.

Class specific details are provided here.  See L<Astro::NED::Query>
for general information on the class methods (including those not
documented here) and how to set or get the search parameters.

=head2 Methods

=over

=item new

  $req = Astro::NED::Query::NearName->new( keyword1 => $value1,
				   keyword2 => $value2, ... );


Queries are constructed using the B<new> method, which is passed a
list of keyword and value pairs.  The keywords may be the names of
single valued query parameters, or may be class options.  There are no
options I<specific> to B<Astro::NED::Query::NearName>.

Fields which may have mutiple concurrent values (such as
B<IncObjType>) cannot be specified in the call to B<new>; use the
field accessor method, and specify the value and whether it should be
selected or not:

  $req->IncObjType( 'Galaxies' => 1 )
  $req->IncObjType( 'XRay' => 1 )

Search parameters may also be set or queried using the accessor methods;
see L<Astro::NED::Query>.

=item query

  $res = $req->query;

The B<query> method returns an instance of the
B<Astro::NED::Response::Objects> class, which contains the results of
the query.  At present it returns I<only> the summary table, not the
detailed information on each object.  See
L<Astro::NED::Response::Object> for more info.

If an error ocurred an exception is thrown via B<croak>.

=back

=head2 Search Parameters

Please note that for fields which take specific enumerated values, the
values are often I<not> those which are displayed by a web browser.
It's best to initially use the B<possible_values> method to determine
acceptable values.  Usually it's pretty obvious what they correspond
to.

The class accessor methods have the same names as the search parameters.
See L<Astro::NED::Query> on how to use them.

=over 8

=item ObjName

The object name.

=item Radius

The search radius in arcminutes

=item CoordSys

The output coordinate system.  Use the B<possible_values> method
to determine which ones are available.

=item Equinox

The output coordinate system equinox.

=item Sort

The output sort order.   Use the B<possible_values> method
to determine which ones are available.

=item Format

Whether the output is formatted as an HTML table or plain text.
This will always be forced to HTML.

=item ListLimit

The upper limit to the number of objects with detailed information.
This is always set to force no detailed information

=item ZVBreaker

The maximum redshift velocity which will be displayed as km/s.

=item ImageStamp

Whether or not to return an image preview.  Always forced off.

=item ZConstraint

Constraints on the redshifts of the objects.  Used in conjunction
with the B<ZValue1> and B<ZValue2> fields.

Use the B<possible_values> method to determine which constraints are
available.

=item ZValue1, ZValue2

Values for the redshift constraints.

=item ZUnit

Either C<km/s> or C<z>.

=item ObjTypeInclude

Whether to objects must have C<ANY> or C<ALL> of the types in
the B<IncObjType> field.  Takes the values C<ANY> or C<ALL>.

=item IncObjType

This specifies the types of objects to include.  This is a multi-valued
field, meaning that it can hold more than one type of object concurrently.
As such, it cannot be initialized in the object constructor.  The
accessor method must be used instead:

  $obj->IncObjType( Galaxies => 1 );
  $obj->IncObjType( GPairs => 1 );

Use the B<possible_values> method to determine which object types are
available.

=item ExcObjType

This specifies the types of objects to exclude.  This is a multi-valued
field, meaning that it can hold more than one type of object concurrently.
As such, it cannot be initialized in the object constructor.  The
accessor method must be used instead:

  $obj->ExcObjType( Galaxies => 1 );
  $obj->ExcObjType( GPairs => 1 );

Use the B<possible_values> method to determine which object types are
available.

=item NamePrefixOp

This specifies how to handle objects with name prefixes specified with
the B<NamePrefix> field.  This is so complicated there's an extra
documentation link on the NED site, so I suggest you look there:
L<http://nedwww.ipac.caltech.edu/help/object_help.html#exclcat>.

Use the B<possible_values> method to determine which object types are
available.

=item NamePrefix

This specifies the types of name prefix used with B<NamePrefixOp>.
This is a multi-valued field, meaning that it can hold more than one
type of object concurrently.  As such, it cannot be initialized in the
object constructor.  The accessor method must be used instead:

  $obj->NamePrefix( ABELL => 1 );
  $obj->NamePrefix( 'ABELL S' => 1 );

Use the B<possible_values> method to determine which prefixes are
available.

=back

=head2 EXPORT

None by default.


=head1 AUTHOR

Diab Jerius, E<lt>djerius@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (C) 2003 Smithsonian Astrophysical Observatory.
All rights are of course reserved.

It is released under the GNU General Public License.  You may find a
copy at

   http://www.fsf.org/copyleft/gpl.html

=head1 SEE ALSO

L<Astro::NED::Query>,
L<Astro::NED::Response::Objects>,
L<Astro::NED::Response::Object>,
L<perl>.

=cut
