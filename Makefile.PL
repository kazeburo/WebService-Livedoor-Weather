use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'WebService::Livedoor::Weather',
    VERSION_FROM => 'lib/WebService/Livedoor/Weather.pm',
    PREREQ_PM    => {
        'Encode'          => 0,
        'URI::Fetch'      => 0,
        'XML::Parser'     => 0,
        'XML::Simple'     => 0,
        'JSON'            => 0,
        'Test::Exception' => 0,
        'Test::More'      => '0.98',
    },
    (
        $] >= 5.005
        ? (
            ABSTRACT_FROM => 'lib/WebService/Livedoor/Weather.pm',
            AUTHOR        => 'Masahiro Nagano <kazeburo@nomadscafe.jp>'
          )
        : ()
    ),
);
