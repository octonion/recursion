```bash
gcc -O3 -c outcomes.c
gfortran -O3 -c partitions.f03
gcc -O3 -o outcomes outcomes.o partitions.o -lgfortran
```
