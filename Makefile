SRC_FILES = $(wildcard ./src/*.s)

GCC = gcc 
PRODUCTION_FLAGS =
DEBUG_FLAGS = -g
OUTPUT = ./bin/fatty-fish

all: dir_make 
	${GCC} ${PRODUCTION_FLAGS} ${SRC_FILES} -o ${OUTPUT}

debug:
	${GCC} ${DEBUG_FLAGS} ${SRC_FILES} -o ${OUTPUT}-dbg

dir_make:
	mkdir -p ./bin/

cleanall:
	rm -rf ./bin/
