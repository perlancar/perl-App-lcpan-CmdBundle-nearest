package App::lcpan::Cmd::nearest_dists;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

require App::lcpan;

our %SPEC;

$SPEC{handle_cmd} = {
    v => 1.1,
    summary => 'List dists with names nearest to a specified name',
    args => {
        %App::lcpan::dist_args,
    },
};

sub handle_cmd {
    my %args = @_;

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my $sth = $dbh->prepare("SELECT name FROM dist");
    $sth->execute;
    my @names;
    while (my ($name) = $sth->fetchrow_array) { push @names, $name }

    require Text::Fuzzy;
    my $tf = Text::Fuzzy->new($args{dist});

    [200, "OK", [$tf->nearestv(\@names)]];
}

1;
# ABSTRACT:
