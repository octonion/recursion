```bash
gfortran -O3 -c outcomes.f03
gcc -O3 -c partitions.c
gfortran -O3 -o outcomes outcomes.o partitions.o
```
