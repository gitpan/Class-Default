#!/usr/local/bin/perl

# Formal testing for Class::Default

# Do all the tests on ourself, since we know we will be loaded.

use strict;
use lib '../../modules';
use lib '../lib'; # For installation testing
use Class::Inspector;
use UNIVERSAL 'isa';
use Test::Simple tests => 23;

# Set up any needed globals
use vars qw{$loaded $cd $cdt};
BEGIN {
	$loaded = 0;
	$| = 1;

	$cd = 'Class::Default';
	$cdt = 'Class::Default::Test1';
}




# Check their perl version
BEGIN {
	ok( $] >= 5.005, "Your perl is new enough" );
	ok( Class::Inspector->installed( 'Carp' ), "Carp is installed" );	
}
	




# Does the module load
END { ok( 0, 'Class::Default loads OK' ) unless $loaded; }
use Class::Default;
$loaded = 1;
ok( 1, 'Class::Default loads OK' );





# Create the test package
package Class::Default::Test1;

use strict;

use base 'Class::Default';

sub new {
	my $class = shift;
	my $self = {
		name => undef,
		};
	return bless $self, $class;
}

sub setName {
	my $self = shift->_self;
	my $value = shift;
	$self->{name} = $value;
	return 1;
}
sub getName {
	my $self = shift->_self;
	return $self->{name};
}

sub hash {
	my $self = shift->_self;
	return "$self";
}

sub class {
	my $class = shift->_class;
	return $class;
}

1;

package main;





# Basic API existance
ok( Class::Default->can( '_self' ), "Class::Default->_self exists" );
ok( Class::Default->can( '_get_default' ), "Class::Default->_get_default exists" );
ok( Class::Default->can( '_create_default_object' ), "Class::Default->_create_default_object exists" );
ok( Class::Default::Test1->can( '_self' ), "Class::Default::Test1->_self exists" );
ok( Class::Default::Test1->can( '_get_default' ), "Class::Default::Test1->_get_default exists" );
ok( Class::Default::Test1->can( '_create_default_object' ),
	"Class::Default::Test1->_create_default_object exists" );

# Object gets created...
my $object = Class::Default::Test1->new();
ok( isa( $object, "Class::Default::Test1" ), "Object isa Class::Default::Test1" );
ok( isa( $object, "Class::Default" ), "Object isa Class::Default" );
ok( ! scalar keys %Class::Default::DEFAULT, "DEFAULT hash remains empty after normal object creation" );

# Default gets created
my $default1 = Class::Default::Test1->_get_default;
ok( $default1, "->_get_default returns something" );
ok( (ref $default1 eq $cdt), "->_get_default returns the correct object type" );
ok( scalar keys %Class::Default::DEFAULT, "DEFAULT hash contains something after _get_default" );
ok( (scalar keys %Class::Default::DEFAULT == 1), "DEFAULT hash contains only one thing after _get_default" );
ok( exists $Class::Default::DEFAULT{$cdt}, "DEFAULT hash contains the correct key after _get_Default" );
ok( "$Class::Default::DEFAULT{$cdt}" eq "$default1",
	"DEFAULT hash entry matches that returned" );

# Get another object and see if they match
my $default2 = Class::Default::Test1->_get_default;
ok( "$default1" eq "$default2", "Second object matches the first object" );

# Check the response of a typical method as compared to the static
ok( $object->hash eq "$object", "Result of basic object method matchs" );
ok( Class::Default::Test1->hash eq "$default1", "Result of basic static method matchs" );

# Check the result of the _class method
ok( Class::Default::Test1->class eq 'Class::Default::Test1', "Static ->_class returns the class" );
ok( $default1->class eq 'Class::Default::Test1', "Object ->_class returns the class" );