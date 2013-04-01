
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'WebService::Livedoor::Weather',
    VERSION_FROM      => 'lib/WebService/Livedoor/Weather.pm',
    PREREQ_PM         => {
	'URI::Fetch' => 0,
	'XML::Simple' => 0,
        'JSON::XS' => 0
    },
    ($] >= 5.005 ? 
      (ABSTRACT_FROM  => 'lib/WebService/Livedoor/Weather.pm',
       AUTHOR         => 'Masahiro Nagano <kazeburo@nomadscafe.jp>') : ()),
);
