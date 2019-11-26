```bash
gcc -O3 -c outcomes.c
gfortran -O3 -ffree-form -c partitions.f90
gcc -O3 -o outcomes outcomes.o partitions.o -lgfortran
```
