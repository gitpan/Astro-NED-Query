package Astro::NED::Response::CoordExtinct;

use 5.006;
use strict;
use warnings;

use Regexp::Common;

our $VERSION = '0.01';

use base qw/ Class::Accessor /;

our @Bandpasses = qw/ U B V R I J H K L' /;

our @Fields = ( qw/ RA Dec Lat Lon PA EB-V/, @Bandpasses );

__PACKAGE__->mk_ro_accessors( @Fields );

# Preloaded methods go here.

sub dump
{
  my ( $self, $fh )  = @_;

  $fh = \*STDOUT unless defined $fh;

  print $fh "$_: ", defined $self->get($_) ? $self->get($_) : 'undef', "\n"
    foreach @Fields;
}

sub fields
{
  # object method
  if ( ref $_[0] )
  {
    return grep { defined $_[0]->get($_) } @Fields
  }

  # class method
  else
  {
    return @Fields;
  }
}

sub data
{
  %{$_[0]};
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
    ( $self->{$bandpass} ) = $text =~ /^$bandpass\s*\(.*\)\s+($RE{num}{real})/m;
  }

  @{$self}{qw/ Lat Lon PA/} =
    $text =~ /^Output:.*\n+
	    ($RE{num}{real})\s+
	    ($RE{num}{real})\s+
	    ($RE{num}{real})/mx;

  $self->{RA}  = $self->{Lat};
  $self->{Dec} = $self->{Lon};
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
  $obj->parse_HTML( $html );

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