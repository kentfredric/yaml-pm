use strict;
use lib -e 't' ? 't' : 'test';
use TestYAML tests => 11;
use YAML ();
use YAML::Dumper;

$YAML::QuoteNumericStrings = 1;
filters { perl => [qw'eval yaml_dump'], };

ok( YAML::Dumper->is_literal_number(1),    '1 is a literal number' );
ok( !YAML::Dumper->is_literal_number("1"), '"1" is not a literal number' );
ok( YAML::Dumper->is_literal_number( "1" + 1 ), '"1" +1  is a literal number' );

ok( !YAML::Dumper->is_literal_number("Inf"), '"Inf" is not a literal number' );
ok( YAML::Dumper->is_literal_number( "Inf" + 1 ), '"Inf" +1  is a literal number' );
ok( !YAML::Dumper->is_literal_number("NaN"), '"NaN" is not a literal number' );
ok( YAML::Dumper->is_literal_number( "NaN" + 1 ), '"NaN" +1  is a literal number' );

run_is;

__DATA__
=== Mixed Literal and Stringy ints
+++ perl
+{ foo => '2', baz => 1 }
+++ yaml
---
baz: 1
foo: '2'

=== Mixed Literal and Stringy floats
+++ perl
+{ foo => '2.000', baz => 1.000 }
+++ yaml
---
baz: 1
foo: '2.000'

=== Numeric Keys
+++ perl
+{ 10 => '2.000', 20 => 1.000, '030' => 2.000 }
+++ yaml
---
'030': 2
'10': '2.000'
'20': 1

=== INF/NAN
+++ perl
+ { a=> q[Inf] + 1, b => q[Nan] + 1, c => q[Inf], d => q[NaN], e => 0 - q[Inf], f => '-Inf'  }
+++ yaml
---
a: !inf
b: !nan
c: 'Inf'
d: 'NaN'
e: !inf -1
f: '-Inf'
