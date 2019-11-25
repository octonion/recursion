```bash
gfortran -O3 -ffree-form -c outcomes.f90
gcc -O3 -c partitions.c
gfortran -O3 -o outcomes outcomes.o partitions.o
```
