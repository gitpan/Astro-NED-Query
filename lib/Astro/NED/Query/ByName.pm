package Astro::NED::Query::ByName;

use 5.006;
use strict;
use warnings;

use base qw/ Astro::NED::Query::Objects Class::Accessor /;

our $VERSION = '0.01';

our %Field = qw{
	   ObjName	objname
	   Extend	extend
	   CoordSys	out_csys
	   Equinox	out_equinox
	   Sort		obj_sort
	   Format	of
	   ListLimit	list_limit
	   ZVBreaker	zv_breaker
	   ImageStamp   img_stamp
	   };

our %Option;

__PACKAGE__->mk_accessors( keys %Field,
			   keys %Option,
			   keys %Astro::NED::Query::Option,
			 );

sub _init
{
  $_[0]->{_ua}->follow( qr/by name/i );
}

1;
__END__


=head1 NAME

Astro::NED::Query::ByName - query NED by object name

=head1 SYNOPSIS

  use Astro::NED::Query::ByName;

  $req = Astro::NED::Query::ByName->new( Field => $value, ... );

  $req->Field( $value );

  $objs = $req->query;

=head1 DESCRIPTION

This class queries NED using the "Objects By Name" interface.  It
is a subclass of B<Astro::NED::Query>, and thus shares all of its
methods.

Class specific details are provided here.  See L<Astro::NED::Query>
for general information on the class methods (including those not
documented here) and how to set or get the search parameters.

=head2 Methods

=over

=item new

  $req = Astro::NED::Query::ByName->new( keyword1 => $value1,
				 keyword2 => $value2, ... );

Queries are constructed using the B<new> method, which is passed a
list of keyword and value pairs.  The keywords may be the names of
single valued query parameters, or may be class options.  There are no
options I<specific> to B<Astro::NED::Query::ByName>.

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

=item Extend

Whether to perform an extended search.  Possible values are C<yes> and
C<no>.

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
