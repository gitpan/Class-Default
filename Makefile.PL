require 5.000;
use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'         => 'Class::Default',
	'VERSION_FROM' => 'lib/Class/Default.pm',
	'PREREQ_PM'    => {
		'Class::Inspector' => 0,
	},
	($] >= 5.005) ? (
		'AUTHOR'     => 'Adam Kennedy (adam@ali.as)',
		'ABSTRACT'   => "Static methods apply to a defaulf instantiation",
	) : (),
);
