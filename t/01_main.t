#!/usr/bin/perl

# Formal testing for Class::Default

# Do all the tests on ourself, since we know we will be loaded.

use strict;
use UNIVERSAL 'isa';
use File::Spec::Functions qw{:ALL};
use lib catdir( updir(), updir(), 'modules' ), # Development testing
        catdir( updir(), 'lib' );              # For installation testing
use Test::More tests => 22;

# Set up any needed globals
use vars qw{$cd $cdt};
BEGIN {
	$| = 1;
	$cd = 'Class::Default';
	$cdt = 'Class::Default::Test1';
}




# Check their perl version
BEGIN {
	ok( $] >= 5.005, "Your perl is new enough" );
}





# Does the module load
use_ok( 'Class::Default' );




# Create the test package
package Class::Default::Test1;

use strict;

use base 'Class::Default';

sub new {
	my $class = shift;
	my $self = {
		name => undef,
		};
	bless $self, $class;
}

sub setName {
	my $self = shift->_self;
	my $value = shift;
	$self->{name} = $value;
	1;
}
sub getName {
	my $self = shift->_self;
	$self->{name};
}

sub hash {
	my $self = shift->_self;
	"$self";
}

sub class {
	my $class = shift->_class;
	$class;
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
