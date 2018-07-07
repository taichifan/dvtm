include config.mk

SRC += dvtm-plus.c vt.c ini.c
OBJ = ${SRC:.c=.o}

all: clean options dvtm-plus

options:
	@echo dvtm-plus build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

config.h:
	cp config.def.h config.h

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

dvtm-plus: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

debug: clean
	@make CFLAGS='${DEBUG_CFLAGS}'

clean:
	@echo cleaning
	@rm -f dvtm-plus ${OBJ} dvtm-plus-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p dvtm-plus-${VERSION}
	@cp -R LICENSE Makefile README testsuite.sh config.def.h config.mk \
		${SRC} vt.h forkpty-aix.c forkpty-sunos.c tile.c bstack.c \
		tstack.c vstack.c grid.c fullscreen.c fibonacci.c \
		dvtm-plus-status dvtm-plus.info dvtm-plus.1 dvtm-plus-${VERSION}
	@tar -cf dvtm-plus-${VERSION}.tar dvtm-plus-${VERSION}
	@gzip dvtm-plus-${VERSION}.tar
	@rm -rf dvtm-plus-${VERSION}

install: dvtm-plus
	@echo stripping executable
	@strip -s dvtm-plus
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f dvtm-plus ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dvtm-plus
	@cp -f dvtm-plus-status ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dvtm-plus-status
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < dvtm-plus.1 > ${DESTDIR}${MANPREFIX}/man1/dvtm-plus.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/dvtm-plus.1
	@echo installing terminfo description
	@tic -o ${DESTDIR}${PREFIX}/share/terminfo -s dvtm-plus.info

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/dvtm-plus
	@rm -f ${DESTDIR}${PREFIX}/bin/dvtm-plus-status
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/dvtm-plus.1

.PHONY: all options clean dist install uninstall debug
