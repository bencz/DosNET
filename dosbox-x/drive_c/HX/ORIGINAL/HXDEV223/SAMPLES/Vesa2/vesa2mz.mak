
# NMAKE Makefile, creates vesa2mz.exe

!ifdef DEBUG
AOPTD=-Zi
LOPTD=debug codeview
!else
AOPTD=
LOPTD=
MODD=
!endif

ASMOPT= -c -nologo -Fl$* -Fo$* -D_VESA32_ -D?FLAT=0 -I\hx\Include $(AOPTD)

VESA2MZ.EXE: vesa2mz.obj
	@jwlink format dos f $*,\hx\libomf\InitPM name vesa2mz lib \hx\libomf\vesa32s op q,m=vesa2mz

VESA2MZ.OBJ: vesa2.asm
	@jwasm $(ASMOPT) vesa2.asm

