# ispl
A small garbage-collected LISP dialect based on compilation to postfix notation

This is effectively a far superior rewrite of my previous LISP project, csl.

The header files contain short summaries of the purpose of their contents.
Implementation details and type definitions can be found in object.h.
Its source file, object.c, contains C functions only for direct use by the programmer.
Such functions include those for memory management and type checking.
Functions in core.c are intended only for direct use by the language itself.

The source code for the core functions in core.c may seem odd.
A fair amount of work is done in functions generated by quasi-recursive preprocessor macros
which convert C functions into a stack-based equivalent.
Really, they only pop arguments, push results, and do basic memory management.
However, it greatly reduces the amount of work required to add new built-in functions.

This project also makes use of my own hash table implementation, called [semstable](../../../semstable),
with a slight modification to allow hash tables to be case-insensitive.

##### To create source files for new built-in functions:
1. Make the header (with include guards) and `#include "core.h"` to gain access to its macros.
3. Make an init function at the bottom of the source file, and declare it in the header.
2. Include your header in namespace.h and add a call to the new init function in `init_dict`.

##### To create a new built-in function:
1. Write the C function. It must take only object pointers (or void) and return an object pointer.
2. Use the `STACK(name,argc)` macro after the function definition to generate a stack-based function.
3. Use the `INIT(lispname,cname)` macro in the init function to make the function available.

##### Memory management guidelines for new functions:
Reference counters must always be incremented by `incr_refs` and decremented by `decr_refs`,
with one exception.<sup>&dagger;</sup>
Of course, this must be done whenever a pointer is permanently stored or removed, respectively.
Calling `push` to store an item on the stack will increase its references automatically.
Calling `pop` to retrieve a value will leave its references alone to avoid prematurely destroying objects.
The object retrieved must have its references decremented *as soon as* it is no longer useful.
Waiting to decrement a reference counter can hide bugs in memory management. This is a bad thing.

However, should C variables count as references? It depends on what will happen to the object.

* If the object is generated for temporary use by the same function, increment its references.
  * This must be done so that its references can be decremented later.
* If the object will be generated as a return value, leave its references alone.
  * Memory management of generated objects is to be done by the caller.
  
Naturally, one should use functions declared in new.h, object.h, or namespace.h whenever possible,
as these functions are designed to make reference counting easier.
  
<sup>&dagger;</sup>When popping an object off of the stack to be returned, decrement its references manually.
As with any returned value, memory management is to be done by the caller.
However, if you use `decr_refs`, you risk destroying the object prematurely.
This can be avoided by simply using `obj->refs--;` instead.