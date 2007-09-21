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

package Astro::NED::Response::Objects;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.02';

our @Fields;

BEGIN {

  # mapping between HTML table column names and Object field names
  # These must be defined in a BEGIN as they are used by
  # Astro::NED::Response::Object to create class accessors
  # at compile time.
  @Fields = ( 
	     [ No	=> qr/no[.]/           ],
	     [ Name	=> qr/object name/     ],
	     [ Lat	=> qr/lat$/            ],
	     [ Lon	=> qr/lon$/            ],
	     [ Type	=> qr/object type/     ],
	     [ RA	=> qr/ra$/             ],
	     [ Dec	=> qr/dec$/            ],
	     [ Velocity => qr{km/s}            ],
	     [ Z	=> qr/redshift z$/     ],
	     [ VZQual	=> qr/qual$/           ],
	     [ Distance => qr/distance/        ],
	     [ NRefs	=> qr/number of refs/  ],
	     [ NNotes	=> qr/number of notes/ ],
	     [ NPhot	=> qr/number of phot/  ],
	     [ NPosn	=> qr/number of posn/  ],
	     [ NVel	=> qr{number of vel/z} ],
	     [ NDiam	=> qr/number of diam/  ],
	     [ NAssoc	=> qr/number of assoc/ ],
	     [ Images	=> qr/images/          ],
	    );

}

use Astro::NED::Response::Object;


#---------------------------------------------------------------------------

sub new
{
  my $class = shift;
  $class = ref $class || $class;

  my $self = {
	      curr_object => -1,
	      objects => [],
	     };
  bless $self, $class;

  $self;
}

#---------------------------------------------------------------------------

sub objects { @{$_[0]{objects}} }

sub nobjects { scalar @{$_[0]{objects}} }

sub addobject
{
  my $self = shift; 

  croak( __PACKAGE__, '->addobject: object is not of type Astro::NED::Response::Object' )
    if grep { ! $_->isa( 'Astro::NED::Response::Object' ) } @_;

  push @{$self->{objects}}, @_;

  scalar @{$self->{objects}}
}

#---------------------------------------------------------------------------


sub parseHTML
{

  require HTML::LinkExtor;
  require HTML::TableParser;

  my $self = shift;

  # don't do this, as we don't want to copy the passed data.
  # my $html = shift;

  # first get list of links
  my $p = HTML::LinkExtor->new;
  $p->parse( $_[0]);

  my @links = grep { /search_type=Obj_id/i } map { $_->[2] } $p->links;

  my @cols;

  $p = HTML::TableParser->new( 
     [{
       cols => qr/Object Type/,
       DecodeNBSP => 1,

       hdr => sub {

	 for my $colname ( @{$_[2]} )
	 {
	   $colname = lc $colname;
	   my @matches = grep { $colname =~ $_->[1] } @Fields;
	   if ( 1 != @matches )
	   {
	     require Carp;
	     Carp::croak( __PACKAGE__, 
			  "::internal error; multiple or zero column name matches for $colname\n ");
	   }
	   push @cols, $matches[0][0];
	 }
       },

       row => sub {
	 my %data;
	 @data{@cols} = map { $_ eq '' || $_ eq '...' ? undef : $_ } @{$_[2]};
	 $data{InfoLink} = shift @links;
	 $data{Name} =~ s/^[*]//;
	 push @{$self->{objects}}, Astro::NED::Response::Object->new( \%data );
       },

       Trim => 1,
      }]
  );

  $p->parse( $_[0] );
}

#---------------------------------------------------------------------------

# the following provide support for Object::Iterate

sub __init__
{
  $_[0]{curr_object} = -1;
}

sub __more__
{
  $_[0]{curr_object} + 1 < @{$_[0]{objects}};
}

sub __next__
{
  $_[0]{object}[++$_[0]{curr_object}];
}

#---------------------------------------------------------------------------


1;
__END__

=head1 NAME

Astro::NED::Response::Objects - a container for NED Object query objects 

=head1 SYNOPSIS

  use Astro::NED::Response::Objects;

  # create an empty container.
  my $objs = Astro::NED::Response::Objects->new();

  # add an object of type Astro::NED::Response::Object
  $objs->addobject( $obj );

  # parse a NED object query and add the objects to the container
  $objs->parseHTML( $html );

  # get the number of objects
  my $nobj = $objs->nobjects;

  # get the objects as a list
  my @objs = $objs->objects;

=head1 DESCRIPTION

This class implements a container for Astronomical objects returned by
an B<Astro::NED::Query::Objects> query.  The objects are stored as
B<Astro::NED::Response::Object> objects.

The most useful methods for the general user are the B<nobjects> and
B<objects> methods.

=head2 Methods

=over

=item new

  $objs = Astro::NED::Response::Objects->new();

creates an empty container

=item parseHTML

  $objs->parseHTML( $html );

parse the HTML response from a NED "Objects" query and add the objects
to the container.

=item addobject

  $objs->addobject( $obj );

add an object of type B<Astro::NED::Response::Object>.

=item nobjects

  $nobjs = $objs->nobjects

returns the number of objects in the container

=item objects

  @objects = $objs->objects

returns the objects as a Perl list.

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

L<Astro::NED::Response::Object>,
L<Astro::NED::Query::Objects>,
L<perl>.

=cut
