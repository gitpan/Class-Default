require 5.000;
use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'         => 'Class::Default',
	'VERSION_FROM' => 'lib/Class/Default.pm',
	'PREREQ_PM'    => {
		'File::Spec'       => 0.83,
		'Test::More'       => 0,
		'Class::Inspector' => 1,
	},
	($] >= 5.005) ? (
		'AUTHOR'     => 'Adam Kennedy (cpan@ali.as)',
		'ABSTRACT'   => "Static methods apply to a default instantiation",
	) : (),
);
