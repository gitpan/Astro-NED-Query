# --8<--8<--8<--8<--
#
# Copyright (C) 2007 Smithsonian Astrophysical Observatory
#
# This file is part of Astro::NED::Query
#
# Astro::NED::Query is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# -->8-->8-->8-->8--

package Astro::NED::Response::CoordExtinct;

use 5.006;
use strict;
use warnings;

use Regexp::Common;

our $VERSION = '0.30';

use base qw/ Class::Accessor /;

my @Bandpasses = qw/ U B V R I J H K L' /;

my @Fields = ( qw/ RA Dec Lat Lon PA EB-V/, @Bandpasses );

__PACKAGE__->mk_ro_accessors( @Fields );

# Preloaded methods go here.

sub dump
{
  my ( $self, $fh )  = @_;

  $fh = \*STDOUT unless defined $fh;

  print {$fh} "$_: ", defined $self->get($_) ? $self->get($_) : 'undef', "\n"
    foreach @Fields;

  return;
}

sub fields
{
    my ( $self ) = @_;

    # object method
    if ( ref $self )
    {
        return grep { defined $self->get($_) } @Fields
    }

    # class method
    else
    {
        return @Fields;
    }
}

sub data
{
    my ( $self ) = @_;

    return %{$self};
}

sub parseHTML
{
  my $self = shift;

  require HTML::Parser;
  my $text;
  my $p = HTML::Parser->new;
  $p->handler( text => sub { $text .= $_[0] }, 'dtext' );
  $p->handler( start => '' );
  $p->handler( end => '' );
  $p->unbroken_text(1);
  $p->parse( $_[0] );
  $p->eof;

  $self->{'EB-V'} = $text =~ /E\(B-V\)\s*=\s*(.*)\s+mag/;


  for my $bandpass ( @Bandpasses )
  {
    ( $self->{$bandpass} ) =
      $text =~ /^$bandpass\s*\(.*\)\s+($RE{num}{real})/m;
  }

  @{$self}{qw/ Lat Lon PA/} =
     $text =~ /^Output:.*\n+
               ($RE{num}{real})\s+
               ($RE{num}{real})\s+
               ($RE{num}{real})/mx;

  $self->{RA}  = $self->{Lat};
  $self->{Dec} = $self->{Lon};

  return;
}

1;
__END__

=head1 NAME

Astro::NED::Response::CoordExtinct - query results for a coordinates and extinction

=head1 SYNOPSIS

  use Astro::NED::Response::CoordExtinct;

  # create and initialize object
  $obj = Astro::NED::Response::CoordExtinct->new( Field => $value, ...  );

  print $obj->Field;

  # initialize existing object from an HTML response
  $obj->parseHTML( $html );

=head1 DESCRIPTION

An instance of B<Astro::NED::Response::CoordExtinct> contains information
returned by queries generated by B<Astro::NED::Query::CoordExtinct>.

For complete information on the available fields, see
L<http://nedwww.ipac.caltech.edu/help/calc_help.html>.

=head2 Constructor

The constructor, B<new>, takes a list of field, value pairs with
which to initialize the object.  See L<Fields> for more information.

=head2 Non Accessor Methods

=over

=item dump

  $obj->dump( $fh );

Print a representation of the object to the passed filehandle.  If no
filehandle is specified, it is printed to the standard output stream.

=item fields

  @fields = $obj->fields;
  @fields = Astro::NED::Response::CoordExtinct->fields;

This is either a class or an object method.  As an object method,
it returns a list of fields which had values in the object.
As a class method, it returns a list of all possible fields.

=item data

  %data = $obj->data;

This returns the object's data as a hash, keyed off of the field names.
Use the accessor methods if possible.

=item parseHTML

  $obj->parseHTML( $html );

Initializes the object from the passed HTML content.  This is typically
invoked only by B<Astro::NED::Query::CoordExtinct>.

=back

=head2 Accessing the data

Acesss to the data is via accessor methods named after the fields
returned by NED (e.g. C<$obj-E<gt>RA>).  They take no arguments
and return the field values.  Data can also be extracted into a
hash via the B<data> method.

=head2 Fields

The following fields are defined.

=over

=item Lat

The latitude of the object in degrees, if the output coordinate system is in
latitude/longitude.

=item Lon

The longitude of the object in degrees, if the output coordinate system is in
latitude/longitude.

=item RA

The Right Ascension of the object in degrees, if the output coordinate system is
equatorial.

=item Dec

The Declination of the object in degrees, if the output coordinate system is
equatorial.

=item PA

The position angle of the object in degrees, in the output coordinate system,

=item U, B, V, R, I, J, H, K, L'

The extinction in the given bandpass.

=item EB-V

The E(B-V) color excess.

=back

=head2 EXPORT

None by default.


=head1 AUTHOR

Diab Jerius, E<lt>djerius@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (C) 2004 Smithsonian Astrophysical Observatory.
All rights are of course reserved.

It is released under the GNU General Public License.  You may find a
copy at

   http://www.fsf.org/copyleft/gpl.html

=head1 SEE ALSO

L<Astro::NED::Response>,
L<Astro::NED::Query>,
L<perl>.

=cut
