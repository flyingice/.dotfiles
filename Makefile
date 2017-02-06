#
# 'make depend' uses makedepend to automatically generate dependencies 
#               (dependencies are added to end of Makefile)
# 'make'        build executable file
# 'make clean'  removes all .o and executable files
#

SRCDIR = src
HDRDIR = include

# define the compiler to use
CC = g++

# define path to GTest
GTEST_DIR = /usr/local/gtest/googletest
GMOCK_DIR = /usr/local/gtest/googlemock

# define any compile-time flags
CPPFLAGS = -Wall -g -pthread

# define any directories containing header files other than /usr/include
INCLUDES = -I $(GTEST_DIR)/include -I $(GMOCK_DIR)/include
INCLUDES += -I $(HDRDIR)

# define library paths in addition to /usr/lib
LFLAGS = -L$(GTEST_DIR)/make -L$(GMOCK_DIR)/make

# define any libraries to link into executable
LIBS = -lgtest -lgmock

# define the source files
SRCS := $(shell find $(SRCDIR) -name '*.cpp')

# define the cpp object files 
#
# This uses Suffix Replacement within a macro:
#   $(name:string1=string2)
#         For each word in 'name' replace 'string1' with 'string2'
# Below we are replacing the suffix .c of all words in the macro SRCS
# with the .o suffix
#
OBJS = $(SRCS:.cpp=.o)

# define the executable file 
MAIN = run

# define the utility for the cleanup
RM = rm

#
# The following part of the makefile is generic; it can be used to 
# build any executable just by changing the definitions above and by
# deleting dependencies appended to the file from 'make depend'
#

.PHONY: depend clean

all: $(MAIN)
	@echo	The project has been compiled.

$(MAIN): $(OBJS)
	$(CC) $(CPPFLAGS) $(INCLUDES) -o $(MAIN) $(OBJS) $(LFLAGS) $(LIBS)

# this is a suffix replacement rule for building .o's from .c's
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .c file) and $@: the name of the target of the rule (a .o file) 
# (see the gnu make manual section about automatic variables)
.cpp.o:
	$(CC) $(CPPFLAGS) $(INCLUDES) -c $<  -o $@

clean:
	$(RM) $(SRCDIR)/*.o $(MAIN)

depend: $(SRCS)
	makedepend $(INCLUDES) $^

# DO NOT DELETE THIS LINE -- make depend needs it
