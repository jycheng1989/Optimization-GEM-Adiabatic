SRCS =	gem_com.f90 gem_equil.f90 gem_main.f90 gem_outd.f90 gem_fcnt.f90 gem_fft_wrapper.f90 gem_gkps_adi.f90 ppush.f90 cpush.f90 grid1.f90

OBJS =	gem_com.o gem_equil.o gem_main.o gem_outd.o gem_fcnt.o gem_fft_wrapper.o gem_gkps_adi.o ppush.o cpush.o grid1.o 

DFFTPACK=dfftpack/libdfftpack.a
LIBS = $(DFFTPACK)
PLIB = gem_pputil.o

F90 = mpif90
OPT = -fast -r8 -Kieee -llapack -lblas -Minfo=accel -acc
#OPT = -FR -r8 -heap-arrays -O2 -g -traceback -check bounds
#OPT = -FR -r8 -O3
LDFLAGS = 

#all : gem

gem_main: gem_equil.o gem_main.o gem_outd.o gem_fcnt.o gem_pputil.o gem_com.mod gem_fft_wrapper.o gem_gkps_adi.o
	$(F90)  -o gem_main $(OPT) $(OBJS) $(PLIB) $(LIBS) 

gem_pputil.o: gem_pputil.f90
	$(F90) -c $(OPT) gem_pputil.f90

gem_com.mod: gem_com.f90 gem_pputil.o
	$(F90) -c $(OPT) gem_com.f90

gem_equil.o: gem_equil.f90 gem_pputil.o
	$(F90) -c $(OPT) gem_equil.f90

gem_gkps_adi.o: gem_gkps_adi.f90 gem_com.f90 gem_equil.f90 gem_pputil.f90 gem_com.mod
	$(F90) -c $(OPT) gem_gkps_adi.f90

ppush.o: gem_com.mod gem_equil.o ppush.f90
	$(F90) -c $(OPT) ppush.f90

cpush.o: gem_com.mod gem_equil.o cpush.f90
	$(F90) -c $(OPT) cpush.f90

grid1.o: gem_com.mod gem_equil.o grid1.f90
	$(F90) -c $(OPT) grid1.f90

gem_main.o: gem_main.f90 gem_fft_wrapper.o gem_pputil.o gem_com.mod gem_equil.o gem_gkps_adi.o ppush.o cpush.o grid1.o
	$(F90) -c $(OPT) gem_main.f90

gem_outd.o: gem_outd.f90 gem_fft_wrapper.o gem_pputil.o gem_com.mod gem_equil.o
	$(F90) -c $(OPT) gem_outd.f90

gem_fcnt.o: gem_fcnt.f90
	$(F90) -c $(OPT) gem_fcnt.f90

gem_fft_wrapper.o: gem_fft_wrapper.f90
	$(F90) -c $(OPT) gem_fft_wrapper.f90

clean:
	rm -f *.o *.lst *.mod gem_main
