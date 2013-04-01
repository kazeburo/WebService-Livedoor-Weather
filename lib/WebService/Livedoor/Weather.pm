package WebService::Livedoor::Weather;

use strict;
use warnings;
use Carp;
use URI::Fetch;
use XML::Simple;

our $VERSION = '0.02';

sub new {
    my ( $class, %args ) = @_;
    $args{fetch} ||= {};
    $args{fetch} = {
	%{$args{fetch}},
        UserAgent => LWP::UserAgent->new( agent => "WebService::Livedoor::Weather/$VERSION" )
    };
    bless \%args,$class;
}

sub get {
    my $self = shift;
    my ($city,$day) = @_;
    croak('city is required') unless $city;
    $day ||= 'today';
    my $cityid = $self->__get_cityid($city);

    my $res = URI::Fetch->fetch("http://weather.livedoor.com/forecast/webservice/rest/v1?city=$cityid&day=$day", %{$self->{fetch}});
    croak("Cannot get weather information : " . URI::Fetch->errstr) unless $res;

    my $ref;
    eval{$ref = XMLin($res->content)};
    croak('Oops! failed reading weather information : ' . $@) if $@;

    #temperature fixing
    ref $ref->{temperature}{max}{celsius} and $ref->{temperature}{max}{celsius} = undef;
    ref $ref->{temperature}{min}{celsius} and $ref->{temperature}{min}{celsius} = undef;
    ref $ref->{temperature}{max}{fahrenheit} and $ref->{temperature}{max}{fahrenheit} = undef;
    ref $ref->{temperature}{min}{fahrenheit} and $ref->{temperature}{min}{fahrenheit} = undef;

    return $ref;
}

sub __get_cityid {
    my ($self,$city) = @_;
    return $city if $city =~ /^\d+$/;

    my $cityname = pack('C0A*',$city);
    croak('Invalid city name. cannot find city id with ' . $city) 
	unless exists $self->__forecastmap->{$cityname};

    return $self->__forecastmap->{$cityname};
}

sub __forecastmap{
    my $self = shift;

    return $self->{forecastmap} if $self->{forecastmap};

    my $res = URI::Fetch->fetch('http://weather.livedoor.com/forecast/rss/forecastmap.xml', %{$self->{fetch}});
    croak("Couldn't get forecastmap.xml : " . URI::Fetch->errstr) unless $res;

    my $ref;
    eval{$ref = XMLin($res->content,ForceArray => [qw/pref area city/])};
    croak('Oops! failed reading forecastmap.xml : ' . $@) if $@;

    my %forecastmap;
    foreach my $area (@{$ref->{channel}->{'ldWeather:source'}->{area}}){
	foreach my $pref (@{$area->{pref}}){
	    $forecastmap{pack('C0A*',$pref->{city}->{$_}->{title})} = $_
		for keys %{$pref->{city}};
	}
    }

    $self->{forecastmap} = \%forecastmap;
    return $self->{forecastmap};
}

1;
__END__

=head1 NAME

WebService::Livedoor::Weather - Perl interface to Livedoor Weather Web Service

=head1 SYNOPSIS

  use WebService::Livedoor::Weather;

  $lwws = WebService::Livedoor::Weather->new;
  my $ret = $lwws->get('63','tomorrow'); #63 is tokyo

  print $ret->{title};
  print $ret->{description};

=head1 DESCRIPTION

WebService::Livedoor::Weather is a simple interface to Livedoor Weather Web Service (LWWS)

=head1 METHODS

=item new

    $lwws = WebService::Livedoor::Weather->new;
    $lwws = WebService::Livedoor::Weather->new(fetch=>{
        Cache=>$c
    });

creates an instance of WebService::Livedoor::Weather.

C<fetch> is option for URI::Fetch that used for fetching weather information.

=item get(cityid or name,[day])

    my $ret = $lwws->get('63','tomorrow'); #63 is tokyo
    my $ret = $lwws->get('cityname','today');

retrieve weather.
You can get a city id from http://weather.livedoor.com/forecast/rss/forecastmap.xml

=head1 SEE ALSO

L<URI::Fetch>
http://weather.livedoor.com/weather_hacks/webservice.html (Japanese)

=head1 AUTHOR

Masahiro Nagano, E<lt>kazeburo@nomadscafe.jpE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Masahiro Nagano

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.5 or,
at your option, any later version of Perl 5 you may have available.


=cut
