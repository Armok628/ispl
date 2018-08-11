#!/usr/bin/tclsh
proc puts_init_lines {file} {
	if [catch {set fh [open $file r]} err] {
		puts "/*$err*/"
		return
	}
	set lines [split [read $fh] "\n"]
	close $fh
	foreach line $lines {
		if {[regexp {^CORE\((\w+),} $line -> name]} {
			puts "\tinsert(dict,\"$name\",incr_refs(new_cfunction(&stack_$name)));"
		}
	}
}

puts \
"#ifndef INIT
#define INIT
#include \"src/types.h\"
void init(void)
{
	dict=new_table(STACK_SIZE,(dtor_t)&decr_refs);
	obj_t *f=NULL;"
foreach file $argv {puts_init_lines $file}
puts \
"}
#endif"