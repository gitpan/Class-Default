use inc::Module::Install;

name          ( 'Class-Default');
abstract      ( 'Static methods apply to a default instantiation');
author        ( 'Adam Kennedy<cpan@ali.as>');
version_from  ( 'lib/Class/Default.pm');
license       ( 'perl');

requires      ( 'perl'             => '5.005' );

build_requires( 'Test::More'       => '0.47'  );
build_requires( 'File::Spec'       => '0.82'  );

auto_install();

&WriteAll;
