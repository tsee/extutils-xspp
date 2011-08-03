package ExtUtils::XSpp::Typemap::simplexs;

use base 'ExtUtils::XSpp::Typemap';

sub init {
  my $this = shift;
  my %args = @_;

  $this->{TYPE} = $args{type};
  $this->{XS_TYPE} = $args{xs_type};
}

sub cpp_type { $_[0]->{TYPE}->print }
sub xs_type { $_[0]->{XS_TYPE} }
sub output_code { undef } # likewise
sub call_parameter_code { undef }
sub call_function_code { undef }

1;
