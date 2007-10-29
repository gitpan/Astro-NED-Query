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

package Astro::NED::Response::Fields;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.20';

# mapping between HTML table column names and Object field names
my @Fields = (
              [ No         => qr/no[.]/           ],
              [ Name       => qr/object name/     ],
              [ Lat        => qr/lat$/            ],
              [ Lon        => qr/lon$/            ],
              [ Type       => qr/object type/     ],
              [ RA         => qr/ra$/             ],
              [ Dec        => qr/dec$/            ],
              [ Velocity   => qr{km/s}            ],
              [ Z          => qr/redshift z$/     ],
              [ VZQual     => qr/qual$/           ],
              [ Distance   => qr/distance/        ],
              [ NRefs      => qr/number of refs/  ],
              [ NNotes     => qr/number of notes/ ],
              [ NPhot      => qr/number of phot/  ],
              [ NPosn      => qr/number of posn/  ],
              [ NVel       => qr{number of vel/z} ],
              [ NDiam      => qr/number of diam/  ],
              [ NAssoc     => qr/number of assoc/ ],
              [ Images     => qr/images/          ],
             );

## no critic (AccessOfPrivateData)
# @Fields is a list of arrayrefs, not objects.

my @FieldNames = map { $_->[0] } @Fields;

## use critic

sub fields { return @Fields };
sub names { return @FieldNames };


1;
__END__

=head1 NAME

Astro::NED::Response::Fields - Helper module for Astro::NED::Response::Object(s)

=head1 SYNOPSIS

  use Astro::NED::Response::Fields;

=head1 DESCRIPTION

This class is a helper class for B<Astro::NED::Query::Object(s)> query.

=head2 Class Methods

=over

=item fields

  @fields = Astro::NED::Response::Fields::names();

Returns a list of recognized fields.  Each field is an array
containing the field name and the regex used to match it.

=item names

  @names = Astro::NED::Response::Fields::names();

returns the list of recognized field names.  This should rarely, if
ever be used by user code.  Instead, use the query object's
B<fields> method.

=back

=head2 EXPORT

None.

=head1 AUTHOR

Diab Jerius, E<lt>djerius@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (C) 2007 Smithsonian Astrophysical Observatory.
All rights are of course reserved.

It is released under the GNU General Public License.  You may find a
copy at

   http://www.fsf.org/copyleft/gpl.html

=head1 SEE ALSO

L<Astro::NED::Response::Object>,
L<Astro::NED::Query::Objects>,
L<perl>.

=cut
