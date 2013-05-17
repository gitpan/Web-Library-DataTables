use strict;
use warnings;
use ExtUtils::MakeMaker 6.58;
use File::ShareDir::Install;
install_share 'share';
my $name = 'Web-Library-DataTables';
(my $from = "lib/$name.pm") =~ y!-!/!;
WriteMakefile(
    ABSTRACT_FROM      => $from,
    "AUTHOR"           => 'Marcel Gruenauer <marcel@cpan.org>',
    "BUILD_REQUIRES"   => { 'Test::More' => '0.94' },
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => '6.58' },
    LICENSE            => 'perl',
    META_MERGE         => {
        resources => {
            bugtracker => "https://github.com/marcelgruenauer/$name/issues",
            repository => "git://github.com/marcelgruenauer/$name.git",
            homepage   => "https://github.com/marcelgruenauer/$name",
        },
    },
    MIN_PERL_VERSION => '5.12.0',
    NAME             => $name,
    PREREQ_PM        => {
        'Moose'        => '0',
        'Web::Library' => '0.02',
    },
    VERSION_FROM => $from,
    test         => { TESTS => 't/*.t' }
);

package MY;
use File::ShareDir::Install qw(postamble);

# Uninstall the old shared files so files that were present in older
# versions but aren't present now won't interfere.
sub install {
    my $result = shift->SUPER::install(@_);
    $result =~ s/install :: \K(?=pure_install )/share_uninstall /;
    $result .= <<EOMAKE;

share_uninstall ::
\t\$(RM_RF) \$(INSTALLSITELIB)/auto/share/dist/\$(DISTNAME)
EOMAKE
    $result;
}
