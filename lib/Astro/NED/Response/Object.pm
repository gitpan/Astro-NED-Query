package Astro::NED::Response::Object;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

use base qw/ Class::Accessor::Fast /;

use Astro::NED::Response::Objects;

# Preloaded methods go here.

# using %Astro::NED::Response::Fields directly is gross,
# but it makes sure we don't duplicate information

__PACKAGE__->mk_ro_accessors( 'InfoLink', 
			      map { $_->[0] } @Astro::NED::Response::Objects::Fields );

sub dump
{
  my ( $self, $fh )  = @_;

  $fh = \*STDOUT unless defined $fh;

  print $fh "$_: ", defined $self->get($_) ? $self->get($_) : 'undef', "\n"
    foreach map { $_->[0] } @Astro::NED::Response::Objects::Fields;
}

sub fields
{
  # object method
  if ( ref $_[0] )
  {
    return grep { defined $_[0]->get($_) } 
           map { $_->[0] } @Astro::NED::Response::Objects::Fields
  }

  # class method
  else
  {
    return map { $_->[0] } @Astro::NED::Response::Objects::Fields;
  }
}

sub data
{
  %{$_[0]};
}


1;
__END__

=head1 NAME

Astro::NED::Response::Object - query results for a single object

=head1 SYNOPSIS

  use Astro::NED::Response::Object;

  my $obj = Astro::NED::Response::Object->new( Field => $value, ...  );

  print $obj->Field;

=head1 DESCRIPTION

An instance of B<Astro::NED::Response::Object> contains information on
a single object (astronomical, not computer science) returned by
queries generated by B<Astro::NED::Query::ByName>,
B<Astro::NED::Query::NearName>, or B<Astro::NED::Query::NearPosition>
(actually, any class subclassed from B<Astro::NED::Query::Objects>).

The object (computer science, not astronomical) is usually contained
in and created by a B<Astro::NED::Response::Objects> object from the
results of the query.

Objects are read-only.

For complete information on the available fields, see
L<http://nedwww.ipac.caltech.edu/help/objresult_help.html>.

Currently, the detailed object information is *not* available (just
the summary information) although the B<InfoLink> method will return
the URL to that information.

=head2 Constructor

The constructor, B<new>, takes a list of field, value pairs with
which to initialize the object.  See L<Fields> for more information.

=head2 Non Accessor Methods

=over

=item dump

  $obj->dump( $fh );

Print a representation of the object the passed filehandle.  If no
filehandle is specified, it is printed to the standard output stream.

=item fields

  @fields = $obj->fields;
  @fields = Astro::NED::Response::Object->fields;

This is either a class or an object method.  As an object method,
it returns a list of fields which had values in the object.
As a class method, it returns a list of all possible fields.

=item data

  %data = $obj->data;

This returns the object's data as a hash, keyed off of the field names.
Use the accessor methods if possible.

=back

=head2 Accessing the data

Acesss to the data is via accessor methods named after the fields
returned by NED (e.g. C<$obj-E<gt>Name>).  They take no arguments
and return the field values.  Data can also be extracted into a
hash via the B<data> method.

=head2 Fields

The following fields are defined.

=over

=item No

A sequential object number applicable to this list only.

=item Name

One of NED's names for the object.

=item Lat

The latitude of the object, if the output coordinate system is in
latitude/longitude.

=item Lon

The longitude of the object, if the output coordinate system is in
latitude/longitude.

=item RA

The Right Ascension of the object, if the output coordinate system is 
equatorial.

=item Dec

The Declination of the object, if the output coordinate system is 
equatorial.

=item Type

The NED "Preferred Object Type"

=item Velocity

The heliocentric redshift as cz, in km/s.

=item Z

The heliocentric redshift.

=item VZQual

A qualifier on the redshift.

=item Distance

The distance, in arcminutes, to the search position or named object position.

=item NRefs

The number of literature references.

=item NNotes

The number of catalogue notes.

=item NPhot

The number of photometric determinations

=item NPosn

The number of positions.

=item NVel

The number of velocities.

=item NAssoc

The number of NED associations.

=item Images

A URL to an image of the object

=item InfoLink

A URL to the detailed information on this object.

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

L<Astro::NED::Response>,
L<Astro::NED::Query>,
L<perl>.

=cut
