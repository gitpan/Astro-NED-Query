use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

$BasePM = 'lib/Astro/NED/Query.pm';

WriteMakefile(
    'NAME'		=> 'Astro::NED::Query',
    'VERSION_FROM'	=> $BasePM, # finds $VERSION
    'PREREQ_PM'		=> {
			    Test::More		=> 0.47,
			    Class::Accessor	=> 0.17,
                            HTML::TableParser	=> 0.32,
                            HTML::LinkExtor	=> 1.31,
			    WWW::Mechanize	=> 0.35,
			   }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => $BasePM, # retrieve abstract from module
       AUTHOR     => 'Diab Jerius <djeriusA@cpan.org>') : ()),
);
