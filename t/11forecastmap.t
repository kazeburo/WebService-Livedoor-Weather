use strict;
use warnings;
use utf8;
use Test::More;
use WebService::Livedoor::Weather;
use t::Util;

my $obj = WebService::Livedoor::Weather->new;
my $forecastmap_data = t::Util->load_forecastmap_data();
my $forecastmap = $obj->__parse_forecastmap($forecastmap_data);

isa_ok $forecastmap, 'HASH';
is $forecastmap->{'札幌'}, '016010';
is $forecastmap->{'仙台'}, '040010';
is $forecastmap->{'東京'}, '130010';
is $forecastmap->{'横浜'}, '140010';
is $forecastmap->{'名古屋'}, '230010';
is $forecastmap->{'大阪'}, '270000';
is $forecastmap->{'京都'}, '260010';
is $forecastmap->{'新潟'}, '150010';
is $forecastmap->{'広島'}, '340010';
is $forecastmap->{'岡山'}, '330010';
is $forecastmap->{'福岡'}, '400010';
is $forecastmap->{'那覇'}, '471010';
is $forecastmap->{'父島'}, '130040';
is $forecastmap->{'練馬'}, undef;

done_testing;
